//
//  AppDelegate.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?
    let client = Client()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        loadAPI()
        checkIfFirstLaunch()
        let sharedViewContext = persistentContainer.viewContext
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
        sharedViewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        sharedViewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        
        Client.sharedViewContext = sharedViewContext
        
        let tabVC = window?.rootViewController as! UITabBarController
        let firstNavVC = tabVC.viewControllers?.first as! UINavigationController
        let tableVC = firstNavVC.viewControllers.first as! TableViewController
        
        let secondNavVC = tabVC.viewControllers?[1] as! UINavigationController
        let portifolioVC = secondNavVC.viewControllers.first as! PortifolioTableViewController
        
        tableVC.sharedViewContext = sharedViewContext
        portifolioVC.backgroundViewContext = backgroundContext
        portifolioVC.sharedViewContext = sharedViewContext
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    //Check first launch / Set Options to User Defaults
    func checkIfFirstLaunch() {
        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            print("has launched before")
        } else {
            print("first launch")
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.set("en_US", forKey: "optionSelected")
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK: - APICall for Comparing Prices
    
    func loadAPI(){
        client.taskForGetMethodCompare { (data, response, error) in
            guard (error == nil) else {
                return
            }
            if let statusCode = response, statusCode <= 200 || statusCode >= 299  {
                print(error)
            }
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "coconut")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

