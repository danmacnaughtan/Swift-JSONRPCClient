//
//  JSONRPCException.swift
//

public class JSONRPCException {
    let code: Int
    let message: String
    let data: Any?
    
    init(code: Int, message: String, data: Any?) {
        self.code = code
        self.message = message
        self.data = data
    }
}

public class JSONRPCApplicationException: JSONRPCException {}
