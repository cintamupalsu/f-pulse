//
//  EditMujinItemViewController.swift
//  Mujin
//
//  Created by アリフ on 2021/06/17.
//

import UIKit

class EditMujinItemViewController: UITableViewController, UITextFieldDelegate {

    var user: User!
    var selectedMujin: Int!
    var selectedMujinItem: Int!
    var website: String!
    var mainResponse = 0
    var jsonMD: Metadata?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.mujinBoxes[selectedMujin].mujin_items[selectedMujinItem].name
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // to get an id of new mujin Item
        if user.mujinBoxes[selectedMujin].mujin_items[selectedMujinItem].id == -1 {
            saveNewMujinItem(mujinItem: user.mujinBoxes[selectedMujin].mujin_items[selectedMujinItem], mujin: user.mujinBoxes[selectedMujin])
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Name"
        case 1:
            return "Stock"
        case 3:
            return "Price"
        default:
            return "none"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath)
        if let cellTextField = cell.viewWithTag(1) as? UITextField{
            switch indexPath.section {
            case 0:
                if user.mujinBoxes[selectedMujin].mujin_items[selectedMujinItem].id != -1 {
                    cellTextField.text = user.mujinBoxes[selectedMujin].mujin_items[selectedMujinItem].name
                }
                cellTextField.tag = 1
            case 1:
                if user.mujinBoxes[selectedMujin].mujin_items[selectedMujinItem].id != -1 {
                    cellTextField.text = "\(user.mujinBoxes[selectedMujin].mujin_items[selectedMujinItem].stock)"
                }
                cellTextField.tag = 2
            case 2:
                if user.mujinBoxes[selectedMujin].mujin_items[selectedMujinItem].id != -1 {
                    cellTextField.text = "\(user.mujinBoxes[selectedMujin].mujin_items[selectedMujinItem].price)"
                }
                cellTextField.tag = 3
            default:
                cellTextField.text = "undefined cell"
            }
        }
        return cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        switch textField.tag {
        case 1:
            user.mujinBoxes[selectedMujin].mujin_items[selectedMujinItem].name = textField.text ?? ""
        case 2:
            user.mujinBoxes[selectedMujin].mujin_items[selectedMujinItem].stock = Double(textField.text ?? "") ?? 0
        case 3:
            user.mujinBoxes[selectedMujin].mujin_items[selectedMujinItem].price = Double(textField.text ?? "") ?? 0
        default:
            return
        }
        
        if user.mujinBoxes[selectedMujin].mujin_items[selectedMujinItem].id != -1 {
            performSelector(inBackground: #selector(updateMujinItem), with: nil)
        }
    }
    
    func saveNewMujinItem(mujinItem: MujinItem, mujin: Mujin){
        //var mujin: Mujin
        //mujin = user.mujinBoxes.last!
        let urlString = website + "apis/create_mujin_item/"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = "email=\(user.setting.email)&token=\(user.setting.token)&name=\(mujinItem.name)&stock=\(mujinItem.stock)&price=\(mujinItem.price)&mujin_id=\(mujin.id)".data(using: .utf8)
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
            self.selectedMujinItem = self.user.mujinBoxes[self.selectedMujin].mujin_items.count - 1
        }.resume()
    }
    
    @objc func updateMujinItem(){
        let mujin = user.mujinBoxes[selectedMujin]
        let mujinItem = mujin.mujin_items[selectedMujinItem]
        let urlString = website + "apis/edit_mujin_item/"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = "email=\(user.setting.email)&token=\(user.setting.token)&name=\(mujinItem.name)&stock=\(mujinItem.stock)&price=\(mujinItem.price)&mujin_item_id=\(mujinItem.id)".data(using: .utf8)
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
    
    @objc func acMessage(){
        
        if mainResponse != 200  {
            let ac = UIAlertController(title: "Upload failed", message: jsonMD?.metadata.responseInfo.developerMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Close", style: .default))
            present(ac, animated: true)
        }
    }

}
