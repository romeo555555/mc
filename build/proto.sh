#!/bin/bash
protoc --proto_path=client/proto --go_out=proto --go_opt=paths=source_relative buff.proto
