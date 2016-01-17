//
//  ViewController.swift
//  MyBlog Home Automation
//
//  Created by Hristo Borisov on 1/2/16.
//  Copyright © 2016 Hristo Borisov. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    var appDelegate: AppDelegate!
    /*var counter: Int = 0
    var newButtons = [String: CustomButton]()
    
    
    var softwareButton = CustomBundleButton(frame: CGRect(x: 70, y: 70,
        width: 80, height: 100))
*/
   // var homeControlApp = HomeControlApp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.myApp.loadSwitches()
        for button in appDelegate.myApp.newButtons.values {
            self.view.addSubview(button)
        }

        /*
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.myViewController = self
        
        let action = SoftwareSwitchAction()
        self.softwareButton = CustomBundleButton(frame: CGRect(x: 70, y: 70,
            width: 80, height: 100))
        self.softwareButton.switchId = "000000"
        self.softwareButton.setTitle("Light Switch 000000")
        self.softwareButton.addAction(action)
        self.view.addSubview(self.softwareButton)
        
        loadSwitches()
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clicked(sender: UIButton) {
        appDelegate.myApp.discoverSwitches(self.view)
    }
    
    @IBAction func SaveButtons(sender: UIButton) {
       appDelegate.myApp.saveSwitches()
       print("saved")
    }
    
    @IBAction func RemoveSwitches(sender: UIButton) {
        self.view.subviews.forEach({
            if $0 is CustomButton {
            $0.removeFromSuperview()
            }
        })
        
        appDelegate.myApp.removeSwitches()
    }
   
}

