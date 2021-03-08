//
//  ViewController.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/10/21.
//

import UIKit

class CocktailsListViewController: UIViewController {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cocktailsView: UICollectionView!
    
    private let dataSource = CocktailsListDataSource()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addLoginButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        UIHelper.setupGradient(for: shadowView)
        
        dataSource.attach(to: cocktailsView) { cocktail in
            self.showCocktailDetailsController(with: cocktail)
        }
    }
    
    private func addLoginButton() {
        let loginButton = UIButton()
        loginButton.setImage(UIImage(named: "Profile"), for: .normal)
        loginButton.contentVerticalAlignment = .fill
        loginButton.contentHorizontalAlignment = .fill
        loginButton.tag = Constants.loginButtonTag
        
        navigationController?.navigationBar.addSubview(loginButton)
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        UIHelper.applyImageInsetsAndConstraints(for: loginButton, rootView: navigationController?.navigationBar)
    }
    
    @objc private func login() {
        let alertVC = UIAlertController(title: "enter_code_title".localized, message: "enter_code_description".localized, preferredStyle: .alert)
        alertVC.addTextField()
        
        let submitAction = UIAlertAction(title: "login".localized, style: .default) { [unowned alertVC] _ in
            guard let textFields = alertVC.textFields else { return }
            let answerField = textFields[0]
            if answerField.text == Constants.editorPasscode {
                print("yes")
                // TODO: add saving Editor's mode to prefs
            }
        }
        
        alertVC.addAction(submitAction)
        
        present(alertVC, animated: true)
    }
    
    // MARK: - Navigation
    private func showCocktailDetailsController(with cocktail: CocktailItem) {
        performSegue(withIdentifier: "SegueToCocktailVC", sender: cocktail)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cocktailVC = segue.destination as? CocktailDetailsViewController, let cocktail = sender as? CocktailItem {
            cocktailVC.cocktail = cocktail
        }
    }
}
