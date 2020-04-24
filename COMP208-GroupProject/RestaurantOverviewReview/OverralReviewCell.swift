//
//  OverralReviewCell.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 24/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit
import Cosmos

class OverralReviewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    func setData(_ data: Review) {
        if data.giverName == nil {
            DispatchQueue(label: "getGiverName").async {
                guard let id = data.giverId else { return }
                guard let user = DatabaseConnector.getUserDetail(userId: id) else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.nameLabel.text =  user.name
                    data.giverName = user.name
                }
            }
        } else {
            nameLabel.text =  data.giverName
        }
        rateView.rating = data.score
        reviewTextLabel.text = data.text
    }
}
