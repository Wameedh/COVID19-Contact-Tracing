//
//  AppDelegate.swift
//  ContactTracing
//
//  Created by Jennifer Finaldi on 11/23/20.
//

import UIKit
import UserNotifications
import PushKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let token = deviceToken.map{String(format: "%02.2hhx", $0)}.joined()
		print("token: \(token)")
		UserDefaults().setValue(token, forKey: "deviceToken")
		UserDefaults().synchronize()
	}

	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("error: \(error)")
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.banner, .sound])
		
		NotificationCenter.default.post(name: AppDelegate.dangerMessage, object: nil)
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		print("reached")
		let title = userInfo["title"] as? String
		let body = userInfo["body"] as? String
		
		print(title as Any)
		print(body as Any)
		completionHandler(UIBackgroundFetchResult.newData)
	}
	
    static let dangerMessage = Notification.Name("dangerMessage")
    
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		
		if let notification = response.notification.request.content.userInfo as? [String:AnyObject] {
			let message = parseRemoteNotification(notification: notification)
			print(message as Any)
		}
        
        //Post a notification to the Home VC to output modal
        NotificationCenter.default.post(name: AppDelegate.dangerMessage, object: nil)
		completionHandler()
	}
	
	private func parseRemoteNotification(notification:[String:AnyObject]) -> String? {
		if let aps = notification["aps"] as? [String:AnyObject] {
			print("reached")
			let alert = aps["alert"] as? String
			return alert
		}
		
		return nil
	}


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
		
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(granted, error) in
			print("granted: \(granted)")
		})
		
		UIApplication.shared.registerForRemoteNotifications()
		UIApplication.shared.applicationIconBadgeNumber = 0
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
		UIApplication.shared.applicationIconBadgeNumber = 0
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

