//
//  BusinessLoginViewController.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 15/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit

class BusinessLoginViewController: UIViewController {
    static func create() -> BusinessLoginViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BusinessLoginViewController") as! BusinessLoginViewController
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginBtn(_ sender: UIButton){
        if (emailTextField.text == nil || passwordTextField.text == nil) {
            Messenger.showMessage(title: "Attention", content: "Please enter email and password. ")
            return
        }
        
        let email = emailTextField.text!
        let pw = passwordTextField.text!
        
        if let account = DatabaseConnector.loginBiz(email: email, password: pw) {
            Setting.myBizId = account.id
            let vc = BusinessAccountViewController.create()
            vc.navigationController?.isNavigationBarHidden = true
            let lastTab = mainController?.viewControllers?.last as? UINavigationController
            lastTab?.setViewControllers([vc], animated: false)
            dismiss(animated: true)
            mainController?.selectedIndex = 2
            mainController?.homeVc.toggleBizLoginButton()
        } else {
            Messenger.showMessage(title: "Attention", content: "Incorrect credential. Please try again.")
        }
        
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))

    }
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

}
