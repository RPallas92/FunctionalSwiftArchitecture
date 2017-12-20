//
//  JokeDetail+State.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/20/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

enum JokeEvent {
    case loadJoke
    case jokeLoaded(JokeViewModel)
    case error(JokeError)
}

struct JokeState {
    var joke: JokeViewModel?
    var categoryName = ""
    var shouldLoadJoke = false
    var error: JokeError?
    
    static var empty: (String) -> JokeState = { categoryName in
        JokeState(joke: nil, categoryName: categoryName, shouldLoadJoke: false, error: nil)
    }
    
    static func reduce(state: JokeState, event: JokeEvent) -> JokeState {
        switch event {
        case .loadJoke:
            var newState = state
            newState.shouldLoadJoke = true
            newState.joke = nil
            newState.error = nil
            return newState
        case .jokeLoaded(let joke):
            var newState = state
            newState.shouldLoadJoke = false
            newState.joke = joke
            newState.error = nil
            return newState
        case .error(let error):
            var newState = state
            newState.shouldLoadJoke = false
            newState.joke = nil
            newState.error = error
            return newState
        }
    }
}
