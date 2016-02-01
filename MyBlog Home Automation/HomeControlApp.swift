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
    var lampSwitches = [String: CustomButton]()
    
    func saveSwitches() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let newButtonsData = NSKeyedArchiver.archivedDataWithRootObject(self.lampSwitches)
        defaults.setObject(newButtonsData, forKey: "newButtons")
    }
    
    func loadSwitches(view: UIView) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let newButtonData = defaults.objectForKey("newButtons") as? NSData
        
        if let newButtonData = newButtonData {
            let loadedNewButtons = (NSKeyedUnarchiver.unarchiveObjectWithData(newButtonData) as? [String: CustomButton])!
            self.lampSwitches = loadedNewButtons
        }
        
        for button in self.lampSwitches.values {
            if let b = button as? [CustomBundleButton] {
                let action = SoftwareSwitchAction()
                button.addAction(action)
                print("custombundle")
            }
            else {
                let action = LampSwitchAction()
                button.addAction(action)
            }
            
            //button.dropTarget.append(self.softwareButton)
            view.addSubview(button)

            
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
        }
        
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
                        print(response)


                        let customButton = CustomButton(frame: CGRect(x: 10, y: 20+self.counter*100,
                            width: 80, height: 100))
                        if post["state"].boolValue {
                            customButton.setSwitchOn()
                        } else {
                            customButton.setSwitchOff()
                        }
                        customButton.switchId = post["id"].stringValue
                        customButton.ipAddress = post["ip"].stringValue
                        customButton.setTitle("Light Switch "+post["id"].stringValue)
                        let action = LampSwitchAction()
                        customButton.addAction(action)
                        self.lampSwitches[customButton.switchId] = customButton


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
        
        self.lampSwitches.removeAll()
    }

    func addSwitch(view: UIView) {

        let softwareButton = CustomBundleButton(frame: CGRect(x: 70, y: 70,
            width: 80, height: 100))
        softwareButton.switchId = "000000"
        softwareButton.setTitle("Light Switch 000000")
        let action = SoftwareSwitchAction()
        softwareButton.addAction(action)
        
        for b in self.lampSwitches.values {
            b.dropTarget.append(softwareButton)
        }
        
        self.lampSwitches[softwareButton.switchId] = softwareButton
        view.addSubview(softwareButton)
    }

}