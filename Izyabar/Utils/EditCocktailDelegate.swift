//
//  EditCocktailDelegate.swift
//  Izyabar
//
//  Created by Izya Pitersky on 3/14/21.
//

import Foundation

protocol EditCocktailDelegate: AnyObject {
    func onCocktailChanged(_ cocktail: CocktailItem)
    func onCocktailDeleted(forId cocktailId: Int)
}
