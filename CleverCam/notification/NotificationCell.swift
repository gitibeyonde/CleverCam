//
//  NotificationCell.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 20/10/21.
//

import UIKit

class NotificationCell: UICollectionViewCell {
    @IBOutlet var id: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var deviceName: UILabel!
    @IBOutlet var progress: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
