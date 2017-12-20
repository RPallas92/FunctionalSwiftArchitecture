//
//  JokeDetail.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/20/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import ArchitectureKit


typealias JokeUserAction = UserAction<JokeState, JokeEvent, JokeError, GetRandomJokeContext>
typealias JokeFeedback = Feedback<JokeState, JokeEvent, JokeError, GetRandomJokeContext>
typealias JokeSystem = System<JokeState,JokeEvent,JokeError,GetRandomJokeContext>

func onJokeViewLoaded(context: GetRandomJokeContext, withCategoryName categoryName: String) {
    
    let uiBinding: (JokeState) -> () = { state in
        if let joke = state.joke {
            context.view.drawJoke(joke: joke)
        }
        if let _ = state.error {
            context.view.showGenericError()
        }
    }
    
    let screenLoadedAction = JokeUserAction(trigger: JokeEvent.loadJoke)
    
    let system = JokeSystem.pure(
        initialState: JokeState.empty(categoryName),
        context: context,
        reducer: JokeState.reduce,
        uiBindings: [uiBinding],
        userActions: [screenLoadedAction],
        feedback: [JokeFeedback.react({ getRandomJoke(forCategoryName: $0.categoryName)}, when: { $0.shouldLoadJoke})]
    )
    
    system.addLoopCallback {
        print("System loop executed")
    }
    
    screenLoadedAction.execute()
}
