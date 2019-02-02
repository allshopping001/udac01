//
//  JSONParsing.swift
//  CryptoFinder
//
//  Created by Notebook on 5/12/18.
//  Copyright © 2018 Notebook. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class JsonGraphParsing{
    
    func endPoint(_ query: String) -> String {
        return "https://rest.coinapi.io/\(query)"
    }
    
    func JsonParsing(_ query: String, completionHandler: @escaping([ModelGraph]?, ErrorHandling?) -> Void){
        // Setup Url Request
        let endPointUrl = endPoint(query)
        guard let url = URL(string: endPointUrl) else {
            completionHandler(nil, .urlRequestFailure)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("289CAF59-FB2B-4422-9D84-4CC55CDA4F93", forHTTPHeaderField: "X-CoinAPI-Key")
        
        // Make Request
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completionHandler(nil, .noConnection)
                return
            }
            // Get Response
            guard let dataResponse = data else {
                completionHandler(nil, .responseUnsuccessful)
                return
            }
            
            guard let statusCode = response else {
                return
            }
            
            // Decode
            let decoder = JSONDecoder()
            
            do {
                let modelDecoded = try decoder.decode([ModelGraph].self, from: dataResponse)
                completionHandler(modelDecoded, nil)
            } catch {
                completionHandler(nil, .jsonParsingFailure)
            }
        }
        task.resume()
    }
}



