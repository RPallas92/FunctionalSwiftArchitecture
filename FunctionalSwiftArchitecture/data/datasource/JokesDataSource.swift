//
//  JokesDataSource.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/9/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import FunctionalKit

protocol JokesDataSource {
    func fetchAllJokeCategories<Context>() -> AsyncResult<Context, Array<CategoryDto>> where Context : JokeContext
    func fetchRandomJoke<Context>(forCategoryName cateogory: String) -> AsyncResult<Context, JokeDto> where Context : JokeContext
}
