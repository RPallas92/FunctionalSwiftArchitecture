//
//  ArchitectureTests.swift
//  FunctionalSwiftArchitectureTests
//
//  Created by Pallas, Ricardo on 12/13/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import XCTest
import FunctionalKit

fileprivate typealias Function = () -> ()
fileprivate typealias Completable = (@escaping Function) -> ()

fileprivate func runInBackground(_ asyncCode: @escaping(@escaping Completable)->()) {
    DispatchQueue.global(qos: .background).async {
        asyncCode { inMainThread in
            DispatchQueue.main.async {
                inMainThread()
            }
        }
    }
}

class ArchitectureTests: XCTestCase {
    
    
    func testArchitecture(){
        
        let expect = expectation(description: "testArchitecture")
        
        let context = AppContext()
        
        class System {
            static var doNothing = AsyncResult<AppContext,Event>.pureTT(Event.doNothing)
            
            var loops = [AsyncResult<AppContext, Void>]()
            var callback: (() -> ())? = nil
            
            var initialState: State
            var context: AppContext
            var reducer: (State, Event) -> State
            var uiBindings: (State) -> AsyncResult<AppContext, Void>
            var userActions: UserAction
            var feedback: [(State) -> AsyncResult<AppContext, Event>]
            
            //var actionObserver: (AsyncResult<AppContext, Event>) -> ()
            
            private init(
                initialState: State,
                context: AppContext,
                reducer: @escaping (State, Event) -> State,
                uiBindings: @escaping (State) -> AsyncResult<AppContext, Void>,
                userActions: UserAction,
                feedback: [(State) -> AsyncResult<AppContext, Event>]
                ) {
                
                self.initialState = initialState
                self.context = context
                self.reducer = reducer
                self.uiBindings = uiBindings
                self.userActions = userActions
                self.feedback = feedback
            }
            static func pure(
                initialState: State,
                context: AppContext,
                reducer: @escaping (State, Event) -> State,
                uiBindings: @escaping (State) -> AsyncResult<AppContext, Void>,
                userActions: UserAction,
                feedback: [(State) -> AsyncResult<AppContext, Event>]
            ) -> System {
                return System(initialState: initialState, context: context, reducer: reducer, uiBindings: uiBindings, userActions: userActions, feedback: feedback)
            }
            
            func onUserAction(event: AsyncResult<AppContext,Event>) {
                doLoop(event)
                    //IMPURE PART: EXECUTE SIDE EFFECTS
                    .runT(self.context, { stateResult in
                        assert(Thread.isMainThread, "ArchitectureKit: Final callback must be run on main thread")
                        if let callback = self.callback {
                            callback()
                        }
                    })
            }
            
            func run(callback: @escaping ()->()){
                self.callback = callback
                self.userActions.addListener(system: self)
            }
            
            func doLoop(_ eventResult: AsyncResult<AppContext, Event>) -> AsyncResult<AppContext, Void> {
                return eventResult
                    //User action
                    .mapTT { event in
                        State.reduce(state: self.initialState, event: event)
                    }
                    //Feedback
                    .flatMapTT { state in
                        let stateAfterFeedback = self.feedback.reduce(
                            AsyncResult<AppContext, State>.pureTT(state),
                            { (previousState, feedbackFunction) -> AsyncResult<AppContext, State> in
                                previousState.flatMapTT { stateValue -> AsyncResult<AppContext, State> in
                                    let computedEvent = feedbackFunction(stateValue)
                                    return computedEvent.mapTT { eventValue in
                                        State.reduce(state: stateValue, event: eventValue)
                                    }
                                }
                        })
                        return stateAfterFeedback
                    }
                    //View bindings
                    .flatMapTT { state in
                        self.uiBindings(state)
                    }
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
        
        
   
        
        class UserAction {
            let asyncResult = AsyncResult<AppContext, Event>.pureTT(Event.loadCategories)
            var listeners = [System]()
            
            init() {
            }
            func execute(value: Int) {
                let action = AsyncResult<AppContext, Int>.pureTT(5).mapTT { number -> Event in
                    print("UserAction executed with value: " + String(value))
                    return Event.loadCategories
                }
                
                notify(action)
            }
            
            
            func addListener(system: System) {
                listeners.append(system)
            }
            
            func notify(_ action: AsyncResult<AppContext, Event>) {
                listeners.forEach { system in
                    system.onUserAction(event: action)
                }
            }
        }
        
        let tapUserAction = UserAction()
        
        func tapOnLoadCategoriesButton() {
            tapUserAction.execute(value: 5)
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
                
                return AsyncResult<AppContext, Event>.unfold { _ in
                    return Future.unfold { continuation in
                        
                        runInBackground { runInUI in
                            let result = Result<JokeError, Event>.success(Event.categoriesLoaded(Result.success(categories)))
                            runInUI {
                                continuation(result)
                            }
                        }
                    }
                }
            } else {
                return System.doNothing
            }
        }
        
        let initialState = State.empty
        let userActions = tapUserAction
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
        
        //Simulate user interaction
        tapOnLoadCategoriesButton()
        tapOnLoadCategoriesButton()
        
        wait(for: [expect], timeout: 1.0)
    }
    
}
