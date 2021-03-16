//
//  CocktailDetailsViewModel.swift
//  Izyabar
//
//  Created by Izya Pitersky on 3/16/21.
//

import Foundation
import UIKit

class CocktailDetailsViewModel {
    
    // MARK: Closures
    
    var heightValueClosure: ((_ height: CGFloat) -> Void)?
    var setupCocktailClosure: ((_ cocktail: CocktailItem?) -> Void)?
    var editorModeClosure: (() -> Void)?
    
    // MARK: Properties
    
    var cocktailItem: CocktailItem?
    
    // MARK: Public methods
    
    func checkForCocktail() {
        self.calculateImageViewHeight()
        self.setupCocktail()
        self.checkForEditorMode()
    }
    
    func setupCocktail() {
        self.setupCocktailClosure?(self.cocktailItem)
    }
    
    // MARK: Private methods
    
    private func calculateImageViewHeight() {
        let screenSize = UIScreen.main.bounds
        let imageViewHeight = CGFloat(screenSize.width / 1.21)
        self.heightValueClosure?(imageViewHeight)
    }
    
    private func checkForEditorMode() {
        if AuthDataManager.isEditorModeEnabled() {
            self.editorModeClosure?()
        }
    }
}
