//
//  LocalNotificationHelper.swift
//  Transport4Church
//
//  Created by mac on 10/4/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit

class NotificationHelper: NSObject {
    
    func checkNotificationEnabled() -> Bool {
        // Check if the user has enabled notifications for this app and return True / False
        guard let settings = UIApplication.shared.currentUserNotificationSettings else { return false}
        if settings.types == UIUserNotificationType() {
            return false
        } else {
            return true
        }
    }
    
    func checkNotificationExists(_ taskTypeId: String) -> Bool {
        // Loop through the pending notifications
        for notification in UIApplication.shared.scheduledLocalNotifications! as [UILocalNotification] {
            
            // Find the notification that corresponds to this task entry instance (matched by taskTypeId)
            if (notification.userInfo!["taskObjectId"] as! String == String(taskTypeId)) {
                return true
            }
        }
        return false
        
    }
    
    static func setupNotification(){
        let types: UIUserNotificationType = [.badge, .sound]
        let settings = UIUserNotificationSettings(types: types, categories: nil)
        let application = UIApplication.shared
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
    
    static func scheduleLocal(_ message: String, status: String, alertDate: Date) {
        let notification = UILocalNotification()
        notification.fireDate = alertDate
        notification.timeZone = TimeZone.current
        notification.alertBody = "\(message)"
//        notification.alertAction = "Due : \(alertDate)"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["status": status]
        UIApplication.shared.scheduleLocalNotification(notification)
        
        print("Notification set for message: \(message) at \(alertDate)")
    }
    
    func removeNotification(_ taskTypeId: String) {
        
        // loop through the pending notifications
        for notification in UIApplication.shared.scheduledLocalNotifications! as [UILocalNotification] {
            
            // Cancel the notification that corresponds to this task entry instance (matched by taskTypeId)
            if (notification.userInfo!["taskObjectId"] as! String == String(taskTypeId)) {
                UIApplication.shared.cancelLocalNotification(notification)
                
                print("Notification deleted for taskTypeID: \(taskTypeId)")
                
                break
            }
        }
    }
    
    func listNotifications() -> [UILocalNotification] {
        var localNotify:[UILocalNotification]?
        for notification in UIApplication.shared.scheduledLocalNotifications! as [UILocalNotification] {
            localNotify?.append(notification)
        }
        return localNotify!
    }
    
    func printNotifications() {
        
        print("List of notifications currently set:- ")
        
        for notification in UIApplication.shared.scheduledLocalNotifications! as [UILocalNotification] {
            print ("\(notification)")
        }
    }
}
