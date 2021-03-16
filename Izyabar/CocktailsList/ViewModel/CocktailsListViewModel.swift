//
//  CocktailsListViewModel.swift
//  Izyabar
//
//  Created by Izya Pitersky on 3/16/21.
//

import Foundation

class CocktailsListViewModel {
    
    // MARK: Closures
    
    var onLoadingStatusChangedClosure: ((_ isLoading: Bool) -> Void)?
    var loadCocktailsClosure: ((_ cocktails: [CocktailItem]) -> Void)?
    var errorClosure: ((_ error: CocktailError) -> Void)?
    var successfulLoginClosure: (() -> Void)?
    
    // MARK: Properties
    
    private let cocktailService: CocktailServiceProtocol
    
    // MARK: Constructor
    
    init(cocktailService: CocktailServiceProtocol = CocktailService()) {
        self.cocktailService = cocktailService
    }
    
    // MARK: Public methods
    
    func loadCocktails() {
        self.onLoadingStatusChangedClosure?(true)
        cocktailService.loadCocktails(complete: { [weak self] (cocktails, error) in
            guard let nonNullCocktails = cocktails else {
                self?.errorClosure?(CocktailError.generateError(for: error))
                return
            }
            self?.loadCocktailsClosure?(nonNullCocktails)
            self?.onLoadingStatusChangedClosure?(false)
        })
    }
    
    func loginAsEditor() {
        AuthDataManager.enableEditorMode()
        self.successfulLoginClosure?()
    }
}
