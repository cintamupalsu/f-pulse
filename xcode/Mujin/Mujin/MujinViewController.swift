//
//  MujiinViewController.swift
//  Mujin
//
//  Created by アリフ on 2021/06/14.
//

import UIKit
import MapKit

class MujinViewController: UITableViewController {
    
    var user: User!
    var userLocation: CLLocationCoordinate2D!
    var website: String!
    var mujin: Mujin?
    var mainResponse = 0
    var jsonMD: Metadata?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fridges List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMujin))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        if  user.mujinBoxes.count != 0 {
            //if user.mujinBoxes[lastMujin - 1].id == -1 {
                // save Mujin
             //   performSelector(inBackground: #selector(saveNewMujin), with: nil)
            //} else {
            tableView.reloadData()
            //}
        }
        //tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "You have \(user.mujinBoxes.count) fridges"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.mujinBoxes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = user.mujinBoxes[indexPath.row].name
        cell.detailTextLabel?.text = "\(user.mujinBoxes[indexPath.row].mujin_items.count) items"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        mujin = user.mujinBoxes[indexPath.row]
        performSelector(inBackground: #selector(deleteMujin), with: nil)
        user.mujinBoxes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    @objc func addMujin(){
        //let newMujin = saveNewMujin()
        let newMujin = Mujin(id: -1, name: "Name", lat: Float(userLocation.latitude), lon: Float(userLocation.longitude), user_id: -1, content: "Description", mujin_items: [])
        performSegue(withIdentifier: "EditMujin", sender: newMujin)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedMujin: Int
        let mujinToEdit: Mujin
        
        if sender is Mujin {
            selectedMujin = user.mujinBoxes.count
            mujinToEdit = sender as! Mujin
            user.mujinBoxes.append(mujinToEdit)
        } else {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
            selectedMujin = selectedIndexPath.row
            //mujinToEdit = user.mujinBoxes[selectedMujin]
        }
        
        if let editMujinViewController = segue.destination as? EditMujinViewController{
            editMujinViewController.user = user
            editMujinViewController.selectedMujin = selectedMujin
            //editMujinViewController.mujin = mujinToEdit
            editMujinViewController.userLocation = userLocation
            editMujinViewController.website = website
        }
    }
    
    @objc func deleteMujin(){
        let paramsString = "apis/delete_mujin?email=\(user.setting.email)&token=\(user.setting.token)&mujin_id=\(mujin!.id)"
        if let url = URL(string: website + paramsString){
            if let data = try? Data(contentsOf: url){
                let decoder = JSONDecoder()
                if let jsonMetadata = try? decoder.decode(Metadata.self, from: data){
                    mainResponse = jsonMetadata.metadata.responseInfo.status
                } else {
                    mainResponse = 0
                }
            }
        }
        performSelector(onMainThread: #selector(acMessage), with: nil, waitUntilDone: false)
    }
    
    
    @objc func acMessage(){
        if mainResponse != 200  {
            let ac = UIAlertController(title: "Delete process failed", message: jsonMD?.metadata.responseInfo.developerMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Close", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func reloadTable(){
        tableView.reloadData()
    }
}
