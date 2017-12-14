//
//  Event.swift
//  FunctionalSwiftArchitectureTests
//
//  Created by Pallas, Ricardo on 12/14/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import FunctionalKit

enum Event {
    case loadCategories
    case categoriesLoaded(Result<JokeError, [CategoryViewModel]>)
    case doNothing //TODO
}
