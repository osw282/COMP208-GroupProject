//
//  AccountViewController.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 10/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKCoreKit
import Cosmos

class CustomerLoginController: UIViewController {
    static func create() -> CustomerLoginController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerLoginController") as! CustomerLoginController
    }
    
    
    
    let loginButton = FBLoginButton(permissions: [ .publicProfile, .email ])
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.delegate = self
        var center = view.center
        center.y += 128
        loginButton.center = center
        
        view.addSubview(loginButton)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    
}


extension CustomerLoginController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let res = result else { return }
        let userId = res.token?.userID
        let token = res.token?.tokenString
        
        let request = GraphRequest(graphPath: "me", parameters: ["fields":"first_name,last_name,email"], tokenString: token, version: nil, httpMethod: .get)
        request.start { [weak self] (connection, _result, err) in
            let result = _result as AnyObject
            let email = result["email"] as? String
            let firstName = result["first_name"] as? String ?? ""
            let lastName = result["last_name"]  as? String ?? ""
            let name = firstName + lastName
            let _ = DatabaseConnector.userRegister(userId: userId!, token: token!, name: name, email: email!)
            
            let vc = AccountViewController.create()
            self?.navigationController?.setViewControllers([vc], animated: true)
         
            mainController?.homeVc.toggleBizLoginButton()
        }
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    
}
