//
//  SwiftHTTP+PostAny.swift
//

import SwiftHTTP

extension HTTP {
    
    /// Adds a more convenient post method that can take `Any` as a parameter,
    /// letting the method deal with handling `Array` vs `Dictionary` casting.
    /// Additionally defaults to using `JSONParameterSerializer` as the
    /// `requestSerializer`.
    /// - parameter url: The post url.
    /// - parameter params: The post parameters.
    /// - parameter headers: The post headers.
    /// - parameter completionHandler: The response closure.
    @discardableResult
    open class func postAny(_ url: String, params: Any? = nil, headers: [String: String]? = nil, completionHandler: ((Response) -> Void)? = nil) -> HTTP? {
        
        if params is Array<Any> {
            return HTTP.POST(url, parameters: params as! Array<Any>, headers: headers,
                             requestSerializer: JSONParameterSerializer(),
                             completionHandler: completionHandler)
        }
        
        if params is Dictionary<String, Any> {
            return HTTP.POST(url, parameters: params as! Dictionary<String, Any>, headers: headers,
                             requestSerializer: JSONParameterSerializer(),
                             completionHandler: completionHandler)
        }
        
        return HTTP.POST(url, parameters: nil, headers: headers,
                         requestSerializer: JSONParameterSerializer(),
                         completionHandler: completionHandler)
    }
}

