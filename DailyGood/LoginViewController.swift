//
//  LoginViewController.swift
//  DailyGood
//
//  Created by Kelly Xu on 2/25/15.
//  Copyright (c) 2015 kelly. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var square: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.alpha = 0
        // Do any additional setup after loading the view.
        square.layer.cornerRadius = 10

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onSigninBtn(sender: AnyObject) {
        if emailTextField.text == "test@gmail.com" && passwordTextField.text == "123"{
            activityView.alpha = 1
            delay(1, { () -> () in
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            })
            
        }else{
            var alertView = UIAlertView(title: "Wrong Login", message: "Please enter again", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
        }
        
    }
    
    @IBAction func onTapGesture(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
