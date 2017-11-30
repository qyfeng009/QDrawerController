//
//  LeftViewController.swift
//  QDrawerController
//
//  Created by 009 on 2017/11/22.
//  Copyright © 2017年 aibianli. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 49, right: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension LeftViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor(red: 49/256, green: 184/256, blue: 246/256, alpha: 1)
        cell.selectionStyle = UITableViewCellSelectionStyle.blue
        if indexPath.row == 0 {
            cell.textLabel?.text = "第 \(indexPath.row) 行, 切换 centerVC 样式1"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "第 \(indexPath.row) 行, 切换 centerVC 样式2"
        } else {
            cell.textLabel?.text = "第 \(indexPath.row) 行, 跳转到指定 VC"
        }

        cell.textLabel?.textColor = .white
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 {
            // 切换 centerVC
            self.q_drawerController.setCenterVC(newCenterVC: UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!)
        } else if indexPath.row == 1 {
            // 切换 centerVC
            self.q_drawerController.setCenterVC(newCenterVC: BViewController())
        } else {
            // 跳转到指定 VC
            self.q_drawerController.didSelectedVC(didSelectedVC: CViewController())
        }
    }

   
}

