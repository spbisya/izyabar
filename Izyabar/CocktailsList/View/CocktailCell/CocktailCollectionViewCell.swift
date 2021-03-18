//
//  CocktailCollectionViewCell.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/15/21.
//

import UIKit
import Foundation
import Nuke

class CocktailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cocktailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var wasShadowInitialized = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isUserInteractionEnabled = true
        
        cocktailImageView.layer.cornerRadius = 10
        cocktailImageView.clipsToBounds = true
        
        if #available(iOS 14.0, *) {
            descriptionLabel.lineBreakStrategy = .init()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !wasShadowInitialized {
            shadowView.layoutIfNeeded()
            createShadow()
            wasShadowInitialized = true
        }
    }
    
    private func createShadow() {
        shadowView.clipsToBounds = false
        shadowView.layer.cornerRadius = 10
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = 2
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: cocktailImageView.bounds, cornerRadius: 10).cgPath
    }
    
    func configure(with cocktailItem: CocktailItem, _ isInStopList: Bool) {
        cocktailImageView.image = nil
        if let url = URL(string: cocktailItem.image ?? "") {
            shadowView.isHidden = true
            Nuke.loadImage(with: url, into: cocktailImageView, completion: { (result: Result<ImageResponse, ImagePipeline.Error>) in
                self.shadowView.isHidden = false
                if isInStopList {
                    guard let currentImage = try? result.get().image.grayScaleImage() else { return }
                    self.cocktailImageView.image = currentImage
                }
            })
        }
        nameLabel.text = cocktailItem.name
        descriptionLabel.text = cocktailItem.descriptionShort
        
        nameLabel.alpha = isInStopList ? 0.5 : 1
        descriptionLabel.alpha = isInStopList ? 0.5 : 1
    }
    
    class var identifier: String { return "CocktailCollectionViewCell" }
    
}
