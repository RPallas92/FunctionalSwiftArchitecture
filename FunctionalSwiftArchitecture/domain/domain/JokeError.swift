//
//  JokeError.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/5/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
/**
 * This enum represents all the possible errors that the app is going to model inside its
 * domain. All the exceptions / errors provoked by third party libraries or APIs are mapped to any
 * of the types defined on this class.
 *
 * Mapping exceptions to errors allows the domain use case functions to be referentially
 * transparent, which means that they are completely clear and straightforward about what they
 * return just by reading their public function output types.
 *
 * Other approaches like exceptions + callback propagation (to be able to surpass thread limits)
 * bring not required complexity to the architecture introducing asynchronous semantics.
 */
enum JokeError: Error {
    case UnknownServerError
}
