//
//  playerStatus.swift
//  ITunesMusic
//
//  Created by binyu on 2021/6/1.
//

import Foundation

class PlayerStatus {
    var nowPlaying: ResultItem? = nil
    var nowPlayIndex: Int = Int.random(in: 0...4)
    var duration: Double = 0
    var isPlay: Bool = true
    var playType: String = "normal" // normal, shuffle, repeat
}
