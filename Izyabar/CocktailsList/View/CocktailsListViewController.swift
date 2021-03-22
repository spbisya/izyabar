//
//  ViewController.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/10/21.
//

import UIKit

class CocktailsListViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cocktailsView: UICollectionView!
    
    // MARK: Properties
    
    private let dataSource = CocktailsListDataSource()
    private lazy var viewModel: CocktailsListViewModel = {
        return CocktailsListViewModel()
    }()
    
    // MARK: UIViewController methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupRightButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cocktailVC = segue.destination as? CocktailDetailsViewController, let cocktail = sender as? CocktailItem {
            cocktailVC.viewModel.cocktailItem = cocktail
            cocktailVC.returnChangedCocktailDelegate = self
        } else if let addOrEditCocktailVC = segue.destination as? AddOrEditCocktailViewController {
            addOrEditCocktailVC.returnCocktailDelegate = self
        }
    }
    
    // MARK: Private methods
    
    private func setupUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "back".localized, style: .plain, target: nil, action: nil)
        
        UIHelper.setupGradient(for: shadowView)
        
        dataSource.attach(to: cocktailsView) { cocktail in
            self.showCocktailDetailsViewController(with: cocktail)
        }
        
        setupForceTouch()
    }
    
    private func initViewModel() {
        viewModel.onLoadingStatusChangedClosure = { [weak self] (isLoading: Bool) in
            DispatchQueue.main.async {
                self?.changeLoadingStatus(isLoading)
            }
        }
        
        viewModel.loadCocktailsClosure = { [weak self] (cocktails: [CocktailItem]) in
            DispatchQueue.main.async {
                self?.setupCocktails(cocktails)
            }
        }
        
        viewModel.errorClosure = { (error: CocktailError) in
            DispatchQueue.main.async {
                self.showErrorDialogFor(error) {
                    self.viewModel.loadCocktails()
                }
            }
        }
        
        viewModel.successfulLoginClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.enableEditorMode()
            }
        }
        
        viewModel.loadStopListClosure = { [weak self] (stopList: [Int]) in
            DispatchQueue.main.async {
                self?.updateStopList(with: stopList)
            }
        }
        
        viewModel.loadCocktails()
        viewModel.loadStopList()
    }
    
    private func changeLoadingStatus(_ isLoading: Bool) {
        if isLoading {
            cocktailsView.showAnimatedSkeleton()
        } else {
            cocktailsView.hideSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    private func setupCocktails(_ cocktails: [CocktailItem]) {
        dataSource.handleCocktails(cocktails)
        cocktailsView.reloadData()
    }
    
    private func updateStopList(with ids: [Int]) {
        dataSource.updateStopList(with: ids)
        cocktailsView.reloadData()
    }
    
    private func setupRightButton() {
        let isEditorModeEnabled = AuthDataManager.isEditorModeEnabled()
        let loginButton = UIButton()
        loginButton.setImage(UIImage(named: isEditorModeEnabled ? "AddCocktail" : "Profile"), for: .normal)
        loginButton.contentVerticalAlignment = .fill
        loginButton.contentHorizontalAlignment = .fill
        loginButton.tag = Constants.loginButtonTag
        
        navigationController?.navigationBar.addSubview(loginButton)
        
        let action = isEditorModeEnabled ? #selector(showAddCocktailViewController) : #selector(showLoginAlert)
        loginButton.addTarget(self, action: action, for: .touchUpInside)
        
        UIHelper.applyImageInsetsAndConstraints(for: loginButton, rootView: navigationController?.navigationBar)
    }
    
    @objc private func showLoginAlert() {
        let alertVC = UIAlertController(title: "enter_code_title".localized, message: "enter_code_description".localized, preferredStyle: .alert)
        alertVC.addTextField()
        
        let submitAction = UIAlertAction(title: "login".localized, style: .default) { [unowned alertVC] _ in
            guard let textFields = alertVC.textFields else { return }
            let answerField = textFields[0]
            if answerField.text == Constants.editorPasscode {
                self.viewModel.loginAsEditor()
            }
        }
        
        alertVC.addAction(submitAction)
        
        present(alertVC, animated: true)
    }
    
    private func enableEditorMode() {
        self.navigationController?.removeRightButton()
        self.setupRightButton()
    }
    
    private func reloadDataAndScrollTo(_ index: Int) {
        cocktailsView.reloadData()
        cocktailsView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredVertically, animated: true)
    }
    
    private func setupLongPress() {
//        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
//        longPressGestureRecognizer.minimumPressDuration = 0.5
//        longPressGestureRecognizer.delegate = self
//        longPressGestureRecognizer.delaysTouchesBegan = true
//        self.cocktailsView?.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    private func setupForceTouch() {
        let forceGestureRecognizer = ForceGestureRecognizer(forceThreshold: CGFloat(4))
        forceGestureRecognizer.delegate = self
        forceGestureRecognizer.addTarget(self, action: #selector(handleForceTouch))
        self.cocktailsView?.addGestureRecognizer(forceGestureRecognizer)
    }
    
    @objc private func handleForceTouch(gestureRecognizer: ForceGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizer.State.changed {
            return
        }
        gestureRecognizer.state = .ended
        
        let point = gestureRecognizer.location(in: self.cocktailsView)
        
        guard let indexPath = (self.cocktailsView?.indexPathForItem(at: point)),
              let cocktail = dataSource.cocktailAt(index: indexPath.row) else { return }
        print(cocktail.name ?? "unknown name")
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
}

// MARK: - AddCocktailDelegate

extension CocktailsListViewController: AddCocktailDelegate {
    func onCocktailAdded(_ cocktail: CocktailItem) {
        let lastIndex = dataSource.addCocktail(cocktail)
        reloadDataAndScrollTo(lastIndex)
    }
}

// MARK: - EditCocktailDelegate

extension CocktailsListViewController: EditCocktailDelegate {
    func onCocktailChanged(_ cocktail: CocktailItem) {
        let indexOfCocktail = dataSource.updateCocktail(with: cocktail)
        reloadDataAndScrollTo(indexOfCocktail)
    }
    
    func onCocktailDeleted(forId cocktailId: Int) {
        let deletedCocktailIndex = dataSource.deleteCocktail(for: cocktailId)
        cocktailsView.deleteItems(at: [IndexPath(item: deletedCocktailIndex, section: 0)])
    }
    
}
