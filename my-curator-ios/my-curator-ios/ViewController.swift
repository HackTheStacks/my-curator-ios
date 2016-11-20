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

    var movingAverageThreshold: Int!

    @IBOutlet weak var signalLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var rssiDebugLabel: UILabel!
    
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
        movingAverageThreshold = 5      //# of readings to average over
        beetTriggerValue = -70
        lemonTriggerValue = -75
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.beaconsUpdated), name: Notification.Name("beaconsManagerDidUpdateNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.authorizationDenied), name: Notification.Name("beaconsManagerAuthorizationDenied"), object: nil)
        
        let transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
        activityIndicator.transform = transform
        activityIndicator.startAnimating()
    }
    
    func beaconsUpdated() {
        beacons = beaconManager.beaconsArray
        
        for beacon in beacons {
            if beacon.minor == 49339 {
                //BEET
                if beacon.rssi != 0 {
                    beetMovingArray.append(beacon.rssi)
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
                
                rssiDebugLabel.text = "beet rssi: \(beetAvg) dB\nlemon rssi: \(lemonBeaconMovingAvg) dB"
                
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

                rssiDebugLabel.text = "beet rssi: \(beetBeaconMovingAvg) dB\nlemon rssi: \(lemonAvg) dB"
                
                if lemonAvg >= lemonTriggerValue {
                    if presentedViewController == nil {
                        let transitionVC = storyboard?.instantiateViewController(withIdentifier: "transitionID") as! Transitions
                        transitionVC.beacon = beacon
                        transitionVC.delegate = self
                        self.present(transitionVC, animated: true, completion: nil)
                    }
                }
            }

            if let lemonAvg = lemonBeaconMovingAvg, let beetAvg = beetBeaconMovingAvg {
                if lemonAvg < lemonTriggerValue && beetAvg < beetTriggerValue {
                    if presentedViewController != nil {
                        self.dismiss(animated: true, completion: nil)
                    }
                    activityIndicator.startAnimating()
                    activityIndicator.isHidden = false
                    self.view.backgroundColor = UIColor.white
                    statusLabel.text = "No Items in Range..."
                }
            }
        }
    }

    func authorizationDenied() {
        
    }

}

