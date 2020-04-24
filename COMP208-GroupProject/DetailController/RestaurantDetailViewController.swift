//
//  RestaurantDetailViewController.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 12/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    @IBOutlet weak var detailView: RestaurantDetailView!
    var data: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let restaurant = data {
            detailView.setData(restaurant)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WriteReviewViewController {
            vc.restaurant = data
        }
    }

}
