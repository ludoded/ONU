//
//  ConversationViewController.swift
//  final
//
//  Created by Haik Ampardjian on 04.04.2018.
//  Copyright © 2018 Haik Ampardjian. All rights reserved.
//

import UIKit

class ConversationsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "ConversationCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ConversationCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConversationCell", for: indexPath) as? ConversationCell
            else { fatalError() }
        
        cell.setup(with: "Hello world", at: "1st of Sept")
        cell.backgroundColor = .green
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let height: CGFloat = 60
        
        return CGSize(width: screenWidth, height: height)
    }
}
