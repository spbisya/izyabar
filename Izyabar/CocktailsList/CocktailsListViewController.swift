//
//  ViewController.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/10/21.
//

import UIKit

class CocktailsListViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cocktailsView: UICollectionView!
    
    // MARK: Properties
    
    private let dataSource = CocktailsListDataSource()
    
    // MARK: Lifecycle methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupRightButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "back".localized, style: .plain, target: nil, action: nil)

        UIHelper.setupGradient(for: shadowView)
        
        dataSource.attach(to: cocktailsView) { cocktail in
            self.showCocktailDetailsViewController(with: cocktail)
        }
    }
    
    // MARK: Private methods
    
    private func setupRightButton() {
        let isEditorModeEnabled = AuthDataManager.isEditorModeEnabled()
        let loginButton = UIButton()
        loginButton.setImage(UIImage(named: isEditorModeEnabled ? "AddCocktail" : "Profile"), for: .normal)
        loginButton.contentVerticalAlignment = .fill
        loginButton.contentHorizontalAlignment = .fill
        loginButton.tag = Constants.loginButtonTag
        
        navigationController?.navigationBar.addSubview(loginButton)
        
        let action = isEditorModeEnabled ? #selector(showAddCocktailViewController) : #selector(login)
        loginButton.addTarget(self, action: action, for: .touchUpInside)
        
        UIHelper.applyImageInsetsAndConstraints(for: loginButton, rootView: navigationController?.navigationBar)
    }
    
    @objc private func login() {
        let alertVC = UIAlertController(title: "enter_code_title".localized, message: "enter_code_description".localized, preferredStyle: .alert)
        alertVC.addTextField()
        
        let submitAction = UIAlertAction(title: "login".localized, style: .default) { [unowned alertVC] _ in
            guard let textFields = alertVC.textFields else { return }
            let answerField = textFields[0]
            if answerField.text == Constants.editorPasscode {
                self.enableEditorMode()
            }
        }
        
        alertVC.addAction(submitAction)
        
        present(alertVC, animated: true)
    }
    
    private func enableEditorMode() {
        AuthDataManager.enableEditorMode()
        self.navigationController?.removeRightButton()
        self.setupRightButton()
    }
    
    // MARK: Navigation
    
    private func showCocktailDetailsViewController(with cocktail: CocktailItem) {
        performSegue(withIdentifier: "SegueToCocktailVC", sender: cocktail)
    }
    
    private func showAddCocktailsViewController() {
        performSegue(withIdentifier: "SegueToAddCocktailVC", sender: self)
    }
    
    @objc private func showAddCocktailViewController() {
        showAddCocktailsViewController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cocktailVC = segue.destination as? CocktailDetailsViewController, let cocktail = sender as? CocktailItem {
            cocktailVC.cocktail = cocktail
        } else if let addOrEditCocktailVC = segue.destination as? AddOrEditCocktailViewController {
            addOrEditCocktailVC.returnCocktailDelegate = self
        }
    }
}

extension CocktailsListViewController: AddCocktailDelegate {
    func onCocktailAdded(_ cocktail: CocktailItem) {
        let lastIndex = dataSource.addCocktail(cocktail)
        cocktailsView.reloadData()
        cocktailsView.scrollToItem(at: IndexPath(item: lastIndex, section: 0), at: .centeredVertically, animated: true)

    }
}
