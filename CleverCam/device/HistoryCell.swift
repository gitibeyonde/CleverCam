//
//  HistoryCell.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 18/10/21.
//

import UIKit

protocol HistoryCellDelegate: AnyObject {
    
}

class HistoryCell: UICollectionViewCell {

    @IBOutlet var image: UIImageView!
    @IBOutlet var dateTime: UILabel!
    @IBOutlet var progress: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
