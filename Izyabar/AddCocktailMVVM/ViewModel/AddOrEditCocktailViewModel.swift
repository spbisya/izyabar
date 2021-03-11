//
//  AddOrEditCocktailViewModel.swift
//  Izyabar
//
//  Created by 1 on 11.03.2021.
//

import Foundation

class AddOrEditCocktailViewModel {
    
    // MARK: - Closures
    
    var updateTitleClosure: ((_ title: String) -> Void)?
    var updateActionTitleClosure: ((_ title: String) -> Void)?
    
    // MARK: - Properties
    
    let apiService: AddCocktailServiceProtocol
    
    var cocktailItem: CocktailItem? {
        didSet {
            self.updateTitleClosure?(cocktailItem?.name ?? "add_cocktail".localized)
            self.updateActionTitleClosure?(cocktailItem == nil ? "add".localized : "save".localized)
        }
    }
    
    // MARK: - Constructor
    
    init(apiService: AddCocktailServiceProtocol = AddCocktailService()) {
        self.apiService = apiService
    }
}
