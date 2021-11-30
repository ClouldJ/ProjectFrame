//
//  BaseViewController.swift.swift
//  ProjectFrame
//
//  Created by Pors0he on 2021/11/30.
//

import Foundation
import UIKit

class BaseViewController : ParentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backBtn.isHidden = false
        self.contentView.frame = CGRect.init(x: self.contentView.frame.origin.x, y: self.contentView.frame.origin.y, width: self.contentView.frame.width, height: UIScreen.main.bounds.height - self.navigationView.frame.maxY)
    }
}
