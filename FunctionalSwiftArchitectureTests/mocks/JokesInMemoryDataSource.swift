//
//  JokesNetworkDataSource.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/5/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import FunctionalKit

struct JokesInMemoryDataSource : JokesDataSource {
    func fetchAllJokeCategories<Context>() -> AsyncResult<Context, Array<CategoryDto>> where Context : JokeContext{
        return AsyncResult.unfold { (context) in
            Future.unfold { (continuation) in
                //let api = context.apiUrl, We will use context from Reader monad
                let categories = [
                    CategoryDto(name: "explicit"),
                    CategoryDto(name: "dev"),
                    CategoryDto(name: "movie"),
                    CategoryDto(name: "food"),
                    CategoryDto(name: "celebrity"),
                    ]
                continuation(Result.success(categories))
            }
        }
    }
    
    func fetchRandomJoke<Context>(forCategoryName cateogory: String) -> AsyncResult<Context, JokeDto> where Context : JokeContext {
        return AsyncResult.unfold { context in
            Future.unfold { completion in
                runInBackground { runInMainThread in
                    let joke = JokeDto(
                        id: "ye0_hnd3rgq68e_pfvsqqg",
                        iconUrl: "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
                        url: "http://api.chucknorris.io/jokes/ye0_hnd3rgq68e_pfvsqqg",
                        value: "Chuck Norris can instantiate an abstract class."
                    )
                    
                    runInMainThread {
                        completion(Result.success(joke))
                    }
                }
            }
        }
    }
}

//Syntatic sugar for background execution and returining results on main thread
//typealias thanks to @joseluisalcala
fileprivate typealias Function = () -> ()
fileprivate typealias Completable = (@escaping Function) -> ()

fileprivate func runInBackground(_ asyncCode: @escaping(@escaping Completable)->()) {
    DispatchQueue.global(qos: .background).async {
        asyncCode { inMainThread in
            DispatchQueue.main.async {
                inMainThread()
            }
        }
    }
}

