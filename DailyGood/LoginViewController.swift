//
//  LoginViewController.swift
//  DailyGood
//
//  Created by Maurice Woods on 2/21/15.
//  Copyright (c) 2015 kelly. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var disableLoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func loginButton(sender: AnyObject) {
        
        if (usernameTextField.text.isEmpty) {
            var alertView = UIAlertView(title: "Opps", message: "Please enter a username", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }

        loaderIndicator.startAnimating()
        delay(1, { () -> () in
            if (self.passwordTextField.text == "dailygood" && self.usernameTextField.text == "mo" || self.usernameTextField.text == "Kelly" || self.usernameTextField.text == "Fillip") {
                self.performSegueWithIdentifier("LoginSegue", sender: nil)
                
            } else {
                var alertView = UIAlertView(title: "Incorrect Username or Password", message: "Please try entering your information again", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
                self.loaderIndicator.stopAnimating()
                self.passwordTextField.text = ""
                self.usernameTextField.text = ""
            }
        })

    }
   
    

}
