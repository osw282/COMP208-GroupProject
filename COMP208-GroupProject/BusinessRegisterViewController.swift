//
//  BusinessRegisterViewController.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 12/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit

class BusinessRegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func createAccountBtn(_ sender: UIButton) {
        guard let email = emailTextField.text, email.isEmpty == false else {
            // show message: invalid email
            return
        }
        
        if (emailTextField.text == nil || passwordTextField.text == nil) {
            //show Must enter a email and password to create a business account
        }
        
        let pw = passwordTextField.text
        let name = nameTextField.text
        let registerErr = DatabaseConnector.createBizAccount(name: name!, email: email, password: pw!)
        if registerErr == nil {
            dismiss(animated: true)
        } else {
            // show error message. 
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
