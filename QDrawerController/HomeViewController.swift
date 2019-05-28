//
//  ViewController.swift
//  QDrawerController
//
//  Created by 009 on 2017/11/21.
//  Copyright © 2017年 aibianli. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func openLeftDrawer(_ sender: Any) {
        self.qDrawerController.openLeftDrawer()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }

    @IBAction func search(_ sender: Any) {
        self.qDrawerController.openRightDrawer()
    }
    
}

