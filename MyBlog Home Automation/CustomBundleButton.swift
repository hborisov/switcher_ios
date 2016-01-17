//
//  CustomBundleButton.swift
//  MyBlog Home Automation
//
//  Created by Hristo Borisov on 1/10/16.
//  Copyright © 2016 Hristo Borisov. All rights reserved.
//

import UIKit

class SoftwareSwitchAction: CustomButtonDelegate {
    func action(button: CustomButton) {
        let sbutton = button as! CustomBundleButton
        sbutton.printButtons()
    }
}

class CustomBundleButton: CustomButton {
    var buttons = [String: CustomButton]()
    
    func addButton(button: CustomButton) {
        self.buttons[button.switchId] = button
        
        let imageRect = CGRect(x: 10, y: 0, width: self.frame.size.width-20, height: self.frame.size.height - 40)
        print(imageRect)
        
        UIGraphicsBeginImageContext(self.frame.size)
        UIImage(named: "light-bulb-3-on-red.png")?.drawInRect(imageRect)
        offImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.backgroundColor = UIColor(patternImage: offImage)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.dropTarget, forKey: "dropTarget")
    }
    
    func printButtons() {
        for button in self.buttons.values {
            print(button.switchId)
            button.setState(self.switchState)
            button.buttonAction?.action(button)
        }
    }

}
