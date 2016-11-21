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
    var delegate: ViewController!
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        mainImage.image = UIImage.init(named: "flag2")
//        mainImage.image = UIImage(data: try! Data.init(contentsOf: URL.init(string: "http://images.library.amnh.org/digital/files/original/6615b3ec15600bbef25d5c3908a43b33.jpg")!))

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
            self.delegate.shouldDismiss = false
        }
    }
}
