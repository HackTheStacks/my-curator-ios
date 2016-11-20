//
//  ViewController.swift
//  my-curator-ios
//
//  Created by Gregory O'Neill on 11/19/16.
//  Copyright © 2016 Gregory O'Neill. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController {
    
    let beaconManager = BeaconManager.sharedInstance
    var beacons: [CLBeacon]!
    
    var shouldDismiss: Bool = true

    var movingAverageThreshold: Int!

    @IBOutlet weak var signalLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var rssiDebugLabel: UILabel!
    @IBOutlet weak var amnhLogo: UIImageView!
    
    var beetTriggerValue: Int!
    var beetBeaconMovingAvg: Int!
    var beetMovingArray = [Int]()
    
    var lemonTriggerValue: Int!
    var lemonBeaconMovingAvg: Int!
    var lemonMovingArray = [Int]()
    
    var isGrantedNotificationAccess: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,error) in
                self.isGrantedNotificationAccess = granted
        })
        
        // Can Update For Precision
        movingAverageThreshold = 4      //# of readings to average over
        beetTriggerValue = -80
        lemonTriggerValue = -80
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.beaconsUpdated), name: Notification.Name("beaconsManagerDidUpdateNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.authorizationDenied), name: Notification.Name("beaconsManagerAuthorizationDenied"), object: nil)
//        animateImageView()
    }
    
    func beaconsUpdated() {
        beacons = beaconManager.beaconsArray
        
        for beacon in beacons {
            if beacon.minor == 49339 {
                //BEET
                if beacon.rssi != 0 {
                    beetMovingArray.append(beacon.rssi)
                    print("beet_rssi: \(beacon.rssi)")
                }
                if beetMovingArray.count >= movingAverageThreshold {
                    while beetMovingArray.count > movingAverageThreshold {
                        beetMovingArray.remove(at: 0)
                    }
                    let avg = Int(Double(beetMovingArray.reduce(0) { $0 + $1 }) / Double(beetMovingArray.count))
                    beetBeaconMovingAvg = avg
                }
                
                guard let beetAvg = beetBeaconMovingAvg else {
                    return
                }
                
                if beetAvg >= beetTriggerValue {
                    if presentedViewController == nil {
                        let transitionVC = storyboard?.instantiateViewController(withIdentifier: "transitionID") as! Transitions
                        transitionVC.beacon = beacon
                        transitionVC.delegate = self
                        self.present(transitionVC, animated: true, completion: nil)
                    }
                }
                
            } else if beacon.minor == 18544 {
                //LEMON
                if beacon.rssi != 0 {
                    lemonMovingArray.append(beacon.rssi)
                    print("lemon_rssi: \(beacon.rssi)")
                }
                if lemonMovingArray.count >= movingAverageThreshold {
                    while lemonMovingArray.count > movingAverageThreshold {
                        lemonMovingArray.remove(at: 0)
                    }
                    let avg = Int(Double(lemonMovingArray.reduce(0) { $0 + $1 }) / Double(lemonMovingArray.count))
                    lemonBeaconMovingAvg = avg
                }
                
                guard let lemonAvg = lemonBeaconMovingAvg else {
                    return
                }
                
                if lemonAvg >= lemonTriggerValue {
                    if presentedViewController == nil {
                        let transitionVC = storyboard?.instantiateViewController(withIdentifier: "transitionID") as! Transitions
                        transitionVC.beacon = beacon
                        transitionVC.delegate = self
                        shouldDismiss = true
                        self.present(transitionVC, animated: true, completion: nil)
                    }
                }
            }
            
            if let lemonAvg = lemonBeaconMovingAvg, let beetAvg = beetBeaconMovingAvg {
                if lemonAvg < lemonTriggerValue && beetAvg < beetTriggerValue {
                    if shouldDismiss {
                        self.dismiss(animated: true, completion: nil)
                        shouldDismiss = false
                    }
                    
                    
//                    if presentedViewController != nil && presentedViewController is UINavigationController == false {
//                        self.dismiss(animated: true, completion: nil)
//                    }
                    statusLabel.text = "No Items in Range..."
                }
            }
        }
        rssiDebugLabel.text = "beet rssi: \(beetBeaconMovingAvg) dB\nlemon rssi: \(lemonBeaconMovingAvg) dB"
    }
    
    func animateImageView() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform.rotation.z"
        animation.values = [0, 0, M_PI * 2.0]
        animation.duration = 3.0
        animation.isCumulative = true
        animation.repeatCount = 20

        self.amnhLogo.layer.add(animation, forKey: "rotationAnimation")
    }

    func authorizationDenied() {
        
    }

}

