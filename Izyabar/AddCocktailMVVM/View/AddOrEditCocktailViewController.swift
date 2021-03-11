//
//  AddOrEditCocktailViewController.swift
//  Izyabar
//
//  Created by Izya on 10.03.2021.
//

import UIKit

class AddOrEditCocktailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageUrlTf: UITextField!
    @IBOutlet weak var largeImageUrlTf: UITextField!
    @IBOutlet weak var cocktailNameTf: UITextField!
    @IBOutlet weak var shortDescriptionTf: UITextField!
    @IBOutlet weak var largeDescriptionTv: UITextView!
    @IBOutlet weak var strengthTf: UITextField!
    @IBOutlet weak var keywordsTf: UITextField!
    @IBOutlet weak var saveBt: UIButton!
    
    var cocktailItem: CocktailItem?
    
    lazy var viewModel: AddOrEditCocktailViewModel = {
            return AddOrEditCocktailViewModel()
    }()
    
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
    private func setupUI() {
        setupSaveButton()
        setupLargeDescriptionTv()
        
        largeDescriptionTv.superview?.subviews.forEach { view in
            if let editText = view as? UITextField {
                editText.delegate = self
            }
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
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
        
        viewModel.cocktailItem = cocktailItem
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

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
        
        let inset = largeDescriptionTv.textContainerInset
        largeDescriptionTv.textContainerInset = UIEdgeInsets(top: inset.top + 0.5, left: inset.left, bottom: inset.bottom + 0.5, right: inset.right)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case imageUrlTf:
            largeImageUrlTf.becomeFirstResponder()
        case largeImageUrlTf:
            cocktailNameTf.becomeFirstResponder()
        case cocktailNameTf:
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
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        strengthTf.becomeFirstResponder()
        return false
    }
}
