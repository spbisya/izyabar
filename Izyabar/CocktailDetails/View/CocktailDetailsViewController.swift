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
    
    lazy var viewModel: CocktailDetailsViewModel = {
        return CocktailDetailsViewModel()
    }()
    weak var returnChangedCocktailDelegate: EditCocktailDelegate?
    
    // MARK: VC methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.removeRightButton()
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addOrEditCocktailVC = segue.destination as? AddOrEditCocktailViewController {
            addOrEditCocktailVC.cocktailItem = viewModel.cocktailItem
            addOrEditCocktailVC.returnChangedCocktailDelegate = self
        }
    }
    
    // MARK: Private methods
    
    private func setupUI() {
        if #available(iOS 14.0, *) {
            descriptionLabel.lineBreakStrategy = .init()
        }
    }
    
    private func initViewModel() {
        viewModel.heightValueClosure = { [weak self] (height: CGFloat) in
            DispatchQueue.main.async {
                self?.cocktailImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
            }
        }
        
        viewModel.setupCocktailClosure = { [weak self] (cocktail: CocktailItem?) in
            DispatchQueue.main.async {
                self?.setupCocktail(cocktail)
            }
        }
        
        viewModel.editorModeClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.enableEditorMode()
            }
        }
        
        viewModel.checkForCocktail()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupCocktail(_ cocktail: CocktailItem?) {
        if let url = URL(string: cocktail?.imageLarge ?? "") {
            let options = ImageLoadingOptions(transition: .fadeIn(duration: 0.3))
            Nuke.loadImage(with: url, options: options, into: cocktailImageView)
        }
        cocktailNameLabel.text = cocktail?.name
        let isShot = cocktail?.keywords?.contains("shot") == true
        typeOfDrinkLabel.text = isShot ? "shot".localized : "long".localized
        strengthLabel.text = "\(cocktail?.strength ?? 0)"
        descriptionLabel.text = cocktail?.descriptionLarge
    }
    
    private func enableEditorMode() {
        editButton.isHidden = false
        editButton.layoutIfNeeded()
        editButton.addAction(UIAction(handler: { _ in
            self.editCocktail()
        }), for: .touchUpInside)
    }
    
    private func editCocktail() {
        performSegue(withIdentifier: "SegueEditCocktailVC", sender: viewModel.cocktailItem)
    }
}

// MARK: - EditCocktailDelegate

extension CocktailDetailsViewController: EditCocktailDelegate {
    func onCocktailChanged(_ cocktail: CocktailItem) {
        viewModel.cocktailItem = cocktail
        viewModel.setupCocktail()
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
