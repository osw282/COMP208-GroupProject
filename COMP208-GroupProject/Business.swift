//
//  Business.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 23/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import Foundation

class Business {
    var id: Int
    var email: String
    var name: String
    
    init?(raw: [String: Any]) {
        guard let id = raw["BusinessID"] as? Int, let email = raw["BusinessEmail"] as? String, let name = raw["BusinessName"] as? String else { return nil }
        self.id = id
        self.email = email
        self.name = name
    }
}
