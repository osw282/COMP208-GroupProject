//
//  LocationHelper.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 23/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import Foundation
import CoreLocation
class LocationHelper {
    static func getNearbyRestaurantsByCode(_ code: String, completion: @escaping(([Restaurant]) -> Void)){
        getLocationFromPostCode(code: code) { (address, location) in
            guard let location = location else {
                completion([])
                return
            }
            let res = DatabaseConnector.searchNearby(targetLocation: location)
            completion(res)
        }
    }
    static func getLocationFromPostCode(code: String,completion: @escaping(String?, CLLocation?) -> Void) {
        let api = "http://api.postcodes.io/postcodes/" + code
        guard let urlString = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(nil, nil)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                
                let street = json.value(forKeyPath: "result.parliamentary_constituency") as? String
                let city = json.value(forKeyPath: "result.admin_district") as? String
                let county = json.value(forKeyPath: "result.admin_county") as? String
                let address = [street, city, county].compactMap({return $0 }).joined(separator: ", ")
                guard let lat = json.value(forKeyPath: "result.latitude") as? Double, let long = json.value(forKeyPath: "result.longitude") as? Double else {
                    completion(nil, nil)
                    return
                }
                let location = CLLocation(latitude: lat, longitude: long)
                completion(address, location)
            } catch {
                print(error)
                completion(nil, nil)
            }
        }
        
        task.resume()
    }
}
