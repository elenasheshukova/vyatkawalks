//
//  File.swift
//  vyatkawalks
//
//  Created by Елена Червоткина on 03.06.2020.
//

import Foundation

struct Walk {
    //var id: Int
    var name: String = ""
//    dynamic var places: [Place] = []
    var image: String = ""
    
    init(_ name: String, _ image: String){
        self.name = name
        self.image = image
    }
}
