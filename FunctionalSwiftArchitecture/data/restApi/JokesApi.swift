//
//  JokesApi.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/10/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import Moya

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
    
    var method: Moya.Method {
        switch self {
        case .fetchCategories, .fetchRandomJoke:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .fetchCategories:
            return "[\"explicit\",\"dev\",\"movie\",\"food\",\"celebrity\",\"science\",\"political\",\"sport\",\"religion\",\"animal\",\"music\",\"history\",\"travel\",\"career\",\"money\",\"fashion\"]".data(using: .utf8)!
        case .fetchRandomJoke:
            return "{\"category\":[\"dev\"],\"icon_url\":\"https://assets.chucknorris.host/img/avatar/chuck-norris.png\",\"id\":\"1jgggc4rruety6zvlvb5ag\",\"url\":\"http://api.chucknorris.io/jokes/1jgggc4rruety6zvlvb5ag\",\"value\":\"Google won't search for Chuck Norris because it knows you don't find Chuck Norris, he finds you.\"}".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .fetchCategories, .fetchRandomJoke:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
