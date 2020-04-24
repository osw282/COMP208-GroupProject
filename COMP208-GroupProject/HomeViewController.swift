//
//  HomeViewController.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 23/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    var locationManager = CLLocationManager()
    var datasource = [Restaurant]()
    var stopUpdating = false
    @IBOutlet weak var bizLoginButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       toggleBizLoginButton()
        
        searchTextField.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization() //Ask the user for permission to get their location
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    @IBAction func startSearching() {
        getNearby()
    }
    // - get nearby
    // customer delete reviews
    // add new restaurant/edit
    // polish the code 
    
    @IBAction func showBizLogin() {
        let vc = BusinessLoginViewController.create()
        vc.modalPresentationStyle = .fullScreen
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    func toggleBizLoginButton() {
        if Setting.myId == nil && Setting.myBizId == nil {
            bizLoginButton.isHidden = false
        } else {
            bizLoginButton.isHidden = true
        }
    }
 
    func getNearby() {
        guard let code = searchTextField.text, code.isEmpty == false else {
            showLocationMessage(message: "Please input your post code")
            return
        }
        Indicator.showLoading()
        view.endEditing(true)
        LocationHelper.getNearbyRestaurantsByCode(code) {[weak self] (restaurants) in
            Indicator.hide()
            if restaurants.isEmpty == false {
                DispatchQueue.main.async {
                    mainController?.restaurantVc.datasource = restaurants
                    mainController?.selectedIndex = 1
                }
            } else {
                self?.showLocationMessage(message: "Please try another post code")
            }
        }
    }
    func showLocationMessage(message: String) {
        let vc = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.searchTextField.becomeFirstResponder()
        }))
        vc.addAction(UIAlertAction(title: "Search near me", style: .default, handler: { [weak self] _ in
            Indicator.showLoading()
            self?.stopUpdating = false
            self?.locationManager.startUpdatingLocation()
        }))
        DispatchQueue.main.async {
            self.present(vc, animated: true)
        }
    }
}


extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getNearby()
        return true
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if stopUpdating { return }
        let locationOfUser = locations[0] //get the first location (ignore any others)
        let latitude = locationOfUser.coordinate.latitude
        let longitude = locationOfUser.coordinate.longitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let nearby = DatabaseConnector.searchNearby(targetLocation: location)
        if nearby.isEmpty == false {
            Indicator.hide()
            DispatchQueue.main.async {
                mainController?.restaurantVc.datasource = nearby
                mainController?.selectedIndex = 1
            }
        } else {
            Indicator.hide()
            Messenger.showMessage(title: "Attention", content: "We can't find any restaurants around you. ")
        }
        manager.stopUpdatingLocation()
        stopUpdating = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
