//
//  HistoryViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 17/10/21.
//

import UIKit

class HistoryViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading HistoryViewController")
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyImage", for: indexPath as IndexPath)
        
        return cell
    }
    

}
