//
//  SignUpViewController.swift
//  final
//
//  Created by Haik Ampardjian on 21.04.2018.
//  Copyright © 2018 Haik Ampardjian. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    var usernameText: String?
    @IBOutlet weak var username: UITextField!
    
    @IBAction func back(_ sender: UIButton!) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.text = usernameText
    }
}
