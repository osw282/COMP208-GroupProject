//
//  BusinessRestaurantDetailViewController.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 18/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit
class BusinessRestaurantDetailViewController: UIViewController {
    static func create() -> BusinessRestaurantDetailViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BusinessRestaurantDetailViewController") as! BusinessRestaurantDetailViewController
    }
    
    @IBOutlet weak var detailView: RestaurantDetailView!
    var data: Restaurant?
    weak var listController: BusinessAccountViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let restaurant = data {
            detailView.setData(restaurant)
        }
    }
    
    func close() {
        dismiss(animated: true)
        listController?.getData()
    }
    
    @IBAction func showEdit() {
        let vc = EditRestaurantViewController.create()
        vc.hostController = self
        vc.restaurant = data
        present(vc, animated: true)
    }
}
