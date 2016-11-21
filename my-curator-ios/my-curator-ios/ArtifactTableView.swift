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
    var delegate: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! ImageDescriptionCell
            if indexPath.row == 0 {
                cell.descriptionLabel.text = "The New Conquest of Central Asia\nThrough partnership with the Biodiversity Heritage Library and Archive.org, the logs of the expedition book is available for download as a PDF."
//                cell.descriptionImage.image = UIImage(data: try! Data.init(contentsOf: URL.init(string: "http://images.library.amnh.org/digital/files/original/6615b3ec15600bbef25d5c3908a43b33.jpg")!))
            } else if indexPath.row == 1 {
                cell.descriptionLabel.text = "Fossil Hunting in the Gobi 360"
//                cell.descriptionImage.image = UIImage(named: "book1")
            } else if indexPath.row == 2 {
                cell.descriptionLabel.text = "More than 300 photos from the Central Asiatic Expeditions are available in the Digital Collections, detailing the many new adventures of the journey."
//                cell.descriptionImage.image = UIImage(named: "book1")
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) 
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            UIApplication.shared.open(URL.init(string: "http://www.archive.org/download/newconquestofcen00andr/newconquestofcen00andr.pdf")!, options: [:], completionHandler: nil)
        } else if indexPath.row == 1 {
            UIApplication.shared.open(URL.init(string: "https://youtu.be/HDdqd8c_-hY")!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL.init(string: "http://images.library.amnh.org/digital/items/browse?collection=10")!, options: [:], completionHandler: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1 {
            return 168
        } else {
            return 54
        }
    }
    
    @IBAction func leaveTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.delegate.shouldDismiss = true
    }
}
