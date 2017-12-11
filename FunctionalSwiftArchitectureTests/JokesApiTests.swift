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
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 10.0)
    }
}
