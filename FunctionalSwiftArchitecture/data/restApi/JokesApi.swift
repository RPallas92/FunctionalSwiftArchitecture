//
//  JokesApi.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/10/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import FunctionalKit

/**
 * https://api.chucknorris.io/jokes/random?category=dev
 * https://api.chucknorris.io/jokes/categories
 */

struct JokesApi {
    
    func fetchCategories() -> AsyncResult<JokeContext, [CategoryDto]> {
        return get(path: "jokes/categories")
            .mapTT{ $0 as! [String] }
            .mapTT { array in
                array.map { CategoryDto(name: $0) }
            }
    }
    
    func fetchRandomJoke(forCategoryName categoryName: String) -> AsyncResult<JokeContext, JokeDto> {
        return get(path: "jokes/random?category=\(categoryName)")
            .mapTT {$0 as! [String:Any]}
            .mapT { dictResult in
                dictResult.fold(
                    onSuccess: { dict in
                        if let joke:JokeDto = JokeDto(dict) {
                            return Result.success(joke)
                        } else {
                            return Result.failure(JokeError.UnknownServerError)
                        }
                    },
                    onFailure: { Result.failure($0)})
            }
    }

    private func get(path: String) -> AsyncResult<JokeContext, Any?> {
        return AsyncResult.unfold { context in
            Future.unfold { continuation in
                let request = NSMutableURLRequest(url: URL(string: context.apiUrl+path)!)
                request.addValue("application/json", forHTTPHeaderField: "Content-type")
                request.httpMethod = "GET"
                
                let session = URLSession(configuration: URLSessionConfiguration.default)
                session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    if let data = data {
                        let json = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                            continuation(Result.success(json))
                        } else {
                            continuation(Result.failure(JokeError.UnknownServerError))
                        }
                    }
                }.resume()
            }
        }
    }
}
