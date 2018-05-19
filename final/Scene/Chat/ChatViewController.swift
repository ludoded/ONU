//
//  ChatViewController.swift
//  final
//
//  Created by Haik Ampardjian on 31.03.2018.
//  Copyright © 2018 Haik Ampardjian. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

final class ChatViewController: UIViewController {
    private var ref = Database.database().reference()
    private var auth = Auth.auth()
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var textview: UITextView!
    
    @IBAction func send(_ sender: UIButton!) {
        guard let userID = auth.currentUser?.uid,
            let message = textfield.text,
            !message.isEmpty
            else { return }
        
        
        let data = [
            "message": message
        ]
        
        let messageRef = ref.child("user/\(userID)/conversations/71hougFDHwOfLZ7CNGOg73z8GJJ2/messages/").childByAutoId()
        messageRef.setValue(data) { (error, databaseRef) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeChat()
    }
    
    private func observeChat() {
        guard let userID = auth.currentUser?.uid
            else { return }
        
        ref.child("user/\(userID)/conversations/71hougFDHwOfLZ7CNGOg73z8GJJ2/messages/").observe(.childAdded) { (snapshot) in
            DispatchQueue.main.async {
                let value = snapshot.value as! [String : AnyObject]
                let message = value["message"] as! String
                
                let text = self.textview.text
                let appendedMessage = text?.appending("\(message)\n\n")
                self.textview.text = appendedMessage
                self.textfield.text = ""
            }
        }
    }
}
