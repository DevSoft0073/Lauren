//
//  VideoPlayer.swift
//  GrownStrong
//
//  Created by Aman on 30/07/21.
//

import UIKit
import AVKit
import AVFoundation
import HCVimeoVideoExtractor

class VideoPlayer: NSObject,CachingPlayerItemDelegate{
    static let shared = VideoPlayer()
    
    var vc : AVPlayerViewController!
    
    func playVideo(url: URL) {
        
//           let player = AVPlayer(url: url)
//
//           let vc = AVPlayerViewController()
//           vc.player = player
//            UIApplication.topViewController()?.present(vc, animated: true) { vc.player?.play() }
        
        let player = AVPlayer()
        
        let vc = AVPlayerViewController()
        vc.player = player
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        }
        
        do {
                  try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                  print("AVAudioSession Category Playback OK")
                  do {
                      try AVAudioSession.sharedInstance().setActive(true)
                      print("AVAudioSession is Active")
                      
                  } catch let error as NSError {
                      print(error.localizedDescription)
                  }
              } catch let error as NSError {
                  print(error.localizedDescription)
              }
        let firstPlayerItem = CachingPlayerItem(url: url)
        player.automaticallyWaitsToMinimizeStalling = false
        firstPlayerItem.delegate = self
        player.replaceCurrentItem(with: firstPlayerItem)
        player.play()
       }
    
    
    func playVimeoVideo(videoUrl : String){
        
        let player = AVPlayer()
        
        vc = AVPlayerViewController()
        vc.player = player
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(self.vc, animated: true, completion: nil)
        }
        
        let url = URL(string: videoUrl)!
        HCVimeoVideoExtractor.fetchVideoURLFrom(url: url, completion: { ( video:HCVimeoVideo?, error:Error?) -> Void in
            if let err = error {
                print("Error = \(err.localizedDescription)")
                return
            }
            guard let vid = video else {
                print("Invalid video object")
                return
            }
            if let videoURL = vid.videoURL[.Quality720p] {
                
                do {
                          try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                          print("AVAudioSession Category Playback OK")
                          do {
                              try AVAudioSession.sharedInstance().setActive(true)
                              print("AVAudioSession is Active")
                              
                          } catch let error as NSError {
                              print(error.localizedDescription)
                          }
                      } catch let error as NSError {
                          print(error.localizedDescription)
                      }
                
                
                
               // let firstAsset = AVURLAsset(url: videoURL)
                let firstPlayerItem = CachingPlayerItem(url: videoURL)
                player.automaticallyWaitsToMinimizeStalling = false
                firstPlayerItem.delegate = self
                player.replaceCurrentItem(with: firstPlayerItem)
                player.play()
            }
        })
    }
    
    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {
            print("File is downloaded and ready for storing")
        }
        
        func playerItem(_ playerItem: CachingPlayerItem, didDownloadBytesSoFar bytesDownloaded: Int, outOf bytesExpected: Int) {
//            print("\(bytesDownloaded)/\(bytesExpected)")
        }
        
        func playerItemPlaybackStalled(_ playerItem: CachingPlayerItem) {
            print("Not enough data for playback. Probably because of the poor network. Wait a bit and try to play later.")
        }
        
        func playerItem(_ playerItem: CachingPlayerItem, downloadingFailedWith error: Error) {
            print(error)
        }
    
}
