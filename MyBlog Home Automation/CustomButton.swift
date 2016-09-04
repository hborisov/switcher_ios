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
        var url = "http://" + button.ipAddress
        
        if button.switchState {
            url += "/on"
        } else {
            url += "/off"
        }
        
        print("request")
        Alamofire.request(.GET, url).response {
            request, response, data, error in
            print("response")
            print(response)
            print(response!.statusCode)
            print(request!.URL)
            print(error)
        }
        print("delgate action: " + url)
    }
}

class CustomButton: UIControl {

    let textField = UITextView()
    var onImage = UIImage()
    var offImage = UIImage()
    
    var switchState: Bool
    var switchId: String
    var ipAddress: String
    var buttonAction: CustomButtonDelegate?
    var dropTarget: [UIControl]
    var dragInitialLocation = CGPoint()
    
    internal override init(frame: CGRect) {
        self.switchId = ""
        self.ipAddress = ""
        self.switchState = false
        self.dropTarget = [UIControl]()
        
        super.init(frame: frame)
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)

        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //DO NOT CHANGE THE ORDER OF THE FOLLOWING STATEMENTS
        self.switchState = false
        self.switchId = ""
        self.ipAddress = ""
        self.dropTarget = [UIControl]()
        super.init(coder: aDecoder)

        let x = aDecoder.decodeObjectForKey("x") as! CGFloat
        let y = aDecoder.decodeObjectForKey("y") as! CGFloat
        let width = aDecoder.decodeObjectForKey("width") as! CGFloat
        let height = aDecoder.decodeObjectForKey("height") as! CGFloat
        self.frame = CGRectMake(x, y, width, height)
        self.dropTarget = aDecoder.decodeObjectForKey("dropTarget") as! [UIControl]
        self.setUp()
        
        let switchId = aDecoder.decodeObjectForKey("switchId") as! String
        self.switchId = switchId
        let ipAddress = aDecoder.decodeObjectForKey("ipAddress") as! String
        self.ipAddress = ipAddress
        let switchState = aDecoder.decodeBoolForKey("switchState")
        self.setState(switchState)
        let title = aDecoder.decodeObjectForKey("title") as! String
        self.setTitle(title)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(switchId, forKey: "switchId")
        aCoder.encodeObject(ipAddress, forKey: "ipAddress")
        aCoder.encodeBool(switchState, forKey: "switchState")
        aCoder.encodeObject(self.frame.origin.x, forKey: "x")
        aCoder.encodeObject(self.frame.origin.y, forKey: "y")
        aCoder.encodeObject(self.frame.size.width, forKey: "width")
        aCoder.encodeObject(self.frame.size.height, forKey: "height")
        aCoder.encodeObject(self.textField.text, forKey: "title")
        aCoder.encodeObject(self.dropTarget, forKey: "dropTarget")
    }

    
    func setUp() {
        
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
        let point = touch.locationInView(self)
        
        let translation = CGPoint(x: point.x - previousPoint.x, y: point.y - previousPoint.y)
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)

        /*
        if CGRectIntersectsRect(self.frame, dropTarget.frame) {
            let temp = dropTarget as! CustomBundleButton
            temp.addButton(self)
        }
        */
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dragInitialLocation = self.center
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let previousPoint = touch.previousLocationInView(self)
        let point = touch.locationInView(self)
        
        let translation = CGPoint(x: point.x - previousPoint.x, y: point.y - previousPoint.y)
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        
        for currentDropTarget in dropTarget {
            if CGRectIntersectsRect(self.frame, currentDropTarget.frame) {
                let temp = currentDropTarget as! CustomBundleButton
                temp.addButton(self)
                
                self.center = self.dragInitialLocation
            }
        }
        
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
        self.switchState = true
        self.backgroundColor = UIColor(patternImage: onImage)
    }
    
    func setSwitchOff() {
        self.switchState = false
        self.backgroundColor = UIColor(patternImage: offImage)
    }
    
    func setState(state: Bool) {
        if state {
            self.setSwitchOn()
        } else {
            self.setSwitchOff()
        }
    }
    
    func addAction(action: CustomButtonDelegate) {
        buttonAction = action
    }
    
}
