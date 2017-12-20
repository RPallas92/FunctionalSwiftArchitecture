//
//  ViewModelMappers.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/20/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

func toJokeViewModel(from joke: Joke) -> JokeViewModel {
    return JokeViewModel(id: joke.id, iconUrl: joke.iconUrl, url: joke.url, value: joke.value)
}

func toCategoryViewModel(from category: Category) -> CategoryViewModel{
    return CategoryViewModel(name: category.name)
}

func toCategoriesViewModel(from categories: [Category]) -> [CategoryViewModel] {
    return categories.map(toCategoryViewModel)
}
