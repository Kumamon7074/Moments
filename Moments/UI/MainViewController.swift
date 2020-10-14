//
//  MainViewController.swift
//  Moments
//
//  Created by Mac Zhou on 2020/10/14.
//

import UIKit
import ChameleonFramework

class MainViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
}

//MARK: - common init
private extension MainViewController {
    
    func commonInit() {
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = UIColor.flatWhite()
    }
}
