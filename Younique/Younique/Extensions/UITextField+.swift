//
//  UITextField+.swift
//  LashandCarry
//
//  Created by Krishna Pradeep on 10/25/17.
//  Copyright © 2017 Krishna Pradeep. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func addPlaceholderTextWithColor(color: UIColor, text: String){
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [.foregroundColor: color])
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 4, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 4, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
