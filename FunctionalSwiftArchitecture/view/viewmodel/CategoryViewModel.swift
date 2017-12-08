//
//  CategoryViewModel.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/7/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

struct CategoryViewModel {
    var name: String
}

extension CategoryViewModel: Equatable {
    static func ==(lhs: CategoryViewModel, rhs: CategoryViewModel) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func containSameElements(lhs: [CategoryViewModel], rhs: [CategoryViewModel]) -> Bool{
        return lhs.count == rhs.count && lhs.sorted() { $0.name > $1.name } == rhs.sorted() { $0.name > $1.name }
    }
}

