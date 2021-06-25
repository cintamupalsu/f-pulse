//
//  EditMujinViewController.swift
//  Mujin
//
//  Created by アリフ on 2021/06/15.
//

import UIKit
import MapKit

class EditMujinViewController: UITableViewController, MKMapViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var user: User!
    var selectedMujin: Int!
    //var mujin: Mujin!
    var userLocation: CLLocationCoordinate2D!
    var mapView: MKMapView!
    var imageView: UIImageView!
    var imageFromBase64: UIImage?
    var website: String!
    var jsonMD: Metadata?
    var mainResponse = 0
    var destroyedMujinItem: MujinItem!
  
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = user.mujinBoxes[selectedMujin].name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMujinItem))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // to get an id of new mujin
        if user.mujinBoxes[selectedMujin].id == -1 {
            saveNewMujin(mujin: user.mujinBoxes[selectedMujin])
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Identity"
        case 1:
            return "Last Pictures"
        case 2:
            return "Contains"
        case 3:
            return "Position"
        default:
            return "none"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return user.mujinBoxes[selectedMujin].mujin_items.count
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath)
            if let cellTextField = cell.viewWithTag(1) as? UITextField{
                if indexPath.row == 0 {
                    if user.mujinBoxes[selectedMujin].id != -1{
                        cellTextField.text = user.mujinBoxes[selectedMujin].name
                    } else {
                        cellTextField.placeholder = user.mujinBoxes[selectedMujin].name
                    }
                } else {
                    if user.mujinBoxes[selectedMujin].id != -1{
                        cellTextField.text = user.mujinBoxes[selectedMujin].content
                    }else{
                        cellTextField.placeholder = user.mujinBoxes[selectedMujin].content
                    }
                    cellTextField.tag = 2
                }
            }
            return cell
        case 1:
            //let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath)
            //cell.translatesAutoresizingMaskIntoConstraints = false
            //cell.heightAnchor.constraint(equalToConstant: 300).isActive = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath)
            cell.heightAnchor.constraint(equalToConstant: 217).isActive = true
            
            let labelField = UILabel()
            labelField.text = "Tap to select an image"
            labelField.translatesAutoresizingMaskIntoConstraints = false

            imageView = UIImageView()
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(labelField)
            cell.addSubview(imageView)
            
            labelField.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            labelField.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
            
            if user.mujinBoxes[selectedMujin].id != -1{
                performSelector(inBackground: #selector(get_mujin_image), with: nil)
            }
           
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureReco))
            imageView.addGestureRecognizer(tap)
            imageView.isUserInteractionEnabled = true
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
            cell.textLabel?.text = user.mujinBoxes[selectedMujin].mujin_items[indexPath.row].name
            cell.detailTextLabel?.text = "\(Int(user.mujinBoxes[selectedMujin].mujin_items[indexPath.row].stock)) pcs"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath)
            //cell.translatesAutoresizingMaskIntoConstraints = false
            cell.heightAnchor.constraint(equalToConstant: 300).isActive = true
            mapView = MKMapView()
            mapView.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(mapView)
            mapView.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
            mapView.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
            mapView.delegate = self
            let mujinLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(user.mujinBoxes[selectedMujin].lat), longitude: CLLocationDegrees(user.mujinBoxes[selectedMujin].lon))
            mapView.setCenter(mujinLocation, animated: true)
            var region: MKCoordinateRegion = mapView.region
            region.center = mujinLocation
            region.span.latitudeDelta = 0.005
            region.span.longitudeDelta = 0.005
            mapView.setRegion(region, animated: true)
            let mujinBox =  MujinBox(title: user.mujinBoxes[selectedMujin].name, coordinate: mujinLocation, info: user.mujinBoxes[selectedMujin].content, items: user.mujinBoxes[selectedMujin].mujin_items, id: user.mujinBoxes[selectedMujin].id)
            mapView.addAnnotation(mujinBox)
            return cell
      
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 2
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        destroyedMujinItem = user.mujinBoxes[selectedMujin].mujin_items[indexPath.row]
        performSelector(inBackground: #selector(deleteMujinItem), with: nil)
        user.mujinBoxes[selectedMujin].mujin_items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    //image function
    @objc func tapGestureReco(){
        //imageView.image = UIImage(named: "refresh")
        let vc = UIImagePickerController()
        vc.modalPresentationStyle = .formSheet
        vc.delegate = self
        present(vc, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 1: dismiss the image picker
        dismiss(animated: true)
        // 2: fetch the image that was picked
        guard let image = info[.originalImage] as? UIImage else { return }
        //let image64 = image.jpegData(compressionQuality: 0.1)?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) ?? ""
        
        let image64 = image.jpegData(compressionQuality: 0.1)?.base64EncodedString()
        //let imageDataBack = Data(base64Encoded: image64!, options: Data.Base64DecodingOptions(rawValue: 0))
        //let imageBack = UIImage(data: imageDataBack!)
        //image64 = imageBack!.pngData()?.base64EncodedString()
        //let image64 = image.jpegData(compressionQuality: 0.25)
        // 3: send image to server
        let urlString = website + "apis/update_mujin_image/"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = "email=\(user.setting.email)&token=\(user.setting.token)&mujin_id=\(user.mujinBoxes[selectedMujin].id)&image64=\(image64!)".data(using: .utf8)
        
        let session = URLSession.shared
        session.dataTask(with: request){(data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                let decoder = JSONDecoder()
                if let jsonMetadata = try? decoder.decode(Metadata.self, from: data){
                    //print(jsonMetadata.metadata.responseInfo.status)
                    self.mainResponse = response.statusCode
                    self.jsonMD = jsonMetadata
                    self.performSelector(onMainThread: #selector(self.acMessage), with: nil, waitUntilDone: false)
                }
            }
        }.resume()
        
        // load image into cell
        imageView.image = image
    }
    
    //map function
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MujinBox else {return nil}
       
        let identifier = "Mujin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let mujin = view.annotation as? MujinBox else {return}
        let placeName = mujin.title
        let placeInfo = "\(mujin.info ?? "") \ncontains \(mujin.items.count) items"
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // text field functions
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.tag == 1 {
            user.mujinBoxes[selectedMujin].name = textField.text!
            title = user.mujinBoxes[selectedMujin].name
            
        } else {
            user.mujinBoxes[selectedMujin].content = textField.text!
        }
        
        if user.mujinBoxes[selectedMujin].id != -1 {
       //     performSelector(inBackground: #selector(saveNewMujin), with: nil)
       //
       // } else {
            performSelector(inBackground: #selector(updateMujin), with: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // update database on web
    @objc func updateMujin(){
        var mujin: Mujin
        mujin = user.mujinBoxes[selectedMujin]
        let urlString = website + "apis/edit_mujin/"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = "email=\(user.setting.email)&token=\(user.setting.token)&name=\(mujin.name)&content=\(mujin.content)&lat=\(mujin.lat)&lon=\(mujin.lon)&mujin_id=\(mujin.id)".data(using: .utf8)
        let session = URLSession.shared
        
        session.dataTask(with: request){(data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                let decoder = JSONDecoder()
                
                if let jsonMetadata = try? decoder.decode(Metadata.self, from: data){
                    //print(jsonMetadata.metadata.responseInfo.status)
                    self.mainResponse = response.statusCode
                    self.jsonMD = jsonMetadata
                    self.performSelector(onMainThread: #selector(self.acMessage), with: nil, waitUntilDone: false)
                }
            }
        }.resume()
    }
    
    func saveNewMujin(mujin: Mujin){
        //var mujin: Mujin
        //mujin = user.mujinBoxes.last!
        let urlString = website + "apis/create_mujin/"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = "email=\(user.setting.email)&token=\(user.setting.token)&name=\(mujin.name)&content=\(mujin.content)&lat=\(mujin.lat)&lon=\(mujin.lon)".data(using: .utf8)
        let session = URLSession.shared
        
        session.dataTask(with: request){(data, response, error) in
            if error == nil, let data = data, let _ = response as? HTTPURLResponse {
                let decoder = JSONDecoder()
                if let jsonMujin = try? decoder.decode(Mujins.self, from: data){
                    var mujins: [Mujin]
                    mujins = jsonMujin.mujins
                    self.user.mujinBoxes = [Mujin]()
                    for mujin in mujins {
                        self.user.mujinBoxes.append(mujin)
                    }
                }
            }
            self.selectedMujin = self.user.mujinBoxes.count - 1
        }.resume()
    }
    
    @objc func get_mujin_image(){
        
        let paramsString = "apis/get_mujin_image?email=\(user.setting.email)&token=\(user.setting.token)&mujin_id=\(user.mujinBoxes[selectedMujin].id)"
        if let url = URL(string: website + paramsString){
            if let data = try? Data(contentsOf: url){
                let decoder = JSONDecoder()
                if let jsonImage64 = try? decoder.decode(Image64.self, from: data){
                    var image64: String
                    image64 = jsonImage64.image64
                    if image64 != ""{
                        //let imageData = Data.init(base64Encoded: image64, options: .ignoreUnknownCharacters)
                        //let imageData : Data = Data(base64Encoded: image64, options: .ignoreUnknownCharacters)!
                        
                        //let sampleImage = UIImage(named: "cat")
                        //image64 = sampleImage?.jpegData(compressionQuality: 0.1)?.base64EncodedString() ?? ""
                        
                        //let imageData = Data(base64Encoded: image64)
                        let imageData = Data(base64Encoded: image64, options: Data.Base64DecodingOptions(rawValue: 0))
                        
                        
                        if imageData != nil {
                            imageFromBase64 = UIImage(data: imageData!)
                            performSelector(onMainThread: #selector(show_image_on_cell), with: nil, waitUntilDone: false)
                        }
                    }
                    
                } else {
                    mainResponse = 0
                }
            }
        }
    }
    

    
    @objc func show_image_on_cell(){
        imageView.image = imageFromBase64
    }
    
    
    @objc func deleteMujinItem(){
        let paramsString = "apis/delete_mujin_item?email=\(user.setting.email)&token=\(user.setting.token)&mujin_item_id=\(destroyedMujinItem.id)"
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
            let ac = UIAlertController(title: "Upload failed", message: jsonMD?.metadata.responseInfo.developerMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Close", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func addMujinItem(){
        let newMujinItem = MujinItem(id: -1, name: "noname", stock: 0, price: 0)
        performSegue(withIdentifier: "EditMujinItem", sender: newMujinItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedMujinItem: Int
        let mujinItemToEdit: MujinItem
        
        if sender is MujinItem{
            selectedMujinItem = user.mujinBoxes[selectedMujin].mujin_items.count
            mujinItemToEdit = sender as! MujinItem
            user.mujinBoxes[selectedMujin].mujin_items.append(mujinItemToEdit)
        } else {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {return}
            selectedMujinItem = selectedIndexPath.row
        }
        
        if let editMujinItemViewController = segue.destination as? EditMujinItemViewController{
            editMujinItemViewController.user = user
            editMujinItemViewController.selectedMujin = selectedMujin
            editMujinItemViewController.selectedMujinItem = selectedMujinItem
            editMujinItemViewController.website = website
        }
        
    }
    
}
