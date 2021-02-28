//
//  CocktailDetailViewController.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/20/21.
//

import UIKit
import Nuke

class CocktailDetailsViewController: UIViewController {
    
    @IBOutlet weak var cocktailImageView: UIImageView!
    @IBOutlet weak var cocktailNameLabel: UILabel!
    @IBOutlet weak var typeOfDrinkLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    
    var cocktail: CocktailItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        if let url = URL(string: cocktail.image ?? "") {
            Nuke.loadImage(with: url, into: cocktailImageView)
        }
        cocktailNameLabel.text = cocktail.name
        typeOfDrinkLabel.text = cocktail.keywords?.contains("short") == true ? "Short" : "Long"
        strengthLabel.text = "\(cocktail.strength ?? 0)"
    }
    
    private func setupNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
