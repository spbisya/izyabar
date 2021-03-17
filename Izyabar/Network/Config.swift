//
//  Config.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/22/21.
//

import Foundation

enum Config {
    private static let baseURL = "http://82.196.15.171"
    static let cocktailsURL = baseURL + "/cocktails"
    static let cocktailURL = baseURL + "/cocktail"
    static let stopListURL = baseURL + "/stoplist"
    static let addToStopListURL = baseURL + "/stoplist/add"
    static let removeFromStopListURL = baseURL + "/stoplist/remove"
}
