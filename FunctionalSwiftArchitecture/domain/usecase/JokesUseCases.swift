//
//  JokesUseCases.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/6/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import FunctionalKit

func getCategoriesUseCase() -> AsyncResult<JokeContext, [Category]> {
    return getCategories(withPolicy: .NetworkOnly)
}

func getRandomJokeUseCase(forCategoryName name:String) -> AsyncResult<JokeContext, Joke> {
    return getRandomJoke(forCategoryName: name, withPolicy: .NetworkOnly)
}
