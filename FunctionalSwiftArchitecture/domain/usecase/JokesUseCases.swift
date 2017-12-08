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

func getRandomJokeUseCase<Context>(forCategoryName name:String, withContextType: Context.Type) -> AsyncResult<Context, Joke> where Context: JokeContext {
    return getRandomJoke(forCategoryName: name, withPolicy: .NetworkOnly, andContextType: withContextType)
}
