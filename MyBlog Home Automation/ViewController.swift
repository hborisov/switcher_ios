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
    var counter: Int = 0
    var newButtons = [CustomButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.myViewController = self
        
        loadSwitches()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func clicked(sender: UIButton) {
        discoverSwitches()
    }
    
    @IBAction func SaveButtons(sender: UIButton) {
        saveSwitches()
        
        print("saved")
    }
    
    func saveSwitches() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let newButtonsData = NSKeyedArchiver.archivedDataWithRootObject(self.newButtons)
        defaults.setObject(newButtonsData, forKey: "newButtons")
    }
    
    func loadSwitches() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let newButtonData = defaults.objectForKey("newButtons") as? NSData

        if let newButtonData = newButtonData {
            let loadedNewButtons = (NSKeyedUnarchiver.unarchiveObjectWithData(newButtonData) as? [CustomButton])!
            self.newButtons = loadedNewButtons
        }
        
        for button in self.newButtons {
            let action = LampSwitchAction()
            button.addAction(action)
            
            Alamofire.request(.GET, "http://"+button.switchId+".local/state").responseJSON {response in
                
                switch response.result {
                case .Success:
                    
                    if let value: AnyObject = response.result.value {
                        let payload = JSON(value)
                        
                        button.setState(payload["state"].boolValue)
                    }
                    
                case .Failure:
                    print("")
                }
            }
            
            self.view.addSubview(button)
        }
    
    }
    
    func refreshSwitchState(switchId: String) {
        
    }
    
    func discoverSwitches() {
        
        for index in 1...254 {
            var url:String = "http://192.168.1."
            url += String(index)
            url += "/state"

            Alamofire.request(.GET, url).responseJSON {response in
                
                switch response.result {
                case .Success:
                    
                    if let value: AnyObject = response.result.value {
                        let post = JSON(value)
                        
                        self.counter += 1

                        
                        let action = LampSwitchAction()
                        let customButton = CustomButton(frame: CGRect(x: 10, y: 20+self.counter*100,
                            width: 80, height: 100))
                        if post["state"].boolValue {
                            customButton.setSwitchOn()
                        } else {
                            customButton.setSwitchOff()
                        }
                        customButton.switchId = post["id"].stringValue
                        customButton.setTitle("Light Switch "+post["id"].stringValue)
                        customButton.addAction(action)
                        self.newButtons.append(customButton)
                        self.view.addSubview(customButton)
                        
                    }
                    
                case .Failure:
                    print("")
                }
                
            }
        }
    }
    
   
}

