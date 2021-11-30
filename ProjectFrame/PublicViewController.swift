//
//  PublicViewController.swift
//  ProjectFrame
//
//  Created by Pors0he on 2021/11/29.
//

import Foundation
import UIKit

class PublicViewController : UIViewController, TabBarDelegate {
    var ff : UnsafeMutablePointer<Int>?
    var tabBarHeight: CGFloat = 49
    var tabBarView: TabBarController? = nil
    
    var currentVC: ParentViewController? = nil
    
    var _controllerConfigs : [[String : String]] = []
    var controllerConfigs : [[String : String]] {
        set{
            _controllerConfigs = newValue
            
            let count = newValue.count
            if count > 0 {
                if ff != nil {
                    free(ff)
                }
                
                ff = UnsafeMutablePointer<Int>.allocate(capacity: count)
                for i in 0 ..< count {
                    guard let controllerName = self.controllerConfigs[i]["viewController"] else { return }
                    
                    if let controller = self.allocObj(controllerName) {
                        objc_setAssociatedObject(self, &(ff![i]), controller, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    }
                }
            }
            
            let home : ParentViewController = objc_getAssociatedObject(self, &(ff![0])) as! ParentViewController
            self.addChild(home)
            home.didMove(toParent: self)
            self.view.addSubview(home.view)
            self.currentVC = home
            self.currentVC?.isSelected = true
            
            let screenHeight: CGFloat = UIScreen.main.bounds.height
            let screenWidth: CGFloat = UIScreen.main.bounds.width
            
            self.tabBarView = TabBarController.init(frame: CGRect.init(x: 0, y: screenHeight - self.safeArea.bottom - tabBarHeight, width: screenWidth, height: tabBarHeight + self.safeArea.bottom))
            self.tabBarView?.tabs = self.controllerConfigs
            self.tabBarView?.delegate = self
            self.tabBarView?.backgroundColor = .white
            self.view.addSubview(self.tabBarView!)
        }
        
        get{
            return _controllerConfigs
        }
    }
    
    func selectedIndex(_ idx: Int) {
        guard let tabBar: TabBarController = self.tabBarView else { return }
        tabBar.setSelectedIndex(idx)
    }
    
    func didClickIdx(_ idx: Int) {
        for i in 0 ..< self.controllerConfigs.count {
            if let menuID = self.controllerConfigs[i]["MenuID"] {
                if idx == Int(menuID) {
                    let vc = objc_getAssociatedObject(self, &(ff![i])) as! UIViewController
                    self.replace(self.currentVC!, vc as! ParentViewController)
                }
            }
        }
    }
    
    func replace(_ oldController: ParentViewController, _ newController: ParentViewController) {
        self.addChild(newController)
        self.transition(from: oldController, to: newController, duration: 0.3, options: .curveEaseInOut) {
            
        } completion: { finish in
            if finish {
                newController.didMove(toParent: self)
                oldController.willMove(toParent: self)
                oldController.removeFromParent()
                self.currentVC?.isSelected = false
                self.currentVC = newController
                self.currentVC?.isSelected = true
                
                self.view.bringSubviewToFront(self.tabBarView!)
            }else {
                self.currentVC = oldController
            }
        }

    }
    
    deinit {
        free(ff)
    }
}

extension PublicViewController {
    func didSelected(_ tabBar: TabBarController, idx: Int) {
        self.didClickIdx(idx)
    }
}

extension NSObject {
    var nameSpace : String {
        get {
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as! String
        }
    }
    
    var delegateWindow : UIWindow? {
        get {
            guard let app = UIApplication.shared.delegate as? AppDelegate else { return nil }
            return app.window
        }
    }
    
    var safeArea : UIEdgeInsets {
        get {
            if let window = self.delegateWindow {
                return window.safeAreaInsets
            }else {
                return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    func allocObj(_ obj : String) -> AnyObject? {
        ///获取名空间
        let nameSpace = self.nameSpace
        let cls: AnyClass? = NSClassFromString(nameSpace + "." + obj)
        guard let objClass = cls as? UIViewController.Type else { return nil }
        let controller = objClass.init()
        return controller
    }
    
}
