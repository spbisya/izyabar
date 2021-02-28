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
    
    private let dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupGradient()
        
        dataSource.attach(to: cocktailsView) { cocktail in
            self.showCocktailDetailsController(with: cocktail)
        }
    }
    
    private func setupGradient(){
        let gradient = CAGradientLayer()
        
        gradient.frame = shadowView.bounds
        gradient.colors = [UIColor(red: 241/255, green: 241/255, blue: 243/255, alpha: 1).cgColor, UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor]
        
        shadowView.layer.insertSublayer(gradient, at: 0)
    }
    
    private func showCocktailDetailsController(with cocktail: CocktailItem) {
        let storyboard = UIStoryboard(name: "CocktailsList", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: CocktailDetailsViewController.identifier) as CocktailDetailsViewController
        
        secondVC.cocktailName = cocktail.name

        show(secondVC, sender: self)
    }
}

