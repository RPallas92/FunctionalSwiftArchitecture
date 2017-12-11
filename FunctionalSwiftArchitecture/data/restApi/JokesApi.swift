//
//  JokesApi.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/10/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

/**
 * https://github.com/Moya/Moya/blob/master/docs/Examples/Basic.md
 * https://api.chucknorris.io/jokes/random?category=dev
 * https://api.chucknorris.io/jokes/categories
 */

enum JokesApi {
    case fetchCategories
    case fetchRandomJoke(forCategoryName: String)
}

extension JokesApi {
    var baseURL: URL { return URL(string: "https://api.chucknorris.io")! }
    
    
    var path: String {
        switch self {
        case .fetchCategories:
            return "/jokes/categories"
        case .fetchRandomJoke(let categoryName):
            return "/jokes/random?category=\(categoryName)"
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
