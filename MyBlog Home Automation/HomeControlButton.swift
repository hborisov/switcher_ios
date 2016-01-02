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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setBackgroundImage(UIImage(named: "light-bulb-3.png"), forState: UIControlState.Normal)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setBackgroundImage(UIImage(named: "light-bulb-3.png"), forState: UIControlState.Normal)
        
        let id = aDecoder.decodeObjectForKey("id") as? String
        self.id = id!
        self.setTitle(id, forState: UIControlState.Normal)
        self.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        
        let isSwitched = aDecoder.decodeBoolForKey("isSwitched")
        self.isSwitched = isSwitched

        print("init")
        print(self.id)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        print("encoding...")
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
    
    func toggle() {
        if isSwitched {
            var url = "http://"
            url += id
            url += ".local/on"
            print(url)
            Alamofire.request(.GET, url)
            
            isSwitched = !isSwitched
            self.setBackgroundImage(UIImage(named: "light-bulb-3-on.png"), forState: UIControlState.Normal)
        } else {
            var url = "http://"
            url += id
            url += ".local/off"
            Alamofire.request(.GET, url)
            
            isSwitched = !isSwitched
            self.setBackgroundImage(UIImage(named: "light-bulb-3.png"), forState: UIControlState.Normal)
        }
        
    }

}
