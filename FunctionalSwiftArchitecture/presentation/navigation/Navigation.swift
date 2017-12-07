//
//  Navigation.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/7/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import FunctionalKit

struct JokeDetailsPage {
    func go(cateogryName: String) -> Reader<GetCategoriesContext, Void>{
        return Reader<GetCategoriesContext, Void>.ask.map { context in
            
        } //TODO
    }
}
