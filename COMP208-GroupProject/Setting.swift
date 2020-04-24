//
//  Setting.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 18/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit

class Setting {
    static var myId: Int? {
        get {
            return UserDefaults.standard.value(forKey: "myId") as? Int
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "myId")
        }
    }
    static var myBizId: Int? {
        get {
            return UserDefaults.standard.value(forKey: "myBizId") as? Int
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "myBizId")
        }
    }
}
