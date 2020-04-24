//
//  BusinessAccountViewController.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 15/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit

class BusinessAccountViewController: UIViewController {
    static func create() -> BusinessAccountViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BusinessAccountViewController") as! BusinessAccountViewController
    }
    
    @IBOutlet weak var tableView: UITableView!
    var datasource = [Restaurant]()
    
    func getData() {
        guard let myBizId = Setting.myBizId else { return }
        let result = DatabaseConnector.getMyRestaurant(businessId: myBizId)
        datasource = result
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        getData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    @IBAction func showNewRestaurant() {
        let vc = AddNewRestaurantViewController.create()
        vc.listController = self
        present(vc, animated: true)
    }
    @IBAction func signout() {
        Setting.myBizId = nil
        let lastTab = mainController?.viewControllers?.last as? UINavigationController
        let loginVc = CustomerLoginController.create()
        lastTab?.setViewControllers([loginVc], animated: true)
        mainController?.homeVc.toggleBizLoginButton()
    }
}


extension BusinessAccountViewController: UITableViewDataSource, UITableViewDelegate {
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
        let vc = BusinessRestaurantDetailViewController.create()
        vc.data = datasource[indexPath.row]
        vc.listController = self
        present(vc, animated: true)
    }
}
