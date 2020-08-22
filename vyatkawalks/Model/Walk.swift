//
//  File.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 03.06.2020.
//

import Foundation

struct Stop: Decodable {
    var id: String
    var name: String
    var image: String
    var text: String
    var place: String
    var sort: Int
}

struct Walk: Decodable {
    var id: String
    var name: String
    var image: String
    var text: String
    var stops : [Stop]
}
