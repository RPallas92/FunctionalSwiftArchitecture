//
//  AsyncResultTests.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/8/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import XCTest
import FunctionalKit

class AsyncResultTests: XCTestCase {
    

    
    func testFlatMapTT() {
        let expect = expectation(description: "Test flapMatTT")
        let context = JokeContext()
        let asyncResult = AsyncResult<JokeContext, Int>.pureTT(1)
        let asyncResult2 = AsyncResult<JokeContext, Int>.pureTT(2)
        
        let asyncResult3 = asyncResult.flatMapTT { value -> Reader<JokeContext, Future<Result<JokeError, Int>>> in
            XCTAssertEqual(value, 1)
            return asyncResult2
        }
        
        asyncResult3.runT(context, { result in
            let value = result.tryRight!
            XCTAssertEqual(value, 2)
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 1.0)
    }
    
}