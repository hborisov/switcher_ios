//
//  HomeControlButton.swift
//  MyBlog Home Automation
//
//  Created by Hristo Borisov on 1/2/16.
//  Copyright © 2016 Hristo Borisov. All rights reserved.
//

import UIKit
import Alamofire

class HomeControlButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    var isSwitched: Bool = false
    var id: String = ""
    
    init(id: String) {
        super.init(frame: CGRectZero)
        self.id = id
        self.setBackgroundImage(UIImage(named: "light-bulb-3.png"), forState: UIControlState.Normal)
        
        self.setTitle(id, forState: UIControlState.Normal)
        self.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let id = aDecoder.decodeObjectForKey("id") as? String
        self.id = id!
        self.setTitle(id, forState: UIControlState.Normal)
        self.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        
        let isSwitched = aDecoder.decodeBoolForKey("isSwitched")
        self.isSwitched = isSwitched
        print(self.isSwitched)
        print(isSwitched)
        
        if self.isSwitched {
            self.setBackgroundImage(UIImage(named: "light-bulb-3-on.png"), forState: UIControlState.Normal)
        } else {
            self.setBackgroundImage(UIImage(named: "light-bulb-3.png"), forState: UIControlState.Normal)
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeBool(isSwitched, forKey: "isSwitched")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        toggle()
        
        super.touchesEnded(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let previousPoint = touch.previousLocationInView(self)
        let point  = touch.locationInView(self)

        let translation = CGPoint(x: point.x-previousPoint.x, y: point.y - previousPoint.y)
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
    }
    
    
    func toggle() {
        var url = "http://" + id + ".local"
        if isSwitched {
            url += "/off"
            setSwitchedOff()
        } else {
            url += "/on"
            setSwitchedOn()
        }
        print(url)
        Alamofire.request(.GET, url)
    }
    
    func setSwitchedOn() {
        isSwitched = true
        self.setBackgroundImage(UIImage(named: "light-bulb-3-on.png"), forState: UIControlState.Normal)
    }
    
    func setSwitchedOff() {
        isSwitched = false
        self.setBackgroundImage(UIImage(named: "light-bulb-3.png"), forState: UIControlState.Normal)
    }

}
