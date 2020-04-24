//
//  MyReviewcell.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 24/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit
import Cosmos

class MyReviewCell: UITableViewCell {
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var reviewScore: CosmosView!
    @IBOutlet weak var reviewText: UITextView!
    
    func setData(_ data: Review) {
        if let resId = data.restaurantId {
            let res = DatabaseConnector.getRestaurantDetail(id: resId)
            restaurantImage.downloadImage(from: res?.imageUrl)
            restaurantName.text = res?.name
        }
        
        reviewScore.rating = data.score
        reviewText.text = data.text
        reviewScore.isUserInteractionEnabled = false

    }
}

