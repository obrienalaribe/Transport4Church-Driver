//
//  AppDelegate.swift
//  Transport4ChurchDriver
//
//  Created by Obrien Alaribe on 02/11/2016.
//
//

import UIKit
import CoreData
import Parse
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let googleMapsApiKey = "AIzaSyCRbgOlz9moQ-Hlp65-piLroeMtfpNouck"

    let parseServer = ParseServer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
       
        GMSServices.provideAPIKey(googleMapsApiKey)
        GMSPlacesClient.provideAPIKey(googleMapsApiKey)
        

        if let loggedInUser = PFUser.current(){
            print(loggedInUser)
            window?.rootViewController = UINavigationController(rootViewController: RoutesViewController())
            
        }else{
            print("user not logged in ")
            
            window?.rootViewController = UINavigationController(rootViewController:AuthViewController())
        }
        
        
        
//        window?.rootViewController = UINavigationController(rootViewController:DriverRequestListController(collectionViewLayout: UICollectionViewFlowLayout()))

        return true
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installation = PFInstallation.current()
        
        if let deviceInstallation = installation {
            deviceInstallation.setDeviceTokenFrom(deviceToken)
            //register user on a channel with their ID
            if let user = PFUser.current() {
                deviceInstallation.channels = [user.objectId!]
            }
            
            deviceInstallation.saveInBackground(block: { (success, error) in
                if error != nil {
                    print(error)
                }else{
                    print("installation done: push notification registered with token \(deviceToken)")
                }
            })
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if error._code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        if application.applicationState == .background {
            //            PFPush.handle(userInfo)
        }
        
        print("RECEIVED REMOTE NOTIFICATION \(userInfo)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
       
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        _ = ChurchRepo().fetchNearbyChurchesIfNeeded()

    }

    func applicationWillTerminate(_ application: UIApplication) {
        
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
        let container = NSPersistentContainer(name: "Transport4ChurchDriver")
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

