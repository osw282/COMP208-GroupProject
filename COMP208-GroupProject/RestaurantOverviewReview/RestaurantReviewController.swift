//
//  RestaurantReviewController.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 23/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit
class RestaurantReviewController: UIViewController {
    static func create() -> RestaurantReviewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantReviewController") as! RestaurantReviewController
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortByRatingBtn: UIButton!
    var data: Restaurant?
    var datasource = [Review]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getData()
        sortByRatingBtn.addTarget(self, action: #selector(sortByRating), for: .touchUpInside)
        sortByRatingBtn.layer.cornerRadius = 8
        sortByRatingBtn.layer.masksToBounds = true
    }
    
    func getData() {
        guard let resId = data?.id else { return }
        datasource = DatabaseConnector.getAllReviewsOfRestaurant(resId)
        tableView.reloadData()
    }
    @objc func sortByRating() {
        sortByRatingBtn.isSelected = !sortByRatingBtn.isSelected
        if sortByRatingBtn.isSelected {
            datasource = datasource.sorted(by: { return $0.score > $1.score })
            sortByRatingBtn.backgroundColor = UIColor.green
        } else {
            datasource = datasource.sorted(by: { return $0.score < $1.score })
            sortByRatingBtn.backgroundColor = UIColor.red
        }
        
        tableView.reloadData()
    }
}

extension RestaurantReviewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OverralReviewCell", for: indexPath) as! OverralReviewCell
        cell.setData(datasource[indexPath.row])
        return cell
    }
}
