public func decode<T:Decodable>(_ type:T.Type, bytes:consuming [UInt8], flags:consuming Decoding.Flags = Decoding.Flags(), memory memconfig:consuming Memory.Configuration = .automatic) throws -> T {
	return try bytes.withUnsafeMutableBytes { (buf) in
		return try decode(type, buffer:buf, flags:flags, memory:memconfig)
	}
}

public func decode<T:Decodable>(bytes:consuming [UInt8], flags:consuming Decoding.Flags = Decoding.Flags(), memory memconfig:consuming Memory.Configuration = .automatic, _ handlerFunc:(Swift.Decoder) throws -> T) throws -> T {
	return try bytes.withUnsafeMutableBytes { (buf) in
		return try decode(buffer:buf, flags:flags, memory:memconfig, handlerFunc)
	}
}