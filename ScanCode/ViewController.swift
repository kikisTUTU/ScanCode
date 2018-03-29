//
//  ViewController.swift
//  ScanCode
//
//  Created by TH-011 on 2018/3/29.
//  Copyright © 2018年 TH-011. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton()
        button.backgroundColor = .red
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        button.setTitle("123", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
    }
    @objc func buttonAction() {
        let scanvc = ScanVC()
        self.present(scanvc, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
































