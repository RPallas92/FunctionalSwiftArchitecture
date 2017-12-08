//
//  Extensions.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/8/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation


extension Array where Element: Equatable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted(by: ) == other.sorted()
    }
}
