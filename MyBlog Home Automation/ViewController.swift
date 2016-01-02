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
        
        
        print("saved")
    }
    
    func loadSwitches() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let buttonData = defaults.objectForKey("buttons") as? NSData
        if let buttonData = buttonData  {
            print("loading")
            let loadedbuttons = (NSKeyedUnarchiver.unarchiveObjectWithData(buttonData) as? [HomeControlButton])!
            self.buttons = loadedbuttons
            print(loadedbuttons.count)
            print(self.buttons.count)
            
        }
        
        for button in self.buttons {
            print("in loading")
            print(button.id)
            
            self.counter += 1
            //let aButton = HomeControlButton(id: post["id"].stringValue)
            button.frame = CGRect(x: Int(self.view.bounds.width - 70), y: 20+self.counter*70,
                width: 60, height: 60)
            self.view.addSubview(button)
        }
    }
    
    func discoverSwitches() {
        
        for index in 1...254 {
            var url:String = "http://192.168.1."
            url += String(index)
            url += "/state"
            //print(url)
            Alamofire.request(.GET, url).responseJSON {
                response in
                
                switch response.result {
                case .Success:
                    
                    if let value: AnyObject = response.result.value {
                        let post = JSON(value)
                        //print(post["id"])
                        
                        
                        self.counter += 1
                        let aButton = HomeControlButton(id: post["id"].stringValue)
                        aButton.frame = CGRect(x: Int(self.view.bounds.width - 70), y: 20+self.counter*70,
                            width: 60, height: 60)
                        self.buttons.append(aButton)
                        self.view.addSubview(aButton)
                        
                        let defaults = NSUserDefaults.standardUserDefaults()
                        let buttonData = NSKeyedArchiver.archivedDataWithRootObject(self.buttons)
                        defaults.setObject(buttonData, forKey: "buttons")
                        
                    }
                    
                case .Failure:
                    // print("Not OK" + url)
                    print("")
                    
                }
                
            }
        }
    }


}

