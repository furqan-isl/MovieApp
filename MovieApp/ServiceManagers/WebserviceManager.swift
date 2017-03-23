//
//  WebserviceManager.swift
//  MovieApp
//
//  Created by Furqan on 3/23/17.
//  Copyright © 2017 Furqan. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import ReachabilitySwift
import HTTPStatusCodes


typealias ResponseTuple = (success: Bool, hasInternetSuccess: Bool, message: String, responseDictionary:JSON?, completeJSONResponseDictionary: NSDictionary?)
typealias ResponseCompletionHandler = (_ returningResponseTuple: ResponseTuple) -> ()


class WebserviceManager: NSObject {
    
    // Singleton shared object
    static let shared = WebserviceManager()
    
    //declare this property where it won't go out of scope relative to your listener
    let reachability = Reachability()!
    var isConnectedToInternet: Bool = false

    
    private override init() {  //This prevents others from using the default '()' initializer for this Singleton class
        super.init()
        //Initialization
    }
    
    
    //Reachibility Configuration
    func configureInternetConnectivityCheck() {
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            self.isConnectedToInternet = true
            //            self.processSignUpStep1()
            
            self.getMoviesList(query: "batman", completionHandler: { (response: ResponseTuple) in
                print(response)
            })
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread
            print("Not reachable")
            self.isConnectedToInternet = false
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    
    
    func getMoviesList(query: String, completionHandler: @escaping ResponseCompletionHandler) {
        
        /*
         GET http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=batman
         {
         "api_key": "string",
         "query": "string"
         }
         */
        
        var parameters = [String : AnyObject]()
        parameters["api_key"] = Constants.ApiKeys.MOVIEDB_APIKEY as AnyObject?
        parameters["query"] = query as AnyObject?
        print(parameters)
        
        sendRequestWithParams(baseURL: Constants.URLs.APIBASE_URLSTRING, params: parameters as [String : AnyObject], webServiceName: "", requestMethod: .get) { (response: ResponseTuple) in
            
            completionHandler(response)
        }
    }

    
    
    func sendRequestWithParams(baseURL: String, params: [String: AnyObject], webServiceName: String, requestMethod: HTTPMethod, completionHandler: @escaping ResponseCompletionHandler) {
        var returningResponse: ResponseTuple = (false, false,"", nil, nil)
        
        if isConnectedToInternet == false {
            
            DispatchQueue.main.async {
                returningResponse.success = false
                returningResponse.message = "Internet connection appears to be offline"
                returningResponse.hasInternetSuccess = false
                // Calling completion handler with no connectivity status
                completionHandler(returningResponse)
            }
            return
        }
        
        let paramEncoding: ParameterEncoding = URLEncoding.default
        let url = baseURL
        
        // Calling the service with corresponding parameters using Alamofire
        
        
        Alamofire.request(url, method: requestMethod, parameters: params, encoding: paramEncoding, headers: nil).responseJSON { (response: DataResponse<Any>) in
            
            
            print(response)
            debugPrint("Calling Web service : \(baseURL + webServiceName)")
            debugPrint("Passing parmeters \n")
            debugPrint("Request Method : \(requestMethod)")
            debugPrint("Alamofire Request Body : \(response.request?.httpBody)")
            debugPrint("Alamofire Request URL String : \(response.request?.urlRequest)")
            debugPrint("Alamofire Request Status Code : \(response.response?.statusCode)")
            debugPrint("Alamofire All header fields : \(response.response?.allHeaderFields)")
            
            // Handle other Generic error codes e.g. 200, 500
            // Do stuff here and call the completion right from this code
            
            
            if response.response?.statusCode == nil {
                returningResponse.success = false
                returningResponse.message = "request is not processed"
                returningResponse.hasInternetSuccess = true
                completionHandler(returningResponse)
                return
            }
            
            let statusCodeResponse = HTTPStatusCode(rawValue: (response.response?.statusCode)!)
            let responseValue = response.result.value as? NSDictionary
            
            if let value = response.result.value {
                // handle the results as JSON, without a bunch of nested if loops
                returningResponse.responseDictionary = JSON(value)
            }
            returningResponse.completeJSONResponseDictionary = response.result.value as? NSDictionary
            
            if statusCodeResponse == .ok { // 200
                returningResponse.success = true
                returningResponse.hasInternetSuccess = true
                completionHandler(returningResponse)
                return
            } else {
                
                //Error
                var errorMessage = "Something went wrong"
                if let responseValueDictionary = responseValue {
                    if let error = responseValueDictionary["Error"] {
                        errorMessage = error as! String
                    }
                    else if let error = responseValueDictionary["error"] {
                        errorMessage = error as! String
                    }
                }
                
                if statusCodeResponse == .internalServerError { // 500
                    returningResponse.success = false
                    returningResponse.message = errorMessage
                    returningResponse.hasInternetSuccess = true
                    completionHandler(returningResponse)
                    return
                } else {
                    
                    returningResponse.success = false
                    returningResponse.message = errorMessage
                    returningResponse.hasInternetSuccess = true
                    completionHandler(returningResponse)
                }
            }
            
        }.resume()
    }

    
    
    
    

}
