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
    var buttons = [HomeControlButton]()
    var newButtons = [CustomButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSwitches()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func clicked(sender: UIButton) {
        discoverSwitches()
    }
    
    @IBAction func SaveButtons(sender: UIButton) {
        let defaults = NSUserDefaults.standardUserDefaults()

        
        let buttonData = NSKeyedArchiver.archivedDataWithRootObject(self.buttons)
        defaults.setObject(buttonData, forKey: "buttons")
        
        let newButtonsData = NSKeyedArchiver.archivedDataWithRootObject(self.newButtons)
        defaults.setObject(newButtonsData, forKey: "newButtons")
        
        
        print("saved")
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
            
            self.view.addSubview(button)
        }
        
        for button in self.buttons {
            print("in loading")
            print(button.id)
            
            
            Alamofire.request(.GET, "http://"+button.id+".local/state").responseJSON {response in
                
                switch response.result {
                case .Success:
                    
                    if let value: AnyObject = response.result.value {
                        let payload = JSON(value)
                        if payload["state"].boolValue {
                            button.setSwitchedOn()
                        } else {
                            button.setSwitchedOff()
                        }
                        
                        self.counter += 1
                        button.frame = CGRect(x: Int(self.view.bounds.width - 70), y: 20+self.counter*70,
                            width: 60, height: 60)
                        self.view.addSubview(button)

                    }
                    
                case .Failure:
                    print("")
                }
            }

            
        }
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

