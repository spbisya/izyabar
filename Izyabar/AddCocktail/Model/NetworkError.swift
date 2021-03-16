//
//  NetworkError.swift
//  Izyabar
//
//  Created by Izya Pitersky on 3/14/21.
//

import Foundation

enum CocktailErrors: Error {
    case networkError(description: String)
    case otherError(description: String)
}
