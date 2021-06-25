//
//  IOHelper.swift
//  Mujin
//
//  Created by アリフ on 2021/06/03.
//

import Foundation
struct IOHelper{
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
}
