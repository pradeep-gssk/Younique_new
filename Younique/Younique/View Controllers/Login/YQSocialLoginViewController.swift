//
//  YQSocialLoginViewController.swift
//  LashandCarry
//
//  Created by Krishna Pradeep on 10/25/17.
//  Copyright © 2017 Krishna Pradeep. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class YQSocialLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    @IBAction func didClickFacebookLogin(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
            
            if error != nil {
                print("FACEBOOK LOGIN FAILED: \(error!)")
            }
            else if result!.isCancelled {
                print("User cancelled login.")
            }
            else {
                self.signInWithAuthToken(token: result!.token.tokenString, type: .facebook)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? YQInstagramWebViewController {
            viewController.didFetchAccessToken = {[weak self] (access_token) -> Void in
                if let weakSelf = self {
                    weakSelf.signInWithAuthToken(token: access_token, type: .instagram)
                }
            }
        }
    }
    
    func signInWithAuthToken(token: String, type: Provider){
        self.showLoadingScreen()
        let router = Router(endpoint: .SocialLogin(type: type, token: token))
        
        APIManager.shared.login(router: router, success: {
            DispatchQueue.main.async {
                self.hideLoadingScreen()
                appDelegate.showMainApplication()
            }
        }, failure: { (error: Error) in
            DispatchQueue.main.async {
                self.hideLoadingScreen()
            }
            //Show error
        })
    }
}
