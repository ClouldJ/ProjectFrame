//
//  FirstViewController.swift
//  ProjectFrame
//
//  Created by Pors0he on 2021/11/30.
//

import Foundation
import UIKit

class FirstViewController : ParentViewController {
    lazy var btn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setBackgroundImage(UIImage.init(named: ""), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: ""), for: .selected)
        btn.setTitle("push", for: .normal)
        btn.tag = 0
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        btn.frame = CGRect.init(x: 10, y: 10, width: 80, height: 80)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.backgroundColor = .cyan
        
        self.title = "首页"
        self.contentView.addSubview(self.btn)
        
    }
    
    @objc func action(_ btn: UIButton) {
//        self.navigationController?.pushViewController(TestViewController(), animated: true)
        self.pushController("TestViewController", data: nil, param: nil)
    }
}
