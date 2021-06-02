//
//  MusicResponse.swift
//  ITunesMusic
//
//  Created by binyu on 2021/5/31.
//

import Foundation

struct MusicResponse: Codable {
    let resultCount: Int
    let results: [ResultItem]
}

struct ResultItem: Codable {
    let artistName: String
    let collectionName: String
    let trackName: String
    let previewUrl: URL
    let artworkUrl30: URL
    let artworkUrl60: URL
    let artworkUrl100: URL
    
}
