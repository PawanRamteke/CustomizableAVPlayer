//
//  AppVideoPlayert.swift
//  AVPlayerDemo
//
//  Created by TIU-User on 16/04/21.
//

import UIKit
import AVKit
class AppVideoPlayer: UIView {
    
    var fullScreenClosure : ((Bool)->())?
    
    var mediaPlayer : AVPlayer!
    var playerLayer : AVPlayerLayer!
    
    private var playButton : UIButton!
    private var toolView : UIView!
    var lblCurrentTime : UILabel!
    var lblEndTime : UILabel!
    var slider : UISlider!
    var timer : Timer!
    var loader : UIActivityIndicatorView!
    var videoURL: URL! {
        didSet {
            loader.startAnimating()
            if playerLayer != nil {
                DispatchQueue.main.async {
                    self.mediaPlayer.pause()
                    self.mediaPlayer.seek(to: CMTime.zero)
                    
                    let asset = AVAsset(url: self.videoURL)
                    let playerItem = AVPlayerItem(asset: asset)

                    self.mediaPlayer.replaceCurrentItem(with: playerItem)
                    self.playerLayer.player = self.mediaPlayer
                    self.mediaPlayer.play()
                }
            }
            else {
                DispatchQueue.main.async {
                    self.mediaPlayer = self.player(with: self.videoURL)//AVPlayer(playerItem: AVPlayerItem(url: videoURL))
                    self.playerLayer = self.playerLayer(with: self.mediaPlayer)
                    self.layer.insertSublayer(self.playerLayer, at: 0)
                    self.mediaPlayer.play()
                }
            }
            
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerEvent), userInfo: nil, repeats: false)
            }
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func timerEvent() {
        timer = nil
        UIView.animate(withDuration: 0.4) {
            self.playButton.alpha = 0.0
            self.toolView.alpha = 0.0
        }
    }
      
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async {[weak self] in
                    if newStatus == .playing || newStatus == .paused {
                        self?.loader.stopAnimating()
                    } else {
                        self?.loader.startAnimating()
                    }
                }
            }
        }
    }
    
    func playerLayer(with player: AVPlayer) -> AVPlayerLayer {
        self.layoutIfNeeded()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspect
        playerLayer.contentsGravity = .resizeAspect
        self.playerLayer = playerLayer
        return playerLayer
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)

        setupPlayButton()
        setupToolView()
        setupLoader()
    }
    
    
    func setupPlayButton() {
        playButton = UIButton()
        playButton.setImage(UIImage(named: "ic_play"), for: .selected)
        playButton.setImage(UIImage(named: "ic_pause"), for: .normal)
        playButton.backgroundColor =  toolColor()
        playButton.layer.cornerRadius = 30.0
        playButton.addTarget(self, action: #selector(btnPlayClicked(_:)), for: .touchUpInside)
        self.addSubview(playButton)
        playButton.enableAutoLayout()
        playButton.centerX()
        playButton.centerY()
        playButton.fixedWidth(pixels: 60)
        playButton.fixedHeight(pixels: 60)
        
        self.bringSubviewToFront(playButton)
        
    }
    @objc func tapGesture(_ gesture:UITapGestureRecognizer) {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerEvent), userInfo: nil, repeats: false)
            UIView.animate(withDuration: 0.4) {
                self.playButton.alpha = 1.0
                self.toolView.alpha = 1.0
            }
        }
    }
    
    func setupToolView() {
        toolView = UIView()
        toolView.backgroundColor = toolColor()
        toolView.layer.cornerRadius = 10.0
        self.addSubview(toolView)
        toolView.enableAutoLayout()
        toolView.leadingMargin(pixels: 10)
        toolView.trailingMargin(pixels: 10)
        toolView.bottomMargin(pixels: 20)
        toolView.fixedHeight(pixels: 40)
        
        lblCurrentTime = UILabel()
        lblCurrentTime.font = UIFont.systemFont(ofSize: 13)
        lblCurrentTime.textColor = .white
      //  lblCurrentTime.text = mediaPlayer.time.stringValue // "00:00"
        
        toolView.addSubview(lblCurrentTime)
        lblCurrentTime.enableAutoLayout()
        lblCurrentTime.leadingMargin(pixels: 10)
        lblCurrentTime.centerY()
        
        let btnFullScreen = UIButton()
        btnFullScreen.setImage(UIImage(named: "expand"), for: .normal)
        btnFullScreen.setImage(UIImage(named: "expand"), for: .selected)
        btnFullScreen.addTarget(self, action: #selector(btnFullScreenClicked(_:)), for: .touchUpInside)
        toolView.addSubview(btnFullScreen)
        btnFullScreen.enableAutoLayout()
        btnFullScreen.trailingMargin(pixels: 0)
        btnFullScreen.topMargin(pixels: 0)
        btnFullScreen.bottomMargin(pixels: 0)
        btnFullScreen.fixedWidth(pixels: 50)
        
        lblEndTime = UILabel()
        lblEndTime.font = UIFont.systemFont(ofSize: 13)
        lblEndTime.textColor = .white
     //   lblEndTime.text = mediaPlayer.remainingTime.stringValue//"00:00"
        toolView.addSubview(lblEndTime)
        lblEndTime.enableAutoLayout()
        lblEndTime.addToLeftToView(view: btnFullScreen, pixels: 0)
        lblEndTime.centerY()

        
        slider = UISlider()
       // slider.isContinuous = false
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderEndDragging(_:)), for: .touchUpInside)

        toolView.addSubview(slider)
        slider.enableAutoLayout()
        slider.addToRightToView(view: lblCurrentTime, pixels: 10)
        slider.addToLeftToView(view: lblEndTime, pixels: 10)
        slider.centerY()
    }
    
    func setupLoader() {
        loader = UIActivityIndicatorView()
        loader.color = .white
        loader.style = .whiteLarge
        loader.isUserInteractionEnabled = false
        loader.hidesWhenStopped = true
        self.addSubview(loader)
        loader.enableAutoLayout()
        loader.centerX()
        loader.centerY()
    }
    
    func player(with url: URL) -> AVPlayer? {
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        let player = AVPlayer(playerItem: playerItem)
        
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 2), queue: DispatchQueue.main) {[weak self] (progressTime) in
            if let duration = player.currentItem?.duration {
                
                let durationSeconds = CMTimeGetSeconds(duration)
                if !durationSeconds.isNaN {
                    let seconds = CMTimeGetSeconds(progressTime)
                    self?.lblCurrentTime.text = self?.secondsToHoursMinutesSeconds(seconds: Int(seconds))

                    let formattedDuration = self?.secondsToHoursMinutesSeconds(seconds: Int(durationSeconds - seconds))
                    self?.lblEndTime.text = "\(formattedDuration!)"

                    let progress = Float(seconds/durationSeconds)
                    DispatchQueue.main.async {
                     //   self?.progressBar.progress = progress
                        self?.slider.value = progress
                        if progress >= 1.0 {
                      //      self?.progressBar.progress = 0.0
                            self?.slider.value = 0.0
                        }
                    }
                }
            }
        }
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndedPlaying), name: Notification.Name("AVPlayerItemDidPlayToEndTimeNotification"), object: nil)
        
        return player
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        let hour = seconds/3600
        let min = (seconds % 3600) / 60
        let sec = (seconds % 3600) % 60
        
        return hour > 0 ? "\(String(format: "%02d", hour)):\(String(format: "%02d", min)):\(String(format: "%02d", sec))" : "\(String(format: "%02d", min)):\(String(format: "%02d", sec))"
    }
    
    @objc func btnPlayClicked(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected ? mediaPlayer.pause() : mediaPlayer.play()
    }
    
    @objc func btnFullScreenClicked(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        fullScreenClosure?(sender.isSelected)
    }
    
    @objc func sliderEndDragging(_ sender:UISlider?) {
        if sender != nil {
            if let duration = self.mediaPlayer.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                let newTime = durationSeconds * Float64(sender!.value)
                self.mediaPlayer.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
                self.mediaPlayer.play()
            }
        }
    }
    
    @objc func sliderValueChanged(_ sender:UISlider) {
        pause()
    }
    
    func stopPlay() {
        mediaPlayer.pause()
    }
    
    func pause() {
        playButton.isSelected = false
        mediaPlayer.pause()
    }
    
    
    @objc func playerEndedPlaying(_ notification: Notification) {
        DispatchQueue.main.async {[weak self] in
            if let playerItem = notification.object as? AVPlayerItem {
             //   self?.player?.remove(playerItem)
                playerItem.seek(to: .zero, completionHandler: nil)
              //  self?.player?.insert(playerItem, after: nil)
                self?.pause()
            }
        }
    }
    
    func toolColor() -> UIColor {
        return UIColor(red: 48.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    }

    func onFullScreenClicked(closure:@escaping (Bool)->()) {
        fullScreenClosure = closure
    }
}
