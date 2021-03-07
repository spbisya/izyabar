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
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var cocktail: CocktailItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeRightButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        if #available(iOS 14.0, *) {
            descriptionLabel.lineBreakStrategy = .init()
        }
        
        if let url = URL(string: cocktail.image ?? "") {
            Nuke.loadImage(with: url, into: cocktailImageView)
        }
        cocktailNameLabel.text = cocktail.name
        typeOfDrinkLabel.text = cocktail.keywords?.contains("short") == true ? "Short" : "Long"
        strengthLabel.text = "\(cocktail.strength ?? 0)"
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func removeRightButton() {
        guard let subviews = self.navigationController?.navigationBar.subviews else { return }
        subviews.forEach { view in
            if view.tag == Constants.loginButtonTag {
                view.removeFromSuperview()
            }
        }
    }
}
