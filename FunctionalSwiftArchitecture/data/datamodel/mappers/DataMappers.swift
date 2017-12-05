//
//  DataMappers.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/5/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

func mapToJoke(from jokeDto:JokeDto) -> Joke {
    return Joke(id: jokeDto.id, category: jokeDto.category, iconUrl: jokeDto.iconUrl, url: jokeDto.url, value: jokeDto.value)
}

func mapToCategory(from categoryDto:CategoryDto) -> Category {
    return Category(name: categoryDto.name)
}
