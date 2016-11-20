//
//  ViewController.swift
//  my-curator-ios
//
//  Created by Gregory O'Neill on 11/19/16.
//  Copyright © 2016 Gregory O'Neill. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let beaconManager = BeaconManager.sharedInstance
    var beacons: [CLBeacon]!
    var movingAverageThreshold: Int?

    @IBOutlet weak var signalLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var beetBeaconMovingAvg: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //how many previous values to average
        beaconManager.movingAverageThreshold = 3
        
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
                if beacon.rssi != 0 {
                    signalLabel.text = "Signal: \(beacon.rssi)"
                }
            }
            
        }
    }

    func authorizationDenied() {
        
    }

}

