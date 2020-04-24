//
//  Review.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 23/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import Foundation


class Review {
    var id: Int?
    var restaurantId: Int?
    var restaurantImage: String?
    var restaurantName: String?
    var score: Double = 0
    var text: String?
    var giverId: Int?
    var createdAt: Date?
    var giverName: String? 
    
    init(rawData: [String: Any]) {
        restaurantId = rawData["RestaurantID"] as? Int
        score = rawData["SentimentReviewScore"] as? Double ?? 0
        giverId = rawData["CustomerID"] as? Int
        text = rawData["ReviewText"] as? String
        id = rawData["ReviewID"] as? Int
        if let createdAtRaw = rawData["DateTimePosted"] as? String {
            createdAt = Date(dateString: createdAtRaw, format: "yyyy/MM/dd hh:mm:ss")
        }
    }
}
