//
//  AddOrEditCocktailViewModel.swift
//  Izyabar
//
//  Created by 1 on 11.03.2021.
//

import Foundation

class AddOrEditCocktailViewModel {
    
    // MARK: Closures
    
    var updateTitleClosure: ((_ title: String) -> Void)?
    var updateActionTitleClosure: ((_ title: String) -> Void)?
    var fieldsIncorrectClosure: (() -> Void)?
    var buttonActionClosure: ((_ isAddMode: Bool) -> Void)?
    var addCocktailClosure: ((_ cocktail: CocktailItem) -> Void)?
    var editCocktailClosure: ((_ cocktail: CocktailItem?) -> Void)?
    var serverErrorClosure: ((_ error: Error?) -> Void)?
    
    // MARK: Properties
    
    let apiService: AddCocktailServiceProtocol
    
    var cocktailItem: CocktailItem? {
        didSet {
            self.updateTitleClosure?(cocktailItem?.name ?? "add_cocktail".localized)
            self.updateActionTitleClosure?(cocktailItem == nil ? "add".localized : "save".localized)
            self.buttonActionClosure?(cocktailItem==nil)
        }
    }
    
    // MARK: Constructor
    
    init(apiService: AddCocktailServiceProtocol = AddCocktailService()) {
        self.apiService = apiService
    }
    
    // MARK: Public methods
    
    func postCocktail(cocktail: CocktailItem) {
        let isEditMode = cocktail.id != nil
        if cocktail.isValid() {
            apiService.addCocktail(cocktailItem: cocktail, complete: { [weak self] (success, newCocktail, error) in
                if success {
                    if isEditMode {
                        self?.editCocktailClosure?(newCocktail)
                    } else {
                        guard let nonNullCocktail = newCocktail else {
                            self?.serverErrorClosure?(error)
                            return
                        }
                        self?.addCocktailClosure?(nonNullCocktail)
                    }
                } else {
                    self?.serverErrorClosure?(error)
                }
            })
        } else {
            fieldsIncorrectClosure?()
        }
    }
}
