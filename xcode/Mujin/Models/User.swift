//
//  User.swift
//  Mujin
//
//  Created by アリフ on 2021/06/02.
//

import Foundation
import CoreLocation

class User: NSObject {
    var setting: Setting
    var mujinBoxes: [Mujin]
    var mujinFeature: Bool
    
    init(setting: Setting, mujinBoxes: [Mujin], mujinFeature: Bool){
        self.setting = setting
        self.mujinBoxes = mujinBoxes
        self.mujinFeature = mujinFeature
    }
}
