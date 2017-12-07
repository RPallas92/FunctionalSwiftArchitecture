//
//  JokesPresentation.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/7/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import FunctionalKit

protocol JokesView {
    func showGenericError()
}

protocol JokeCategoriesListView : JokesView {
    func drawCategories(categories: [CategoryViewModel])
}

protocol JokeDetailView : JokesView {
    func drawJoke(category: JokeViewModel)
}

func onJokeCategoryClick(categoryName: String) -> Reader<GetCategoriesContext, Void> {
    return Reader<GetCategoriesContext, Void>.ask.flatMap { context -> Reader<GetCategoriesContext, Void> in
        context.jokesDetailPage.go(cateogryName: categoryName)
    }
}


func drawCategories(categories:[CategoryViewModel]) -> AsyncResult<GetCategoriesContext, Void> {
    return AsyncResult<GetCategoriesContext, Void>.ask.flatMap { context -> AsyncResult<GetCategoriesContext, Void> in
        context.view.drawCategories(categories: categories)
        return AsyncResult<GetCategoriesContext, Void>.pureT(())
    }
}

func toJokeViewModel(from joke: Joke) -> JokeViewModel {
    return JokeViewModel(id: joke.id, category: joke.category, iconUrl: joke.iconUrl, url: joke.url, value: joke.value)
}
func toCategoryViewModel(from category: Category) -> CategoryViewModel{
    return CategoryViewModel(name: category.name)
}
