//
//  BeaconAdmin.swift
//  my-curator-ios
//
//  Created by Gregory O'Neill on 11/19/16.
//  Copyright © 2016 Gregory O'Neill. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import UserNotifications

class BeaconManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance: BeaconManager = {
        let instance = BeaconManager()
        
        return instance
    }()
    
    let locationManager = CLLocationManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let appDefaults = UserDefaults.standard
    
    var beaconsArray: [CLBeacon]!
    
    let defaultUUID = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
    var uuidString: String!
    var beaconRegion: CLBeaconRegion!
    
    override init() {
        super.init()
        
        locationManager.allowsBackgroundLocationUpdates = true
        
        checkForLocationServiceAuthorization()
    }
    
    func checkForLocationServiceAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            if locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)) {
                locationManager.requestAlwaysAuthorization()
                startUpdatingLocation()
            } else {
                startUpdatingLocation()
            }
        }
    }
    
    func startUpdatingLocation() {

        uuidString = defaultUUID
        
        let beaconIdentifier = "AMNH.Beacon"
        let beaconUUID = UUID(uuidString: uuidString)!
        beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID,
                                      identifier: beaconIdentifier)
        
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        locationManager.startUpdatingLocation()
    }
    
    func updateUUID(uuidString:String) {
        if let beaconUUID = UUID(uuidString: uuidString) {
            appDefaults.setValue(uuidString, forKey: "uuid")
            locationManager.stopMonitoring(for: beaconRegion)
            locationManager.stopRangingBeacons(in: beaconRegion)
            beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: "Aurnhammer.Beacon")
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
        } else {
            print("Not a valid UUID")
//            let alert = UIAlertView(title: "Not a valid UUID", message: nil, delegate: nil, cancelButtonTitle: "OK")
//            alert.show()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
            print("Location Authorization has been disabled", terminator: "")
            NotificationCenter.default.post(name: NSNotification.Name("beaconsManagerAuthorizationDenied"), object: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if(beacons.count > 0) {
            beaconsArray = beacons as [CLBeacon]!
            NotificationCenter.default.post(name: NSNotification.Name("beaconsManagerDidUpdateNotification"), object: nil)
        }
        guard let array = beaconsArray else { return }
        for beacon in array {
            if beacon.minor == 49339 || beacon.minor == 18544 {
                if beacon.rssi >= -75 {
                    sendCloseLocalNotification()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        manager.startRangingBeacons(in: region as! CLBeaconRegion)
        manager.startUpdatingLocation()
        
        let content = UNMutableNotificationContent()
        content.title = "Entered the beacon region"
        content.subtitle = "Subtitle"
        content.body = "You have entered into the region of this beacon!!"
        content.categoryIdentifier = "message"
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1.0,
            repeats: false)
        let request = UNNotificationRequest(
            identifier: "museum.message",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(
            request, withCompletionHandler: nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
        manager.stopUpdatingLocation()
        
        let content = UNMutableNotificationContent()
        content.title = "Exited the beacon region"
        content.subtitle = "Subtitle"
        content.body = "You have exited the region of this beacon!!"
        content.categoryIdentifier = "message"
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1.0,
            repeats: false)
        let request = UNNotificationRequest(
            identifier: "museum.exit_message",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(
            request, withCompletionHandler: nil)
        
    }
    
    func sendCloseLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "You're close!"
        content.subtitle = "Subtitle"
        content.body = "YOU ARE REALLY CLOSE TO THIS BEACON NOW! OPEN THE APP!"
        content.categoryIdentifier = "message"
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1.0,
            repeats: false)
        let request = UNNotificationRequest(
            identifier: "museum.proximity_message",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(
            request, withCompletionHandler: nil)

    }
}

