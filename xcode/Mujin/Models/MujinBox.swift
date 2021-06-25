//
//  MujinBox.swift
//  Mujin
//
//  Created by Arief Maulana on 2021/05/07.
//

import UIKit
import MapKit

class MujinBox: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String?
    var items: [MujinItem]
    var id: Int?
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, items: [MujinItem], id: Int){
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.items = items
    }
    
}
