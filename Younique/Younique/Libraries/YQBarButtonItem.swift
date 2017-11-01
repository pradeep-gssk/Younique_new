//
//  YQBarButtonItem.swift
//  Younique
//
//  Created by Krishna Pradeep on 10/31/17.
//  Copyright © 2017 Krishna Pradeep. All rights reserved.
//

import UIKit

class YQBarButtonItem: UIBarButtonItem {
    var badgeValue: Int = 0 {
        didSet {
            self.badgeValueString = "\(badgeValue)"
            updateBadgeValue()
        }
    }
    
    private var badgeValueString: String = ""
    
    private var badgeLabel: UILabel = UILabel()
    private var shouldHideBadgeAtZero: Bool = true
    private var originalFrame: CGRect = .zero
    private var minimumWidth: CGFloat = 8.0
    private var horizontalPadding: CGFloat = 8.0
    private var shouldAnimateBadge: Bool = true
    private var textColor: UIColor = UIColor.white
    private var font: UIFont = UIFont.systemFont(ofSize: 12.0)
    private var backgroundColor: UIColor = UIColor(red: (224/255), green: (73/255), blue: (154/255), alpha: 1.0)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        var buttonFrame: CGRect = CGRect.zero
        if let image = self.image {
            buttonFrame = CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
        } else if let title = self.title {
            let lbl = UILabel()
            lbl.text = title
            let textSize = lbl.sizeThatFits(CGSize(width: 100.0, height: 100.0))
            buttonFrame = CGRect(x: 0.0, y: 0.0, width: textSize.width + 2.0, height: textSize.height)
        }
        
        
        performStoryboardInitalizationSetup(with: buttonFrame, title: self.title, image: self.image)
        commonInit()
    }
    
    private func performStoryboardInitalizationSetup(with frame: CGRect, title: String? = nil, image: UIImage?) {
        let btn = createInternalButton(frame: frame, title: title, image: image)
        self.customView = btn
        btn.addTarget(self, action: #selector(internalButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func internalButtonTapped(_ sender: UIButton) {
        guard let action = self.action, let target = self.target else {
            preconditionFailure("Developer Error: The BadgedBarButtonItem requires a target-action pair")
        }
        
        UIApplication.shared.sendAction(action, to: target, from: self, for: nil)
    }
    
    private func commonInit() {
        badgeLabel.font = self.font
        badgeLabel.textColor = self.textColor
        badgeLabel.backgroundColor = self.backgroundColor
    }
    
    private func createInternalButton(frame: CGRect,
                                      title: String? = nil,
                                      image: UIImage?) -> UIButton {
        
        let btn = UIButton(type: .custom)
        btn.setImage(image, for: UIControlState())
        btn.setTitle(title, for: UIControlState())
        btn.setTitleColor(UIColor.black, for: UIControlState())
        btn.frame = frame
        
        return btn
    }
    
    private func calculateUpdatedBadgeFrame(usingFrame frame: CGRect) {
        let offset = CGFloat(10.0)
        self.originalFrame.origin.x = (frame.size.width - offset) - badgeLabel.frame.size.width/2
        self.originalFrame.origin.y = offset - frame.size.height
    }
    
    func updateBadgeValue() {
        guard !shouldBadgeHide(badgeValue) else {
            if (badgeLabel.superview != nil) {
                removeBadge()
            }
            return
        }
        
        if (badgeLabel.superview != nil) {
            animateBadgeValueUpdate()
        } else {
            badgeLabel = self.createBadgeLabel()
            updateBadgeProperties()
            customView?.addSubview(badgeLabel)
            
            // Pull the setting of the value and layer border radius off onto the next event loop.
            DispatchQueue.main.async() { () -> Void in
                self.badgeLabel.text = self.badgeValueString
                self.updateBadgeFrame()
            }
        }
    }
    
    func animateBadgeValueUpdate() {
        if shouldAnimateBadge, badgeLabel.text != badgeValueString {
            let animation: CABasicAnimation = CABasicAnimation()
            animation.keyPath = "transform.scale"
            animation.fromValue = 1.5
            animation.toValue = 1
            animation.duration = 0.2
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 1.3, 1.0, 1.0)
            badgeLabel.layer.add(animation, forKey: "bounceAnimation")
        }
        
        badgeLabel.text = badgeValueString;
        
        UIView.animate(withDuration: 0.2) {
            self.updateBadgeFrame()
        }
    }
    
    func updateBadgeFrame() {
        let expectedLabelSize: CGSize = badgeExpectedSize()
        var minHeight = expectedLabelSize.height
        
        minHeight = (minHeight < self.minimumWidth) ? self.minimumWidth : expectedLabelSize.height
        var minWidth = expectedLabelSize.width
        let horizontalPadding = self.horizontalPadding
        
        minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width
        
        let nFrame = CGRect(
            x: self.originalFrame.origin.x,
            y: self.originalFrame.origin.y,
            width: minWidth + horizontalPadding,
            height: minHeight + horizontalPadding
        )
        
        UIView.animate(withDuration: 0.2) {
            self.badgeLabel.frame = nFrame
        }
        
        self.badgeLabel.layer.cornerRadius = (minHeight + horizontalPadding) / 2
    }
    
    func removeBadge() {
        let duration = shouldAnimateBadge ? 0.08 : 0.0
        
        let currentTransform = badgeLabel.layer.transform
        let tf = CATransform3DMakeScale(0.001, 0.001, 1.0)
        badgeLabel.layer.transform = tf
        let scaleAnimation = CABasicAnimation()
        scaleAnimation.fromValue = currentTransform
        scaleAnimation.duration = duration
        scaleAnimation.isRemovedOnCompletion = true
        badgeLabel.layer.add(scaleAnimation, forKey: "transform")
        
        badgeLabel.layer.opacity = 0.0
        let opacityAnimation = CABasicAnimation()
        opacityAnimation.fromValue = 1.0
        opacityAnimation.duration = duration
        opacityAnimation.isRemovedOnCompletion = true
        opacityAnimation.delegate = self
        badgeLabel.layer.add(opacityAnimation, forKey: "opacity")
    }
    
    func createBadgeLabel() -> UILabel {
        let frame = CGRect(
            x: self.originalFrame.origin.x,
            y: self.originalFrame.origin.y,
            width: self.originalFrame.width,
            height: self.originalFrame.height
        )
        let label = UILabel(frame: frame)
        label.textColor = self.textColor
        label.font = self.font
        label.backgroundColor = self.backgroundColor
        label.textAlignment = NSTextAlignment.center
        label.layer.cornerRadius = frame.size.width / 2
        label.clipsToBounds = true
        
        return label
    }
    
    func badgeExpectedSize() -> CGSize {
        let frameLabel: UILabel = self.duplicateLabel(badgeLabel)
        frameLabel.sizeToFit()
        let expectedLabelSize: CGSize = frameLabel.frame.size
        
        return expectedLabelSize
    }
    
    func duplicateLabel(_ labelToCopy: UILabel) -> UILabel {
        let dupLabel = UILabel(frame: labelToCopy.frame)
        dupLabel.text = labelToCopy.text
        dupLabel.font = labelToCopy.font
        
        return dupLabel
    }
    
    func shouldBadgeHide(_ value: Int) -> Bool {
        return (value == 0) && shouldHideBadgeAtZero
    }
    
    func updateBadgeProperties() {
        if let customView = self.customView {
            calculateUpdatedBadgeFrame(usingFrame: customView.frame)
        }
    }
}

extension YQBarButtonItem: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.badgeLabel.removeFromSuperview()
        }
    }
}

