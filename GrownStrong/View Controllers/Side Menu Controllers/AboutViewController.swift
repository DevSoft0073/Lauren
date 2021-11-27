//
//  AboutViewController.swift
//  GrownStrong
//
//  Created by Aman on 30/07/21.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

  //MARK: butotn click
//    @IBAction func playBtn(_ sender: UIButton) {
//        let videoUrl = URL(string: demoVideoUrl)
//        VideoPlayer.shared.playVideo(url: videoUrl!)
//
//    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
