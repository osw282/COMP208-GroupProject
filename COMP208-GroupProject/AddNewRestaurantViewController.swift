//
//  AddNewRestaurantViewController.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 13/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit
import MapKit

class AddNewRestaurantViewController: UIViewController {
    static func create() -> AddNewRestaurantViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewRestaurantViewController") as! AddNewRestaurantViewController
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var postCodeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imageUrlTextField: UITextField!
    @IBOutlet weak var openingTimesTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    var location: CLLocationCoordinate2D?
    weak var listController: BusinessAccountViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openingTimesTextView.text = """
        Opening times:
        Mon-Fri: 9am-10pm
        Saturday:11am-12am
        Sunday:12pm-5pm
        """
        openingTimesTextView.textColor = UIColor.lightGray
        tableView.contentInsetAdjustmentBehavior = .never
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        openingTimesTextView.delegate = self
        openingTimesTextView.layer.borderColor = UIColor.lightGray.cgColor
        openingTimesTextView.layer.borderWidth = 1
        openingTimesTextView.layer.cornerRadius = 5
        openingTimesTextView.layer.masksToBounds = true
        
        
        nameTextField.delegate = self
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
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

    @IBAction func createRestaurant() {
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
        guard let myBizId = Setting.myBizId else { return }
        let error = DatabaseConnector.addNewRestaurants(BusinessID: myBizId,
                                            RestaurantName: name,
                                            RestaurantDescription: description,
                                            ImageURL: imageUrlTextField.text,
                                            RestaurantAddress: address,
                                            Lat: lat, Long: long, OpeningTimes: openingTimes)
        if error == nil {
            dismiss(animated: true)
            listController?.getData()
        } else {
            Messenger.showMessage(title: "Attention", content: error!.localizedDescription)
        }
    }

}

extension AddNewRestaurantViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        tableView.tableFooterView = nil
    }
}


extension AddNewRestaurantViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
    }
}
