//
//  RestaurantDetailView.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 15/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit
import Cosmos
import CoreLocation
import MapKit

class RestaurantDetailView: UIView {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var resNameLabel: UILabel!
    @IBOutlet weak var resScore: CosmosView!
    @IBOutlet weak var resDescriptionLabel: UILabel!
    @IBOutlet weak var resAddressLabel: UILabel!
    @IBOutlet weak var resOpeningTimeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var data: Restaurant?
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func setData(_ restaurant: Restaurant) {
        self.data = restaurant
        if let url = restaurant.imageUrl, url.isEmpty == false {
            coverImageView.downloadImage(from: url)
        } else {
            coverImageView.image = UIImage(named: "Top-Background")
        }
        resNameLabel.text = restaurant.name
        resScore.rating = restaurant.score
        resDescriptionLabel.text = """
        Description:
        \(restaurant.description)
        """
        resAddressLabel.text = """
        Address:
        \(restaurant.address)
        """
        resOpeningTimeLabel.text = """
        Opening Times:
        \(restaurant.openingTimes))
        """
        
        if let lat = restaurant.lat, let long = restaurant.long {
            let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let pin = MKPlacemark(coordinate: location)
            let coordinateRegion = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
            mapView.setRegion(coordinateRegion, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = resNameLabel.text
            mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func viewAllReviews() {
        let vc = RestaurantReviewController.create()
        vc.data = data
        UIApplication.topViewController()?.present(vc, animated: true)
    }
}


extension UIView {
    func xibSetup() {
        backgroundColor = UIColor.clear
        guard let view = loadNib() else { return }
        view.frame = bounds
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
    }
    
    func loadNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
