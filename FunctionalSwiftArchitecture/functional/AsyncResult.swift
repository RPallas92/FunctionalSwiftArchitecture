//
//  AsyncResult.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/5/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import FunctionalKit

typealias AsyncResult<E,A> = Reader<E, Future<Result<JokeError, A>>>

extension AsyncResult where ParameterType: FutureType, ParameterType.ParameterType: ResultType,
    ParameterType.ParameterType.ErrorType == JokeError {
    
    func runT<H>(_ environment:EnvironmentType, _ callback: @escaping (Result<JokeError, H>) -> ()) where ParameterType.ParameterType.ParameterType == H {
        let future = self.run(environment)
        future.run { result in
            let _ = future //HACK
            result.fold(
                onSuccess: { callback(Result.success($0))},
                onFailure: { callback(Result.failure($0))}
            )
        }
    }
    
    func mapTT<H>(_ transform: @escaping (ParameterType.ParameterType.ParameterType) -> H) -> Reader<EnvironmentType,Future<Result<JokeError, H>>> {
        return self.map { future in
            future.map { result in
                result.map(transform)
            }
        }
    }
    
    /*
 public func map <T> (_ transform: @escaping (ParameterType) -> T) -> Reader<EnvironmentType,T> {
 return dimap(from: { $0 }, to: transform)
 }
 */
    
}
