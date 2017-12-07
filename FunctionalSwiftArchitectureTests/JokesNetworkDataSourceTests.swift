//
//  JokesNetworkDataSourceTests.swift
//  FunctionalSwiftArchitectureTests
//
//  Created by Pallas, Ricardo on 12/6/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import XCTest

class JokesNetworkDataSourceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchRandomJoke() {
        let expect = expectation(description: "Fetch random joke")
        
        let jokeResult = fetchRandomJoke(forCategoryName: "dev")
        let context = JokeContext()
        
        jokeResult.runT(context, { result in
            
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 5.0)
    }
}
