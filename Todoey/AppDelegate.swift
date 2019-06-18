//
//  AppDelegate.swift
//  Todoey
//
//  Created by Seong Kon Kim on 6/4/19.
//  Copyright © 2019 Seong Kon Kim. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Path to realm data
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        do{
            let realm = try Realm()
            try realm.write {
            }
        }catch{
            print("Error initializing new realm, \(error)")
        }
        
        
       
        return true
    }


}

