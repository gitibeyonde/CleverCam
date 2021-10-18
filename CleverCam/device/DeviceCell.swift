//
//  DeviceCell.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 14/10/21.
//

import UIKit

protocol DeviceCellDelegate: AnyObject {
    func historyClicked(with uuid: String)
}

class DeviceCell: UICollectionViewCell {

    @IBOutlet var image: UIImageView!
    @IBOutlet var deviceName: UILabel!
    weak var delegate: DeviceCellDelegate?
    private var uuid:String=""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func settingsClick(_ sender: Any) {
    }
    @IBAction func historyClicked(_ sender: Any) {
        print("history clicked")
        delegate?.historyClicked(with: uuid)
    }
    @IBAction func liveClicked(_ sender: Any) {
    }
    
    public func configure(uuid: String){
        self.uuid = uuid
    }
}
