//
//  QDrawerController.swift
//  QDrawerController
//
//  Created by 009 on 2017/11/22.
//  Copyright © 2017年 aibianli. All rights reserved.
//

import UIKit

class QDrawerController: UIViewController, UIGestureRecognizerDelegate {

    let screenWidth = UIScreen.main.bounds.width

    var centerVC: UIViewController?
    var leftDrawerVC: UIViewController?
    var rightDrawerVC: UIViewController?
    var maxLeftDrawerWidth: CGFloat = 280.0
    var maxRightDrawerWidth: CGFloat = 280.0

    init(centerVC: UIViewController, leftDrawerVC: UIViewController, maxLeftDrawerWidth: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        self.centerVC = centerVC
        self.leftDrawerVC = leftDrawerVC
        self.maxLeftDrawerWidth = maxLeftDrawerWidth
        self.leftDrawerVC?.view.frame = CGRect(x: 0, y: 0, width: maxLeftDrawerWidth, height: UIScreen.main.bounds.size.height)
        view.addSubview(leftDrawerVC.view)
        view.addSubview(centerVC.view)
        addChildViewController(leftDrawerVC)
        addChildViewController(centerVC)
        leftDrawerVC.view.isHidden = true
    }

    init(centerVC: UIViewController, rightDrawerVC: UIViewController, maxRightDrawerWidth: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        self.centerVC = centerVC
        self.rightDrawerVC = rightDrawerVC
        self.maxRightDrawerWidth = maxRightDrawerWidth
        self.rightDrawerVC?.view.frame = CGRect(x: 0, y: 0, width: maxRightDrawerWidth, height: UIScreen.main.bounds.size.height)
        view.addSubview(centerVC.view)
        view.addSubview(rightDrawerVC.view)
        addChildViewController(centerVC)
        addChildViewController(rightDrawerVC)
        rightDrawerVC.view.isHidden = true
    }

    init(centerVC: UIViewController, leftDrawerVC: UIViewController, maxLeftDrawerWidth: CGFloat, rightDrawerVC: UIViewController, maxRightDrawerWidth: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        self.centerVC = centerVC
        self.leftDrawerVC = leftDrawerVC
        self.rightDrawerVC = rightDrawerVC
        self.maxLeftDrawerWidth = maxLeftDrawerWidth
        self.maxRightDrawerWidth = maxRightDrawerWidth
        self.leftDrawerVC?.view.frame = CGRect(x: 0, y: 0, width: maxLeftDrawerWidth, height: UIScreen.main.bounds.size.height)
        self.rightDrawerVC?.view.frame = CGRect(x: 0, y: 0, width: maxRightDrawerWidth, height: UIScreen.main.bounds.size.height)
        view.addSubview(leftDrawerVC.view)
        view.addSubview(centerVC.view)
        view.addSubview(rightDrawerVC.view)
        addChildViewController(leftDrawerVC)
        addChildViewController(centerVC)
        addChildViewController(rightDrawerVC)
        leftDrawerVC.view.isHidden = true
        rightDrawerVC.view.isHidden = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        leftDrawerVC?.view.transform = CGAffineTransform(translationX: -maxLeftDrawerWidth / 2, y: 0)
        rightDrawerVC?.view.transform = CGAffineTransform(translationX: screenWidth, y: 0)

        if centerVC is UITabBarController {
            for childrenVC in (centerVC?.childViewControllers)! {
                addScreenEdgePanGestureREcognizerToView(view: childrenVC.view)
            }
        } else {
            addScreenEdgePanGestureREcognizerToView(view: (centerVC?.view)!)
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - 主页面封皮View(打开左侧页面时，主页面半透明遮罩)，默认隐藏，滑出侧页面时出现，其他隐藏
    private lazy var coverButton: UIButton = {
        let button = UIButton(frame: (self.centerVC?.view.bounds)!)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(closeDrawer), for: UIControlEvents.touchUpInside)
        button.addGestureRecognizer(closePanGesture)
        button.isHidden = true
        return button
    }()
    private lazy var closePanGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panCloseLeftDrawer(_:)))
        panGesture.delegate = self
        return panGesture
    }()

    // MARK: - 添加边缘侧滑手势(左边缘侧滑)
    private func addScreenEdgePanGestureREcognizerToView(view: UIView) {
        if leftDrawerVC != nil {
            let edgeLeftPanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGesture(_:)))
            edgeLeftPanGesture.edges = UIRectEdge.left
            edgeLeftPanGesture.delegate = self
            view.addGestureRecognizer(edgeLeftPanGesture)
        }
        if rightDrawerVC != nil {
            let edgeRightPanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGesture(_:)))
            edgeRightPanGesture.edges = UIRectEdge.right
            edgeRightPanGesture.delegate = self
            view.addGestureRecognizer(edgeRightPanGesture)
        }
    }
    // MARK: - 边缘侧滑方法，拉出侧页面
    @objc private func edgePanGesture(_ edgePanGesture: UIScreenEdgePanGestureRecognizer) {
        let offsetX = edgePanGesture.translation(in: edgePanGesture.view).x
        if edgePanGesture.state == UIGestureRecognizerState.began {
            self.centerVC?.view.addSubview(coverButton)
            self.coverButton.isHidden = false
            if offsetX >= 0 {
                self.leftDrawerVC?.view.isHidden = false
                self.openSide = QDrawerSide.left
            } else {
                self.rightDrawerVC?.view.isHidden = false
                self.openSide = QDrawerSide.right
            }
        }
        if edgePanGesture.state == UIGestureRecognizerState.changed {
            edgePanGestureChanged(offsetX: offsetX, state: edgePanGesture.state)
        } else if edgePanGesture.state == UIGestureRecognizerState.ended
            || edgePanGesture.state == UIGestureRecognizerState.failed
            || edgePanGesture.state == UIGestureRecognizerState.cancelled {
            edgePanGestureOff(offsetX: offsetX, state: edgePanGesture.state)
        }
    }
    private func edgePanGestureChanged(offsetX: CGFloat, state: UIGestureRecognizerState) {
        UIView.animate(withDuration: 0.13, animations: {
            if self.openSide == .left && (offsetX >= 0 && offsetX <= self.maxLeftDrawerWidth) {
                self.centerVC?.view.transform = CGAffineTransform(translationX: max(offsetX, 0), y: 0)
                self.leftDrawerVC?.view.transform = CGAffineTransform(translationX: (-self.maxLeftDrawerWidth / 2 + offsetX/2), y: 0)
                self.coverButton.backgroundColor = UIColor.black.withAlphaComponent(abs((offsetX / self.maxLeftDrawerWidth) * 0.3))
            }
            if self.openSide == .right && (offsetX <= 0 && offsetX >= -self.maxRightDrawerWidth) {
                self.rightDrawerVC?.view.transform = CGAffineTransform(translationX: self.screenWidth + offsetX, y: 0)
                self.coverButton.backgroundColor = UIColor.black.withAlphaComponent((abs(offsetX / self.maxRightDrawerWidth) * 0.3))
            }
        })
    }
    private func edgePanGestureOff(offsetX: CGFloat, state: UIGestureRecognizerState) {
        if openSide == .left {
            if offsetX >= maxLeftDrawerWidth * 0.5 {
                openLeftDrawer()
            } else {
                closeDrawer()
            }
        }
        if openSide == .right {
            if offsetX <= -maxRightDrawerWidth * 0.5 {
                openRightDrawer()
            } else {
                closeDrawer()
            }
        }
        if state == UIGestureRecognizerState.ended {
            self.view.addGestureRecognizer(closePanGesture)
        } else {
            self.view.removeGestureRecognizer(closePanGesture)
        }
    }

    // MARK: - 滑动关闭侧页面
    @objc private func panCloseLeftDrawer(_ panGesture: UIScreenEdgePanGestureRecognizer) {
        let offsetX = panGesture.translation(in: panGesture.view).x
        if panGesture.state == UIGestureRecognizerState.changed {
            UIView.animate(withDuration: 0.13, animations: {
                if self.openSide == .left && (offsetX >= -self.maxLeftDrawerWidth && offsetX <= 0) {
                    let distace = self.maxLeftDrawerWidth + offsetX
                    self.centerVC?.view.transform = CGAffineTransform(translationX: distace, y: 0)
                    self.leftDrawerVC?.view.transform = CGAffineTransform(translationX: offsetX/2, y: 0)
                    self.coverButton.backgroundColor = UIColor.black.withAlphaComponent(abs(0.3 + (offsetX / self.maxLeftDrawerWidth) * 0.3))
                }
                if self.openSide == .right && (offsetX <= self.maxRightDrawerWidth && offsetX >= 0) {
                    self.rightDrawerVC?.view.transform = CGAffineTransform(translationX: (self.screenWidth - self.maxRightDrawerWidth) + offsetX, y: 0)
                    self.coverButton.backgroundColor = UIColor.black.withAlphaComponent(0.3 - abs(offsetX / self.maxLeftDrawerWidth) * 0.3)
                }
            })
        } else if panGesture.state == UIGestureRecognizerState.ended
            || panGesture.state == UIGestureRecognizerState.cancelled
            || panGesture.state == UIGestureRecognizerState.failed {

            if openSide == .left {
                if offsetX > -maxLeftDrawerWidth * 0.5 {
                    openLeftDrawer()
                } else {
                    closeDrawer()
                }
            }
            if openSide == .right {
                if offsetX < maxRightDrawerWidth * 0.5 {
                    openRightDrawer()
                } else {
                    closeDrawer()
                }
            }

            if panGesture.state == UIGestureRecognizerState.ended {
                self.view.removeGestureRecognizer(closePanGesture)
            }
        }
    }

    // MARK: - 重新设置 centerVC
    /// 重新设置 centerVC
    ///
    /// - Parameter newCenterVC: newCenterVC
    open func setCenterVC(newCenterVC: UIViewController) {
        if centerVC == newCenterVC {
            return
        }
        let oldCenterVC = self.centerVC
        if oldCenterVC != nil {
            oldCenterVC?.willMove(toParentViewController: nil)
            oldCenterVC?.view.removeFromSuperview()
            oldCenterVC?.removeFromParentViewController()
        }
        self.centerVC = newCenterVC
        self.addChildViewController(self.centerVC!)
        self.centerVC?.view.transform = CGAffineTransform(translationX: maxLeftDrawerWidth, y: 0)
        self.view.addSubview((self.centerVC?.view)!)
        self.view.bringSubview(toFront: (self.centerVC?.view)!)
        self.centerVC?.view.autoresizingMask = UIViewAutoresizing([.flexibleWidth, .flexibleHeight])

        if centerVC is UITabBarController {
            for childrenVC in (centerVC?.childViewControllers)! {
                addScreenEdgePanGestureREcognizerToView(view: childrenVC.view)
            }
        } else {
            addScreenEdgePanGestureREcognizerToView(view: (centerVC?.view)!)
        }
        self.centerVC?.view.addSubview(coverButton)
        if rightDrawerVC != nil {
            self.view.bringSubview(toFront: (rightDrawerVC?.view)!)
        }

        self.closeDrawer()
    }
    // MARK: - 侧栏跳转
    /// 侧栏点击跳转页面，仅支持 centerVC is UINavigationController or centerVC's childrenController is UINavigationController
    ///
    /// - Parameter didSelectedVC: 目标VC
    open func didSelectedVC(didSelectedVC: UIViewController) {
        didSelectedVC.hidesBottomBarWhenPushed = true
        if centerVC is UITabBarController {
            let tabbarC = centerVC as? UITabBarController
            let navC = tabbarC?.selectedViewController as? UINavigationController
            navC?.pushViewController(didSelectedVC, animated: false)
        } else if centerVC is UINavigationController {
            let navC = centerVC as? UINavigationController
            navC?.pushViewController(didSelectedVC, animated: false)
        }
        closeDrawer()
    }

    // MARK: - 打开侧页面
    /// 打开左侧页面
    open func openLeftDrawer() {
        if leftDrawerVC != nil {
            openSide = .left
            openDrawer()
        }
    }
    /// 打开右侧页面
    open func openRightDrawer() {
        if rightDrawerVC != nil {
            openSide = .right
            openDrawer()
        }
    }
    private func openDrawer() {
        var duration: TimeInterval?

        if  openSide == QDrawerSide.left {
            self.leftDrawerVC?.view.isHidden = false
            duration = 0.28
        }
        if  openSide == QDrawerSide.right {
            self.rightDrawerVC?.view.isHidden = false
            duration = 0.20
        }
        if !(centerVC?.view.subviews.contains(coverButton))! {
            self.centerVC?.view.addSubview(coverButton)
        }
        self.coverButton.isHidden = false
        UIView.animate(withDuration: duration!, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            if self.openSide == QDrawerSide.left {
                self.leftDrawerVC?.view.transform = CGAffineTransform.identity
                self.centerVC?.view.transform = CGAffineTransform(translationX: self.maxLeftDrawerWidth, y: 0)
            }
            if self.openSide == QDrawerSide.right {
                self.rightDrawerVC?.view.transform = CGAffineTransform(translationX: self.screenWidth-self.maxRightDrawerWidth, y: 0)
            }
            self.coverButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }, completion: {(finish: Bool) in
            self.view.addGestureRecognizer(self.closePanGesture)
        })
    }
    // MARK: - 关闭侧页面
    @objc private func closeDrawer() {
        UIView.animate(withDuration: 0.15, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            if self.openSide == QDrawerSide.left {
                self.leftDrawerVC?.view.transform = CGAffineTransform(translationX: -self.maxLeftDrawerWidth/2, y: 0)
                self.centerVC?.view.transform = CGAffineTransform.identity
            }
            if self.openSide == QDrawerSide.right {
                self.rightDrawerVC?.view.transform = CGAffineTransform(translationX: self.screenWidth, y: 0)
            }
            self.coverButton.backgroundColor = UIColor.black.withAlphaComponent(0)
        }, completion: {(finish: Bool) in
            self.leftDrawerVC?.view.isHidden = true
            self.rightDrawerVC?.view.isHidden = true
            self.coverButton.isHidden = true
            self.coverButton.removeFromSuperview()
            self.view.removeGestureRecognizer(self.closePanGesture)
            self.openSide = QDrawerSide.none
        })
    }

    // MARK: - 手势代理, navigationController 的二级页面时，不响应 QDrawerController 的手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if centerVC is UITabBarController {
            for childrenVC in (centerVC?.childViewControllers)! where childrenVC.childViewControllers.count > 1 {
                return false
            }
        } else if centerVC is UINavigationController {
            if (centerVC?.childViewControllers.count)! > 1 {
                return false
            }
        }
        if openSide == .right || openSide == .left {
            if gestureRecognizer is UIScreenEdgePanGestureRecognizer {
                return false
            }
        } else {
            if gestureRecognizer == closePanGesture {
                return false
            }
        }
        return true
    }

    // MARK: - 状态栏变化处理 ******************
    enum QDrawerSide {
        case none
        case left
        case right
    }
    private var openSide: QDrawerSide? = QDrawerSide.none {
        didSet {
            setNeedsStatusBarAppearanceUpdateIfSupported()
        }
    }
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return getTopViewController()
    }
    override var childViewControllerForStatusBarHidden: UIViewController? {
        return getTopViewController()
    }
    private func childViewControllerForSide(drawerSide: QDrawerSide) -> UIViewController {
        switch drawerSide {
        case .left:
            return leftDrawerVC!
        case .right:
            return rightDrawerVC!
        case .none:
            return centerVC!
        }
    }
    private func setNeedsStatusBarAppearanceUpdateIfSupported() {
        if responds(to: #selector(setNeedsStatusBarAppearanceUpdate)) {
            self.perform(#selector(setNeedsStatusBarAppearanceUpdate))
        }
    }
    private func getTopViewController() -> UIViewController {
        if self.childViewControllerForSide(drawerSide: openSide!) == centerVC {
            if centerVC is UITabBarController {
                for vcs in (centerVC?.childViewControllers)! {
                    if vcs is UINavigationController {
                        return (vcs as! UINavigationController).topViewController!
                    } else {
                        return vcs
                    }
                }
            } else if centerVC is UINavigationController {
                return (centerVC as! UINavigationController).topViewController!
            } else {
                return self.childViewControllerForSide(drawerSide: openSide!)
            }
        }
        return self.childViewControllerForSide(drawerSide: openSide!)
    }
}

// MARK: - UIViewController 扩展，方便调用 QDrawerController 
extension UIViewController {
    var qDrawerController: QDrawerController {
        var drawerController: QDrawerController?
        
        var parentVC = self.parent
        while parentVC != nil {
            if parentVC is QDrawerController {
                drawerController = parentVC as? QDrawerController
            }
            parentVC = parentVC?.parent
        }
        return drawerController!
    }
}
