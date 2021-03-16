//
//  CocktailDetailViewController.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/20/21.
//

import UIKit
import Nuke

class CocktailDetailsViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var cocktailImageView: UIImageView!
    @IBOutlet weak var cocktailNameLabel: UILabel!
    @IBOutlet weak var typeOfDrinkLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    // MARK: Properties
    
    var cocktail: CocktailItem!
    weak var returnChangedCocktailDelegate: EditCocktailDelegate?
    
    // MARK: VC methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.removeRightButton()
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 14.0, *) {
            descriptionLabel.lineBreakStrategy = .init()
        }
        
        setupCocktail()
        
        if AuthDataManager.isEditorModeEnabled() {
            enableEditorMode()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addOrEditCocktailVC = segue.destination as? AddOrEditCocktailViewController {
            addOrEditCocktailVC.cocktailItem = cocktail
            addOrEditCocktailVC.returnChangedCocktailDelegate = self
        }
    }
    
    // MARK: Private methods
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupCocktail() {
        if let url = URL(string: cocktail.image ?? "") {
            Nuke.loadImage(with: url, into: cocktailImageView)
        }
        cocktailNameLabel.text = cocktail.name
        typeOfDrinkLabel.text = cocktail.keywords?.contains("shot") == true ? "shot".localized : "long".localized
        strengthLabel.text = "\(cocktail.strength ?? 0)"
        descriptionLabel.text = cocktail.descriptionLarge
    }
    
    private func enableEditorMode() {
        editButton.isHidden = false
        editButton.layoutIfNeeded()
        editButton.addAction(UIAction(handler: { _ in
            self.editCocktail()
        }), for: .touchUpInside)
    }
    
    private func editCocktail() {
        performSegue(withIdentifier: "SegueEditCocktailVC", sender: cocktail)
    }
}

// MARK: - EditCocktailDelegate

extension CocktailDetailsViewController: EditCocktailDelegate {
    func onCocktailChanged(_ cocktail: CocktailItem) {
        self.cocktail = cocktail
        setupCocktail()
        returnChangedCocktailDelegate?.onCocktailChanged(cocktail)
    }
    
    func onCocktailDeleted(forId cocktailId: Int) {
        returnChangedCocktailDelegate?.onCocktailDeleted(forId: cocktailId)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension CocktailDetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
