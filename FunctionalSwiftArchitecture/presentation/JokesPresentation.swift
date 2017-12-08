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
    func drawJoke(joke: JokeViewModel)
}

func onJokeCategoryClick(categoryName: String) -> Reader<GetCategoriesContext, Void> {
    return Reader<GetCategoriesContext, Void>.ask.flatMap { context -> Reader<GetCategoriesContext, Void> in
        context.jokesDetailPage.go(cateogryName: categoryName)
    }
}

func drawCategories(categories:[CategoryViewModel]) -> AsyncResult<GetCategoriesContext, Void> {
    return AsyncResult<GetCategoriesContext, Void>.ask.flatMap { context -> AsyncResult<GetCategoriesContext, Void> in
        context.view.drawCategories(categories: categories)
        return AsyncResult<GetCategoriesContext, Void>.pureTT(())
    }
}

func drawJoke(joke: JokeViewModel) -> AsyncResult<GetRandomJokeContext, Void> {
    return AsyncResult<GetRandomJokeContext, Void>.ask.flatMap { context -> AsyncResult<GetRandomJokeContext, Void> in
        context.view.drawJoke(joke: joke)
        return AsyncResult<GetRandomJokeContext, Void>.pureTT(())
    }
}



func toJokeViewModel(from joke: Joke) -> JokeViewModel {
    return JokeViewModel(id: joke.id, category: joke.category, iconUrl: joke.iconUrl, url: joke.url, value: joke.value)
}

func toCategoryViewModel(from category: Category) -> CategoryViewModel{
    return CategoryViewModel(name: category.name)
}

func toCategoriesViewModel(from categories: [Category]) -> [CategoryViewModel] {
    return categories.map(toCategoryViewModel)
}

func getCategories() -> AsyncResult<GetCategoriesContext, Void> {
    return getCategoriesUseCase(withContextType: GetCategoriesContext.self)
        .mapTT { toCategoriesViewModel(from: $0) }
        .flatMapTT { (categories) -> Reader<GetCategoriesContext, Future<Result<JokeError, Void>>> in
            drawCategories(categories: categories)
        }
}
