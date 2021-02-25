//
//  Cocktail.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/17/21.
//

import Foundation
import UIKit

class CocktailItem: ReflectedStringConvertible {
    let id: Int
    let name: String
    let descriptionShort: String
    let descriptionLarge: String
    let image: String
    let imageLarge: String
    let strength: Int
    let keywords: Array<String>
    
    init(json: Any) {
        if let dict = json as? [String: Any] {
            id = dict["id"] as! Int
            name = dict["name"] as! String
            descriptionShort = dict["description"] as! String
            descriptionLarge = dict["description_large"] as! String
            image = dict["image"] as! String
            imageLarge = dict["image_large"] as! String
            strength = dict["strength"] as! Int
            keywords = dict["keywords"] as! Array<String>
        } else {
            id = -1
            name = ""
            descriptionShort = ""
            descriptionLarge = ""
            image = ""
            imageLarge = ""
            strength = 0
            keywords = Array()
        }
    }
}
