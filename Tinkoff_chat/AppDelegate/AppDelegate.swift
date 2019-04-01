//
//  AppDelegate.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 11/02/2019.
//  Copyright © 2019 X. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /// Logger object for logging applicationState
    let logger = StateLogger.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        /// Достаем данные из UserDefaults
        if let savedData = UserDefaults.standard.value(forKey: "SavedTheme") as? Data, let theme = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? UIColor {
            UINavigationBar.appearance().barTintColor = theme
        } else {
            UINavigationBar.appearance().barTintColor = UIColor.white
        }

        /// Use of applicationState extensions helps us to immediately get current state string
        logger.appStateTransitionInfo(#function, from: "Not running", to: "\(UIApplication.shared.applicationState)")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        logger.appStateTransitionInfo(#function, from: "\(UIApplication.shared.applicationState)", to: "inactive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        logger.appStateTransitionInfo(#function, from: "inactive", to: "\(UIApplication.shared.applicationState)")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        logger.appStateTransitionInfo(#function, from: "\(UIApplication.shared.applicationState)", to: "inactive")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        logger.appStateTransitionInfo(#function, from: "inactive", to: "\(UIApplication.shared.applicationState)")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        logger.appStateTransitionInfo(#function, from: "\(UIApplication.shared.applicationState)", to: "not running")
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Tinkoff_chat")
        container.loadPersistentStores(completionHandler: { (_, error) in
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
