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
    }
    
    func printButtons() {
        for button in self.buttons.values {
            print(button.switchId)
            button.setState(self.switchState)
            button.buttonAction?.action(button)
        }
    }

}
