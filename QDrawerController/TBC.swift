//
//  TBC.swift
//  QDrawerController
//
//  Created by 009 on 2018/3/1.
//  Copyright © 2018年 aibianli. All rights reserved.
//

import UIKit

class TBC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     如果不用 storyBoard 设置上设置 viewControllers，
     代码设置 viewControllers 需要重新 下面两个方法，在初始化 TabBarController 时 传入 TabBarController 的 childViewControllers。
     因为在 QDrawerController 中需要给 TabBarController 的 childViewControllers添加手势时，如果不在TabBarController的初始化时传入childViewControllers，则无法给 childViewControllers 添加侧滑手势
     */
    init(_ childViewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = childViewControllers
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


}
