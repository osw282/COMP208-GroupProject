//
//  RestaurantCell.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 10/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos

class RestaurantCell: UITableViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var resNameLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cosmosView.isUserInteractionEnabled = false
    }
    
    func setData(_ data: Restaurant) {
        if let url = data.imageUrl, url.isEmpty == false {
            coverImageView.downloadImage(from: url, placeholder: UIImage(named: "Top-Background"))
        } else {
            coverImageView.image = UIImage(named: "Top-Background")
        }
        resNameLabel.text = data.name
        cosmosView.rating = data.score
    }
}


class Restaurant {
    var id: Int?
    var imageUrl: String?
    var name: String?
    var score: Double = 0
    var description: String = "Description:"
    var address: String = "Address:"
    var openingTimes: String = "Opening Times:"
    var lat: Double?
    var long: Double?
    
    init(rawData: [String: Any]) {
        id = rawData["RestaurantID"] as? Int
        imageUrl = rawData["ImageURL"] as? String
        name = rawData["RestaurantName"] as? String
        score = rawData["RestaurantOverallScore"] as? Double ?? 0
        description = (rawData["RestaurantDescription"] as? String) ?? "Description:"
        address = rawData["RestaurantAddress"] as? String ?? "Address:"
        openingTimes = rawData["RestaurantOpeningTimes"] as? String ?? "Address:"
        lat = rawData["RestaurantLat"] as? Double
        long = rawData["RestaurantLong"] as? Double
    }
}

extension UIImageView {
    func downloadImage(from url: String?, placeholder: UIImage? = nil) {
        guard let url = url, let nsurl = URL(string: url) else { return }
        kf.setImage(with: ImageResource(downloadURL: nsurl), placeholder: placeholder)
    }
}
