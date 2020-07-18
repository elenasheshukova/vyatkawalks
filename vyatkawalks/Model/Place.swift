//
//  Place.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 03.06.2020.
//

import Foundation

struct Place: Decodable {
    var id: String
    var name: String
    var image: String
    var text: String
    var address: String
    var coordinateLatitude: String
    var coordinateLongitude: String
    var images: [String]
}
