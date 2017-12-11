//
//  JokesNetworkDataSource.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/5/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import FunctionalKit

struct JokesNetworkDataSource : JokesDataSource {
    let api = JokesApi()
    
    func fetchAllJokeCategories<Context>() -> AsyncResult<Context, Array<CategoryDto>> where Context : JokeContext{
        return api.fetchCategories()
            .mapTT { array -> [CategoryDto] in
                array.map { CategoryDto(name: $0) }
        }
    }
    
    func fetchRandomJoke<Context>(forCategoryName categoryName: String) -> AsyncResult<Context, JokeDto> where Context : JokeContext {
        return api.fetchRandomJoke(forCategoryName: categoryName)
            .mapT { dictResult in
                dictResult.flatMap { dict -> Result<JokeError, JokeDto> in
                    if let joke:JokeDto = JokeDto(dict) {
                        return Result.success(joke)
                    } else {
                        return Result.failure(JokeError.UnknownServerError)
                    }
                }
        }
    }
}
