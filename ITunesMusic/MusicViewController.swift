//
//  MusicViewController.swift
//  ITunesMusic
//
//  Created by binyu on 2021/6/1.
//

import UIKit
import AVFoundation

class MusicViewController: UIViewController {
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songTimeSlider: UISlider!
    @IBOutlet weak var voiceSlider: UISlider!
    @IBOutlet weak var positiveTimeLabel: UILabel!
    @IBOutlet weak var negativeTimeLabel: UILabel!
    @IBOutlet weak var SongNameLabel: UILabel!
    @IBOutlet weak var SingerLabel: UILabel!
    
    var songItem: ResultItem? = playerStatus.nowPlaying
    
    override func viewDidLoad() {
        super.viewDidLoad()
       initSongTimeSlider()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       setMusicImageView(selected: songItem!)
        setPlayPauseButton()
        setSliderMaxMin()
        
    }
    

    func initSongTimeSlider(){
        player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: DispatchQueue.main) { CMTime in
            if let _ = playerStatus.nowPlaying, playerStatus.isPlay {
                let currentTime = player.currentTime().seconds
                self.songTimeSlider.value = Float(currentTime)
                
                self.positiveTimeLabel.text = self.timeFormat(time: currentTime)
                self.negativeTimeLabel.text = "-\(self.timeFormat(time: playerStatus.duration - currentTime))"
            }
        }
    }
    
    func timeFormat(time: Double) -> String {
        let result = Int(time).quotientAndRemainder(dividingBy: 60)
        return "\(result.quotient):\(String(format: "%.02d", result.remainder))"
    }
    
    func setSliderMaxMin() {
        songTimeSlider.maximumValue = Float(playerStatus.duration)
        
        songTimeSlider.isContinuous = true
    }
    
    func setPlayPauseButton(){
        if playerStatus.isPlay{
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }else{
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    func setMusicImageView(selected: ResultItem) {
        SongNameLabel.text = selected.trackName
        SingerLabel.text = "華晨宇"
        URLSession.shared.dataTask(with: selected.artworkUrl100) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.songImageView.image = image
                }
            }
        }.resume()
    }
    
    @IBAction func songTimeSlider(_ sender: UISlider) {
        let time = CMTime(value: CMTimeValue(sender.value), timescale: 1)
        player.seek(to: time)
    }
    @IBAction func playPauseButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("playPauseMusic"), object: nil)
        setPlayPauseButton()
    }
    @IBAction func nextSongButton(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name("nextSong"), object: nil)
        songItem = playerStatus.nowPlaying
        setMusicImageView(selected: songItem!)
    }
    @IBAction func backWardButton(_ sender: Any){
        NotificationCenter.default.post(name: NSNotification.Name("backwardSong"), object: nil)
        songItem = playerStatus.nowPlaying
        setMusicImageView(selected: songItem!)
    }
    
    @IBAction func voiceSliderChange(_ sender: UISlider){
        let sliderValue = sender.value
        player.volume = sliderValue
    }
    @IBAction func maxVoiceButton(_ sender: Any) {
        player.isMuted = false
        voiceSlider.value = 1
    }
    @IBAction func minVoiceButton(_ sender: Any) {
        player.isMuted = true
        voiceSlider.value = 0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
