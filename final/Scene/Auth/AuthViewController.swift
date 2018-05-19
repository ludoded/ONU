//
//  AuthViewController.swift
//  final
//
//  Created by Haik Ampardjian on 30.03.2018.
//  Copyright © 2018 Haik Ampardjian. All rights reserved.
//

import UIKit
import FirebaseAuth

final class AuthViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func signUp(_ sender: Any) {
        // Business logic
        performSegue(withIdentifier: "showSignUp", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSignUp" {
            let viewController = segue.destination as? SignUpViewController
            viewController?.usernameText = username.text
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        guard let usernameText = username.text,
            let passwordText = password.text,
            passwordText.count >= 6
            else { return }

        Auth.auth().signIn(withEmail: usernameText,
                           password: passwordText) { [weak self] (user, error) in
                            if let error = error {
                                debugPrint(error.localizedDescription)
                                return
                            }
                            
                            self?.switchMain()
        }
    }
    
    private func switchMain() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        guard let main = UIStoryboard(name: "Camera", bundle: Bundle.main).instantiateInitialViewController()
            else { return }

        appDelegate.window?.rootViewController = main
    }
    
    
}
