const PROTO_VERSION = 3

#
# BSD 3-Clause License
#
# Copyright (c) 2018 - 2022, Oleg Malyavkin
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# DEBUG_TAB redefine this "  " if you need, example: const DEBUG_TAB = "\t"
const DEBUG_TAB : String = "  "

enum PB_ERR {
	NO_ERRORS = 0,
	VARINT_NOT_FOUND = -1,
	REPEATED_COUNT_NOT_FOUND = -2,
	REPEATED_COUNT_MISMATCH = -3,
	LENGTHDEL_SIZE_NOT_FOUND = -4,
	LENGTHDEL_SIZE_MISMATCH = -5,
	PACKAGE_SIZE_MISMATCH = -6,
	UNDEFINED_STATE = -7,
	PARSE_INCOMPLETE = -8,
	REQUIRED_FIELDS = -9
}

enum PB_DATA_TYPE {
	INT32 = 0,
	SINT32 = 1,
	UINT32 = 2,
	INT64 = 3,
	SINT64 = 4,
	UINT64 = 5,
	BOOL = 6,
	ENUM = 7,
	FIXED32 = 8,
	SFIXED32 = 9,
	FLOAT = 10,
	FIXED64 = 11,
	SFIXED64 = 12,
	DOUBLE = 13,
	STRING = 14,
	BYTES = 15,
	MESSAGE = 16,
	MAP = 17
}

const DEFAULT_VALUES_2 = {
	PB_DATA_TYPE.INT32: null,
	PB_DATA_TYPE.SINT32: null,
	PB_DATA_TYPE.UINT32: null,
	PB_DATA_TYPE.INT64: null,
	PB_DATA_TYPE.SINT64: null,
	PB_DATA_TYPE.UINT64: null,
	PB_DATA_TYPE.BOOL: null,
	PB_DATA_TYPE.ENUM: null,
	PB_DATA_TYPE.FIXED32: null,
	PB_DATA_TYPE.SFIXED32: null,
	PB_DATA_TYPE.FLOAT: null,
	PB_DATA_TYPE.FIXED64: null,
	PB_DATA_TYPE.SFIXED64: null,
	PB_DATA_TYPE.DOUBLE: null,
	PB_DATA_TYPE.STRING: null,
	PB_DATA_TYPE.BYTES: null,
	PB_DATA_TYPE.MESSAGE: null,
	PB_DATA_TYPE.MAP: null
}

const DEFAULT_VALUES_3 = {
	PB_DATA_TYPE.INT32: 0,
	PB_DATA_TYPE.SINT32: 0,
	PB_DATA_TYPE.UINT32: 0,
	PB_DATA_TYPE.INT64: 0,
	PB_DATA_TYPE.SINT64: 0,
	PB_DATA_TYPE.UINT64: 0,
	PB_DATA_TYPE.BOOL: false,
	PB_DATA_TYPE.ENUM: 0,
	PB_DATA_TYPE.FIXED32: 0,
	PB_DATA_TYPE.SFIXED32: 0,
	PB_DATA_TYPE.FLOAT: 0.0,
	PB_DATA_TYPE.FIXED64: 0,
	PB_DATA_TYPE.SFIXED64: 0,
	PB_DATA_TYPE.DOUBLE: 0.0,
	PB_DATA_TYPE.STRING: "",
	PB_DATA_TYPE.BYTES: [],
	PB_DATA_TYPE.MESSAGE: null,
	PB_DATA_TYPE.MAP: []
}

enum PB_TYPE {
	VARINT = 0,
	FIX64 = 1,
	LENGTHDEL = 2,
	STARTGROUP = 3,
	ENDGROUP = 4,
	FIX32 = 5,
	UNDEFINED = 8
}

enum PB_RULE {
	OPTIONAL = 0,
	REQUIRED = 1,
	REPEATED = 2,
	RESERVED = 3
}

enum PB_SERVICE_STATE {
	FILLED = 0,
	UNFILLED = 1
}

class PBField:
	func _init(a_name : String, a_type : int, a_rule : int, a_tag : int, packed : bool, a_value = null):
		name = a_name
		type = a_type
		rule = a_rule
		tag = a_tag
		option_packed = packed
		value = a_value
		
	var name : String
	var type : int
	var rule : int
	var tag : int
	var option_packed : bool
	var value
	var is_map_field : bool = false
	var option_default : bool = false

class PBTypeTag:
	var ok : bool = false
	var type : int
	var tag : int
	var offset : int

class PBServiceField:
	var field : PBField
	var func_ref = null
	var state : int = PB_SERVICE_STATE.UNFILLED

class PBPacker:
	static func convert_signed(n : int) -> int:
		if n < -2147483648:
			return (n << 1) ^ (n >> 63)
		else:
			return (n << 1) ^ (n >> 31)

	static func deconvert_signed(n : int) -> int:
		if n & 0x01:
			return ~(n >> 1)
		else:
			return (n >> 1)

	static func pack_varint(value) -> PoolByteArray:
		var varint : PoolByteArray = PoolByteArray()
		if typeof(value) == TYPE_BOOL:
			if value:
				value = 1
			else:
				value = 0
		for _i in range(9):
			var b = value & 0x7F
			value >>= 7
			if value:
				varint.append(b | 0x80)
			else:
				varint.append(b)
				break
		if varint.size() == 9 && varint[8] == 0xFF:
			varint.append(0x01)
		return varint

	static func pack_bytes(value, count : int, data_type : int) -> PoolByteArray:
		var bytes : PoolByteArray = PoolByteArray()
		if data_type == PB_DATA_TYPE.FLOAT:
			var spb : StreamPeerBuffer = StreamPeerBuffer.new()
			spb.put_float(value)
			bytes = spb.get_data_array()
		elif data_type == PB_DATA_TYPE.DOUBLE:
			var spb : StreamPeerBuffer = StreamPeerBuffer.new()
			spb.put_double(value)
			bytes = spb.get_data_array()
		else:
			for _i in range(count):
				bytes.append(value & 0xFF)
				value >>= 8
		return bytes

	static func unpack_bytes(bytes : PoolByteArray, index : int, count : int, data_type : int):
		var value = 0
		if data_type == PB_DATA_TYPE.FLOAT:
			var spb : StreamPeerBuffer = StreamPeerBuffer.new()
			for i in range(index, count + index):
				spb.put_u8(bytes[i])
			spb.seek(0)
			value = spb.get_float()
		elif data_type == PB_DATA_TYPE.DOUBLE:
			var spb : StreamPeerBuffer = StreamPeerBuffer.new()
			for i in range(index, count + index):
				spb.put_u8(bytes[i])
			spb.seek(0)
			value = spb.get_double()
		else:
			for i in range(index + count - 1, index - 1, -1):
				value |= (bytes[i] & 0xFF)
				if i != index:
					value <<= 8
		return value

	static func unpack_varint(varint_bytes) -> int:
		var value : int = 0
		for i in range(varint_bytes.size() - 1, -1, -1):
			value |= varint_bytes[i] & 0x7F
			if i != 0:
				value <<= 7
		return value

	static func pack_type_tag(type : int, tag : int) -> PoolByteArray:
		return pack_varint((tag << 3) | type)

	static func isolate_varint(bytes : PoolByteArray, index : int) -> PoolByteArray:
		var result : PoolByteArray = PoolByteArray()
		for i in range(index, bytes.size()):
			result.append(bytes[i])
			if !(bytes[i] & 0x80):
				break
		return result

	static func unpack_type_tag(bytes : PoolByteArray, index : int) -> PBTypeTag:
		var varint_bytes : PoolByteArray = isolate_varint(bytes, index)
		var result : PBTypeTag = PBTypeTag.new()
		if varint_bytes.size() != 0:
			result.ok = true
			result.offset = varint_bytes.size()
			var unpacked : int = unpack_varint(varint_bytes)
			result.type = unpacked & 0x07
			result.tag = unpacked >> 3
		return result

	static func pack_length_delimeted(type : int, tag : int, bytes : PoolByteArray) -> PoolByteArray:
		var result : PoolByteArray = pack_type_tag(type, tag)
		result.append_array(pack_varint(bytes.size()))
		result.append_array(bytes)
		return result

	static func pb_type_from_data_type(data_type : int) -> int:
		if data_type == PB_DATA_TYPE.INT32 || data_type == PB_DATA_TYPE.SINT32 || data_type == PB_DATA_TYPE.UINT32 || data_type == PB_DATA_TYPE.INT64 || data_type == PB_DATA_TYPE.SINT64 || data_type == PB_DATA_TYPE.UINT64 || data_type == PB_DATA_TYPE.BOOL || data_type == PB_DATA_TYPE.ENUM:
			return PB_TYPE.VARINT
		elif data_type == PB_DATA_TYPE.FIXED32 || data_type == PB_DATA_TYPE.SFIXED32 || data_type == PB_DATA_TYPE.FLOAT:
			return PB_TYPE.FIX32
		elif data_type == PB_DATA_TYPE.FIXED64 || data_type == PB_DATA_TYPE.SFIXED64 || data_type == PB_DATA_TYPE.DOUBLE:
			return PB_TYPE.FIX64
		elif data_type == PB_DATA_TYPE.STRING || data_type == PB_DATA_TYPE.BYTES || data_type == PB_DATA_TYPE.MESSAGE || data_type == PB_DATA_TYPE.MAP:
			return PB_TYPE.LENGTHDEL
		else:
			return PB_TYPE.UNDEFINED

	static func pack_field(field : PBField) -> PoolByteArray:
		var type : int = pb_type_from_data_type(field.type)
		var type_copy : int = type
		if field.rule == PB_RULE.REPEATED && field.option_packed:
			type = PB_TYPE.LENGTHDEL
		var head : PoolByteArray = pack_type_tag(type, field.tag)
		var data : PoolByteArray = PoolByteArray()
		if type == PB_TYPE.VARINT:
			var value
			if field.rule == PB_RULE.REPEATED:
				for v in field.value:
					data.append_array(head)
					if field.type == PB_DATA_TYPE.SINT32 || field.type == PB_DATA_TYPE.SINT64:
						value = convert_signed(v)
					else:
						value = v
					data.append_array(pack_varint(value))
				return data
			else:
				if field.type == PB_DATA_TYPE.SINT32 || field.type == PB_DATA_TYPE.SINT64:
					value = convert_signed(field.value)
				else:
					value = field.value
				data = pack_varint(value)
		elif type == PB_TYPE.FIX32:
			if field.rule == PB_RULE.REPEATED:
				for v in field.value:
					data.append_array(head)
					data.append_array(pack_bytes(v, 4, field.type))
				return data
			else:
				data.append_array(pack_bytes(field.value, 4, field.type))
		elif type == PB_TYPE.FIX64:
			if field.rule == PB_RULE.REPEATED:
				for v in field.value:
					data.append_array(head)
					data.append_array(pack_bytes(v, 8, field.type))
				return data
			else:
				data.append_array(pack_bytes(field.value, 8, field.type))
		elif type == PB_TYPE.LENGTHDEL:
			if field.rule == PB_RULE.REPEATED:
				if type_copy == PB_TYPE.VARINT:
					if field.type == PB_DATA_TYPE.SINT32 || field.type == PB_DATA_TYPE.SINT64:
						var signed_value : int
						for v in field.value:
							signed_value = convert_signed(v)
							data.append_array(pack_varint(signed_value))
					else:
						for v in field.value:
							data.append_array(pack_varint(v))
					return pack_length_delimeted(type, field.tag, data)
				elif type_copy == PB_TYPE.FIX32:
					for v in field.value:
						data.append_array(pack_bytes(v, 4, field.type))
					return pack_length_delimeted(type, field.tag, data)
				elif type_copy == PB_TYPE.FIX64:
					for v in field.value:
						data.append_array(pack_bytes(v, 8, field.type))
					return pack_length_delimeted(type, field.tag, data)
				elif field.type == PB_DATA_TYPE.STRING:
					for v in field.value:
						var obj = v.to_utf8()
						data.append_array(pack_length_delimeted(type, field.tag, obj))
					return data
				elif field.type == PB_DATA_TYPE.BYTES:
					for v in field.value:
						data.append_array(pack_length_delimeted(type, field.tag, v))
					return data
				elif typeof(field.value[0]) == TYPE_OBJECT:
					for v in field.value:
						var obj : PoolByteArray = v.to_bytes()
						data.append_array(pack_length_delimeted(type, field.tag, obj))
					return data
			else:
				if field.type == PB_DATA_TYPE.STRING:
					var str_bytes : PoolByteArray = field.value.to_utf8()
					if PROTO_VERSION == 2 || (PROTO_VERSION == 3 && str_bytes.size() > 0):
						data.append_array(str_bytes)
						return pack_length_delimeted(type, field.tag, data)
				if field.type == PB_DATA_TYPE.BYTES:
					if PROTO_VERSION == 2 || (PROTO_VERSION == 3 && field.value.size() > 0):
						data.append_array(field.value)
						return pack_length_delimeted(type, field.tag, data)
				elif typeof(field.value) == TYPE_OBJECT:
					var obj : PoolByteArray = field.value.to_bytes()
					if obj.size() > 0:
						data.append_array(obj)
					return pack_length_delimeted(type, field.tag, data)
				else:
					pass
		if data.size() > 0:
			head.append_array(data)
			return head
		else:
			return data

	static func unpack_field(bytes : PoolByteArray, offset : int, field : PBField, type : int, message_func_ref) -> int:
		if field.rule == PB_RULE.REPEATED && type != PB_TYPE.LENGTHDEL && field.option_packed:
			var count = isolate_varint(bytes, offset)
			if count.size() > 0:
				offset += count.size()
				count = unpack_varint(count)
				if type == PB_TYPE.VARINT:
					var val
					var counter = offset + count
					while offset < counter:
						val = isolate_varint(bytes, offset)
						if val.size() > 0:
							offset += val.size()
							val = unpack_varint(val)
							if field.type == PB_DATA_TYPE.SINT32 || field.type == PB_DATA_TYPE.SINT64:
								val = deconvert_signed(val)
							elif field.type == PB_DATA_TYPE.BOOL:
								if val:
									val = true
								else:
									val = false
							field.value.append(val)
						else:
							return PB_ERR.REPEATED_COUNT_MISMATCH
					return offset
				elif type == PB_TYPE.FIX32 || type == PB_TYPE.FIX64:
					var type_size
					if type == PB_TYPE.FIX32:
						type_size = 4
					else:
						type_size = 8
					var val
					var counter = offset + count
					while offset < counter:
						if (offset + type_size) > bytes.size():
							return PB_ERR.REPEATED_COUNT_MISMATCH
						val = unpack_bytes(bytes, offset, type_size, field.type)
						offset += type_size
						field.value.append(val)
					return offset
			else:
				return PB_ERR.REPEATED_COUNT_NOT_FOUND
		else:
			if type == PB_TYPE.VARINT:
				var val = isolate_varint(bytes, offset)
				if val.size() > 0:
					offset += val.size()
					val = unpack_varint(val)
					if field.type == PB_DATA_TYPE.SINT32 || field.type == PB_DATA_TYPE.SINT64:
						val = deconvert_signed(val)
					elif field.type == PB_DATA_TYPE.BOOL:
						if val:
							val = true
						else:
							val = false
					if field.rule == PB_RULE.REPEATED:
						field.value.append(val)
					else:
						field.value = val
				else:
					return PB_ERR.VARINT_NOT_FOUND
				return offset
			elif type == PB_TYPE.FIX32 || type == PB_TYPE.FIX64:
				var type_size
				if type == PB_TYPE.FIX32:
					type_size = 4
				else:
					type_size = 8
				var val
				if (offset + type_size) > bytes.size():
					return PB_ERR.REPEATED_COUNT_MISMATCH
				val = unpack_bytes(bytes, offset, type_size, field.type)
				offset += type_size
				if field.rule == PB_RULE.REPEATED:
					field.value.append(val)
				else:
					field.value = val
				return offset
			elif type == PB_TYPE.LENGTHDEL:
				var inner_size = isolate_varint(bytes, offset)
				if inner_size.size() > 0:
					offset += inner_size.size()
					inner_size = unpack_varint(inner_size)
					if inner_size >= 0:
						if inner_size + offset > bytes.size():
							return PB_ERR.LENGTHDEL_SIZE_MISMATCH
						if message_func_ref != null:
							var message = message_func_ref.call_func()
							if inner_size > 0:
								var sub_offset = message.from_bytes(bytes, offset, inner_size + offset)
								if sub_offset > 0:
									if sub_offset - offset >= inner_size:
										offset = sub_offset
										return offset
									else:
										return PB_ERR.LENGTHDEL_SIZE_MISMATCH
								return sub_offset
							else:
								return offset
						elif field.type == PB_DATA_TYPE.STRING:
							var str_bytes : PoolByteArray = PoolByteArray()
							for i in range(offset, inner_size + offset):
								str_bytes.append(bytes[i])
							if field.rule == PB_RULE.REPEATED:
								field.value.append(str_bytes.get_string_from_utf8())
							else:
								field.value = str_bytes.get_string_from_utf8()
							return offset + inner_size
						elif field.type == PB_DATA_TYPE.BYTES:
							var val_bytes : PoolByteArray = PoolByteArray()
							for i in range(offset, inner_size + offset):
								val_bytes.append(bytes[i])
							if field.rule == PB_RULE.REPEATED:
								field.value.append(val_bytes)
							else:
								field.value = val_bytes
							return offset + inner_size
					else:
						return PB_ERR.LENGTHDEL_SIZE_NOT_FOUND
				else:
					return PB_ERR.LENGTHDEL_SIZE_NOT_FOUND
		return PB_ERR.UNDEFINED_STATE

	static func unpack_message(data, bytes : PoolByteArray, offset : int, limit : int) -> int:
		while true:
			var tt : PBTypeTag = unpack_type_tag(bytes, offset)
			if tt.ok:
				offset += tt.offset
				if data.has(tt.tag):
					var service : PBServiceField = data[tt.tag]
					var type : int = pb_type_from_data_type(service.field.type)
					if type == tt.type || (tt.type == PB_TYPE.LENGTHDEL && service.field.rule == PB_RULE.REPEATED && service.field.option_packed):
						var res : int = unpack_field(bytes, offset, service.field, type, service.func_ref)
						if res > 0:
							service.state = PB_SERVICE_STATE.FILLED
							offset = res
							if offset == limit:
								return offset
							elif offset > limit:
								return PB_ERR.PACKAGE_SIZE_MISMATCH
						elif res < 0:
							return res
						else:
							break
			else:
				return offset
		return PB_ERR.UNDEFINED_STATE

	static func pack_message(data) -> PoolByteArray:
		var DEFAULT_VALUES
		if PROTO_VERSION == 2:
			DEFAULT_VALUES = DEFAULT_VALUES_2
		elif PROTO_VERSION == 3:
			DEFAULT_VALUES = DEFAULT_VALUES_3
		var result : PoolByteArray = PoolByteArray()
		var keys : Array = data.keys()
		keys.sort()
		for i in keys:
			if data[i].field.value != null:
				if data[i].state == PB_SERVICE_STATE.UNFILLED \
				&& !data[i].field.is_map_field \
				&& typeof(data[i].field.value) == typeof(DEFAULT_VALUES[data[i].field.type]) \
				&& data[i].field.value == DEFAULT_VALUES[data[i].field.type]:
					continue
				elif data[i].field.rule == PB_RULE.REPEATED && data[i].field.value.size() == 0:
					continue
				result.append_array(pack_field(data[i].field))
			elif data[i].field.rule == PB_RULE.REQUIRED:
				print("Error: required field is not filled: Tag:", data[i].field.tag)
				return PoolByteArray()
		return result

	static func check_required(data) -> bool:
		var keys : Array = data.keys()
		for i in keys:
			if data[i].field.rule == PB_RULE.REQUIRED && data[i].state == PB_SERVICE_STATE.UNFILLED:
				return false
		return true

	static func construct_map(key_values):
		var result = {}
		for kv in key_values:
			result[kv.get_key()] = kv.get_value()
		return result
	
	static func tabulate(text : String, nesting : int) -> String:
		var tab : String = ""
		for _i in range(nesting):
			tab += DEBUG_TAB
		return tab + text
	
	static func value_to_string(value, field : PBField, nesting : int) -> String:
		var result : String = ""
		var text : String
		if field.type == PB_DATA_TYPE.MESSAGE:
			result += "{"
			nesting += 1
			text = message_to_string(value.data, nesting)
			if text != "":
				result += "\n" + text
				nesting -= 1
				result += tabulate("}", nesting)
			else:
				nesting -= 1
				result += "}"
		elif field.type == PB_DATA_TYPE.BYTES:
			result += "<"
			for i in range(value.size()):
				result += String(value[i])
				if i != (value.size() - 1):
					result += ", "
			result += ">"
		elif field.type == PB_DATA_TYPE.STRING:
			result += "\"" + value + "\""
		elif field.type == PB_DATA_TYPE.ENUM:
			result += "ENUM::" + String(value)
		else:
			result += String(value)
		return result
	
	static func field_to_string(field : PBField, nesting : int) -> String:
		var result : String = tabulate(field.name + ": ", nesting)
		if field.type == PB_DATA_TYPE.MAP:
			if field.value.size() > 0:
				result += "(\n"
				nesting += 1
				for i in range(field.value.size()):
					var local_key_value = field.value[i].data[1].field
					result += tabulate(value_to_string(local_key_value.value, local_key_value, nesting), nesting) + ": "
					local_key_value = field.value[i].data[2].field
					result += value_to_string(local_key_value.value, local_key_value, nesting)
					if i != (field.value.size() - 1):
						result += ","
					result += "\n"
				nesting -= 1
				result += tabulate(")", nesting)
			else:
				result += "()"
		elif field.rule == PB_RULE.REPEATED:
			if field.value.size() > 0:
				result += "[\n"
				nesting += 1
				for i in range(field.value.size()):
					result += tabulate(String(i) + ": ", nesting)
					result += value_to_string(field.value[i], field, nesting)
					if i != (field.value.size() - 1):
						result += ","
					result += "\n"
				nesting -= 1
				result += tabulate("]", nesting)
			else:
				result += "[]"
		else:
			result += value_to_string(field.value, field, nesting)
		result += ";\n"
		return result
		
	static func message_to_string(data, nesting : int = 0) -> String:
		var DEFAULT_VALUES
		if PROTO_VERSION == 2:
			DEFAULT_VALUES = DEFAULT_VALUES_2
		elif PROTO_VERSION == 3:
			DEFAULT_VALUES = DEFAULT_VALUES_3
		var result : String = ""
		var keys : Array = data.keys()
		keys.sort()
		for i in keys:
			if data[i].field.value != null:
				if data[i].state == PB_SERVICE_STATE.UNFILLED \
				&& !data[i].field.is_map_field \
				&& typeof(data[i].field.value) == typeof(DEFAULT_VALUES[data[i].field.type]) \
				&& data[i].field.value == DEFAULT_VALUES[data[i].field.type]:
					continue
				elif data[i].field.rule == PB_RULE.REPEATED && data[i].field.value.size() == 0:
					continue
				result += field_to_string(data[i].field, nesting)
			elif data[i].field.rule == PB_RULE.REQUIRED:
				result += data[i].field.name + ": " + "error"
		return result



############### USER DATA BEGIN ################


enum OpCode {
	OPCODE_UNSPECIFIED = 0,
	OPCODE_START = 1,
	OPCODE_ADD_CARD = 2,
	OPCODE_ADD_BUILD = 3,
	OPCODE_CAST_CARD = 4,
	OPCODE_ATTACK = 5,
	OPCODE_END_TURN = 6
}

class Mana:
	func _init():
		var service
		
		_red = PBField.new("red", PB_DATA_TYPE.INT64, PB_RULE.OPTIONAL, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT64])
		service = PBServiceField.new()
		service.field = _red
		data[_red.tag] = service
		
		_blue = PBField.new("blue", PB_DATA_TYPE.INT64, PB_RULE.OPTIONAL, 2, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT64])
		service = PBServiceField.new()
		service.field = _blue
		data[_blue.tag] = service
		
		_green = PBField.new("green", PB_DATA_TYPE.INT64, PB_RULE.OPTIONAL, 3, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT64])
		service = PBServiceField.new()
		service.field = _green
		data[_green.tag] = service
		
		_white = PBField.new("white", PB_DATA_TYPE.INT64, PB_RULE.OPTIONAL, 4, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT64])
		service = PBServiceField.new()
		service.field = _white
		data[_white.tag] = service
		
		_black = PBField.new("black", PB_DATA_TYPE.INT64, PB_RULE.OPTIONAL, 5, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT64])
		service = PBServiceField.new()
		service.field = _black
		data[_black.tag] = service
		
	var data = {}
	
	var _red: PBField
	func get_red() -> int:
		return _red.value
	func clear_red() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_red.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT64]
	func set_red(value : int) -> void:
		_red.value = value
	
	var _blue: PBField
	func get_blue() -> int:
		return _blue.value
	func clear_blue() -> void:
		data[2].state = PB_SERVICE_STATE.UNFILLED
		_blue.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT64]
	func set_blue(value : int) -> void:
		_blue.value = value
	
	var _green: PBField
	func get_green() -> int:
		return _green.value
	func clear_green() -> void:
		data[3].state = PB_SERVICE_STATE.UNFILLED
		_green.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT64]
	func set_green(value : int) -> void:
		_green.value = value
	
	var _white: PBField
	func get_white() -> int:
		return _white.value
	func clear_white() -> void:
		data[4].state = PB_SERVICE_STATE.UNFILLED
		_white.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT64]
	func set_white(value : int) -> void:
		_white.value = value
	
	var _black: PBField
	func get_black() -> int:
		return _black.value
	func clear_black() -> void:
		data[5].state = PB_SERVICE_STATE.UNFILLED
		_black.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT64]
	func set_black(value : int) -> void:
		_black.value = value
	
	func to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PoolByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PoolByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class Zone:
	func _init():
		var service
		
	var data = {}
	
	func to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PoolByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PoolByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class Spell:
	func _init():
		var service
		
	var data = {}
	
	func to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PoolByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PoolByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class Item:
	func _init():
		var service
		
	var data = {}
	
	func to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PoolByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PoolByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class Unit:
	func _init():
		var service
		
		_healty = PBField.new("healty", PB_DATA_TYPE.INT64, PB_RULE.OPTIONAL, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT64])
		service = PBServiceField.new()
		service.field = _healty
		data[_healty.tag] = service
		
		_cost = PBField.new("cost", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 2, true, [])
		service = PBServiceField.new()
		service.field = _cost
		service.func_ref = funcref(self, "add_cost")
		data[_cost.tag] = service
		
	var data = {}
	
	var _healty: PBField
	func get_healty() -> int:
		return _healty.value
	func clear_healty() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_healty.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT64]
	func set_healty(value : int) -> void:
		_healty.value = value
	
	var _cost: PBField
	func get_cost() -> Array:
		return _cost.value
	func clear_cost() -> void:
		data[2].state = PB_SERVICE_STATE.UNFILLED
		_cost.value = []
	func add_cost() -> Mana:
		var element = Mana.new()
		_cost.value.append(element)
		return element
	
	func to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PoolByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PoolByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class Build:
	func _init():
		var service
		
		_add = PBField.new("add", PB_DATA_TYPE.MESSAGE, PB_RULE.OPTIONAL, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
		service = PBServiceField.new()
		service.field = _add
		service.func_ref = funcref(self, "new_add")
		data[_add.tag] = service
		
		_sub = PBField.new("sub", PB_DATA_TYPE.MESSAGE, PB_RULE.OPTIONAL, 2, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
		service = PBServiceField.new()
		service.field = _sub
		service.func_ref = funcref(self, "new_sub")
		data[_sub.tag] = service
		
		_one = PBField.new("one", PB_DATA_TYPE.MESSAGE, PB_RULE.OPTIONAL, 3, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
		service = PBServiceField.new()
		service.field = _one
		service.func_ref = funcref(self, "new_one")
		data[_one.tag] = service
		
	var data = {}
	
	var _add: PBField
	func get_add() -> Mana:
		return _add.value
	func clear_add() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_add.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
	func new_add() -> Mana:
		_add.value = Mana.new()
		return _add.value
	
	var _sub: PBField
	func get_sub() -> Mana:
		return _sub.value
	func clear_sub() -> void:
		data[2].state = PB_SERVICE_STATE.UNFILLED
		_sub.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
	func new_sub() -> Mana:
		_sub.value = Mana.new()
		return _sub.value
	
	var _one: PBField
	func get_one() -> Mana:
		return _one.value
	func clear_one() -> void:
		data[3].state = PB_SERVICE_STATE.UNFILLED
		_one.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
	func new_one() -> Mana:
		_one.value = Mana.new()
		return _one.value
	
	func to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PoolByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PoolByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class Card:
	func _init():
		var service
		
		_id = PBField.new("id", PB_DATA_TYPE.STRING, PB_RULE.OPTIONAL, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
		service = PBServiceField.new()
		service.field = _id
		data[_id.tag] = service
		
		_name = PBField.new("name", PB_DATA_TYPE.STRING, PB_RULE.OPTIONAL, 2, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
		service = PBServiceField.new()
		service.field = _name
		data[_name.tag] = service
		
		_desc = PBField.new("desc", PB_DATA_TYPE.STRING, PB_RULE.OPTIONAL, 3, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
		service = PBServiceField.new()
		service.field = _desc
		data[_desc.tag] = service
		
		_unit = PBField.new("unit", PB_DATA_TYPE.MESSAGE, PB_RULE.OPTIONAL, 4, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
		service = PBServiceField.new()
		service.field = _unit
		service.func_ref = funcref(self, "new_unit")
		data[_unit.tag] = service
		
		_build = PBField.new("build", PB_DATA_TYPE.MESSAGE, PB_RULE.OPTIONAL, 5, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
		service = PBServiceField.new()
		service.field = _build
		service.func_ref = funcref(self, "new_build")
		data[_build.tag] = service
		
	var data = {}
	
	var _id: PBField
	func get_id() -> String:
		return _id.value
	func clear_id() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_id.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
	func set_id(value : String) -> void:
		_id.value = value
	
	var _name: PBField
	func get_name() -> String:
		return _name.value
	func clear_name() -> void:
		data[2].state = PB_SERVICE_STATE.UNFILLED
		_name.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
	func set_name(value : String) -> void:
		_name.value = value
	
	var _desc: PBField
	func get_desc() -> String:
		return _desc.value
	func clear_desc() -> void:
		data[3].state = PB_SERVICE_STATE.UNFILLED
		_desc.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
	func set_desc(value : String) -> void:
		_desc.value = value
	
	var _unit: PBField
	func has_unit() -> bool:
		return data[4].state == PB_SERVICE_STATE.FILLED
	func get_unit() -> Unit:
		return _unit.value
	func clear_unit() -> void:
		data[4].state = PB_SERVICE_STATE.UNFILLED
		_unit.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
	func new_unit() -> Unit:
		data[4].state = PB_SERVICE_STATE.FILLED
		_build.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
		data[5].state = PB_SERVICE_STATE.UNFILLED
		_unit.value = Unit.new()
		return _unit.value
	
	var _build: PBField
	func has_build() -> bool:
		return data[5].state == PB_SERVICE_STATE.FILLED
	func get_build() -> Build:
		return _build.value
	func clear_build() -> void:
		data[5].state = PB_SERVICE_STATE.UNFILLED
		_build.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
	func new_build() -> Build:
		_unit.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
		data[4].state = PB_SERVICE_STATE.UNFILLED
		data[5].state = PB_SERVICE_STATE.FILLED
		_build.value = Build.new()
		return _build.value
	
	func to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PoolByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PoolByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class Player:
	func _init():
		var service
		
		_id = PBField.new("id", PB_DATA_TYPE.STRING, PB_RULE.OPTIONAL, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
		service = PBServiceField.new()
		service.field = _id
		data[_id.tag] = service
		
		_name = PBField.new("name", PB_DATA_TYPE.STRING, PB_RULE.OPTIONAL, 2, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
		service = PBServiceField.new()
		service.field = _name
		data[_name.tag] = service
		
		_mana = PBField.new("mana", PB_DATA_TYPE.MESSAGE, PB_RULE.OPTIONAL, 3, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
		service = PBServiceField.new()
		service.field = _mana
		service.func_ref = funcref(self, "new_mana")
		data[_mana.tag] = service
		
		_tabel = PBField.new("tabel", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 5, true, [])
		service = PBServiceField.new()
		service.field = _tabel
		service.func_ref = funcref(self, "add_tabel")
		data[_tabel.tag] = service
		
		_build = PBField.new("build", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 6, true, [])
		service = PBServiceField.new()
		service.field = _build
		service.func_ref = funcref(self, "add_build")
		data[_build.tag] = service
		
		_deads = PBField.new("deads", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 7, true, [])
		service = PBServiceField.new()
		service.field = _deads
		service.func_ref = funcref(self, "add_deads")
		data[_deads.tag] = service
		
		_hand = PBField.new("hand", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 8, true, [])
		service = PBServiceField.new()
		service.field = _hand
		service.func_ref = funcref(self, "add_hand")
		data[_hand.tag] = service
		
		_deck = PBField.new("deck", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 9, true, [])
		service = PBServiceField.new()
		service.field = _deck
		service.func_ref = funcref(self, "add_deck")
		data[_deck.tag] = service
		
	var data = {}
	
	var _id: PBField
	func get_id() -> String:
		return _id.value
	func clear_id() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_id.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
	func set_id(value : String) -> void:
		_id.value = value
	
	var _name: PBField
	func get_name() -> String:
		return _name.value
	func clear_name() -> void:
		data[2].state = PB_SERVICE_STATE.UNFILLED
		_name.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
	func set_name(value : String) -> void:
		_name.value = value
	
	var _mana: PBField
	func get_mana() -> Mana:
		return _mana.value
	func clear_mana() -> void:
		data[3].state = PB_SERVICE_STATE.UNFILLED
		_mana.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
	func new_mana() -> Mana:
		_mana.value = Mana.new()
		return _mana.value
	
	var _tabel: PBField
	func get_tabel() -> Array:
		return _tabel.value
	func clear_tabel() -> void:
		data[5].state = PB_SERVICE_STATE.UNFILLED
		_tabel.value = []
	func add_tabel() -> Card:
		var element = Card.new()
		_tabel.value.append(element)
		return element
	
	var _build: PBField
	func get_build() -> Array:
		return _build.value
	func clear_build() -> void:
		data[6].state = PB_SERVICE_STATE.UNFILLED
		_build.value = []
	func add_build() -> Card:
		var element = Card.new()
		_build.value.append(element)
		return element
	
	var _deads: PBField
	func get_deads() -> Array:
		return _deads.value
	func clear_deads() -> void:
		data[7].state = PB_SERVICE_STATE.UNFILLED
		_deads.value = []
	func add_deads() -> Card:
		var element = Card.new()
		_deads.value.append(element)
		return element
	
	var _hand: PBField
	func get_hand() -> Array:
		return _hand.value
	func clear_hand() -> void:
		data[8].state = PB_SERVICE_STATE.UNFILLED
		_hand.value = []
	func add_hand() -> Card:
		var element = Card.new()
		_hand.value.append(element)
		return element
	
	var _deck: PBField
	func get_deck() -> Array:
		return _deck.value
	func clear_deck() -> void:
		data[9].state = PB_SERVICE_STATE.UNFILLED
		_deck.value = []
	func add_deck() -> Card:
		var element = Card.new()
		_deck.value.append(element)
		return element
	
	func to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PoolByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PoolByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class Enemy:
	func _init():
		var service
		
		_id = PBField.new("id", PB_DATA_TYPE.STRING, PB_RULE.OPTIONAL, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
		service = PBServiceField.new()
		service.field = _id
		data[_id.tag] = service
		
		_name = PBField.new("name", PB_DATA_TYPE.STRING, PB_RULE.OPTIONAL, 2, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
		service = PBServiceField.new()
		service.field = _name
		data[_name.tag] = service
		
		_mana = PBField.new("mana", PB_DATA_TYPE.MESSAGE, PB_RULE.OPTIONAL, 3, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
		service = PBServiceField.new()
		service.field = _mana
		service.func_ref = funcref(self, "new_mana")
		data[_mana.tag] = service
		
		_tabel = PBField.new("tabel", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 5, true, [])
		service = PBServiceField.new()
		service.field = _tabel
		service.func_ref = funcref(self, "add_tabel")
		data[_tabel.tag] = service
		
		_build = PBField.new("build", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 6, true, [])
		service = PBServiceField.new()
		service.field = _build
		service.func_ref = funcref(self, "add_build")
		data[_build.tag] = service
		
		_deads = PBField.new("deads", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 7, true, [])
		service = PBServiceField.new()
		service.field = _deads
		service.func_ref = funcref(self, "add_deads")
		data[_deads.tag] = service
		
		_hand_len = PBField.new("hand_len", PB_DATA_TYPE.INT64, PB_RULE.OPTIONAL, 8, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT64])
		service = PBServiceField.new()
		service.field = _hand_len
		data[_hand_len.tag] = service
		
	var data = {}
	
	var _id: PBField
	func get_id() -> String:
		return _id.value
	func clear_id() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_id.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
	func set_id(value : String) -> void:
		_id.value = value
	
	var _name: PBField
	func get_name() -> String:
		return _name.value
	func clear_name() -> void:
		data[2].state = PB_SERVICE_STATE.UNFILLED
		_name.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
	func set_name(value : String) -> void:
		_name.value = value
	
	var _mana: PBField
	func get_mana() -> Mana:
		return _mana.value
	func clear_mana() -> void:
		data[3].state = PB_SERVICE_STATE.UNFILLED
		_mana.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
	func new_mana() -> Mana:
		_mana.value = Mana.new()
		return _mana.value
	
	var _tabel: PBField
	func get_tabel() -> Array:
		return _tabel.value
	func clear_tabel() -> void:
		data[5].state = PB_SERVICE_STATE.UNFILLED
		_tabel.value = []
	func add_tabel() -> Card:
		var element = Card.new()
		_tabel.value.append(element)
		return element
	
	var _build: PBField
	func get_build() -> Array:
		return _build.value
	func clear_build() -> void:
		data[6].state = PB_SERVICE_STATE.UNFILLED
		_build.value = []
	func add_build() -> Card:
		var element = Card.new()
		_build.value.append(element)
		return element
	
	var _deads: PBField
	func get_deads() -> Array:
		return _deads.value
	func clear_deads() -> void:
		data[7].state = PB_SERVICE_STATE.UNFILLED
		_deads.value = []
	func add_deads() -> Card:
		var element = Card.new()
		_deads.value.append(element)
		return element
	
	var _hand_len: PBField
	func get_hand_len() -> int:
		return _hand_len.value
	func clear_hand_len() -> void:
		data[8].state = PB_SERVICE_STATE.UNFILLED
		_hand_len.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT64]
	func set_hand_len(value : int) -> void:
		_hand_len.value = value
	
	func to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PoolByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PoolByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class Attack:
	func _init():
		var service
		
		_target_player = PBField.new("target_player", PB_DATA_TYPE.STRING, PB_RULE.OPTIONAL, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
		service = PBServiceField.new()
		service.field = _target_player
		data[_target_player.tag] = service
		
		_target_card = PBField.new("target_card", PB_DATA_TYPE.STRING, PB_RULE.OPTIONAL, 2, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
		service = PBServiceField.new()
		service.field = _target_card
		data[_target_card.tag] = service
		
	var data = {}
	
	var _target_player: PBField
	func get_target_player() -> String:
		return _target_player.value
	func clear_target_player() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_target_player.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
	func set_target_player(value : String) -> void:
		_target_player.value = value
	
	var _target_card: PBField
	func get_target_card() -> String:
		return _target_card.value
	func clear_target_card() -> void:
		data[2].state = PB_SERVICE_STATE.UNFILLED
		_target_card.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
	func set_target_card(value : String) -> void:
		_target_card.value = value
	
	func to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PoolByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PoolByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class Cast:
	func _init():
		var service
		
		_target_card = PBField.new("target_card", PB_DATA_TYPE.STRING, PB_RULE.OPTIONAL, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
		service = PBServiceField.new()
		service.field = _target_card
		data[_target_card.tag] = service
		
	var data = {}
	
	var _target_card: PBField
	func get_target_card() -> String:
		return _target_card.value
	func clear_target_card() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_target_card.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
	func set_target_card(value : String) -> void:
		_target_card.value = value
	
	func to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PoolByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PoolByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
################ USER DATA END #################
