//
//  YQNavigationController.swift
//  Younique
//
//  Created by Krishna Pradeep on 10/28/17.
//  Copyright © 2017 Krishna Pradeep. All rights reserved.
//

import UIKit

class YQNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let vc = self.viewControllers.first {
            vc.addYouniqueLogoToNavigationBar()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    override func show(_ vc: UIViewController, sender: Any?) {
        vc.addYouniqueLogoToNavigationBar()
        self.pushViewController(vc, animated: true)
    }
}
