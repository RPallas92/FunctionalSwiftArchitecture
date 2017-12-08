//
//  JokeContext.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/5/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

protocol JokeContext {
    
}
class AppContext: JokeContext {
    var apiUrl = "https://api.chucknorris.io/jokes/"
    var jokesDetailPage = JokeDetailsPage()
}

class GetCategoriesContext: AppContext {
    let view: JokeCategoriesListView
    init(view: JokeCategoriesListView) { self.view = view }
}

class GetRandomJokeContext: AppContext {
    let view: JokeDetailView
    init(view: JokeDetailView) { self.view = view }
}
