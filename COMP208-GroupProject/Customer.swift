//
//  Customer.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 24/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import Foundation

class Customer {
    var id: Int?
    var email: String?
    var name: String?
    init(rawData: [String: Any]) {
        id = rawData["CustomerID"] as? Int
        email = rawData["CustomerAccessToken"] as? String
        name = rawData["CustomerName"] as? String
    }
}
