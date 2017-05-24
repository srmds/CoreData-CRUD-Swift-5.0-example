//
//  HTTPClient.swift
//  CoreDataCRUD
//
//  Copyright © 2016 Jongens van Techniek. All rights reserved.
//

import Foundation

/**
    HTTP Client to do HTTP requests.
*/
class HTTPClient {

    fileprivate var urlSession: URLSession!
    fileprivate var sessionConfiguration: URLSessionConfiguration!

    /**
        Configure NSURL Session.
    */
    init() {
        sessionConfiguration = URLSessionConfiguration.default
        urlSession = URLSession(configuration: sessionConfiguration)
    }

    /**
        Set the HTTP request headers.
        
        - Parameter headers: Dictionary<String, AnyObject> headers to set on the HTTP request.
    */
    func setAdditionalHeaders(_ headers: Dictionary<String, AnyObject>) {
        sessionConfiguration.httpAdditionalHeaders = headers
    }

    /**
        Set URL Query parameters.
        
        - Parameter params: Dictionary<String,AnyObject> parameters to set to build Query String.
        - Returns: String build Query String.
    */
    func queryBuilder(_ params: Dictionary<String, AnyObject>) -> String {

        var queryString: String = "?"
        var counter = 0

        for (key, value) in params {

            // Note that the append method utilized here, is a custom String extension,
            // see utils/StringExtension.swift.

            queryString.append("\(key)=\(value)")

            if params.count > 1  && counter != params.count {
                queryString.append("&")
            }

            counter += 1
        }

        return queryString
    }

    /**
        Do HTTP GET request with callback handler.
        
        - Parameter request: NSURLRequest the URL to do the request on.
        - Parameter callback: The callback handler that will contain the response and http status code.
        - Returns: Void
    */
    func doGet(_ request: URLRequest!, callback:@escaping (_ data: Data?, _ error: NSError?, _ httpStatusCode: HTTPStatusCode?) -> Void) {
        let task = urlSession.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if let responseError = error {
                callback(nil, responseError as NSError?, nil)
            } else if let httpResponse = response as? HTTPURLResponse {

                let httpStatus = self.getHTTPStatusCode(httpResponse)
                print("HTTP Status Code: \(httpStatus.rawValue) \(httpStatus)")

                if httpStatus.rawValue != 200 {
                    let statusError = NSError(domain:"com.io-pandacode.CoreDataCRUD", code:httpStatus.rawValue, userInfo:[NSLocalizedDescriptionKey: "HTTP status code: \(httpStatus.rawValue) - \(httpStatus)"])
                    callback(nil, statusError, httpStatus)
                } else {
                    callback(data, nil, httpStatus)
                }

            }
        })

        task.resume()
    }

    /**
        Get the HTTP status code of the request reponse.
        
        - Parameter httpURLResponse: the reponse that will contain the response code.
        - Returns: HTTPStatusCode status code of HTTP response.
    */
    func getHTTPStatusCode(_ httpURLResponse: HTTPURLResponse) -> HTTPStatusCode {
        var httpStatusCode: HTTPStatusCode!

        for status in HTTPStatusCode.getAll {
            if httpURLResponse.statusCode == status.rawValue {
                httpStatusCode = status
            }
        }

        return httpStatusCode
    }

}
