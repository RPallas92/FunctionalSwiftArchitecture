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
        
        let expect = expectation(description: "testArchitecture")

        let context = AppContext()
        
        enum Event {
            case loadCategories
            case categoriesLoaded(Result<JokeError, [CategoryViewModel]>)
            case nothing //TODO
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
                case .nothing:
                    return state
                }
            }
        }
        
        
        func tapOnLoadCategoriesButton() -> AsyncResult<AppContext, Event> {
            return AsyncResult<AppContext, Event>.pureTT(Event.loadCategories)
        }
        
        func categoriesSubscription() -> (State) -> () {
            return { state in
                print(state.categories)
            }
        }
        
        
        let uiActions = tapOnLoadCategoriesButton
        let uiSubscriptions = categoriesSubscription()
        //let feedback
        
        func loadCategoriesFeedback(state: State) -> AsyncResult<AppContext, Event> {
            if(state.shouldLoadData){
                let categories = [
                    CategoryViewModel(name: "dev")
                ]
                return AsyncResult<AppContext,Event>.pureTT(Event.categoriesLoaded(Result.success(categories)))
            } else {
                return AsyncResult<AppContext,Event>.pureTT(Event.nothing)
            }
        }
        
        //Simulate user Event
        let initialState = State.empty
        let loop = uiActions().mapTT { event in
            State.reduce(state: initialState, event: event)
        }.flatMapTT { state in
            loadCategoriesFeedback(state: state)
                .mapTT { event -> State in
                    State.reduce(state: state, event: event)
                }
        }
        
        
        loop.runT(context, { stateResult in
            let state = stateResult.tryRight!
            uiSubscriptions(state)
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 1.0)

        
        
        //Actions
        //Feedback
        //Subscriptions
    }
    
}
