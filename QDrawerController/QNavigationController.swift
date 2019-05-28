//
//  BaseNavigationController.swift
//  QDrawerController
//
//  Created by 009 on 2017/11/24.
//  Copyright © 2017年 aibianli. All rights reserved.
//

import UIKit

class QNavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            delegate = self
            interactivePopGestureRecognizer?.delegate = self
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        //iOS 11 以下系统
        guard #available(iOS 11.0, *) else {
            if self.viewControllers.count > 1 {
                viewController.tabBarController?.tabBar.isTranslucent = false
            } else {
                viewController.tabBarController?.tabBar.isTranslucent = true
            }
            return
        }
    }

    // MARK: - 在转场效果的过程中禁用手势识别,当新的视图控制器加载完成后再启用
    // 当 push 二级及以下页面时隐藏 BottomBar
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.isEnabled = false
        }
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    // 视图控制器加载完成后启用手势识别
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.isEnabled = true
        }
    }


    // MARK: - 使 navigationController 中第一个控制器不响应右滑 pop 手势
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count == 1 {
            return false
        }
        return true
    }
    // MARK: - 解决多个手势冲突，同时接受多个手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    // MARK: - 解决在手指滑动时，被 pop 的 ViewController 中的 UIScrollView 会跟着一起滚动
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (gestureRecognizer is UIScreenEdgePanGestureRecognizer)
    }


    /// 获取 topViewController 处理状态栏的变化
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }

    
}



