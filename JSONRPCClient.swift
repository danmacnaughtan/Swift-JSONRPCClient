//
//  JSONRPCClient.swift
//

import SwiftHTTP
import SwiftyJSON

public class JSONRPCClient {
    
    public static let VERSION = "2.0"
    
    /// Add a JSONRPC method call to the batch.
    /// - parameter id: The id of the query.
    /// - parameter method: The method name.
    /// - parameter arguments: The arguements JSON.
    public func query(id: Int, method: String, params: Any?) {
        
        var message: [String: Any] = [
            "jsonrpc": JSONRPCClient.VERSION,
            "id": id,
            "method": method
        ]
        
        if let args = params {
            message["params"] = args
        }
        
        messages.append(message)
    }
    
    /// Add a JSONRPC method that we are not expecting a response from.
    /// - parameter method: The method name.
    /// - parameter arguments: The arguments JSON.
    public func notify(method: String, arguments: [Any]?) {
        
        var message: [String: Any] = [
            "jsonrpc": JSONRPCClient.VERSION,
            "method": method
        ]
        
        if let args = arguments {
            message["params"] = args
        }
        
        messages.append(message)
    }
    
    /// Get the queued JSONRPC messages.
    /// - returns: The JSON object or array depending on the
    ///   number of messages, or nil.
    public func encode() -> Any? {
        
        var output: Any?
        let count = messages.count
        
        if count == 0 {
            return nil
        }
        
        if count == 1 {
            output = messages.first
        } else {
            output = messages
        }
        
        messages = []
        
        return output
    }
    
    /// Decodes the response into an array of JSON objects (regardless of the response type)
    /// RPC Error cases hare shared with the exceptopn handler asyncronously.
    /// Errors are also returned in the result, along with any other results (in the case of
    /// a batch call)
    ///
    /// - Note: Requires `SwiftyJSON`
    ///
    /// - parameter response: The response JSON object.
    /// - parameter exceptionHandler: The callback closure for handling any errors. (Default `nil`)
    /// - returns: An array of JSON objects (even if call was not a batch). Includes all error and
    ///    result json objects.
    public func decode(_ response: JSON, exceptionHandler: ((JSONRPCException) -> Void)? = nil) -> [JSON] {
        
        var resultArray: [JSON] = []
        var responseArray: [JSON] = []
        
        if let array = response.array {
            responseArray = array
        } else {
            responseArray = [response]
        }
        
        for resp in responseArray {
            
            // get the error object
            if resp["error"].exists() {
                let exception = JSONRPCException(
                    code: resp["error"]["code"].intValue,
                    message: resp["error"]["message"].stringValue,
                    data: resp["error"]["data"])
                if let handler = exceptionHandler {
                    handler(exception)
                }
                resultArray.append(resp["error"])
                continue
            }
            
            // get the result object
            if resp["result"].exists() {
                resultArray.append(resp["result"])
                continue
            }
            
            // error if both result and error are missing in response
            let exception = JSONRPCApplicationException(
                code: -32099,
                message: "Missing `result` or `error` in response.",
                data: nil)
            if let handler = exceptionHandler {
                handler(exception)
            }
        }
        
        return resultArray
    }
    
    // MARK: - Private
    
    /// The array of messages.
    private var messages = [Any]()
}
