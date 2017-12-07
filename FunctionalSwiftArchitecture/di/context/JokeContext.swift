//
//  JokeContext.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/5/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

class JokeContext {
    var apiUrl = "https://api.chucknorris.io/jokes/"
    var jokesDetailaPage = JokeDetailsPage()
}

class GetCategoriesContext: JokeContext {
    let view: JokeCategoriesListView
    init(view: JokeCategoriesListView) { self.view = view }
}

class GetRandomJokeContext: JokeContext {
    let view: JokeDetailView
    init(view: JokeDetailView) { self.view = view }
}
