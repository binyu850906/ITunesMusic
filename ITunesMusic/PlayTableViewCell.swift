//
//  PlayTableViewCell.swift
//  ITunesMusic
//
//  Created by binyu on 2021/5/31.
//

import UIKit

class PlayTableViewCell: UITableViewCell {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shufflePlayButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.tintColor = .systemPink
        playButton.setTitle("播放", for: .normal)
        playButton.setTitleColor(.systemPink, for: .normal)
        playButton.backgroundColor = UIColor(red: 0.051, green: 0.051, blue: 0.051, alpha: 1)
        
        shufflePlayButton.setImage(UIImage(systemName: "shuffle"), for: .normal)
        shufflePlayButton.tintColor = .systemPink
        shufflePlayButton.setTitle("隨機播放", for: .normal)
        shufflePlayButton.setTitleColor(.systemPink, for: .normal)
        shufflePlayButton.backgroundColor = UIColor(red: 0.051, green: 0.051, blue: 0.051, alpha: 1)
    }
      
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
