//
//  CustomButton.swift
//  MyBlog Home Automation
//
//  Created by Hristo Borisov on 1/3/16.
//  Copyright © 2016 Hristo Borisov. All rights reserved.
//

import UIKit
import Alamofire

protocol CustomButtonDelegate {
    func action(button: CustomButton) -> Void
}

class LampSwitchAction: CustomButtonDelegate {
    func action(button: CustomButton) {
        var url = "http://" + button.switchId + ".local"
        
        if button.switchState {
            url += "/on"
        } else {
            url += "/off"
        }
        
        Alamofire.request(.GET, url)
        print("delgate action: " + url)
    }
}

class CustomButton: UIControl {

    let textField = UITextView()
    var onImage = UIImage()
    var offImage = UIImage()
    
    var switchState = false
    var switchId = ""
    var buttonAction: CustomButtonDelegate?
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUp()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setUp()
    }
    
    func setUp() {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)
        
        textField.frame = CGRect(x: 0, y: 60, width:self.frame.size.width, height: 40)
        textField.textAlignment = NSTextAlignment.Center
        textField.textColor = UIColor.redColor()
        textField.scrollEnabled = true
        self.addSubview(textField)
        
        let imageRect = CGRect(x: 10, y: 0, width: self.frame.size.width-20, height: self.frame.size.height - 40)
        print(imageRect)
        
        UIGraphicsBeginImageContext(self.frame.size)
        UIImage(named: "light-bulb-3.png")?.drawInRect(imageRect)
        offImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(self.frame.size)
        UIImage(named: "light-bulb-3-on.png")?.drawInRect(imageRect)
        onImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.backgroundColor = UIColor(patternImage: offImage)
        
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        self.addGestureRecognizer(recognizer)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let previousPoint = touch.previousLocationInView(self)
        let point  = touch.locationInView(self)
        
        let translation = CGPoint(x: point.x-previousPoint.x, y: point.y - previousPoint.y)
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
    }
    
    func setTitle(title: String) {
        textField.text = title
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        changeState()
        buttonAction?.action(self)
    }
    
    func changeState() {
        if switchState {
            setSwitchOff()
        } else {
            setSwitchOn()
        }
    }
    
    func setSwitchOn() {
        switchState = true
        self.backgroundColor = UIColor(patternImage: onImage)
    }
    
    func setSwitchOff() {
        switchState = false
        self.backgroundColor = UIColor(patternImage: offImage)
    }
    
    func addAction(action: CustomButtonDelegate) {
        buttonAction = action
    }
    
}
