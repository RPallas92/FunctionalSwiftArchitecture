//
//  JokesRepository.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/5/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import FunctionalKit

enum CachePolicy {
    case NetworkOnly
    case NetworkFirst
    case LocalOnly
    case LocalFirst
}

func getCategories(withPolicy policy: CachePolicy) -> AsyncResult<JokeContext, [CategoryDto]> {
    switch policy {
    case .NetworkOnly:
        return fetchAllJokeCategories()
    case .NetworkFirst:
        return fetchAllJokeCategories() // TODO change to conditional call
    case .LocalOnly:
        return fetchAllJokeCategories() // TODO change to local only cache call
    case .LocalFirst:
        return fetchAllJokeCategories() // TODO change to conditional call
    }
}

func getRandomJoke(forCategoryName name: String, withPolicy policy: CachePolicy) -> AsyncResult<JokeContext, JokeDto> {
    switch policy {
    case .NetworkOnly:
        return fetchRandomJoke(forCategoryName: name)
    case .NetworkFirst:
        return fetchRandomJoke(forCategoryName: name) // TODO change to conditional call
    case .LocalOnly:
        return fetchRandomJoke(forCategoryName: name) // TODO change to local only cache call
    case .LocalFirst:
        return fetchRandomJoke(forCategoryName: name) // TODO change to conditional call
    }
}
