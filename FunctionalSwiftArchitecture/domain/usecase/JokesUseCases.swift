//
//  JokesUseCases.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/6/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import FunctionalKit

func getCategoriesUseCase<Context>(withContextType: Context.Type) -> AsyncResult<Context, [Category]> where Context : JokeContext{
    return getCategories(withPolicy: .NetworkOnly, andContextType: withContextType)
}

func getRandomJokeUseCase(forCategoryName name:String) -> AsyncResult<JokeContext, Joke> {
    return getRandomJoke(forCategoryName: name, withPolicy: .NetworkOnly)
}
