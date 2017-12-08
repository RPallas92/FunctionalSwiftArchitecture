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
    
    typealias ValueType = ParameterType.ParameterType.ParameterType

    func runT<H>(_ environment:EnvironmentType, _ callback: @escaping (Result<JokeError, H>) -> ()) where ValueType == H {
        let future = self.run(environment)
        future.run { result in
            let _ = future //HACK
            result.fold(
                onSuccess: { callback(Result.success($0))},
                onFailure: { callback(Result.failure($0))}
            )
        }
    }
    
    func mapTT<H>(_ transform: @escaping (ValueType) -> H) -> AsyncResult<EnvironmentType,H> {
        return self.map { future in
            future.map { result in
                result.map(transform)
            }
        }
    }
    
    func flatMapTT<H>(_ transform: @escaping (ValueType) -> AsyncResult<EnvironmentType,H>) -> AsyncResult<EnvironmentType,H> {
        return AsyncResult<EnvironmentType,H>.ask.flatMap { context -> AsyncResult<EnvironmentType,H> in

            self.flatMap { future -> AsyncResult<EnvironmentType,H> in
                let newFuture = Future<Result<JokeError, H>>.unfold { callback -> () in
                    future.run { result -> () in
                        result.fold(
                            onSuccess: { value in
                                let newReader = transform(value)
                                let newFuture = newReader.run(context)
                                newFuture.run { newResult -> () in
                                    callback(newResult)
                                }
                            },
                            onFailure: { jokeError in
                                callback(Result<JokeError,H>.failure(jokeError))
                            }
                        )
                    }
                }
                return AsyncResult<EnvironmentType,H>.pure(newFuture)
            }
        }
    }
    
    static func pureTT<H>(_ value:H) -> AsyncResult<EnvironmentType,H> where H == ValueType {
        let result = Result<JokeError, H>.pure(value)
        let future = Future.pure(result)
        return AsyncResult<EnvironmentType, H>.pure(future)
    }
    
    
    /*func handleErrorWith(_ transform: @escaping (ValueType) -> Reader<EnvironmentType,Future<Result<JokeError, ValueType>>>) -> Reader<EnvironmentType,Future<Result<JokeError, ValueType>>> {
        
        return Reader<EnvironmentType,Future<Result<JokeError, H>>>.ask.flatMap { context -> Reader<EnvironmentType,Future<Result<JokeError, H>>> in
            
            self.flatMap { future -> Reader<EnvironmentType,Future<Result<JokeError, H>>> in
                let newFuture = Future<Result<JokeError, H>>.unfold { callback -> () in
                    future.run { result -> () in
                        result.fold(
                            onSuccess: { value in
                                let newReader = transform(value)
                                let newFuture = newReader.run(context)
                                newFuture.run { newResult -> () in
                                    callback(newResult)
                                }
                        },
                            onFailure: { jokeError in
                                callback(Result<JokeError,H>.failure(jokeError))
                        }
                        )
                    }
                }
                return Reader<EnvironmentType,Future<Result<JokeError, H>>>.pure(newFuture)
            }
        }
        
    }*/
    
}
