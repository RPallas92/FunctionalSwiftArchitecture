//
//  AsyncResult.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/5/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import FunctionalKit

typealias AsyncResult<E,A> = Reader<E, Future<Result<JokeError, A>>>
