//
//  TabbarController.swift
//  ProjectFrame
//
//  Created by Pors0he on 2021/11/29.
//

import Foundation
import UIKit

protocol TabBarDelegate {
    func didSelected(_ tabBar: TabBarController, idx: Int)
}

class TabBarController : UIView {
    
    var tabBars : [TabBarView] = []
    var selectBar : TabBarView? = nil
    
    var _tabs : [[String : String]]? = []
    var tabs : [[String : String]]? {
        set {
            _tabs = newValue
            
            for subView in self.subviews {
                subView.removeFromSuperview()
            }
            
            let count = newValue?.count
            var makeRect : CGRect
            
            guard let j = count else { return }
            
            let width : CGFloat = UIScreen.main.bounds.width / CGFloat(j)
            if let params = self.tabs {
                for i in 0 ..< j {
                    let param : [String : String] = params[i]
                    let tagID = param["MenuID"]
                    let normalImage = param["normalImage"]
                    let selectImage = param["selectImage"]
                    let tabName = param["MenuName"]
                    
                    makeRect = CGRect.init(x: CGFloat(i) * width, y: 0, width: width, height: self.frame.height)
                    
                    let tabBarView = TabBarView.init(frame: makeRect)
                    tabBarView.tag = (tagID! as NSString).integerValue
                    tabBarView.target = self
                    tabBarView.selectImageName = selectImage!
                    tabBarView.normalImageName = normalImage!
                    tabBarView.itemTitle = tabName!
                    tabBarView.targetSEL = #selector(tabBarSelectAction(_:))
                    self.addSubview(tabBarView)
                    
                    self.tabBars.append(tabBarView)
                }
                
                let frontTabBar = self.tabBars.first
                frontTabBar?.selected = true
                self.selectBar = frontTabBar
            }
        }
        
        get {
            return _tabs
        }
    }
    var delegate : TabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tabBarSelectAction(_ tabBarView: TabBarView) {
        if tabBarView.tag != self.selectBar?.tag {
            self.selectBar?.selected = false
            self.selectBar = tabBarView
            self.selectBar?.selected = true
            
            self.delegate?.didSelected(self, idx: tabBarView.tag)
        }
    }
    
    func setSelectedIndex(_ idx: Int) {
        guard let tabBar = self.viewWithTag(idx) as? TabBarView else { return }
        tabBar.target?.performSelector(onMainThread: tabBar.targetSEL!, with: tabBar, waitUntilDone: true)
    }
}


class TabBarView : UIView {
    
    var itemWidth : CGFloat = 30
    var itemHeight : CGFloat = 30
    
    var target : AnyObject?
    var targetSEL : Selector?
    
    var _selected : Bool = false
    var selected : Bool {
        get {
            return _selected
        }
        set {
            _selected = newValue
            
            if self.selected {
                self.imageView.isHighlighted = true
                self.item.textColor = .red
            }else {
                self.imageView.isHighlighted = false
                self.item.textColor = .black
            }
        }
    }
    lazy var tabBarBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = self.bounds
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(itemAction(_:)), for: .touchUpInside)
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
    var _normalImageName : String = ""
    var normalImageName : String {
        set{
            _normalImageName = newValue
            if self.normalImageName.contains("http://") {
                //网络图片加载
            }else {
                self.imageView.image = UIImage.init(named: self.normalImageName)
            }
        }
        get {
            return _normalImageName
        }
    }
    
    var _selectImageName : String = ""
    var selectImageName : String {
        set{
            _selectImageName = newValue
            if self.selectImageName.contains("http://") {
                //网络图片加载
            }else {
                self.imageView.highlightedImage = UIImage.init(named: self.selectImageName)
            }
        }
        get{
            return _selectImageName
        }
    }
    lazy var imageView : UIImageView = {
        let showImage = UIImageView.init(frame: CGRect.init(x: (self.bounds.width - itemWidth) / 2.0, y: 3, width: itemWidth, height: itemHeight))
        showImage.contentMode = .scaleAspectFit
        showImage.isUserInteractionEnabled = false
        return showImage
    }()
    
    var _itemTitle : String = ""
    var itemTitle : String {
        set {
            _itemTitle = newValue
            
            self.item.text = newValue
        }
        get {
            return _itemTitle
        }
    }
    lazy var item : UILabel = {
        let title = UILabel.init(frame: CGRect.init(x: 0, y: self.imageView.frame.maxY, width: self.bounds.width, height: self.bounds.height - self.imageView.frame.maxY))
        title.font = UIFont.systemFont(ofSize: 11)
        title.textColor = .black
        title.textAlignment = .center
        title.isUserInteractionEnabled = false
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.tabBarBtn)
        self.addSubview(self.imageView)
        self.addSubview(self.item)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func itemAction(_ btn : UIButton) {
        guard let tt = self.target else { return }
        guard let SEL = self.targetSEL else { return }
        
        tt.performSelector(onMainThread: SEL, with: self, waitUntilDone: true)
    }
    
    deinit {
        self.target = nil
        self.targetSEL = nil
    }
}
