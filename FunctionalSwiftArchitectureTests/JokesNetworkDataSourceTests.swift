//
//  JokesNetworkDataSourceTests.swift
//  FunctionalSwiftArchitectureTests
//
//  Created by Pallas, Ricardo on 12/6/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import XCTest

class JokesNetworkDataSourceTests: XCTestCase {
    
    
    func testFetchRandomJoke() {
        let expect = expectation(description: "Fetch random joke")
        
        let jokeResult:AsyncResult<AppContext, JokeDto> = JokesNetworkDataSource().fetchRandomJoke(forCategoryName: "dev")
        let context = AppContext()
        
        jokeResult.runT(context, { result in
            
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 5.0)
    }
}
