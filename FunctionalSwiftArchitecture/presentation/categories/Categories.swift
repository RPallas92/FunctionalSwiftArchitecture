//
//  JokesPresentation.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/7/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import FunctionalKit
import ArchitectureKit

typealias CategoriesCustomAction = CustomAction<CategoriesState, CategoriesEvent, JokeError, GetCategoriesContext>
typealias CategoriesFeedback = Feedback<CategoriesState, CategoriesEvent, JokeError, GetCategoriesContext>
typealias CategoriesSystem = System<CategoriesState,CategoriesEvent,JokeError,GetCategoriesContext>

func onCategoriesViewLoaded(context: GetCategoriesContext) {
    
    let uiBinding: (CategoriesState) -> () = { state in
        context.view.drawCategories(categories: state.categories)
        if let _ = state.error {
            context.view.showGenericError()
        }
    }

    let screenLoadedAction = CategoriesCustomAction(trigger: CategoriesEvent.loadCategories)
    
    let system = CategoriesSystem.pure(
        initialState: CategoriesState.empty,
        context: context,
        reducer: CategoriesState.reduce,
        uiBindings: [uiBinding],
        actions: [screenLoadedAction],
        feedback: [CategoriesFeedback.react({_ in getCategories()}, when: { $0.shouldLoadCategories})]
    )
    
    system.addLoopCallback {
        print("System loop executed")
    }
    
    screenLoadedAction.execute()
}
