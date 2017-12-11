//
//  JokeDto.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/5/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation


struct JokeDto {
    var id:String
    var iconUrl: String
    var url: String
    var value: String
    
    
    init(id: String, iconUrl: String, url: String, value: String) {
        self.id = id
        self.iconUrl = iconUrl
        self.url = url
        self.value = value
    }
    
    init?(_ json: [String: Any]) {
        guard let id = json["id"] as? String,
            let iconUrl = json["icon_url"] as? String,
            let url = json["url"] as? String,
            let value = json["value"] as? String else {
                return nil
        }
        
        self.id = id
        self.iconUrl = iconUrl
        self.url = url
        self.value = value
    }
}
