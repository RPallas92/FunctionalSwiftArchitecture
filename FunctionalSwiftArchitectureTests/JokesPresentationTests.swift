//
//  JokesPresentationTests.swift
//  FunctionalSwiftArchitectureTests
//
//  Created by Pallas, Ricardo on 12/8/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import XCTest
import FunctionalKit
import Cuckoo

class JokesPresentationTests: XCTestCase {
    
    //TODO test also error cases
    
    let categoriesMatcher = ParameterMatcher { (categories: [CategoryViewModel]) -> Bool in
        let expectedCategories = [
            CategoryViewModel(name: "explicit"),
            CategoryViewModel(name: "dev"),
            CategoryViewModel(name: "movie"),
            CategoryViewModel(name: "food"),
            CategoryViewModel(name: "celebrity"),
            ]
        return CategoryViewModel.containSameElements(lhs: categories, rhs: expectedCategories)
    }
    
    let jokeMatcher = ParameterMatcher { (joke: JokeViewModel) -> Bool in
        let expectedJoke = JokeViewModel(
            id: "ye0_hnd3rgq68e_pfvsqqg",
            category: ["dev"],
            iconUrl: "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
            url: "http://api.chucknorris.io/jokes/ye0_hnd3rgq68e_pfvsqqg",
            value: "Chuck Norris can instantiate an abstract class."
        )
        return joke == expectedJoke
    }
    
    /*
     * Verifies it calls JokeCategoriesListView's drawCategories with correct categories
     */
    func testGetCategories() {
        let expect = expectation(description: "testHandleErrorWith")

        let categoriesListView = MockJokeCategoriesListView()
        stub(categoriesListView) { stub in
            when(stub.drawCategories(categories: self.categoriesMatcher)).thenDoNothing()
        }
        
        let context = GetCategoriesContext(view: categoriesListView)
        let categoriesAsyncResult = getCategories()
        
        //Verify not called here (otherwise that would mean side effects were executed before actually running the monad).
        verify(categoriesListView, never()).drawCategories(categories: self.categoriesMatcher)
        
        categoriesAsyncResult.runT(context, { result in
            //Verify it was called with correct categories.
            verify(categoriesListView).drawCategories(categories: self.categoriesMatcher)
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func testGetRandomJoke(){
        let expect = expectation(description: "testGetRandomJoke")
        
        let jokeDetailView = MockJokeDetailView()
        stub(jokeDetailView) { stub in
            when(stub.drawJoke(joke: jokeMatcher)).thenDoNothing()
        }
        
        let context = GetRandomJokeContext(view: jokeDetailView)
        let jokeAsyncResult = getRandomJoke(categoryName: "dev")
        
        //Verify not called here (otherwise that would mean side effects were executed before actually running the monad).
        verify(jokeDetailView, never()).drawJoke(joke: self.jokeMatcher)
        
        jokeAsyncResult.runT(context, { result in
            //Verify it was called with correct joke.
            verify(jokeDetailView).drawJoke(joke: self.jokeMatcher)
            expect.fulfill()
        })
        wait(for: [expect], timeout: 1.0)
    }
}