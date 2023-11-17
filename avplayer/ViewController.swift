//
//  ViewController.swift
//  avplayer
//
//  Created by HOH on 06/12/2016.
//  Copyright © 2016 med abida. All rights reserved.
//

/*
 -import MYAudioTapProcessor.h and MYAudioTapProcessor.m  and add abridging header
 */

import UIKit
import AVFoundation
import MYAudioTapProcessorSDK

class ViewController: UIViewController,MYAudioTabProcessorDelegate {
    var player:AVPlayer!
    var tapProcessor: MYAudioTapProcessor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // AVPlayer for Video Playback
        let filepath:String! = Bundle.main.path(forResource: "bet", ofType: "mp3")
        let fileUrl = URL(fileURLWithPath: filepath)
        player = AVPlayer(url: fileUrl) as AVPlayer
        
        // Notifications
        let playerItem: AVPlayerItem!  = player.currentItem
        playerItem.addObserver(self, forKeyPath: "tracks", options: NSKeyValueObservingOptions.new, context:  nil);
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: OperationQueue.main, using: { (notif: Notification) -> Void in
            self.player.seek(to: CMTime.zero)
            self.player.play()
            print("replay")
        })
        //程序退出时执行
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: nil, using: { (notif: Notification) -> Void in
            print("willTerminateNotification----------")
        })
        
        player.play()
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (object as? AVPlayerItem == player.currentItem && keyPath == "tracks"){
            if let playerItem: AVPlayerItem = player.currentItem {
                if let tracks = playerItem.asset.tracks as? [AVAssetTrack] {
                    tapProcessor = MYAudioTapProcessor(avPlayerItem: playerItem)
                    playerItem.audioMix = tapProcessor.audioMix
                    tapProcessor.delegate = self
                }
            }
        }
    }
    
    func audioTabProcessor(_ audioTabProcessor: MYAudioTapProcessor!, hasNewLeftChannelValue leftChannelValue: Float, rightChannelValue: Float) {
        print("volume: \(leftChannelValue) : \(rightChannelValue)")
    }
    
    @IBAction func compressorSwitchChanged(_ sender: UISwitch) {
        tapProcessor.compressorEnabled  = sender.isOn
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

