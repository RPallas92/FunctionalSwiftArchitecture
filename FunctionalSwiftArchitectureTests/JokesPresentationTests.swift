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
    
 
    
}
