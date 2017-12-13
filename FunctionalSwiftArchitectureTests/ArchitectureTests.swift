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
        
        func toAsyncResult(results: [AsyncResult<JokeContext, Event>]) -> AsyncResult<JokeContext, [Event]> {
            return results.reduce(AsyncResult<JokeContext,[Event]>.pureTT([]), { (acc, current) -> AsyncResult<JokeContext,[Event]> in
                return acc.flatMapTT{ accValue -> AsyncResult<JokeContext, [Event]> in
                    return current.mapTT { currentValue -> [Event] in
                        accValue + [currentValue]
                    }
                }
            })
        }
        
        let expect = expectation(description: "testArchitecture")
        
        let context = AppContext()
        
        struct System {
            static var doNothing = AsyncResult<AppContext,Event>.pureTT(Event.doNothing)
            
            var initialState: State
            var context: AppContext
            var reducer: (State, Event) -> State
            var uiBindings: (State) -> AsyncResult<AppContext, Void>
            var userActions: () -> AsyncResult<AppContext, Event>
            var feedback: [(State) -> AsyncResult<AppContext, Event>]
            
            static func pure(
                initialState: State,
                context: AppContext,
                reducer: @escaping (State, Event) -> State,
                uiBindings: @escaping (State) -> AsyncResult<AppContext, Void>,
                userActions: @escaping () -> AsyncResult<AppContext, Event>,
                feedback: [(State) -> AsyncResult<AppContext, Event>]
                ) -> System {
                
                return System(initialState: initialState, context: context, reducer: reducer, uiBindings: uiBindings, userActions: userActions, feedback: feedback)
            }
            
            func run(callback: @escaping ()->()){

                //User Action
                let loop = self.userActions().mapTT { event in
                    State.reduce(state: self.initialState, event: event)
                }
                    //Feedback
                    .flatMapTT { state in
                        let feedbackAsyncResults = self.feedback.map { feedbackFunction in
                            
                        }
                        let feedbackResult = toAsyncResult(results: self.feedback)
                       // feedbackResult.
                        
                        //let feedbackEvents: AsyncResult<AppContext, [Event]>
                        
                        //reduce self.feedback (initial value state) then retrun (state) and current value event
                        self.feedback[0](state)
                            .mapTT { event -> State in
                                State.reduce(state: state, event: event)
                        }
                    }
                    //View bindings
                    .flatMapTT { state in
                        self.uiBindings(state)
                }
                
                
                loop.runT(self.context, { stateResult in
                    callback()
                    //do another loop
                })
            }
        }
        
        enum Event {
            case loadCategories
            case categoriesLoaded(Result<JokeError, [CategoryViewModel]>)
            case doNothing //TODO
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
                case .doNothing:
                    return state
                }
            }
        }
        
        
        func tapOnLoadCategoriesButton() -> AsyncResult<AppContext, Event> {
            return AsyncResult<AppContext, Event>.pureTT(Event.loadCategories)
        }
        
        func categoriesBinding(state: State) -> AsyncResult<AppContext, Void> {
            return AsyncResult<AppContext, Void>.ask.flatMap { context -> AsyncResult<AppContext, Void> in
                print(state.categories)
                return AsyncResult<AppContext, Void>.pureTT(())
            }
        }
        
        func loadCategoriesFeedback(state: State) -> AsyncResult<AppContext, Event> {
            if(state.shouldLoadData){
                let categories = [
                    CategoryViewModel(name: "dev")
                ]
                return AsyncResult<AppContext,Event>.pureTT(Event.categoriesLoaded(Result.success(categories)))
            } else {
                return System.doNothing
            }
        }
        
        let initialState = State.empty
        let userActions = tapOnLoadCategoriesButton
        let uiBindings = categoriesBinding
        let feedback = [loadCategoriesFeedback]
        
        let system = System.pure(
            initialState: initialState,
            context: context,
            reducer: State.reduce,
            uiBindings: uiBindings,
            userActions: userActions,
            feedback: feedback
        )
        
        
        system.run {
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1.0)
    }
    
    
    func testAsyncResultTraverse(){
        let expect = expectation(description: "testAsyncResultTraverse")
        
        let asyncResults = [
            AsyncResult<JokeContext, Int>.pureTT(1),
            AsyncResult<JokeContext, Int>.pureTT(2)
        ]
        


        let finalResult = toAsyncResult(results: asyncResults)
        
        finalResult.runT(AppContext(), { result in
            XCTAssertEqual(result.tryRight!, [1,2])
            expect.fulfill()
        })
        wait(for: [expect], timeout: 1.0)

    }
    
    
    
    
}
