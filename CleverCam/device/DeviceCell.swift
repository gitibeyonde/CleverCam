//
//  DeviceCell.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 14/10/21.
//

import UIKit

class DeviceCell: UICollectionViewCell {

    @IBOutlet var image: UIImageView!
    @IBOutlet var deviceName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func settingsClick(_ sender: Any) {
    }
    @IBAction func historyClicked(_ sender: Any) {
        print("history clicked")
        DeviceViewController.device_timer.invalidate()
    }
    @IBAction func liveClicked(_ sender: Any) {
    }
}
