//
//  YQEmailLoginViewController.swift
//  LashandCarry
//
//  Created by Krishna Pradeep on 10/25/17.
//  Copyright © 2017 Krishna Pradeep. All rights reserved.
//

import UIKit

class YQEmailLoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var iconTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var textfieldTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.main.bounds.height <= 480 {
            self.iconTopConstraint.constant = 0
            self.textfieldTopConstraint.constant = 21
        }
        
        let emailLeftImageView = UIImageView(image: UIImage(named: "User_Circle"));
        emailLeftImageView.frame = CGRect(x: 0, y: 0, width: 45, height: 25)
        emailLeftImageView.contentMode = UIViewContentMode.center

        self.emailTextField.leftView = emailLeftImageView
        self.emailTextField.leftViewMode = UITextFieldViewMode.always

        let passwordLeftImageView = UIImageView(image: UIImage(named: "Lock"));
        passwordLeftImageView.frame = CGRect(x: 0, y: 0, width: 45, height: 25)
        passwordLeftImageView.contentMode = UIViewContentMode.center
        
        self.passwordTextField.leftView = passwordLeftImageView
        self.passwordTextField.leftViewMode = UITextFieldViewMode.always
        
        let passwordRightButton = UIButton(type: .custom)
        passwordRightButton.frame = CGRect(x: 0, y: 0, width: 45, height: 25)
        passwordRightButton.setImage(UIImage(named: "ForgotPassword"), for: .normal)
        passwordRightButton.addTarget(self, action: #selector(didClickForgotPassword), for: .touchUpInside)
        
        self.passwordTextField.rightView = passwordRightButton
        self.passwordTextField.rightViewMode = UITextFieldViewMode.always
        
        self.emailTextField.text = "monserratmsoto@yahoo.com"
        self.passwordTextField.text = "Chotu@4263"
    }
    
    @objc func didClickForgotPassword() {
        let url = URL(string: "https://www.youniqueproducts.com/account/resetpassword")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url!)
        }
    }
    
    @IBAction func didClickBackButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didClickLoginButton(_ sender: Any) {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        
        let router = Router(endpoint: .Login(email: email, password: password))

        APIManager.shared.login(router: router, success: {
            DispatchQueue.main.async {
                self.hideLoadingScreen()
                appDelegate.showMainApplication()
                print("success")
            }
        }, failure: { (error: Error) in
            DispatchQueue.main.async {
                self.hideLoadingScreen()
            }
            //Show error
        })
    }
}
