
//
//  JSONParsing.swift
//  CryptoFinder
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import Foundation
import CoreData

class Client {
    
    static var sharedViewContext : NSManagedObjectContext!
    
    func endPoint(_ query: String) -> String {
        return "https://min-api.cryptocompare.com/\(query)"
    }
    
    func endPointGraph(_ query: String) -> String {
        return "https://rest.coinapi.io/\(query)"
    }
    
    func taskForGetMethodCompare(completionHandler: @escaping (_ result: Any?, _ statusCode: Int?, _ error: Error?) -> Void ) -> Void {
        // Setup Url Request

        
        let request = URL(string: "https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,ETH,DASH,DOGE,XRM,LTC,XRP,ZEC,EOS,ETC,TRX,BCC,NEO&tsyms=USD,EUR,CNY,BRL,GBP&api_key=f551db7c7e15e790aa3de08fab1cef3824e0da1d870234ef225578c391137022")
        
        
        // Make Request
        let session = URLSession.shared
        let task = session.dataTask(with: request!) { (data, response, error) in
            //Print Error Or Bad Status Code
            func sendError(error: Error?, response: URLResponse?) {
                print("Error: \(error.debugDescription)", "\nResponse: \(response.debugDescription)")
                completionHandler(nil, (response as? HTTPURLResponse)?.statusCode, error)
            }
            /* GUARD: Error */
            guard (error == nil) else {
                sendError( error: error, response: nil)
                return
            }
            /* GUARD: Response */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error: nil, response: response)
                return
            }
            /* GUARD: Data */
            guard let data = data else {
                return
            }
            self.parseJSON("taskForGetMethodCompare", data, completionHandlerForData: completionHandler)
        }
        task.resume()
    }
    
    func taskForGetMethod(_ query: String, completionHandler: @escaping (_ result: Any?, _ statusCode: Int?, _ error: Error?) -> Void ) -> Void {
        // Setup Url Request
        let endPointUrl = URL(string: endPoint(query))
        
        let request = NSMutableURLRequest(url: endPointUrl!)
                
        // Make Request
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            //Print Error Or Bad Status Code
            func sendError(error: Error?, response: URLResponse?) {
                print("Error: \(error.debugDescription)", "\nResponse: \(response.debugDescription)")
                completionHandler(nil, (response as? HTTPURLResponse)?.statusCode, error)
            }
            /* GUARD: Error */
            guard (error == nil) else {
                sendError( error: error, response: nil)
                return
            }
            /* GUARD: Response */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error: nil, response: response)
                return
            }
            /* GUARD: Data */
            guard let data = data else {
                return
            }
            self.parseJSON("taskForGetMethod", data, completionHandlerForData: completionHandler)
        }
        task.resume()
    }
    
    func taskForGetMethodGraph(_ query: String, completionHandler: @escaping (_ result: Any?, _ statusCode: Int?, _ error: Error?) -> Void ) -> Void {
        let endPointUrl = URL(string: endPointGraph(query))
        let request = NSMutableURLRequest(url: endPointUrl!)
        
        request.setValue("289CAF59-FB2B-4422-9D84-4CC55CDA4F93", forHTTPHeaderField: "X-CoinAPI-Key")
        // Make Request
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            //Print Error Or Bad Status Code
            func sendError(error: Error?, response: URLResponse?) {
                print("Error: \(error.debugDescription)", "\nResponse: \(response.debugDescription)")
                completionHandler(nil, (response as? HTTPURLResponse)?.statusCode, error)
            }
            /* GUARD: Error */
            guard (error == nil) else {
                sendError( error: error, response: nil)
                return
            }
            /* GUARD: Response */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error: nil, response: response)
                return
            }
            /* GUARD: Data */
            guard let data = data else {
                return
            }
            self.parseJSON("taskForGetMethodGraph", data, completionHandlerForData: completionHandler)
        }
        task.resume()
    }

    
    // MARK: - Convert Data Method
    private func parseJSON(_ method:String, _ data: Data, completionHandlerForData: (_ result: Any?, _ statusCode: Int?, _ error: Error?)-> Void){
        
        let decoder = JSONDecoder()
        var result: Any?
        
        do {
            guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                fatalError("Failed to retrieve context")
            }
            // Parse JSON data
            let managedObjectContext = Client.sharedViewContext
            decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext

            switch method {
            case "taskForGetMethod":
                result = try? decoder.decode(APIRoot.self, from: data)
                completionHandlerForData(result, nil, nil)
                
            case "taskForGetMethodGraph":
                result = try? decoder.decode([ModelGraph].self, from: data)
                completionHandlerForData(result, nil, nil)
                
            case "taskForGetMethodCompare":
                result = try? decoder.decode(APIPrices.self, from: data)
                completionHandlerForData(result, nil, nil)
            default:
                return
            }
        }
    }
}



