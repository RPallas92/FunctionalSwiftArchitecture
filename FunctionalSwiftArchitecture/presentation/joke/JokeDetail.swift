//
//  JokeDetail.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/20/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import ArchitectureKit

typealias JokeAction = Action<JokeState, JokeEvent, JokeError, GetRandomJokeContext>
typealias JokeUIButtonAction = UIButtonAction<JokeState, JokeEvent, JokeError, GetRandomJokeContext>
typealias JokeCustomAction = CustomAction<JokeState, JokeEvent, JokeError, GetRandomJokeContext>
typealias JokeFeedback = Feedback<JokeState, JokeEvent, JokeError, GetRandomJokeContext>
typealias JokeSystem = System<JokeState,JokeEvent,JokeError,GetRandomJokeContext>

func onJokeViewLoaded(context: GetRandomJokeContext, withCategoryName categoryName: String, withActions actions: [JokeAction]) {
    
    let uiBinding: (JokeState) -> () = { state in
        if let joke = state.joke {
            context.view.drawJoke(joke: joke)
        }
        if let _ = state.error {
            context.view.showGenericError()
        }
    }
    
    let system = JokeSystem.pure(
        initialState: JokeState.empty(categoryName),
        context: context,
        reducer: JokeState.reduce,
        uiBindings: [uiBinding],
        actions: actions,
        feedback: [JokeFeedback.react({ getRandomJoke(forCategoryName: $0.categoryName)}, when: { $0.shouldLoadJoke})]
    )
    
    system.addLoopCallback {
        print("System loop executed")
    }
}
