//
//  JokeDetail+Feedback.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/20/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

func getRandomJoke(forCategoryName name: String) -> AsyncResult<GetRandomJokeContext, JokeEvent> {
    return getRandomJokeUseCase(forCategoryName: name, withContextType: GetRandomJokeContext.self)
        .mapTT { toJokeViewModel(from: $0) }
        .mapTT { JokeEvent.jokeLoaded($0) }
        .handleErrorWith { AsyncResult.pureTT(JokeEvent.error($0))}
}
