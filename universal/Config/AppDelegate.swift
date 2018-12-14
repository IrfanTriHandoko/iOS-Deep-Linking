//
//  AppDelegate.swift
//  universal
//
//  Created by IRFAN TRIHANDOKO on 07/12/18.
//  Copyright © 2018 IRFAN TRIHANDOKO. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var urlUni: URL?
    var notifData: NotifModel?
    var parameters: [String: String] = [:]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Mark: - Handle universal link when restart apps
        if let activityDictionary = launchOptions?[UIApplicationLaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] { // Universal link
            var acceptedUrl: Bool?
            for key in activityDictionary.keys {
                if let userActivity = activityDictionary[key] as? NSUserActivity, let url = userActivity.webpageURL {
                    // Proceed url here
                    acceptedUrl = self.proceedUniversalLink(url: url)
                }
            }
            if let url = urlUni, acceptedUrl == true{
                self.handleUrl(url: url)
            }
        }
        return true
    }
    
    func proceedUniversalLink(url: URL) -> Bool{
        urlUni = url
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
        if application.userActivity?.activityType == NSUserActivityTypeBrowsingWeb {
            let url = application.userActivity?.webpageURL!
            self.handleUrl(url: url!)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.scheme == "deep-link") { // Handle URL Scheme
            self.handleUrl(url: url)
        } 
        return false
    }
    
    // Mark: - Handle Universal Links from application foreground
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if let url = userActivity.webpageURL, userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            self.handleUrl(url: url)
            return true
        } else {
            return false
        }
    }
    
}

// Mark: - Handle URL Scheme and Universal Links
extension AppDelegate {
    
    func handleUrl(url: URL){
        // Handle url and open whatever page you want to open.
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach{
            parameters[$0.name] = $0.value
        }
        let type = url.path.replacingOccurrences(of: "/", with: "")
        // Convert data to be model
        self.notifData = NotifModel(id: parameters["id"], type: type, title: "", body: "", image: "")
        self.handleDeepLink(data: self.notifData ?? NotifModel(id: "", type: "", title: "", body: "", image: ""))
    }
    
    func handleDeepLink(data: NotifModel){
        let story = UIStoryboard(name: "Notif", bundle: nil)
        let nav = story.instantiateInitialViewController() as? UINavigationController
        let vc = nav?.topViewController as! NotifVC
        vc.data = data
        vc.originRoot = self.window?.rootViewController
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
}

