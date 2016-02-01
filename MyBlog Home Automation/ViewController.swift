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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.myApp.loadSwitches(self.view)
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
    
    @IBAction func addSoftwareButton(sender: UIButton) {
        appDelegate.myApp.addSwitch(self.view)
    }
}

