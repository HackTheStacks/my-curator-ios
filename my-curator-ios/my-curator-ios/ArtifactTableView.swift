//
//  ArtifactTableView.swift
//  my-curator-ios
//
//  Created by Gregory O'Neill on 11/20/16.
//  Copyright © 2016 Gregory O'Neill. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class ArtifactTableViewController: UITableViewController {
    
    var beacon: CLBeacon!
    var delegate: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! ImageDescriptionCell
            cell.descriptionLabel.text = "Just making sure this is working"
            cell.descriptionImage.image = UIImage(named: "book1")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) 
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1 {
            return 168
        } else {
            return 54
        }
    }
}
