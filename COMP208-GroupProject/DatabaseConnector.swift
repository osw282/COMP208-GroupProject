//
//  DatabaseConnector.swift
//  
//
//  Created by Oscar Wong on 10/04/2020.
//

import Foundation
import OHMySQL
import CoreLocation

class DatabaseConnector {
    static var coordinator: OHMySQLStoreCoordinator = {
        let user = OHMySQLUser(userName: "oAkt8vdQew", password: "9lC8hYNA5T", serverName: "remotemysql.com", dbName: "oAkt8vdQew", port: 3306, socket: "/Applications/MAMP/tmp/mysql/mysql.sock")
        let coordinator = OHMySQLStoreCoordinator(user: user!)
        coordinator.encoding = .UTF8MB4
        coordinator.connect()
        return coordinator
    }()
    
    static var context: OHMySQLQueryContext = {
        let context = OHMySQLQueryContext()
        context.storeCoordinator = coordinator
        return context
    }()
    static func getData(table: String, query: String? = nil) -> [[String: Any]] {
        do {
            let query = OHMySQLQueryRequestFactory.select(table, condition: query)
            let response = try context.executeQueryRequestAndFetchResult(query)
            return response
        }
        catch let error {
            print(error)
        }
        return []
    }
    static func getMyRestaurant(businessId: Int) -> [Restaurant] {
        let query = "BusinessID = \(businessId)"
        let response = getData(table: "Restaurant", query: query)
        let restaurants = response.map({ return Restaurant(rawData: $0) })
        return restaurants
    }
    static func createBizAccount(name: String, email: String, password: String) -> Error? {
        let query = OHMySQLQueryRequestFactory.insert("Business", set: ["BusinessName": name,  "BusinessEmail": email, "BusinessHashedPass": password.md5])
        do {
            try context.execute(query)
            return nil
        } catch {
            return error
        }
    }
    static func loginBiz(email: String, password: String) -> Business? {
        let query = "BusinessEmail = '\(email)' AND BusinessHashedPass = '\(password.md5)'"
        guard let response = getData(table: "Business", query: query).first else { return nil }
        let account = Business(raw: response)
        return account
    }
    
    
    
    static func userRegister(userId: String, token: String, name: String?, email: String) -> Customer? {
        if let user = userLogin(userId: userId) {
            return user
        }
        
        let query = OHMySQLQueryRequestFactory.insert("Customer", set: ["CustomerEmail": email, "CustomerName": name, "CustomerAccessToken": userId])
        do {
            try context.execute(query)
            let user = userLogin(userId: userId)
            return user
        }
        catch let err {
            print(err)
        }
        return nil
    }
    static func userLogin(userId: String) -> Customer? {
        let response = getData(table: "Customer", query: "CustomerAccessToken=" + userId)
        guard let item = response.first else { return nil }
        let user = Customer(rawData: item)
        Setting.myId = user.id
        
        return user
    }
    
}


// MARK: REVIEW
extension DatabaseConnector {
    static func sumbitReview(customerID: Int, restaurantID: Int, sentimentReviewScore: Int, reviewText: String) {
        let query = OHMySQLQueryRequestFactory.insert("Review", set: ["ReviewText": reviewText, "CustomerID": customerID, "RestaurantID": restaurantID, "SentimentReviewScore": sentimentReviewScore])
        do {
            try context.execute(query)
        } catch let err {
            print(err)
        }
    }
    static func getMyReview() -> [Review] {
        guard let myId = Setting.myId else { return [] }
        let result = getData(table: "Review", query: "CustomerID=" + String(myId))
        var myReviews = [Review]()
        for item in result {
            guard let giverId = item["CustomerID"] as? Int else { continue }
            if giverId != myId { continue }
            let review = Review(rawData: item)
            myReviews.append(review)
        }
        
        return myReviews
    }
}

// MARK: GET RESTAURANT DETAIL
extension DatabaseConnector {
    static func getRestaurantDetail(id: Int) -> Restaurant? {
        guard let result = getData(table: "Restaurant", query: "RestaurantID=" + String(id)).first else { return nil }
        let restaurant = Restaurant(rawData: result)
        return restaurant
    }
}


extension DatabaseConnector {
    static func searchNearby(targetLocation: CLLocation) -> [Restaurant] {
        let response = getData(table: "Restaurant")
        let restaurants = response.map({ return Restaurant(rawData: $0) })
        
        var nearbyOnes = [Restaurant]()
        for res in restaurants {
            guard let lat = res.lat, let long = res.long else { continue }
            let coffeeShopCoordinate = CLLocation(latitude: lat, longitude: long)
            let distanceInMeters = targetLocation.distance(from: coffeeShopCoordinate)
            if distanceInMeters < 10000 {
                nearbyOnes.append(res)
            }
        }
        return nearbyOnes
    }
}

// MARK: ADD NEW RESTAURANT
extension DatabaseConnector {
    static func addNewRestaurants(BusinessID: Int,
                                  RestaurantName: String,
                                  RestaurantDescription: String,
                                  ImageURL: String?,
                                  RestaurantAddress: String,
                                  Lat: Double,
                                  Long: Double,
                                  OpeningTimes: String) -> Error? {
        let query = OHMySQLQueryRequestFactory.insert("Restaurant", set: [
            "BusinessID": BusinessID,
            "RestaurantName": RestaurantName,
            "RestaurantDescription": RestaurantDescription,
            "ImageURL": ImageURL,
            "RestaurantAddress": RestaurantAddress,
            "RestaurantLat": Lat,
            "RestaurantLong": Long,
            "RestaurantOpeningTimes": OpeningTimes,
            "RestaurantOverallScore": 0])
        do {
            try context.execute(query)
            return nil
        } catch let err {
            print(err)
            return err
        }
    }
    static func updateRestaurants(restaurantId: Int,
                                  RestaurantName: String,
                                  RestaurantDescription: String,
                                  ImageURL: String?,
                                  RestaurantAddress: String,
                                  Lat: Double,
                                  Long: Double,
                                  OpeningTimes: String) -> Error? {
        let query = OHMySQLQueryRequestFactory.update("Restaurant", set: [
            "RestaurantName": RestaurantName,
            "RestaurantDescription": RestaurantDescription,
            "ImageURL": ImageURL,
            "RestaurantAddress": RestaurantAddress,
            "RestaurantLat": Lat,
            "RestaurantLong": Long,
            "RestaurantOpeningTimes": OpeningTimes,
            "RestaurantOverallScore": 0], condition: "RestaurantID="+String(restaurantId))
        do {
            try context.execute(query)
            return nil
        } catch let err {
            print(err)
            return err
        }
    }
    static func deleteRestaurant(restaurantId: Int) -> Error? {
        let query = OHMySQLQueryRequestFactory.delete("Restaurant", condition: "RestaurantID="+String(restaurantId))
        do {
            try context.execute(query)
            return nil
        } catch let err {
            print(err)
            return err
        }
    }
    
}

extension DatabaseConnector {
    static func deleteAccount(userId: Int) -> Error? {
        let query = OHMySQLQueryRequestFactory.delete("Customer", condition: "CustomerID="+String(userId))
        do {
            try context.execute(query)
            return nil
        } catch let err {
            print(err)
            return err
        }
    }
    static func deleteReview(reviewId: Int) -> Error? {
        let query = OHMySQLQueryRequestFactory.delete("Review", condition: "ReviewID="+String(reviewId))
        do {
            try context.execute(query)
            return nil
        } catch let err {
            print(err)
            return err
        }
    }
    static func getUserDetail(userId: Int) -> Customer? {
        guard let result = getData(table: "Customer", query: "CustomerID=" + String(userId)).first else { return nil }
        let user = Customer(rawData: result)
        return user
    }
    static func getAllReviewsOfRestaurant(_ id: Int) -> [Review] {
        let result = getData(table: "Review", query: "RestaurantID=" + String(id))
        let reviews = result.map({ return Review(rawData: $0) })
        return reviews
    }
}
