//
//  UIViewController+.swift
//  Younique
//
//  Created by Jacob Wagstaff on 5/16/17.
//  Copyright © 2017 Jacob Wagstaff. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    
    // Nav Bar Functions
    func addYouniqueLogoToNavigationBar() {
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 57, height: 31))
        logo.contentMode = .scaleAspectFit
        logo.image = UIImage(named: "YouniqueNav")
        navigationItem.titleView = logo
    }
    
    func removeNavigationBarBackTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func showLoadingScreen() {
        if let navigationController = self.navigationController {
            MBProgressHUD.showAdded(to: navigationController.view, animated: true)
        }
        else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    func hideLoadingScreen() {
        if let navigationController = self.navigationController {
            MBProgressHUD.hide(for: navigationController.view, animated: true)
        }
        else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
//    func removeNavigationBarBackButton(){
//        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
//        navigationItem.leftBarButtonItem = backButton
//    }
}
