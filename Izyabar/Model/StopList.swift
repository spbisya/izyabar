//
//  StopList.swift
//  Izyabar
//
//  Created by Izya Pitersky on 3/17/21.
//

import Foundation
import ObjectMapper

class StopList: Mappable {
    var ids: [Int]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        ids <- map["ids"]
    }
}

class StopListPostModel: Encodable {
    var id: Int // swiftlint:disable:this variable_name
    
    required init(id: Int) { // swiftlint:disable:this variable_name
        self.id = id
    }
}

class StopListChangedModel: Mappable {
    var success: Bool?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        success <- map["success"]
    }
}
