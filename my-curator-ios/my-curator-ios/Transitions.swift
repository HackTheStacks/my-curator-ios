//
//  Transitions.swift
//  my-curator-ios
//
//  Created by Gregory O'Neill on 11/20/16.
//  Copyright © 2016 Gregory O'Neill. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Transitions: UIViewController {
    
    var beacon: CLBeacon!
    var delegate: UIViewController!
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainImage.image = UIImage(named: "book1")
        detailButton.layer.cornerRadius = 4.0
    }
    
    @IBAction func detailButtonTapped(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "artifactSegue" {
            let vc = segue.destination as! UINavigationController
            let dest = vc.viewControllers[0] as! ArtifactTableViewController
            dest.delegate = self.delegate
            dest.beacon = self.beacon
        }
    }
}
