//
//  ArchitectureTests.swift
//  FunctionalSwiftArchitectureTests
//
//  Created by Pallas, Ricardo on 12/13/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import XCTest
import FunctionalKit

class ArchitectureTests: XCTestCase {
    
    func testArchitecture(){
        
        enum Event {
            case loadCategories
            case categoriesLoaded(Result<JokeError, [CategoryViewModel]>)
        }
        
        struct State {
            var categories: [CategoryViewModel]
            var shouldLoadData = false
            
            static var empty = State(categories: [], shouldLoadData: false)
            static func reduce(state: State, event: Event) -> State {
                switch event {
                case .loadCategories:
                    var newState = state
                    newState.shouldLoadData = true
                    newState.categories = []
                    return newState
                case .categoriesLoaded(let categoriesResult):
                    var newState = state
                    newState.shouldLoadData = false
                    newState.categories = categoriesResult.tryRight!
                    return newState
                }
            }
        }
        
        
        func tapOnLoadCategoriesButton() -> AsyncResult<JokeContext, Event> {
            return AsyncResult<JokeContext, Event>.pureTT(Event.loadCategories)
        }
        
        
        let uiActions = tapOnLoadCategoriesButton
        
    }
    
}
