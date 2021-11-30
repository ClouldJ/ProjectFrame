//
//  ParentViewController.swift
//  ProjectFrame
//
//  Created by Pors0he on 2021/11/29.
//

import Foundation
import UIKit

class ParentViewController : UIViewController {
    var isSelected: Bool = false
    var dataObject : AnyObject? = nil
    var paramObject : AnyObject? = nil
    
    ///顶部导航栏区域
    lazy var navigationView : UIView = {
        let topView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44 + self.safeArea.top))
        topView.backgroundColor = .white
        return topView
    }()
    
    ///实际内容视图
    lazy var contentView : UIView = {
        let centerView = UIView.init(frame: CGRect.init(x: 0, y: self.navigationView.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - self.navigationView.frame.maxY - 49 - self.safeArea.bottom))
        centerView.backgroundColor = .white
        return centerView
    }()
    
    ///title
    var _title : String = ""
    override var title: String? {
        set {
            _title = newValue ?? ""
            
            self.titleLabel.text = _title
        }
        
        get {
            return _title
        }
    }
    
    ///返回按钮
    lazy var backBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setBackgroundImage(UIImage.init(named: ""), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: ""), for: .selected)
        btn.tag = 0
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(actionForBtn(_:)), for: .touchUpInside)
        btn.frame = CGRect.init(x: 10, y: self.safeArea.top + (self.navigationView.bounds.height - self.safeArea.top - 30)/2.0, width: 30, height: 30)
        btn.isHidden = true
        return btn
    }()
    ///返回按钮提示
    private lazy var backTitleLabel : UILabel = {
        let lbl = UILabel.init()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textAlignment = .left
        lbl.text = "dasdasdas"
        lbl.frame = CGRect.init(x: self.backBtn.frame.maxX + 5, y: self.safeArea.top, width: UIScreen.main.bounds.width - self.backBtn.frame.maxX/2.0 - 50, height: self.navigationView.bounds.height - self.safeArea.top)
        lbl.isHidden = true
        return lbl
    }()
    
    private lazy var titleLabel : UILabel = {
        let lbl = UILabel.init()
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.textColor = .black
        lbl.frame = CGRect.init(x: (UIScreen.main.bounds.width - 120)/2.0, y: self.safeArea.top, width: 120, height: self.navigationView.bounds.height - self.safeArea.top)
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.navigationView)
        self.navigationView.addSubview(self.titleLabel)
        self.navigationView.addSubview(self.backBtn)
        self.navigationView.addSubview(self.backTitleLabel)
        
        self.view.addSubview(self.contentView)
    }
    
    @objc func actionForBtn(_ btn: UIButton) {
        if btn.tag == 0 {
            ///返回
            self.navigationController?.popViewController(animated: true)
        }else {
            
        }
    }
    
    func pushController(_ controllerName: String, data: AnyObject? = nil, param: AnyObject? = nil) {
        guard let controller = self.allocObj(controllerName) as? ParentViewController else {return}
        controller.dataObject = data
        controller.paramObject = param
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
