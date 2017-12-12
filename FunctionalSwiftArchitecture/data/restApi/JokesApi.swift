//
//  JokesApi.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/10/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import FunctionalKit

struct JokesApi {
    
    func fetchCategories<Context>() -> AsyncResult<Context, [String]> where Context : JokeContext{
        return get(path: "jokes/categories")
            .mapTT{ $0 as! [String] }
    }
    
    func fetchRandomJoke<Context>(forCategoryName categoryName: String) -> AsyncResult<Context, [String:Any]> where Context : JokeContext{
        return get(path: "jokes/random?category=\(categoryName)")
            .mapTT {$0 as! [String:Any]}
    }

    private func get<Context>(path: String) -> AsyncResult<Context, Any?> where Context: JokeContext {
        return AsyncResult.unfold { context in
            Future.unfold { continuation in
                let request = NSMutableURLRequest(url: URL(string: context.apiUrl+path)!)
                request.addValue("application/json", forHTTPHeaderField: "Content-type")
                request.httpMethod = "GET"
                
                let session = URLSession(configuration: URLSessionConfiguration.default)
                session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    if let data = data {
                        let json = try? JSONSerialization.jsonObject(with: data, options: [])
                        DispatchQueue.main.async {
                            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                                continuation(Result.success(json))
                            } else {
                                continuation(Result.failure(JokeError.UnknownServerError))
                            }
                        }
                    } else {
                        continuation(Result.failure(JokeError.UnknownServerError))
                    }
                }.resume()
            }
        }
    }
}
