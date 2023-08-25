#!/bin/bash
protoc --proto_path=client/protos --go_out=protos --go_opt=paths=source_relative buff.proto
# ~/Soft/Godot_v3.5.2-stable_x11.64 -s ../client/addons/protobuf/protobuf_cmdln.gd --input=../client/protos/buff.proto --output=../client/protos/buff.gd
