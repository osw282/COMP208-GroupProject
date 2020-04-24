//
//  MainTabController.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 22/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit

var mainController: MainTabController?
class MainTabController: UITabBarController {
    let homeVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    let restaurantVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantViewController") as! RestaurantViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainController = self
        
        delegate = self
        

        viewControllers = [
            homeVc, restaurantVc
        ]
        
        let thirdVC: UIViewController
        if Setting.myId != nil {
            thirdVC = AccountViewController.create()
        } else if Setting.myBizId != nil {
            thirdVC = BusinessAccountViewController.create()
        } else {
            thirdVC = CustomerLoginController.create()
        }
        viewControllers?.append(UINavigationController(rootViewController: thirdVC))
    }
}

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let vc = viewController as? RestaurantViewController {
            if vc.datasource.isEmpty {
                Messenger.showMessage(title: "", content: "Please enter a poscode or enable location services to view restaurants")
                return false
            }
        }
        return true
    }
}
