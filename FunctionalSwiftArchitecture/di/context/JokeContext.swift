//
//  JokeContext.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/5/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

protocol JokeContext {
    var apiUrl: String {get}
    var jokesDetailPage: JokeDetailsPage {get}
    var jokesDataSource: JokesDataSource {get}
}
class AppContext: JokeContext {
    var apiUrl = "https://api.chucknorris.io/"
    var jokesDetailPage = JokeDetailsPage()
    var jokesDataSource: JokesDataSource = JokesNetworkDataSource()
}

class GetCategoriesContext: AppContext {
    let view: JokeCategoriesListView
    init(view: JokeCategoriesListView) { self.view = view }
}

class GetRandomJokeContext: AppContext {
    let view: JokeDetailView
    init(view: JokeDetailView) { self.view = view }
}
