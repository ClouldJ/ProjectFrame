//
//  AppDelegate.swift
//  ProjectFrame
//
//  Created by Pors0he on 2021/11/29.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        let datas: [[String : String]] = self.readBundleFile("TabMenu.plist") ?? []
        print("\(datas)")
        
        let publicVC = PublicViewController.init()
        publicVC.controllerConfigs = datas
        
        let nav = UINavigationController.init(rootViewController: publicVC)
        nav.isNavigationBarHidden = true
        
        self.window?.rootViewController = nav
        
        self.window?.makeKeyAndVisible()
        return true
    }

}

extension NSObject {
    func readBundleFile(_ fileName: String) -> [[String : String]]? {
        let arr = fileName.components(separatedBy: ".")
        if arr.count < 2 {
            return nil
        }
        
        if  let plistPath = Bundle.main.path(forResource: arr.first, ofType: arr.last) {
            return NSArray(contentsOfFile: plistPath) as? [[String : String]]
        }
        return nil
    }
}

