//
//  Navigation.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/7/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import FunctionalKit

class JokesNavigation {
    func go(categoryName: String) -> Reader<GetCategoriesContext, Void>{
        return Reader<GetCategoriesContext, Void>.ask.map { context in
            
        } //TODO
    }
}
