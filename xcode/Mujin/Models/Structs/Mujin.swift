//
//  Mujins.swift
//  Mujin
//
//  Created by アリフ on 2021/06/14.
//

import Foundation
struct Mujin: Codable{
    var id: Int
    var name: String
    var lat: Float
    var lon: Float
    var user_id: Int
    //var created_at: String
    //var updated_at: String
    var content: String
    var mujin_items: [MujinItem]
}
