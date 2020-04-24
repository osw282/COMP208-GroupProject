//
//  WriteReviewViewController.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 12/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit

class WriteReviewViewController: UIViewController {
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var submitReviewBtn: UIButton!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var resNameLabel: UILabel!
    var restaurant: Restaurant?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //submitReviewBtn.isHidden = Setting.myBizId != nil
        if (Setting.myBizId != nil) {
            submitReviewBtn.isEnabled = false
            submitReviewBtn.setTitleColor(UIColor.red, for: .normal)
            submitReviewBtn.setTitle("Not allowed", for: .normal)
        }
        submitReviewBtn.addTarget(self, action: #selector(submitMyReview), for: .touchUpInside)
        if let data = restaurant {
            setData(data)
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func submitMyReview() {
        guard let myId = Setting.myId else { return }
        guard let restaurantId = restaurant?.id else { return }
        guard let text = reviewTextView.text, text.isEmpty == false else {
            Messenger.showMessage(title: "Attention", content: "Please input your review")
            return
        }
        
        // prepare json data
        let json: [String: Any] = ["text": text]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://35.246.115.108:5000/predict_api")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let scoreString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines) ?? "0"
            let score = Int(scoreString) ?? 0
            DatabaseConnector.sumbitReview(customerID: myId, restaurantID: restaurantId, sentimentReviewScore: score, reviewText: text)
            let message = "Your review gives this restaurant a score of " + scoreString
            
            DispatchQueue.main.async {
                Messenger.showMessage(title: "Thank you for your review", content: message, completion: { self?.dismiss(animated: true)})
            }
        }
        
        task.resume()
    }
    
    private func setData(_ restaurant: Restaurant) {
        self.restaurant = restaurant
        coverImage.downloadImage(from: restaurant.imageUrl)
        resNameLabel.text = restaurant.name
    }
}
