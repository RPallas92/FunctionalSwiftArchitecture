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

func displayGetCategoriesErrors(jokeError: JokeError) -> AsyncResult<GetCategoriesContext, Void> {
    return AsyncResult<GetCategoriesContext, Void>.ask.flatMap { context -> AsyncResult<GetCategoriesContext, Void> in
        switch(jokeError){
        case .UnknownServerError:
            context.view.showGenericError()
        }
        return AsyncResult<GetCategoriesContext, Void>.pureTT(())
    }
}

func displayGetRandomJokeErrors(jokeError: JokeError) -> AsyncResult<GetRandomJokeContext, Void> {
    return AsyncResult<GetRandomJokeContext, Void>.ask.flatMap { context -> AsyncResult<GetRandomJokeContext, Void> in
        switch(jokeError){
        case .UnknownServerError:
            context.view.showGenericError()
        }
        return AsyncResult<GetRandomJokeContext, Void>.pureTT(())
    }
}

func getCategories() -> AsyncResult<GetCategoriesContext, Void> {
    return getCategoriesUseCase(withContextType: GetCategoriesContext.self)
        .mapTT { toCategoriesViewModel(from: $0) }
        .flatMapTT { drawCategories(categories: $0)}
        .handleErrorWith { displayGetCategoriesErrors(jokeError: $0)}
}

func getRandomJoke(categoryName: String) -> AsyncResult<GetRandomJokeContext, Void> {
    return getRandomJokeUseCase(forCategoryName: categoryName, withContextType: GetRandomJokeContext.self)
        .mapTT { toJokeViewModel(from: $0)}
        .flatMapTT { drawJoke(joke: $0)}
        .handleErrorWith { displayGetRandomJokeErrors(jokeError: $0) }
}

fileprivate func toJokeViewModel(from joke: Joke) -> JokeViewModel {
    return JokeViewModel(id: joke.id, iconUrl: joke.iconUrl, url: joke.url, value: joke.value)
}

fileprivate func toCategoryViewModel(from category: Category) -> CategoryViewModel{
    return CategoryViewModel(name: category.name)
}

fileprivate func toCategoriesViewModel(from categories: [Category]) -> [CategoryViewModel] {
    return categories.map(toCategoryViewModel)
}


