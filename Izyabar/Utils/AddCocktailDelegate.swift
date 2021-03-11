//
//  AddCocktailDelegateProtocol.swift
//  Izyabar
//
//  Created by 1 on 11.03.2021.
//

import Foundation

protocol AddCocktailDelegate: AnyObject {
    func onCocktailAdded(_ cocktail: CocktailItem)
}
