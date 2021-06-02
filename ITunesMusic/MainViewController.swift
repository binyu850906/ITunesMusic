//
//  MainViewController.swift
//  ITunesMusic
//
//  Created by binyu on 2021/5/31.
//

import UIKit
import  AVFoundation

let player = AVPlayer()
let playerStatus = PlayerStatus()

class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var songsItem: [ResultItem] = []
    let selectedBackgroundView = UIView()
    
    @IBOutlet weak var playingSongImageView: UIImageView!
    @IBOutlet weak var playingSongLabel: UILabel!
    @IBOutlet weak var playSongButtton: UIButton!
    @IBOutlet weak var nextSongButton: UIButton!
    @IBOutlet weak var playingSheet: UIView!
    @IBOutlet weak var songsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkController.shared.FetchMusic { result in
            switch result {
            case .success(let songs):
                self.songsItem = songs
                print(self.songsItem)
            case .failure(let error):
                print(error)
            }
        }
        selectedBackgroundView.backgroundColor = UIColor.black
        initPlayingSheet()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { (_) in
            self.playNextSong()
            self.setPlayingSheet(playingSong: playerStatus.nowPlaying!)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playPauseMusic), name: NSNotification.Name("playPauseMusic"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nextSong), name: NSNotification.Name("nextSong"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(backwardSong), name: NSNotification.Name("backwardSong"), object: nil)
    }
    func initPlayingSheet() {
        playingSheet.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.toCurrentMusicPage))
        playingSheet.addGestureRecognizer(gesture)
        
    }
    
    @objc func toCurrentMusicPage() {
        if let controller = storyboard?.instantiateViewController(identifier: "MusicViewController") as? MusicViewController, let _ = playerStatus.nowPlaying {
            present(controller, animated: true, completion: nil)
        }
    }
    func playMusic(resource: ResultItem) {
        playerStatus.isPlay = true
        let playItem = AVPlayerItem(url: resource.previewUrl)
        playerStatus.duration = playItem.asset.duration.seconds
        player.replaceCurrentItem(with: playItem)
        player.play()
        
        setPlayButton()
    }
    
    func pauseMusic() {
        player.pause()
        playerStatus.isPlay = false
        
        setPlayButton()
    }
    
    func resumeMusic() {
        player.play()
        playerStatus.isPlay = true
        
        setPlayButton()
    }
    
    func setPlayButton() {
        if playerStatus.isPlay {
            playSongButtton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }else {
            playSongButtton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    func setPlayingSheet(playingSong: ResultItem) {
        URLSession.shared.dataTask(with: playingSong.artworkUrl60) { data, response, error in
            if let data = data, let image = UIImage(data: data){
                DispatchQueue.main.async {
                    self.playingSongImageView.image = image
                    self.playingSongLabel.text = playingSong.trackName
                    self.setPlayButton()
                }
            }
        }.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songsItem.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "playTableViewCell", for: indexPath) as? PlayTableViewCell else {
                return UITableViewCell()
            }
           return cell
        }
        else {
            
            if indexPath.row == songsItem.count + 1 {
              let cell =  UITableViewCell()
              cell.backgroundColor = UIColor.black
              return cell
             }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "songsTableViewCell", for: indexPath) as? SongsTableViewCell else { return UITableViewCell() }
            cell.songNameLabel.text = songsItem[indexPath.row - 1].trackName
            cell.selectedBackgroundView = selectedBackgroundView
        return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playingSong = songsItem[indexPath.row - 1]
        playMusic(resource: playingSong)
        setPlayingSheet(playingSong: playingSong)
        playerStatus.nowPlaying = playingSong
        playerStatus.nowPlayIndex = indexPath.row - 1
        playerStatus.isPlay = true
    }
    
    @IBAction func playPauseMusic(_ sender: Any) {
        if playerStatus.isPlay {
            pauseMusic()
        }else{
            if playerStatus.nowPlaying == nil {
                return
            }else {
             resumeMusic()
            }
        }
    }
    
    @IBAction func nextSong(_ sender: Any) {
      playNextSong()
    }
    
    func playNextSong() {
        if playerStatus.nowPlaying == nil {
            return
        }else{
            playerStatus.nowPlayIndex += 1
            if playerStatus.nowPlayIndex > (songsItem.count - 1){
                playerStatus.nowPlayIndex = 0
            }
            playerStatus.nowPlaying = songsItem[playerStatus.nowPlayIndex]
            playMusic(resource: playerStatus.nowPlaying!)
            
            setPlayingSheet(playingSong: playerStatus.nowPlaying!)
            setPlayButton()
        }
    }
    
   @objc func backwardSong() {
        if playerStatus.nowPlaying == nil {
            return
        }else {
            playerStatus.nowPlayIndex -= 1
            if playerStatus.nowPlayIndex < 0{
                playerStatus.nowPlayIndex = songsItem.count - 1
            }
            playerStatus.nowPlaying = songsItem[playerStatus.nowPlayIndex]
            playMusic(resource: playerStatus.nowPlaying!)
            setPlayingSheet(playingSong: playerStatus.nowPlaying!)
            setPlayButton()
            
        }
    }
    
    @IBAction func playFirstSong(_ sender: Any) {
        let playSong = songsItem[0]
        playMusic(resource: playSong)
        playerStatus.nowPlaying = playSong
        playerStatus.nowPlayIndex = 0
        setPlayButton()
        setPlayingSheet(playingSong: playSong)
        toCurrentMusicPage()
    }
    
    @IBAction func playShuffleSong(_ sender: Any) {
        let shuffleNumber = Int.random(in: 0...10)
        let playsong = songsItem[shuffleNumber]
        playMusic(resource: playsong)
        playerStatus.nowPlaying = playsong
        playerStatus.nowPlayIndex = shuffleNumber
        setPlayButton()
        setPlayingSheet(playingSong: playsong)
        toCurrentMusicPage()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let row = songsTableView.indexPathForSelectedRow?.row, let controller = segue.destination as? MusicViewController {
            controller.songItem = songsItem[row - 1]
        }
            }

}
