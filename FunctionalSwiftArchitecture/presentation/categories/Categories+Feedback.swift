//
//  Categories+Feedback.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/20/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

func getCategories() -> AsyncResult<GetCategoriesContext, CategoriesEvent> {
    return getCategoriesUseCase(withContextType: GetCategoriesContext.self)
        .mapTT { toCategoriesViewModel(from: $0) }
        .mapTT { CategoriesEvent.categoriesLoaded($0) }
        .handleErrorWith { AsyncResult.pureTT(CategoriesEvent.error($0))}
}
