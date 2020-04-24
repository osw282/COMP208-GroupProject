//
//  RestaurantViewController.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 10/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortByDistanceBtn: UIButton!
    @IBOutlet weak var sortByRatingBtn: UIButton!
    
    var datasource = [Restaurant]()
    var originalDatasource = [Restaurant]()
    
    func getData() {
        let result = DatabaseConnector.getData(table: "Restaurant")
        for item in result {
            let res = Restaurant(rawData: item)
            datasource.append(res)
        }
        originalDatasource = datasource
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        originalDatasource = datasource
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        searchBar.delegate = self
        sortByRatingBtn.addTarget(self, action: #selector(sortByRating), for: .touchUpInside)
        sortByRatingBtn.layer.cornerRadius = 8
        sortByRatingBtn.layer.masksToBounds = true
    }
    
    @objc func sortByRating() {
        sortByRatingBtn.isSelected = !sortByRatingBtn.isSelected
        if sortByRatingBtn.isSelected {
            datasource = originalDatasource.sorted(by: { return $0.score > $1.score })
            sortByRatingBtn.backgroundColor = UIColor.green
        } else {
            datasource = originalDatasource.sorted(by: { return $0.score < $1.score })
            sortByRatingBtn.backgroundColor = UIColor.red
        }
        
        tableView.reloadData()
    }
    @objc func sortByDistance() {
        sortByDistanceBtn.isSelected = !sortByDistanceBtn.isSelected
        if sortByDistanceBtn.isSelected {
            sortByDistanceBtn.backgroundColor = UIColor.green
        } else {
            sortByDistanceBtn.backgroundColor = UIColor.red
        }
        
        tableView.reloadData()
    }
    
}


extension RestaurantViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        datasource = originalDatasource
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            datasource = originalDatasource
            tableView.reloadData()
            return
        }
        datasource = originalDatasource.filter({ return $0.name?.uppercased().contains(searchText.uppercased()) == true })
        tableView.reloadData()
    }
}
extension RestaurantViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        cell.setData(datasource[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
        vc.data = datasource[indexPath.row]
        present(vc, animated: true)
    }
}
