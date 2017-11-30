# QDrawerController

上效果
<p align="center">
<img src="https://github.com/qyfeng009/QDrawerController/blob/master/QDrawerController.gif" width="266" height="500"/>
</p>

###### 使用
QDrawerController.swift 拖进项目即可使用
```
初始化
init(centerVC: UIViewController, leftDrawerVC: UIViewController, maxLeftDrawerWidth: CGFloat)
init(centerVC: UIViewController, rightDrawerVC: UIViewController, maxRightDrawerWidth: CGFloat)
init(centerVC: UIViewController, leftDrawerVC: UIViewController, maxLeftDrawerWidth: CGFloat, rightDrawerVC: UIViewController, maxRightDrawerWidth: CGFloat)
```
```
重新设置 centerVC
open func setCenterVC(newCenterVC: UIViewController)
eg. self.q_drawerController.setCenterVC(newCenterVC: UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!)

push 到目标ViewController
open func didSelectedVC(didSelectedVC: UIViewController)
eg. self.q_drawerController.setCenterVC(newCenterVC: BViewController())
```
```
打开左侧菜单
open func openLeftDrawer()
eg. self.q_drawerController.openLeftDrawer()

打开右侧菜单
open func openRightDrawer()
eg. self.q_drawerController.openRightDrawer()
```
```
UIViewController 扩展，方便调用 QDrawerController 
extension UIViewController {
    var q_drawerController: QDrawerController {
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
```
