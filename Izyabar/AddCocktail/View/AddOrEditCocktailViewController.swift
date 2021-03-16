//
//  AddOrEditCocktailViewController.swift
//  Izyabar
//
//  Created by Izya on 10.03.2021.
//

import UIKit

class AddOrEditCocktailViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageUrlTf: UITextField!
    @IBOutlet weak var cocktailNameTf: UITextField!
    @IBOutlet weak var shortDescriptionTf: UITextField!
    @IBOutlet weak var largeDescriptionTv: UITextView!
    @IBOutlet weak var strengthTf: UITextField!
    @IBOutlet weak var keywordsTf: UITextField!
    @IBOutlet weak var saveBt: UIButton!
    @IBOutlet weak var deleteBt: UIButton!
    
    // MARK: Properties
    
    var cocktailItem: CocktailItem?
    weak var returnCocktailDelegate: AddCocktailDelegate?
    weak var returnChangedCocktailDelegate: EditCocktailDelegate?
    
    private lazy var viewModel: AddOrEditCocktailViewModel = {
        return AddOrEditCocktailViewModel()
    }()
    private var oldBackground: UIImage?
    private var oldShadow: UIImage?
    
    // MARK: Lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        setupUI()
    }
    
    // MARK: Private methods
    
    private func initViewModel() {
        viewModel.updateTitleClosure = { [weak self] (title: String) in
            DispatchQueue.main.async {
                self?.title = title
            }
        }
        
        viewModel.updateActionTitleClosure = { [weak self] (title: String) in
            DispatchQueue.main.async {
                self?.saveBt.setTitle(title, for: .normal)
            }
        }
        
        viewModel.addCocktailClosure = { [weak self] (cocktailItem: CocktailItem) in
            DispatchQueue.main.async {
                self?.returnNewCocktail(cocktailItem)
            }
        }
        
        viewModel.editCocktailClosure = { [weak self] (cocktailItem: CocktailItem) in
            DispatchQueue.main.async {
                self?.returnChangedCocktail(cocktailItem)
            }
        }
        
        viewModel.errorClosure = { (error: CocktailError) in
            DispatchQueue.main.async {
                self.showErrorDialogFor(error)
            }
        }
        
        viewModel.setupCocktailClosure = { [weak self] (cocktailItem: CocktailItem) in
            DispatchQueue.main.async {
                self?.setupCocktailUI(for: cocktailItem)
            }
        }
        
        viewModel.deleteCocktailClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.handleDeletedCocktail()
            }
        }
        
        viewModel.cocktailItem = cocktailItem
    }
    
    private func setupUI() {
        setupSaveButton()
        setupLargeDescriptionTv()
        
        largeDescriptionTv.superview?.subviews.forEach { view in
            if let editText = view as? UITextField {
                editText.delegate = self
            }
        }
        setupKeyboardBehaviour()
        
        saveBt.addAction(UIAction(handler: { _ in
            self.sendCocktail()
        }), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.removeRightButton()
        oldBackground = self.navigationController?.navigationBar.backgroundImage(for: .default)
        oldShadow = self.navigationController?.navigationBar.shadowImage
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    private func setupKeyboardBehaviour() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let insets = KeyboardContentInsetsBuilder.buildInsetsFor(view: view, notification: notification) else { return }
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    private func setupSaveButton() {
        saveBt.layer.cornerRadius = 5
    }
    
    private func setupLargeDescriptionTv() {
        largeDescriptionTv.layer.borderColor = UIColor.lightGray.cgColor
        largeDescriptionTv.layer.borderWidth = 0.2
        largeDescriptionTv.layer.cornerRadius = 5
        
        largeDescriptionTv.delegate = self
        self.textViewDidEndEditing(largeDescriptionTv)
        
        let inset = largeDescriptionTv.textContainerInset
        largeDescriptionTv.textContainerInset = UIEdgeInsets(top: inset.top + 0.5, left: inset.left, bottom: inset.bottom + 0.5, right: inset.right)
    }
    
    private func buildCocktailItem() -> CocktailItem {
        return CocktailItem(
            id: cocktailItem?.id,
            name: cocktailNameTf.text,
            image: imageUrlTf.text,
            imageLarge: imageUrlTf.text?.replacingOccurrences(of: ".png", with: "_large.png"),
            descriptionShort: shortDescriptionTf.text,
            descriptionLarge: largeDescriptionTv.text == "placeholder_description_large".localized ? nil : largeDescriptionTv.text,
            strength: Int(strengthTf.text ?? "0"),
            keywords: keywordsTf.text?.components(separatedBy: " ")
        )
    }
    
    private func sendCocktail() {
        viewModel.postCocktail(cocktail: buildCocktailItem())
    }
    
    private func returnNewCocktail(_ cocktail: CocktailItem) {
        returnCocktailDelegate?.onCocktailAdded(cocktail)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func returnChangedCocktail(_ cocktail: CocktailItem) {
        returnChangedCocktailDelegate?.onCocktailChanged(cocktail)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupCocktailUI(for cocktail: CocktailItem) {
        cocktailNameTf.text = cocktail.name
        imageUrlTf.text = cocktail.image
        shortDescriptionTf.text = cocktail.descriptionShort
        largeDescriptionTv.text = cocktail.descriptionLarge
        strengthTf.text = String(describing: cocktail.strength ?? 0)
        keywordsTf.text = cocktail.keywords?.joined(separator: " ")
        
        self.textViewDidEndEditing(largeDescriptionTv)
        
        deleteBt.isHidden = false
        deleteBt.layoutIfNeeded()
        deleteBt.addAction(UIAction(handler: { _ in
            self.requestToDeleteCocktail()
        }), for: .touchUpInside)
    }
    
    private func requestToDeleteCocktail() {
        let alertVC = UIAlertController(
            title: "delete_cocktail_dialog_title".localized,
            message: "delete_cocktail_dialog_message".localized,
            preferredStyle: .alert
        )
        alertVC.addAction(UIAlertAction(title: "no".localized, style: .default, handler: nil))
        alertVC.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { _ in
            self.deleteCocktail()
        }))
        present(alertVC, animated: true)
    }
    
    private func deleteCocktail() {
        guard let cocktailId = cocktailItem?.id else {
            return
        }
        viewModel.deleteCocktail(withId: cocktailId)
    }
    
    private func handleDeletedCocktail() {
        guard let cocktailId = cocktailItem?.id else {
            return
        }
        returnChangedCocktailDelegate?.onCocktailDeleted(forId: cocktailId)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension AddOrEditCocktailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case cocktailNameTf:
            imageUrlTf.becomeFirstResponder()
        case imageUrlTf:
            shortDescriptionTf.becomeFirstResponder()
        case shortDescriptionTf:
            largeDescriptionTv.becomeFirstResponder()
        case strengthTf:
            keywordsTf.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
}

// MARK: - UITextViewDelegate

extension AddOrEditCocktailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(hex: 0xC4C4C6) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "placeholder_description_large".localized
            textView.textColor = UIColor(hex: 0xC4C4C6)
        } else {
            textView.textColor = UIColor.black
        }
    }
}
