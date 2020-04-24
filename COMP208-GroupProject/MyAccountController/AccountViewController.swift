//
//  AccountViewController.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 22/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit
import Cosmos
import FacebookLogin

class AccountViewController: UIViewController {
    static func create() -> AccountViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
    }
    @IBOutlet weak var tableView: UITableView!
    var datasource = [Review]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    func getData() {
        let reviews = DatabaseConnector.getMyReview()
        datasource = reviews
        tableView.reloadData()
    }
    @IBAction func signout() {
        let loginManager = LoginManager()
        loginManager.logOut()
        let vc = CustomerLoginController.create()
        navigationController?.setViewControllers([vc], animated: true)
        Setting.myId = nil
        mainController?.homeVc.toggleBizLoginButton()
    }
    @IBAction func deleteAccount() {
        let vc = UIAlertController(title: "Confirmation", message: "Continue to delete account?", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (_) in
            guard let myId = Setting.myId else { return }
            DatabaseConnector.deleteAccount(userId: myId)
            Setting.myId = nil
            
//            let vc = CustomerLoginController.create()
//            self.navigationController?.setViewControllers([vc], animated: true)
//            mainController?.homeVc.toggleBizLoginButton()
            self.signout()
            
        }))
        
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(vc, animated: true)
    }
    
}


extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyReviewCell", for: indexPath) as! MyReviewCell
        cell.setData(datasource[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let id = datasource[indexPath.row].id else { return }
            DatabaseConnector.deleteReview(reviewId: id)
            getData()
        }
    }
}


