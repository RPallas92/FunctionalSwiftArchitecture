//
//  JokesApiTests.swift
//  FunctionalSwiftArchitectureTests
//
//  Created by Pallas, Ricardo on 12/11/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import XCTest

class JokesApiTests: XCTestCase {
    
    func testFetchCategories() {
        let expect = expectation(description: "fetchCategories")
        let jokesApi = JokesApi()
        
        let categoriesResult = jokesApi.fetchCategories()
        let context = AppContext()
        
        categoriesResult.runT(context, { result in
            XCTAssertNotNil(result.tryRight)
            XCTAssertNil(result.tryLeft)
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 10.0)
    }
    
    func testFetchRandomJoke() {
        let expect = expectation(description: "testFetchRandomJoke")
        let jokesApi = JokesApi()
        
        let jokeResult = jokesApi.fetchRandomJoke(forCategoryName: "dev")
        let context = AppContext()
        
        jokeResult.runT(context, { result in
            XCTAssertNotNil(result.tryRight)
            XCTAssertNil(result.tryLeft)
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 10.0)    }
}
