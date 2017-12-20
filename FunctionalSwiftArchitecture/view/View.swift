//
//  View.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/20/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

protocol JokesView {
    func showGenericError()
}

protocol JokeCategoriesListView : JokesView {
    func drawCategories(categories: [CategoryViewModel])
}

protocol JokeDetailView : JokesView {
    func drawJoke(joke: JokeViewModel)
}
