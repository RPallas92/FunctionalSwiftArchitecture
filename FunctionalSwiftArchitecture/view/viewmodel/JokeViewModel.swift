//
//  JokeViewModel.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/7/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

struct JokeViewModel {
    var id:String
    var category: [String]
    var iconUrl: String
    var url: String
    var value: String
}

extension JokeViewModel : Equatable {
    static func ==(lhs: JokeViewModel, rhs: JokeViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
