//
//  File.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 03.06.2020.
//

import Foundation

struct Walk: Decodable {
    var id: String
    var name: String
    var image: String
    var text: String
    var places: [String]

//    init(_ id: String, _ name: String, _ image: String, _ text: String){
//        self.id = id//UUID().uuidString
//        self.name = name
//        self.image = image
//        self.text = text
//    }
}
