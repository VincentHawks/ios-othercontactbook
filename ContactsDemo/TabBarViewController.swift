//
//  TabBarViewController.swift
//  ContactsDemo
//
//  Created by Yastrebov Vsevolod on 30.03.2021.
//

import Foundation
import UIKit

class TabBarViewController : UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        let settingsURL = Bundle.main.url(forResource: "Settings", withExtension: "bundle")!.appendingPathComponent("Root.plist")
        let settingsPlist = NSDictionary(contentsOf: settingsURL)!
        let preferences = settingsPlist["PreferenceSpecifiers"] as! [NSDictionary]
        
        var defaultsToRegister = [String : Any]()
        
        for preference in preferences {
            guard let key = preference["Key"] as? String else {
                print("Key not found")
                continue
            }
            defaultsToRegister[key] = preference["DefaultValue"]
        }
        let defaults = UserDefaults.standard
        defaults.register(defaults: defaultsToRegister)
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let index = UserDefaults.standard.integer(forKey: "defaultScreen")
        self.selectedIndex = index
        print(index)
    }
    
}
