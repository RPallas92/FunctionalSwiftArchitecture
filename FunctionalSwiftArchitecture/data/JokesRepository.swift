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

func getCategories(withPolicy policy: CachePolicy) -> AsyncResult<JokeContext, [Category]> {
    switch policy {
    case .NetworkOnly:
        return getTransformedCategories()
    case .NetworkFirst:
        return getTransformedCategories() // TODO change to conditional call
    case .LocalOnly:
        return getTransformedCategories() // TODO change to local only cache call
    case .LocalFirst:
        return getTransformedCategories() // TODO change to conditional call
    }
}

func getRandomJoke(forCategoryName name: String, withPolicy policy: CachePolicy) -> AsyncResult<JokeContext, Joke> {
    switch policy {
    case .NetworkOnly:
        return getTransformedRandomJoke(forCategoryName: name)
    case .NetworkFirst:
        return getTransformedRandomJoke(forCategoryName: name) // TODO change to conditional call
    case .LocalOnly:
        return getTransformedRandomJoke(forCategoryName: name) // TODO change to local only cache call
    case .LocalFirst:
        return getTransformedRandomJoke(forCategoryName: name) // TODO change to conditional call
    }
}

//TODO use Monad transoformers
fileprivate func getTransformedCategories() -> AsyncResult<JokeContext, [Category]> {
    return fetchAllJokeCategories().map { future in
        future.map { result in
            result.map { categoriesDto in
                categoriesDto.map { categoryDto in
                    mapToCategory(from: categoryDto)
                }
            }
        }
    }
}

//TODO use Monad transformers
fileprivate func getTransformedRandomJoke(forCategoryName categoryName: String) -> AsyncResult<JokeContext, Joke> {
    return fetchRandomJoke(forCategoryName: categoryName).map { future in
        future.map { result in
            result.map { jokeDto in
                mapToJoke(from: jokeDto)
            }
        }
    }
}
