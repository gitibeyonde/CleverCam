//
//  HistoryCell.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 04/12/21.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet var historyImage: UIImageView!
    @IBOutlet var dateTime: UILabel!
    @IBOutlet var progress: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
