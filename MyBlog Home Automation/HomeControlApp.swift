//
//  HomeControlApp.swift
//  MyBlog Home Automation
//
//  Created by Hristo Borisov on 1/17/16.
//  Copyright © 2016 Hristo Borisov. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class HomeControlApp {
    var counter: Int = 0
    var newButtons = [String: CustomButton]()
    
    func saveSwitches() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let newButtonsData = NSKeyedArchiver.archivedDataWithRootObject(self.newButtons)
        defaults.setObject(newButtonsData, forKey: "newButtons")
    }
    
    func loadSwitches() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let newButtonData = defaults.objectForKey("newButtons") as? NSData
        
        if let newButtonData = newButtonData {
            let loadedNewButtons = (NSKeyedUnarchiver.unarchiveObjectWithData(newButtonData) as? [String: CustomButton])!
            self.newButtons = loadedNewButtons
        }
        
        for button in self.newButtons.values {
            let action = LampSwitchAction()
            button.addAction(action)
            //button.dropTarget.append(self.softwareButton)
            
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
            
           // self.view.addSubview(button)
        }
        
        
    }
    
    func refreshSwitchState(switchId: String) {
        
    }
    
    func discoverSwitches(view: UIView) {
        
        for index in 1...254 {
            var url:String = "http://192.168.1."
            url += String(index)
            url += "/state"
            print(url)
            
            let request = Alamofire.request(.GET, url)
                request.validate()
                request.responseJSON {response in
                
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
                        self.newButtons[customButton.switchId] = customButton


                        var customButtonsCount = 0
                        view.subviews.forEach({
                            if $0 is CustomButton {
                                customButtonsCount++
                            }
                        })
                            
                        if customButtonsCount == 0 {
                            view.addSubview(customButton)
                        }

                        var hasButton = false
                        view.subviews.forEach({
                            if $0 is CustomButton {
                                if let button = $0 as? CustomButton {
                                    if button.switchId == customButton.switchId {
                                        hasButton = true
                                    }
                                }

                            }
                        })
                        if hasButton == false {
                            view.addSubview(customButton)
                        }
                    }
                    
                case .Failure:
                    print("")
                }
                
            }
        }
    }
    
    func removeSwitches() {
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        
        self.newButtons.removeAll()
    }

    func addSwitch(view: UIView) {
        let action = SoftwareSwitchAction()
        let softwareButton = CustomBundleButton(frame: CGRect(x: 70, y: 70,
            width: 80, height: 100))
        softwareButton.switchId = "000000"
        softwareButton.setTitle("Light Switch 000000")
        softwareButton.addAction(action)
        
        for b in self.newButtons.values {
            b.dropTarget.append(softwareButton)
        }
        
        self.newButtons[softwareButton.switchId] = softwareButton
        view.addSubview(softwareButton)
    }

}