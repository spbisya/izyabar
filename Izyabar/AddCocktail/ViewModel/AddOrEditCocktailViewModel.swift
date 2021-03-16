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
    var buttonActionClosure: ((_ isAddMode: Bool) -> Void)?
    var addCocktailClosure: ((_ cocktail: CocktailItem) -> Void)?
    var editCocktailClosure: ((_ cocktail: CocktailItem) -> Void)?
    var errorClosure: ((_ error: CocktailError) -> Void)?
    var setupCocktailClosure: ((_ cocktail: CocktailItem) -> Void)?
    var deleteCocktailClosure: (() -> Void)?
    
    // MARK: Properties
    
    let cocktailService: CocktailServiceProtocol
    
    var cocktailItem: CocktailItem? {
        didSet {
            self.updateTitleClosure?(cocktailItem?.name ?? "add_cocktail".localized)
            self.updateActionTitleClosure?(cocktailItem == nil ? "add".localized : "save".localized)
            self.buttonActionClosure?(cocktailItem==nil)
            guard let nonNullCocktail = cocktailItem else {
                return
            }
            self.setupCocktailClosure?(nonNullCocktail)
        }
    }
    
    // MARK: Constructor
    
    init(cocktailService: CocktailServiceProtocol = CocktailService()) {
        self.cocktailService = cocktailService
    }
    
    // MARK: Public methods
    
    func postCocktail(cocktail: CocktailItem) {
        let isEditMode = cocktail.id != nil
        if cocktail.isValid() {
            cocktailService.addCocktail(cocktailItem: cocktail, complete: { [weak self] (newCocktail, error) in
                guard let nonNullCocktail = newCocktail else {
                    self?.errorClosure?(CocktailError.generateError(for: error))
                    return
                }
                if isEditMode {
                    self?.editCocktailClosure?(nonNullCocktail)
                } else {
                    self?.addCocktailClosure?(nonNullCocktail)
                }
            })
        } else {
            self.errorClosure?(CocktailError.fieldValidationError)
        }
    }
    
    func deleteCocktail(withId cocktailId: Int) {
        cocktailService.deleteCocktail(cocktailId: cocktailId, complete: { [weak self] (success, error) in
            if success {
                self?.deleteCocktailClosure?()
            } else {
                self?.errorClosure?(CocktailError.generateError(for: error))
            }
        })
    }
}
