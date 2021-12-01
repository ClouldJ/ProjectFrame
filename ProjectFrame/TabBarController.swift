//
//  TabbarController.swift
//  ProjectFrame
//
//  Created by Pors0he on 2021/11/29.
//

import Foundation
import UIKit

class TabBarModel : NSObject {
    var barTitle : NSMutableAttributedString? = nil
    var barWidth : CGFloat = 0.0
    var tagID : String = ""
    var normalImage : String = ""
    var selectImage : String = ""
}

protocol TabBarDelegate {
    func didSelected(_ tabBar: TabBarController, idx: Int)
}

class TabBarController : UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    var tabBars : [TabBarView] = []
    var selectBar : TabBarView? = nil
    var selectIndex : Int = 0
    
    private var bars : [TabBarModel]? = []
    
    var _tabs : [[String : String]]? = []
    var tabs : [[String : String]]? {
        set {
            _tabs = newValue
            
            let count = newValue?.count
            
            guard let j = count else { return }
            
            if let params = self.tabs {
                for i in 0 ..< j {
                    let param : [String : String] = params[i]
                    let tagID = param["MenuID"]
                    let normalImage = param["normalImage"]
                    let selectImage = param["selectImage"]
                    let tabName = param["MenuName"]
                    
                    let attName: NSMutableAttributedString = NSMutableAttributedString.init(string: tabName!)
                    attName.addAttributes([.font : UIFont.systemFont(ofSize: 14),.foregroundColor : UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)], range: NSRange.init(location: 0, length: attName.length))
                    let renderRect: CGRect = attName.boundingRect(with: CGSize.init(width: 9999, height: 25), options: .usesFontLeading, context: nil)
                    print("render rect : \(renderRect.width)")
                    
                    let model: TabBarModel = TabBarModel()
                    model.barTitle = attName
                    model.barWidth = renderRect.width + 22
                    model.tagID = tagID ?? ""
                    model.normalImage = normalImage ?? ""
                    model.selectImage = selectImage ?? ""
                    self.bars?.append(model)
                }
                self.collection.reloadData()
                
//                let cell = self.collection.cellForItem(at: IndexPath.init(item: self.selectIndex, section: 0)) as! TabBarItemCell
//                cell.updateSelected(true)
            }
        }
        
        get {
            return _tabs
        }
    }
    var delegate : TabBarDelegate?
    
    lazy var tabBarBackground : UIView = {
        let vv = UIView.init()
        vv.frame = CGRect.init(x: 11, y: 0, width: self.bounds.width - 11 * 2, height: self.bounds.height - self.safeArea.bottom)
        vv.layer.shadowColor = UIColor(red: 0.08, green: 0.03, blue: 0.21, alpha: 0.08).cgColor
        vv.layer.shadowOffset = CGSize(width: 0, height: 0)
        vv.layer.shadowOpacity = 0.08
        vv.layer.shadowRadius = 9
        // layerFillCode
        let layer = CALayer()
        layer.frame = vv.bounds
        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        vv.layer.addSublayer(layer)
        // gradientCode
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.18, green: 0.39, blue: 0.87, alpha: 0.19).cgColor, UIColor(red: 0.34, green: 0.81, blue: 0.75, alpha: 0.19).cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = vv.bounds
        vv.layer.addSublayer(gradient1)
        vv.layer.cornerRadius = vv.bounds.height/2.0;
        vv.clipsToBounds = true
        return vv
    }()
    
    lazy var collection : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 11
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 11, bottom: 0, right: 11)
        
        let col = UICollectionView.init(frame: self.tabBarBackground.bounds, collectionViewLayout: flowLayout)
        col.delegate = self
        col.dataSource = self
        col.register(TabBarItemCell.self, forCellWithReuseIdentifier: "TabBarItemCell")
        col.backgroundColor = .clear
        col.showsVerticalScrollIndicator = false
        col.showsHorizontalScrollIndicator = false
        return col
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.tabBarBackground)
        self.tabBarBackground.backgroundColor = .red
        self.tabBarBackground.addSubview(self.collection)
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


extension TabBarController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bars?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TabBarItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabBarItemCell", for: indexPath) as! TabBarItemCell
        if let models = self.bars {
            let model: TabBarModel = models[indexPath.item]
            cell.updateTitle(model.barTitle!)
            cell.tag = Int(model.tagID) ?? 0
        }
        
        if indexPath.row == 0 {
            cell.updateSelected(true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let models = self.bars {
            let model: TabBarModel = models[indexPath.item]
            return CGSize.init(width: model.barWidth, height: collectionView.bounds.height)
        }else {
            return CGSize.init(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let lastCell = collectionView.cellForItem(at: IndexPath.init(item: self.selectIndex, section: 0)) as! TabBarItemCell
        lastCell.updateSelected(false)
        
        let cell = collectionView.cellForItem(at: indexPath) as! TabBarItemCell
        cell.updateSelected(true)
        
        self.selectIndex = indexPath.row
        
        self.delegate?.didSelected(self, idx: cell.tag)
    }
    
}

class TabBarItemCell : UICollectionViewCell {
    
    lazy var title : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        lbl.text = "测试"
        lbl.textAlignment = .center
        let attrString = NSMutableAttributedString(string: "通讯录备份")
        return lbl
    }()
    
    lazy var selectedView : UIView = {
        let vv = UIView()
        vv.frame = CGRect.init(x: 0, y: (self.bounds.height - 25)/2, width: self.bounds.width, height: 25)
        vv.layer.shadowColor = UIColor(red: 0.99, green: 0.55, blue: 0.26, alpha: 0.29).cgColor
        vv.layer.shadowOffset = CGSize(width: 0, height: 5)
        vv.layer.shadowRadius = 8
        // layerFillCode
        let layer = CALayer()
        layer.frame = vv.bounds
        layer.backgroundColor = UIColor(red: 0.99, green: 0.93, blue: 0.88, alpha: 1).cgColor
        vv.layer.addSublayer(layer)
        // gradientCode
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.96, green: 0.58, blue: 0.21, alpha: 1).cgColor, UIColor(red: 0.99, green: 0.72, blue: 0.55, alpha: 1).cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = vv.bounds
        vv.layer.addSublayer(gradient1)
        vv.layer.cornerRadius = 12.5;
        vv.clipsToBounds = true
        vv.isHidden = true
        return vv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(self.selectedView)
        
        self.contentView.addSubview(self.title)
        self.title.frame = CGRect.init(x: 0, y: (self.bounds.height - 25) / 2.0, width: self.bounds.width, height: 25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTitle(_ title: NSMutableAttributedString){
        self.title.attributedText = title
    }
    
    func updateSelected(_ slc: Bool) {
        self.selectedView.isHidden = !slc
        
        var color: UIColor
        if slc {
            color = .white
        }else {
            color = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        }
        
        guard let att: NSMutableAttributedString = self.title.attributedText?.mutableCopy() as? NSMutableAttributedString else { return }
        att.addAttributes([.foregroundColor : color], range: NSRange.init(location: 0, length: att.length))
        self.title.attributedText = att
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
