//
//  AppDelegate.swift
//  Lesson08TableView
//
//  Created by Orest on 14.11.17.
//  Copyright © 2017 Orest Patlyka. All rights reserved.
//

import UIKit
import CoreData

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        //fetch data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        do {
            CurrencyData.currencysDatabase = try context.fetch(CurrencyDatabase.fetchRequest())
            
            for currency in CurrencyData.currencysDatabase {
                print(currency.cc ?? "")
                
                let curObj = Currency(r030: Int(currency.r030), txt: currency.txt!, rate: currency.rate, cc: currency.cc!, exchangedate: currency.exchangedate!)
                
                CurrencyData.currencys.append(curObj)
            }
            
            for i in 0..<CurrencyData.currencys.count {
                CurrencyData.currencyDict[CurrencyData.currencys[i].cc] = CurrencyData.currencys[i].rate
            }
            CurrencyData.currencyDict["UAH"] = 1.0
            
        } catch {
            print(error.localizedDescription as Any)
        }
        
        CurrencyData.loadCurrencyData(completionHandler: {})
        
        // Disable shake to edit
        UIApplication.shared.applicationSupportsShakeToEdit = false
        
        // Make status bar not transparent
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.backgroundColor = .white
        
        
        //UIApplication.shared.statusBarStyle = .lightContent
        
        // Firs launch after download
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "firstTimeLaunch") == nil {
            let currencyNamesArray = ["UAH", "USD", "EUR", "RUB"]
            defaults.set(currencyNamesArray, forKey: "currencyNamesArray")
            
            defaults.set(true, forKey: "firstTimeLaunch")
        } else {
            return true
        }
        
        let alertController = UIAlertController(title: "f", message: "f", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "", style: .cancel, handler: nil)
        
        alertController.addAction(alertAction)
        
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
        return true
    }
   
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
//        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CurrencyDatabase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
