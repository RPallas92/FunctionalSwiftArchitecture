//
//  JokesNetworkDataSource.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/5/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import FunctionalKit

//https://api.chucknorris.io/jokes/random?category=dev
//https://api.chucknorris.io/jokes/categories

func fetchAllJokeCategories() -> AsyncResult<JokeContext, Array<CategoryDto>> {
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

func fetchRandomJoke(forCategoryName cateogory: String) -> AsyncResult<JokeContext, JokeDto> {
    return AsyncResult.unfold { context in
        Future.unfold { completion in
            
            let joke = JokeDto(
                id: "ye0_hnd3rgq68e_pfvsqqg",
                category: ["dev"],
                iconUrl: "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
                url: "http://api.chucknorris.io/jokes/ye0_hnd3rgq68e_pfvsqqg",
                value: "Chuck Norris can instantiate an abstract class."
            )
            completion(Result.success(joke))
            
        }
        
    }
}

func runInBackground(_ asyncCode:@escaping (@escaping ( @escaping(() -> ())) -> ()) -> ()) {
    DispatchQueue.global(qos: .background).async {
        asyncCode { inMainThread in
            DispatchQueue.main.async {
                inMainThread()
            }
        }
    }
}