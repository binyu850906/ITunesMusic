//
//  NetworkViewController.swift
//  ITunesMusic
//
//  Created by binyu on 2021/5/31.
//

import Foundation

class NetworkController {
    static let shared = NetworkController()
    let sings = ["media":"music", "term":"華晨宇.新世界"]
    let baseURLString = "https://itunes.apple.com/search?"
    
    func FetchMusic( completion: @escaping (Result<[ResultItem],Error>) -> Void) {
        
        let baseURL = URL(string: baseURLString)
        var compoments = URLComponents(url: baseURL!, resolvingAgainstBaseURL: true)
        compoments?.queryItems = sings.map{ URLQueryItem(name: $0.0, value: $0.1) }
        let fetchURL = compoments?.url!
     
        URLSession.shared.dataTask(with: fetchURL!) { data, response, error in
            if let data = data{
                let jsonDecoder = JSONDecoder()
                do {
                    let musicResponse =  try jsonDecoder.decode(MusicResponse.self, from: data)
                    let songsItem = musicResponse.results
                    completion(.success(songsItem))
                } catch  {
                 print(error)
                }
            }else if let error = error {
                print(error)
            }
        }.resume()
    }
    
    
}
