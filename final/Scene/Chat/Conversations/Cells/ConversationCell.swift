//
//  ConversationCell.swift
//  final
//
//  Created by Haik Ampardjian on 04.04.2018.
//  Copyright © 2018 Haik Ampardjian. All rights reserved.
//

import UIKit

class ConversationCell: UICollectionViewCell {
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var lastMessageDate: UILabel!
    
    func setup(with lastMessageText: String, at date: String) {
        lastMessage.text = lastMessageText
        lastMessageDate.text = date
    }
}
