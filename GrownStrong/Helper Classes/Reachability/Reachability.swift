//
//  Reachability.swift
//  Lauren
//
//  Created by Rapidsofts Sahil on 18/11/21.
//

import Foundation
import Reachability
import UIKit
import SwiftMessages

class AIReachabilityManager: NSObject {

    var reachability : Reachability!

    static let sharedManager : AIReachabilityManager = {
        let instance = AIReachabilityManager()
        return instance
    }()

    func isInternetAvailable() -> Bool
    {
        if(self.reachability == nil){
            self.doSetupReachability()
        }
        return self.reachability.isReachable() || self.reachability.isReachableViaWiFi() || self.reachability.isReachableViaWWAN()
    }

    func doSetupReachability() {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.warning)
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.text = "No Internet connection"
        view.bodyLabel?.text = ""
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.cornerRadius = 10
        view.button?.isHidden = true
//        view.backgroundView.backgroundColor = .systemRed
        
        let reachability = Reachability.init(hostname: "www.google.com")
        reachability?.reachableBlock = { reachability in
            print("Reachability reachable: \(String(describing: reachability))")
            DispatchQueue.main.async {
                SwiftMessages.hideAll()
            }
        }
        reachability?.unreachableBlock = { reachability in
            print("Reachability unreachable: \(String(describing: reachability))")
            DispatchQueue.main.async {
                var config = SwiftMessages.defaultConfig
                config.duration = .forever
                SwiftMessages.show(config: config, view: view)
            }
        }
        reachability!.startNotifier()
        self.reachability = reachability
    }

    deinit{
        reachability.stopNotifier()
        reachability = nil
    }

}
