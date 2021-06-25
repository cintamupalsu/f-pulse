//
//  FeaturesViewController.swift
//  Mujin
//
//  Created by アリフ on 2021/06/04.
//

import UIKit
import MapKit

class FeaturesViewController: UITableViewController {
    
    var user: User!
    var userLocation: CLLocationCoordinate2D!
    var website: String!
    
    @IBOutlet var mujinCell: UITableViewCell!
    @IBOutlet weak var ennnouCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isToolbarHidden = true
   
        title = user.setting.name
        if user.mujinFeature == false {
            mujinCell.isHidden = true
        }
        ennnouCell.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        mujinCell.detailTextLabel?.text = "\(user.mujinBoxes.count) Places"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mujinViewController = segue.destination as? MujinViewController{
            mujinViewController.user = user
            mujinViewController.userLocation = userLocation
            mujinViewController.website = website
        }
    }
}
