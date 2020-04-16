//
//  ViewController.swift
//  Autolayout_With_Code
//
//  Created by master on 2020/04/15.
//  Copyright © 2020 ksb. All rights reserved.
//

import UIKit

typealias doAlertActionhandler = () -> Void

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func showToastButton(_ sender: Any) {
        
        let toast = CustomToastView()
        let editAction : DzAlertAction = DzAlertAction.action(title: "편집") {
            print("편집버튼입니다.")
        }
        toast.addButtonAction(action: editAction)
        toast.makeToast(message: "등록되었습니다. ㄲㄲㄲㄲㄲㄲㄲ", duration: 3.0, parentView: self.view, color: .black)
        
    }
    
}
