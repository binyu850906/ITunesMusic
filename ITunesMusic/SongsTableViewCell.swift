//
//  SongsTableViewCell.swift
//  ITunesMusic
//
//  Created by binyu on 2021/5/31.
//

import UIKit

class SongsTableViewCell: UITableViewCell {

    @IBOutlet weak var songNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
