//
//  HTTPClient.swift
//  CoreDataCRUD
//
//  Created by c0d3r on 04/10/15.
//  Copyright © 2015 io pandacode. All rights reserved.
//

import Foundation

/**
    HTTP Client to do HTTP requests.
*/
class HTTPClient {
    
    private var urlSession:NSURLSession!
    private var sessionConfiguration:NSURLSessionConfiguration!
    
    /**
        Configure NSURL Session.
    */
    init(){
        sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSession = NSURLSession(configuration: sessionConfiguration)
    }
    
    /**
        Set the HTTP request headers.
        
        - Parameter headers: Dictionary<String, AnyObject> headers to set on the HTTP request.
    */
    func setAdditionalHeaders(headers: Dictionary<String, AnyObject>){
        sessionConfiguration.HTTPAdditionalHeaders = headers
    }
    
    /**
        Set URL Query parameters.
        
        - Parameters params: Dictionary<String,AnyObject> parameters to set to build Query String.
        - Returns: String build Query String.
    */
    func queryBuilder(params: Dictionary<String,AnyObject>) -> String {
        
        var queryString:String = ""
        var counter = 0
        
        for (key, value) in params {
            if counter != 0 {
                if params.count > 1{
                    queryString.append("&")
                }
            } else {
                queryString.append("?")
            }
            
   
            queryString.append("\(key)=\(value)")
            ++counter
        }
        
        return queryString
    }
    
    /**
        Do HTTP GET request with callback handler.
        
        - Parameter request: NSURLRequest the URL to do the request on.
        - Parameter callback: The callback handler that will contain the response and http status code.
        - Returns: Void
    */
    func doGet(request: NSURLRequest!, callback:(data: NSData?, error: NSError?, httpStatusCode: HTTPStatusCode?) -> Void) {
        let task = urlSession.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if let responseError = error {
                callback(data: nil, error: responseError,httpStatusCode: nil)
            }
            else if let httpResponse = response as? NSHTTPURLResponse {
                
                let httpStatus = self.getHTTPStatusCode(httpResponse)
                print("HTTP Status Code: \(httpStatus.rawValue) \(httpStatus)")
                
                if httpStatus.rawValue != 200 {
                    let statusError = NSError(domain:"com.io-pandacode.CoreDataCRUD", code:httpStatus.rawValue, userInfo:[NSLocalizedDescriptionKey : "HTTP status code: \(httpStatus.rawValue) - \(httpStatus)"])
                    callback(data: nil, error: statusError, httpStatusCode: httpStatus)
                } else {
                    callback(data: data, error: nil, httpStatusCode: httpStatus)
                }
                
            }
        }
        
        task.resume()
    }
    
    /**
        Get the HTTP status code of the request reponse.
        
        - Parameter httpURLResponse: the reponse that will contain the response code.
        - Returns: HTTPStatusCode status code of HTTP response.
    */
    func getHTTPStatusCode(httpURLResponse:NSHTTPURLResponse) -> HTTPStatusCode {
        var httpStatusCode:HTTPStatusCode!
        
        for status in HTTPStatusCode.getAll {
            if httpURLResponse.statusCode == status.rawValue {
                httpStatusCode = status
            }
        }
        
        return httpStatusCode
    }
    
}