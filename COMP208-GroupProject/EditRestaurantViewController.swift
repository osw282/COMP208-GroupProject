//
//  EditRestaurantViewController.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 18/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit
import MapKit

class EditRestaurantViewController: UIViewController {
    static func create() -> EditRestaurantViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditRestaurantViewController") as! EditRestaurantViewController
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var postCodeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imageUrlTextField: UITextField!
    @IBOutlet weak var openingTimesTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    var restaurant: Restaurant?
    weak var hostController: BusinessRestaurantDetailViewController?
    
    var location: CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        openingTimesTextView.delegate = self
        openingTimesTextView.layer.borderColor = UIColor.lightGray.cgColor
        openingTimesTextView.layer.borderWidth = 1
        openingTimesTextView.layer.cornerRadius = 5
        openingTimesTextView.layer.masksToBounds = true
        tableView.contentInsetAdjustmentBehavior = .never
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let data = restaurant {
            setData(data)
        }
    }
    
    private func setData(_ restaurant: Restaurant) {
        nameTextField.text = restaurant.name
        addressTextField.text = restaurant.address
        descriptionTextField.text = restaurant.description
        imageUrlTextField.text = restaurant.imageUrl
        openingTimesTextView.text = restaurant.openingTimes
        if let lat = restaurant.lat, let long = restaurant.long {
           let location = CLLocation(latitude: lat, longitude: long)
            showLocationOnMap(location: location)
            self.location = location.coordinate
        }
    }
    
    @IBAction func searchAddress() {
        guard let code = postCodeTextField.text else {
            Messenger.showMessage(title: "Attention", content: "Please enter a post code to search")
            return
        }
        LocationHelper.getLocationFromPostCode(code: code) { [weak self] (_address, _location) in
            guard let address = _address, let location = _location else { return }
            self?.location = location.coordinate
            DispatchQueue.main.async {
                self?.addressTextField.text = address
                self?.showLocationOnMap(location: location)
            }
        }
    }
    func showLocationOnMap(location: CLLocation) {
        let latDelta: CLLocationDegrees = 0.002
        let lonDelta: CLLocationDegrees = 0.002
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: position, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = position // Where the annotation is placed on the map
        annotation.title = nameTextField.text
        mapView.addAnnotation(annotation)
    }
    @IBAction func saveEdit() {
        guard let id = restaurant?.id else  { return }
       guard let name = nameTextField.text,
            let address = addressTextField.text,
            let description = descriptionTextField.text,
            let lat = location?.latitude,
            let long = location?.longitude,
            var openingTimes = openingTimesTextView.text else {
                Messenger.showMessage(title: "Attention ", content: "You have to fill all required fields")
            return
        }
        openingTimes = openingTimes.replacingOccurrences(of: "Opening times:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        Indicator.showLoading()
        let error = DatabaseConnector.updateRestaurants(restaurantId: id,
                                            RestaurantName: name,
                                            RestaurantDescription: description,
                                            ImageURL: imageUrlTextField.text,
                                            RestaurantAddress: address,
                                            Lat: lat, Long: long, OpeningTimes: openingTimes)
        if error == nil {
            Messenger.showMessage(title: "Done", content: "Your restaurant is updated")
        } else {
            Messenger.showMessage(title: "Attention", content: error!.localizedDescription)
        }
        Indicator.hide()
    }
    @IBAction func deleteRestaurant() {
        guard let id = restaurant?.id else  { return }
        Indicator.showLoading()
        let error = DatabaseConnector.deleteRestaurant(restaurantId: id)
        if error == nil {
            dismiss(animated: true)
            hostController?.close()
        } else {
            Messenger.showMessage(title: "Attention", content: error!.localizedDescription)
        }
        Indicator.hide()
    }
}



extension EditRestaurantViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        tableView.tableFooterView = nil
    }
}
