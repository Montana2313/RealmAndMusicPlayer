//
//  collectionViewHeader.swift
//  MusicPlayerWork
//
//  Created by Mac on 26.07.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RealmSwift
import AVFoundation
import MediaPlayer
import SDWebImage



class collectionViewHeaderSection: UICollectionReusableView {
    
    private let songmp3Links : [String] = [
      "https://www.8notes.com/school/mp32/piano/satie_gnoissienne1.mp3",
      "https://www.8notes.com/school/mp32/baritone_saxophone/moonlight_sonata_BSAX.mp3",
      "https://www.8notes.com/school/mp32/accordion/moonlight_sonata_ACC.mp3",
      "https://www.8notes.com/school/mp32/piano/beethoven_tempest_op31_no2_3rdmvt_PNO.mp3",
      "https://www.8notes.com/school/mp32/violin/romance.mp3",
      "https://www.8notes.com/school/mp32/voice/mozart_queen.mp3"
    ]
    private var imageView : UIImageView!
    private var blurView : UIView!
    private let musicPlayerViewModel = MusicPlayerViewModel()
    private let disposeBag = DisposeBag()
    private var currentSongValue = 0
    private var usernameLabel : UILabel!
    private var emailLabel : UILabel!
    
    var player:AVPlayer!
    var playerItem:AVPlayerItem!
    var playerLayer:AVPlayerLayer!
    private var quitButton : UIButton!
    private var searchButton : UIButton!
    private var backGroundPlayer : AVAudioPlayer!
    
    private var startButton : UIButton!
    private var nextSongButton : UIButton!
    private var backSongButton : UIButton!
    
    private var backGroundSoundSlider : UISlider!
    private var songTitle : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .brown
        self.setImageView()
        self.setBlurView()
        self.setUsernameLabel()
        self.setEmailAddress()
        self.setQuitButton()
        self.setSearchButton()
        self.setPlayer()
        self.setBackGroundMusic()
        self.setStartButton()
        self.setNextButton()
        self.setBackButton()
        self.setSongTitleLabel()
        self.setSongSlider()
        self.musicPlayerViewModel.currentUser.asObserver().map { (user)  in
            self.usernameLabel.text = user.userName
            self.emailLabel.text = user.userEmailAddress
        }.subscribe().disposed(by: self.disposeBag)
        
        self.musicPlayerViewModel.getCurrentUserInformation()
        
         self.setupRemoteTransportControls()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.songChanged(_:)), name: NSNotification.Name(rawValue: "songChanged"), object: nil)
    }
    @objc func songChanged(_ notification: NSNotification) {
        if let number = notification.userInfo?["songNumber"] as? Int {
            self.currentSongValue = number
            self.startButton.setTitle("Çal", for: .normal)
            self.player.pause()
            self.backGroundPlayer.stop()
            
            self.setPlayer()
            
            self.player.play()
            self.backGroundPlayer.play()
            self.startButton.setTitle("Dur", for: .normal)
             self.songTitle.text = "Bölüm \(self.currentSongValue + 1)"
            
        }
    }
    private func setImageView(){
        self.imageView = UIImageView(image: UIImage(named: "bgImage.jpg"))
        self.imageView.contentMode = .scaleAspectFill
        self.addSubview(self.imageView)
        self.imageView.isUserInteractionEnabled = true
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.imageView.layoutIfNeeded()
    }
    private func setBlurView(){
        self.blurView = UIView()
        self.imageView.addSubview(self.blurView)
        self.blurView.translatesAutoresizingMaskIntoConstraints = false
        self.blurView.leftAnchor.constraint(equalTo: self.imageView.leftAnchor).isActive = true
        self.blurView.topAnchor.constraint(equalTo: self.imageView.topAnchor).isActive = true
        self.blurView.rightAnchor.constraint(equalTo: self.imageView.rightAnchor).isActive = true
        self.blurView.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true
        
        self.blurView.layoutIfNeeded()
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurView.addSubview(blurEffectView)
    }
    private func setUsernameLabel(){
        self.usernameLabel = UILabel()
        self.usernameLabel.text = "Username"
        self.usernameLabel.textAlignment = .left
        self.usernameLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        self.usernameLabel.textColor = UIColor.white
        self.usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.addSubview(self.usernameLabel)
        self.usernameLabel.leftAnchor.constraint(equalTo: self.imageView.leftAnchor , constant: 24).isActive = true
        self.usernameLabel.rightAnchor.constraint(equalTo: self.imageView.rightAnchor , constant: -24).isActive = true
        self.usernameLabel.topAnchor.constraint(equalTo: self.imageView.safeAreaLayoutGuide.topAnchor , constant: 50).isActive = true
        self.usernameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.imageView.bringSubviewToFront(self.usernameLabel)
    }
    private func setEmailAddress(){
        self.emailLabel = UILabel()
        self.emailLabel.text = "Username"
        self.emailLabel.textAlignment = .left
        self.emailLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        self.emailLabel.textColor = UIColor.white
        self.emailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.addSubview(self.emailLabel)
        self.emailLabel.leftAnchor.constraint(equalTo: self.imageView.leftAnchor , constant: 24).isActive = true
        self.emailLabel.rightAnchor.constraint(equalTo: self.imageView.rightAnchor , constant: -24).isActive = true
        self.emailLabel.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor ).isActive = true
        self.emailLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.imageView.bringSubviewToFront(self.emailLabel)
    }
    
    private func setQuitButton(){
        self.quitButton = UIButton()
        self.quitButton.setTitle("Çıkış", for: .normal)
        self.quitButton.setTitleColor(.white, for: .normal)
        self.quitButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        self.quitButton.addTarget(self, action: #selector(quitButtonTapped), for: .touchUpInside)
        self.quitButton.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.addSubview(self.quitButton)

        self.quitButton.rightAnchor.constraint(equalTo: self.imageView.rightAnchor , constant: -24).isActive = true
        self.quitButton.topAnchor.constraint(equalTo: self.imageView.safeAreaLayoutGuide.topAnchor , constant: 50).isActive = true
        self.quitButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.quitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.imageView.bringSubviewToFront(self.quitButton)
        
        self.quitButton.layoutIfNeeded()
        
        self.quitButton.setGradientBackGroundColor(location: nil, startPoint: CGPoint(x: 0, y: 0), startColor: UIColor.systemGreen.cgColor, endPoint: CGPoint(x: 1, y: 0), endColor: UIColor.black.cgColor)
        self.quitButton.layer.masksToBounds = true
        self.quitButton.layer.cornerRadius = 4
    }
    private func setSearchButton(){
         self.searchButton = UIButton()
        self.searchButton.setTitle("Ara", for: .normal)
        self.searchButton.setTitleColor(.white, for: .normal)
        self.searchButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        self.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.addSubview(self.searchButton)

        self.searchButton.rightAnchor.constraint(equalTo: self.imageView.rightAnchor , constant: -24).isActive = true
        self.searchButton.topAnchor.constraint(equalTo: self.quitButton.bottomAnchor , constant: 5).isActive = true
        self.searchButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.searchButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.imageView.bringSubviewToFront(self.searchButton)
        
        self.searchButton.layoutIfNeeded()
        
        self.searchButton.setGradientBackGroundColor(location: nil, startPoint: CGPoint(x: 0, y: 0), startColor: UIColor.systemGreen.cgColor, endPoint: CGPoint(x: 1, y: 0), endColor: UIColor.black.cgColor)
        self.searchButton.layer.masksToBounds = true
        self.searchButton.layer.cornerRadius = 4
    }

    func setStartButton(){
        self.startButton =  UIButton()
        self.startButton.setTitle("Çal", for: .normal)
        self.startButton.setTitleColor(.white, for: .normal)
        self.startButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20.0)
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageView.addSubview(self.startButton)
        
        self.startButton.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor).isActive = true
        self.startButton.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor).isActive = true
        self.startButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.startButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        self.startButton.layoutIfNeeded()
        
         self.startButton.setGradientBackGroundColor(location: nil, startPoint: CGPoint(x: 0, y: 0), startColor: UIColor.systemRed.cgColor, endPoint: CGPoint(x: 1, y: 0), endColor: UIColor.orange.cgColor)
        
        self.startButton.layer.masksToBounds = true
        self.startButton.layer.cornerRadius = 50
    }
    func setNextButton(){
        self.nextSongButton = UIButton()
        self.nextSongButton.setTitle(">", for: .normal)
        self.nextSongButton.setTitleColor(.white, for: .normal)
        self.nextSongButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20.0)
        self.nextSongButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageView.addSubview(self.nextSongButton)
        
        self.nextSongButton.leftAnchor.constraint(equalTo: self.startButton.rightAnchor , constant: 20).isActive = true
        self.nextSongButton.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor).isActive = true
        self.nextSongButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.nextSongButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.nextSongButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        self.nextSongButton.layoutIfNeeded()
        
        self.nextSongButton.setGradientBackGroundColor(location: nil, startPoint: CGPoint(x: 0, y: 0), startColor: UIColor.systemRed.cgColor, endPoint: CGPoint(x: 1, y: 0),endColor: UIColor.orange.cgColor)
        
        self.nextSongButton.layer.masksToBounds = true
        self.nextSongButton.layer.cornerRadius = 25
    }
    
    func setBackButton(){
        self.backSongButton = UIButton()
        self.backSongButton.setTitle("<", for: .normal)
        self.backSongButton.setTitleColor(.white, for: .normal)
        self.backSongButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20.0)
        self.backSongButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageView.addSubview(self.backSongButton)
        
        self.backSongButton.rightAnchor.constraint(equalTo: self.startButton.leftAnchor , constant: -20).isActive = true
        self.backSongButton.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor).isActive = true
        self.backSongButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.backSongButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.backSongButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        self.backSongButton.layoutIfNeeded()
        
        self.backSongButton.setGradientBackGroundColor(location: nil, startPoint: CGPoint(x: 0, y: 0), startColor: UIColor.systemRed.cgColor, endPoint: CGPoint(x: 1, y: 0),endColor: UIColor.orange.cgColor)
        
        self.backSongButton.layer.masksToBounds = true
        self.backSongButton.layer.cornerRadius = 25
    }
    func setPlayer(){
        let playerItem:AVPlayerItem = AVPlayerItem(url: URL(string: self.songmp3Links[self.currentSongValue])!)
        player = AVPlayer(playerItem: playerItem)
        
        playerLayer = AVPlayerLayer(player: player!)
        playerLayer?.frame=CGRect(x: 0, y: 0, width: 10, height: 50)
        self.imageView.layer.addSublayer(playerLayer!)
        
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)

        let mySecs = Int(seconds) % 60
        let myMins = Int(seconds / 60)
        
        let myTimes = String(myMins) + ":" + String(mySecs);
        print("Time : \(myTimes)")
        
        
        //subroutine used to keep track of current location of time in audio file
       player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
           if self.player!.currentItem?.status == .readyToPlay {
            self.setupNowPlaying()
            self.player.play()
               let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
               let currentSec = Int(time) % 60
               let currentMin = Int(time / 60)
     
               print("Saniye : \(currentSec) - > Dakika : \(currentMin)")
           }
       }
    }
    func setBackGroundMusic(){
         do {
             self.backGroundPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "rain", ofType: "mp3")!))
            self.backGroundPlayer.numberOfLoops = -1
            self.backGroundPlayer.volume = 0.04
             self.backGroundPlayer.prepareToPlay()
            print(self.backGroundPlayer.duration)
            
            let durationTime = backGroundPlayer.duration

            let mySecs = Int(durationTime) % 60
            let myMins = Int(durationTime / 60)
            
            let myTimes = String(myMins) + ":" + String(mySecs);
            print("Time : \(myTimes)")
        
         }catch {
             print(error)
         }
     }
    
    func setSongTitleLabel(){
        self.songTitle = UILabel()
        self.songTitle.text = "Bölüm \(self.currentSongValue + 1)"
        self.songTitle.textAlignment = .center
        self.songTitle.textColor = .white
        self.songTitle.font = UIFont(name: "Avenir-Heavy", size: 20.0)
        
        self.imageView.addSubview(self.songTitle)
        
        self.songTitle.translatesAutoresizingMaskIntoConstraints = false
        self.songTitle.leftAnchor.constraint(equalTo: self.imageView.leftAnchor, constant: 20).isActive = true
        self.songTitle.topAnchor.constraint(equalTo: self.startButton.bottomAnchor, constant: 30).isActive = true
        self.songTitle.rightAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: -20).isActive = true
    }
    func setSongSlider(){
        self.backGroundSoundSlider = UISlider()
        self.backGroundSoundSlider.tintColor = .systemGreen
        self.backGroundSoundSlider.minimumValue = 0.0
        self.backGroundSoundSlider.maximumValue = 1.0
        self.backGroundSoundSlider.value = self.backGroundPlayer.volume
        
        backGroundSoundSlider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        self.imageView.addSubview(self.backGroundSoundSlider)
             
        self.backGroundSoundSlider.translatesAutoresizingMaskIntoConstraints = false
        self.backGroundSoundSlider.leftAnchor.constraint(equalTo: self.imageView.leftAnchor, constant: 20).isActive = true
        self.backGroundSoundSlider.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: -10).isActive = true
        self.backGroundSoundSlider.rightAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: -20).isActive = true
    }
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                print("başlandı")
            case .moved:
                self.backGroundPlayer.volume = slider.value
            case .ended:
                print("bitti")
            default:
                break
            }
        }
    }
    
    
    @objc func quitButtonTapped(){
        self.musicPlayerViewModel.deleteCurrentUserInformation { (res) in
            switch res {
            case .failure(let error):
                UIViewController.getLastViewController().present(UIAlertController.createDefaultAlert(title: "Bilgi", desc: error.rawValue, buttonTitle: "Tamam")
                ,animated: true,completion: nil)
            case .success(let stat):
                if stat == true {
                    UIViewController.seguePage(withController: LoginVC())
                }
              }
        }
    }
    @objc func startButtonTapped(){
        if backGroundPlayer.isPlaying {
            self.startButton.setTitle("Çal", for: .normal)
            self.backGroundPlayer.pause()
            self.player.pause()
        }
        else {
            self.startButton.setTitle("Dur", for: .normal)
            self.backGroundPlayer.play()
            self.player.play()
        }

    }
    @objc func nextButtonTapped(){
        self.startButton.setTitle("Çal", for: .normal)
        self.player.pause()
        self.backGroundPlayer.stop()
        self.currentSongValue += 1
        if self.currentSongValue > 5 {
            self.currentSongValue = 0
        }
        self.setPlayer()
        self.player.play()
        self.backGroundPlayer.play()
        self.startButton.setTitle("Dur", for: .normal)
        self.songTitle.text = "Bölüm \(self.currentSongValue)"
    }
    @objc func backButtonTapped(){
        self.startButton.setTitle("Çal", for: .normal)
        self.player.pause()
        self.backGroundPlayer.stop()
        self.currentSongValue -= 1
        if self.currentSongValue < 0 {
            self.currentSongValue = 0
               self.songTitle.text = "Bölüm \(self.currentSongValue)"
        }else {
                    self.songTitle.text = "Bölüm \(self.currentSongValue)"
        }
        self.setPlayer()
        self.player.play()
        self.backGroundPlayer.play()
        self.startButton.setTitle("Dur", for: .normal)
        

    }
    
    
    @objc func searchButtonTapped(){
        UIViewController.getLastViewController().navigationController?.pushViewController(SearchVC(), animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupRemoteTransportControls() {
           // Get the shared MPRemoteCommandCenter
           let commandCenter = MPRemoteCommandCenter.shared()

           // Add handler for Play Command
           commandCenter.playCommand.addTarget { [unowned self] event in
               if self.player!.rate == 0.0 {
                   self.player!.play()
                   return .success
               }
               return .commandFailed
           }
        commandCenter.nextTrackCommand.addTarget{ [unowned self] event in
            self.nextButtonTapped()
            return .success
        }
        commandCenter.previousTrackCommand.addTarget{ [unowned self] event in
            self.backButtonTapped()
            return .success
        }

           // Add handler for Pause Command
           commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player!.rate == 0.0 {
                self.player!.pause()
                return .success
            }
            return .commandFailed
           }
        
        commandCenter.changePlaybackPositionCommand.addTarget { [unowned self] event in
            if let player = self.player{
                let playerRate = player.rate
                if let event = event as? MPChangePlaybackPositionCommandEvent{
                    player.seek(to: CMTime(seconds: event.positionTime, preferredTimescale: CMTimeScale(1000)), completionHandler: { [weak self](success) in
                                      guard let self = self else {return}
                                      if success {
                                          self.player?.rate = playerRate
                                      }
                                  })
                }
            }
            return .success
        }

       }
       func setupNowPlaying() {
           // Define Now Playing Info
           var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Bölüm \(self.currentSongValue)"

           if let image = UIImage(named: "AppIcon") {
               nowPlayingInfo[MPMediaItemPropertyArtwork] =
                   MPMediaItemArtwork(boundsSize: image.size) { size in
                       return image
               }
           }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.player.currentItem?.currentTime().seconds
           nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.player.currentItem?.asset.duration.seconds
           nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.player?.rate
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "Armut dalda kız balkonda"
        nowPlayingInfo[MPMediaItemPropertyAlbumArtist] = "Özgür Elmaslı"
        let fakeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        fakeImageView.sd_setImage(with: URL(string: "https://img-s1.onedio.com/id-5775a2cbba077b60546373f6/rev-0/w-635/f-jpg-webp/s-c2ff533f21ff70f8753e5efb402228599d5e5049.webp")) { (image, err, type, url) in
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: CGSize(width: 300, height: 300)) { size in
                    return image ?? UIImage()
            }
        }
        

           // Set the metadata
           MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
       }
}
