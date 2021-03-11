//
//  AddOrEditCocktailViewController.swift
//  Izyabar
//
//  Created by Izya on 10.03.2021.
//

import UIKit

class AddOrEditCocktailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageUrlTf: UITextField!
    @IBOutlet weak var largeImageUrlTf: UITextField!
    @IBOutlet weak var cocktailNameTf: UITextField!
    @IBOutlet weak var shortDescriptionTf: UITextField!
    @IBOutlet weak var largeDescriptionTv: UITextView!
    @IBOutlet weak var strengthTf: UITextField!
    @IBOutlet weak var keywordsTf: UITextField!
    @IBOutlet weak var saveBt: UIButton!
    
    // MARK: - Properties
    
    var cocktailItem: CocktailItem?
    weak var returnCocktailDelegate: AddCocktailDelegate?
    
    private lazy var viewModel: AddOrEditCocktailViewModel = {
        return AddOrEditCocktailViewModel()
    }()
    
    // MARK: - Lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.removeRightButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        setupUI()
    }
    
    // MARK: - Private methods
    
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
        
        viewModel.fieldsIncorrectClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.showError(nil)
            }
        }
        
        viewModel.addCocktailClosure = { [weak self] (cocktailItem: CocktailItem) in
            DispatchQueue.main.async {
                self?.returnCocktail(cocktailItem)
            }
        }
        
//        viewModel.editCocktailClosure = { [weak self] (_: CocktailItem?) in
//            DispatchQueue.main.async {
//                // TODO: go back to cocktail details screen
//            }
//        }
        
        viewModel.serverErrorClosure = { [weak self] (error: Error?) in
            DispatchQueue.main.async {
                self?.showError(error)
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
            imageLarge: largeImageUrlTf.text,
            descriptionShort: shortDescriptionTf.text,
            descriptionLarge: largeDescriptionTv.text,
            strength: Int(strengthTf.text ?? "0"),
            keywords: keywordsTf.text?.components(separatedBy: " ")
        )
    }
    
    private func showError(_ error: Error?) {
        // TODO: handle errors correctly
        let alertVC = UIAlertController(
            title: "validation_error_title".localized,
            message: "validation_error_description".localized,
            preferredStyle: .alert
        )
        alertVC.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    private func sendCocktail() {
        viewModel.postCocktail(cocktail: buildCocktailItem())
    }
    
    private func returnCocktail(_ cocktail: CocktailItem) {
        returnCocktailDelegate?.onCocktailAdded(cocktail)
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
            largeImageUrlTf.becomeFirstResponder()
        case largeImageUrlTf:
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
        }
    }
}
