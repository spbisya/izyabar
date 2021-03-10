//
//  Cocktails.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/26/21.
//

import Foundation
import ObjectMapper

class Cocktails: Mappable {
    var coctails: [CocktailItem]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        coctails <- map["cocktails"]
    }
}

class CocktailItem: Mappable, Encodable {
    var id: Int? // swiftlint:disable:this variable_name
    var name: String?
    var descriptionShort: String?
    var descriptionLarge: String?
    var image: String?
    var imageLarge: String?
    var strength: Int?
    var keywords: [String]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        descriptionShort <- map["description"]
        descriptionLarge <- map["description_large"]
        image <- map["image"]
        imageLarge <- map["image_large"]
        strength <- map["strength"]
        keywords <- map["keywords"]
    }
}
