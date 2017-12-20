//
//  Categories+State.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/20/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

enum CategoriesEvent {
    case loadCategories
    case categoriesLoaded([CategoryViewModel])
    case error(JokeError)
}

struct CategoriesState {
    var categories: [CategoryViewModel]
    var shouldLoadCategories = false
    var error: JokeError?
    
    static var empty = CategoriesState(categories: [], shouldLoadCategories: false, error: nil)
    
    static func reduce(state: CategoriesState, event: CategoriesEvent) -> CategoriesState {
        switch event {
        case .loadCategories:
            var newState = state
            newState.shouldLoadCategories = true
            newState.categories = []
            newState.error = nil
            return newState
        case .categoriesLoaded(let categories):
            var newState = state
            newState.shouldLoadCategories = false
            newState.categories = categories
            newState.error = nil
            return newState
        case .error(let error):
            var newState = state
            newState.shouldLoadCategories = false
            newState.categories = []
            newState.error = error
            return newState
        }
    }
}
