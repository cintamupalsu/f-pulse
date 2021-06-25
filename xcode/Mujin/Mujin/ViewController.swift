//
//  ViewController.swift
//  Mujin
//
//  Created by Arief Maulana on 2021/05/06.
//

import UIKit
import ZXingObjC    // for barcode
import MapKit       // for map
import CoreLocation // for GPS

class ViewController: UIViewController, ZXCaptureDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    // 共有Variables
    var progressView: UIProgressView! // プログレスバー
    private let capture = ZXCapture()
    //カメラ
    
    @IBOutlet var cameraView: UIView!
    @IBOutlet var cameraViewHeight: NSLayoutConstraint!
    
    // 地図
    var mapView: MKMapView!
    var mujinBoxes = [MujinBox]()
    
    // user
    //var user = User(name: "Arief", email: "a_maulana@sbs-infosys.co.jp", token: "testtoken")
    var user: User!
    
    // pointed Web
    var website: String!
    
    // Setting
    //var setting = Setting(user: User(name: "", email: "", token: ""))
    var setting = Setting(email: "", token: "", name: "", admin: "No")
    var userAuthenticated = false
    
    // GPS Variables
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    
    let mgmtButton = UIBarButtonItem()
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchEngine))
        //navigationController?.setNavigationBarHidden(true, animated: true)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
              
        website = "https://e-i-e-i-no.herokuapp.com/"
        title = "👨🏻‍🌾E-I-E-I-農"
        cameraInit()
        layout()
        
        // GPS setting
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        
        }
    
        load()
  
    }
    
    // Camera
    func cameraInit(){
        capture.delegate = self
        capture.camera = capture.back()
        capture.rotation = 90
        capture.layer.frame = cameraView.bounds
        cameraViewHeight.constant = view.frame.size.height * 0.3
        cameraView.layer.addSublayer(capture.layer)
        cameraToggle()
    }
    
    // Layout
    func layout(){
        // 地図を追加
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        //mapView.sizeToFit()
        view.addSubview(mapView)
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: cameraView.bottomAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.delegate = self
        
        // Dimension recognizing
        let iconSize = view.frame.size.height * 0.05
        
        // Toolbar 設定
        // プログレスバー
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor(hex: "9AD1BF")
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.widthAnchor.constraint(equalToConstant: iconSize * 3).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: iconSize * 0.2).isActive = true
        let progressBar = UIBarButtonItem(customView: progressView)
        
        // バーコードのカメラボタン
        let barcodeBtn = UIButton(type: UIButton.ButtonType.custom)
        barcodeBtn.setImage(UIImage(named: "barcode"), for: .normal)
        barcodeBtn.translatesAutoresizingMaskIntoConstraints = false
        barcodeBtn.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
        barcodeBtn.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        barcodeBtn.addTarget(self, action: #selector(cameraToggle), for: .touchDown)
        let barcodeButton = UIBarButtonItem(customView: barcodeBtn)

        // Light button
        let lightBtn = UIButton(type: UIButton.ButtonType.custom)
        lightBtn.setImage(UIImage(named: "light"), for: .normal)
        lightBtn.translatesAutoresizingMaskIntoConstraints = false
        lightBtn.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
        lightBtn.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        //lightBtn.addTarget(self, action: #selector(lightToggle), for: .touchDown)
        let lightButton = UIBarButtonItem(customView: lightBtn)
        
        // 設定ボタン
        let settingBtn = UIButton(type: UIButton.ButtonType.custom)
        settingBtn.setImage(UIImage(named: "setting"), for: .normal)
        settingBtn.translatesAutoresizingMaskIntoConstraints = false
        settingBtn.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
        settingBtn.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        settingBtn.addTarget(self, action: #selector(openFeatures), for: .touchDown)
        let settingButton = UIBarButtonItem(customView: settingBtn)
       
        // Refreshボタン
        let refreshBtn = UIButton(type: UIButton.ButtonType.custom)
        refreshBtn.setImage(UIImage(named: "refresh"), for: .normal)
        refreshBtn.translatesAutoresizingMaskIntoConstraints = false
        refreshBtn.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
        refreshBtn.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        //refreshBtn.addTarget(self, action: #selector(refreshWeb), for: .touchDown)
        let refreshButton = UIBarButtonItem(customView: refreshBtn)
        
        // Space between icon
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Arrangement
        //toolbarItems = [barcodeButton, spacer, lightButton, spacer, refreshButton, spacer, progressBar, spacer, settingButton]
        toolbarItems = [barcodeButton, spacer, lightButton, spacer, refreshButton, spacer, settingButton]
    }
    
    func captureResult(_ capture: ZXCapture!, result: ZXResult!) {
        cameraToggle()
        guard let barcode = result.text else { return }
        
        let first3 = barcode.prefix(3)
        if first3 == "SBS" || setting.token == "" || !userAuthenticated {
            let los = barcode.count
            setting.token = String(barcode.suffix(los-3))
            performSelector(inBackground: #selector(userAuthentication), with: nil)
            //userAuthentication()
        } else {
            
        }
        
       // let ac = UIAlertController(title: "バーコードを読みました", message: setting.user.name, preferredStyle: .alert)
       // ac.addAction(UIAlertAction(title: "OK", style: .default))
        //present(ac, animated: true)
        
    }
    
    // Toggle functions
    @objc func cameraToggle(){
        if cameraView.isHidden == false {
            capture.stop()
            cameraViewHeight.constant = 0
            navigationController?.setNavigationBarHidden(false, animated: true)
            cameraView.isHidden = true

        } else {
            cameraView.isHidden = false
            navigationController?.setNavigationBarHidden(true, animated: true)
            cameraViewHeight.constant = view.frame.size.height * 0.3
            capture.start()
           
        }
 
    }
    
    // Map Functions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MujinBox else {return nil}
        let identifier = "Mujin"
        //let annotationView = MKPinAnnotationView()
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        //markAnno.annotation = annotation
        //return markAnno
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        userLocation = CLLocationCoordinate2D(latitude: locations.last!.coordinate.latitude, longitude: locations.last!.coordinate.longitude)
        
        //locationManager.stopUpdatingLocation()
        showUserLocation()
    }
    
    func showUserLocation(){
        
        mapView.setCenter(userLocation, animated: true)
        var region: MKCoordinateRegion = mapView.region
        region.center = userLocation
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        //let center = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        //mapView.centerToLocation(center)
    }
    
    // Search function
    @objc func searchEngine(){
        
        
        let ac = UIAlertController(title: "Search", message: "Items in maps", preferredStyle: .alert)
        ac.addTextField(){[weak ac] action in
            ac?.textFields?[0].placeholder = "Orange"
        }
        let submitAction = UIAlertAction(title: "Go", style: .default){[weak self, weak ac] action in
            guard let words = ac?.textFields?[0].text else { return }
            self?.searchItem(words: words)
        }
        //submitAction.setValue(guideQR, forKey: "image")
        ac.addAction(submitAction)
        present(ac,animated: true)
    }
    
    func searchItem(words: String){
        
    }
    
    func getMapItemData(){
        let paramsString = "apis/mujin_points?email=\(setting.email)&token=\(setting.token)"
        if let url = URL(string: website + paramsString){
            if let data = try? Data(contentsOf: url){
                let decoder = JSONDecoder()
                if let jsonMujin = try? decoder.decode(Mujins.self, from: data){
                    var mujins: [Mujin]
                    mujins = jsonMujin.mujins
                   
                    
                    for mujin in mujins {
                        let mujinBox = MujinBox(title: mujin.name, coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(mujin.lat), longitude: CLLocationDegrees(mujin.lon)), info: mujin.content, items: mujin.mujin_items, id: mujin.id)
                        mujinBoxes.append(mujinBox)
                    }
                }
            }
        }
    }
    
    @objc func addMujinPinOnMap(){
        for mujinBox in mujinBoxes{
            mapView.addAnnotation(mujinBox)
        }
    }
    // Login administration functions
    
    @objc func userAuthentication(){
        var userInfo = [String]()
        let paramsString = "apis/scan?email=\(setting.email)&token=\(setting.token)"
        if let url = URL(string: website + paramsString){
            if let data = try? Data(contentsOf: url){
                let code = parseMetadata(json: data)
                if code == 200 {
                    let decoder = JSONDecoder()
                    if let jsonUser = try? decoder.decode(Results.self, from: data){
                        userInfo = jsonUser.results
                        if userInfo != [] {
                            setting.name = userInfo[0]
                            if userInfo[1] == "1"{
                                setting.admin = "Yes"
                            } else {
                                setting.admin = "No"
                            }
                            
                            user = User(setting: setting, mujinBoxes: [], mujinFeature: false)
                            //if userInfo[1] == "true"{
                                user.mujinFeature = true
                            //}
                        }
                    }
                    
                    getMapItemData()
                    //performSelector(onMainThread: #selector(getMapItemData), with: nil, waitUntilDone: false)
                    
                    //progressView.progress = 0.5
                    
                    getUserMujins()
                    
                    //progressView.progress = 1
                    performSelector(onMainThread: #selector(addMujinPinOnMap), with: nil, waitUntilDone: false)
                    userAuthenticated = true // to activate setting button
                    save()
                } else {
                    userAuthenticated = false
                    performSelector(onMainThread: #selector(promptForLogFailed), with: nil, waitUntilDone: false)
                }
            } else {
                performSelector(onMainThread: #selector(promptForFailedConnection), with: nil, waitUntilDone: false)
            }
        }
    }
    
    func getUserMujins(){
        
        let paramsString = "apis/user_mujins?email=\(setting.email)&token=\(setting.token)"
        user.mujinBoxes = [Mujin]()
        if let url = URL(string: website + paramsString){
            if let data = try? Data(contentsOf: url){
                let decoder = JSONDecoder()
                if let jsonMujin = try? decoder.decode(Mujins.self, from: data){
                    var mujins: [Mujin]
                    mujins = jsonMujin.mujins
                    for mujin in mujins {
                        user.mujinBoxes.append(mujin)
                    }
                }
            }
        }
        
    }
    
    func parseMetadata(json: Data) -> Int {
        let decoder = JSONDecoder()
        if let jsonMetadata = try? decoder.decode(Metadata.self, from: json){
            return jsonMetadata.metadata.responseInfo.status
        } else {
            return 0
        }
    }
    
    @objc func promptForLogFailed(){
        let ac = UIAlertController(title: "😩ログインが失敗しました。", message: "メール又はQRコードが違います。", preferredStyle: .alert)
        let reLoginAction = UIAlertAction(title: "も一度やり直す", style: .default){[weak self] action in
            self?.promptForLogin()
        }
        ac.addAction(reLoginAction)
        present(ac, animated: true, completion: nil)
        
    }
    
    @objc func promptForFailedConnection(){
        let ac = UIAlertController(title: "😣エラー", message: "インターネット接続をしてください。", preferredStyle: .alert)
        let reLoginAction = UIAlertAction(title: "も一度やり直す", style: .default){[weak self] action in
            self?.promptForLogin()
        }
        ac.addAction(reLoginAction)
        //ac.addAction(UIAlertAction(title: "閉じる", style: .cancel))
        present(ac, animated: false)
    }
    
    @objc func save(){
        do {
            let path = IOHelper.getDocumentsDirectory().appendingPathComponent("user")
            let data = try NSKeyedArchiver.archivedData(withRootObject: setting, requiringSecureCoding: false)
            try data.write(to: path)
        } catch {
            
            errorMessage(errorMessage: error.localizedDescription)
        }
    }
    
    func load(){
        do {
            let path = IOHelper.getDocumentsDirectory().appendingPathComponent("user")
            let data = try Data(contentsOf: path)
            setting = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Setting) ?? Setting(email: "", token: "", name: "", admin: "No")
            performSelector(inBackground: #selector(userAuthentication), with: nil)
        } catch {
            promptForLogin()
        }
    }
    
    func errorMessage(errorMessage: String, errorTitle: String = "😖エラー"){
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    @objc func promptForLogin(){
        //var guideView = UIImageView()
        //guideView.image = UIImage(named: "guideQR")
        //let guideQR = UIImage(named: "guideQR")
        
        let ac = UIAlertController(title: "最新設定", message: "メールを書いてください。その後ウェブのホームにクレデンシャルボタンを押してQRコードをスキャンしてください。", preferredStyle: .alert)
        ac.addTextField(){[weak ac] action in
            ac?.textFields?[0].placeholder = "example@sbs-infosys.co.jp"
            ac?.textFields?[0].textContentType = UITextContentType.emailAddress
            if self.setting.email != "" {
                ac?.textFields?[0].text = self.setting.email
            }
            
        }
        let submitAction = UIAlertAction(title: "QRコードをスキャン", style: .default){[weak self, weak ac] action in
            guard let email = ac?.textFields?[0].text else { return }
            self?.setting.email = email
            self?.cameraToggle()
        }
        //submitAction.setValue(guideQR, forKey: "image")
        ac.addAction(submitAction)
        present(ac,animated: true)
        
    }
    
    @objc func openFeatures(){
        if userAuthenticated == true {
            performSegue(withIdentifier: "FeaturesShow", sender: setting)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let featuresViewController = segue.destination as? FeaturesViewController{
            featuresViewController.user = user
            featuresViewController.userLocation = userLocation
            featuresViewController.website = website
        }
    }
    
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0){
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256 ) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256 ) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256 ) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha,0),1))
    }
}

//private extension MKMapView{
//    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 100){
//        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
//    }
//}


