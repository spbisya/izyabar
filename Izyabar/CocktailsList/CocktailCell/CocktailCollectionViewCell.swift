//
//  CocktailCollectionViewCell.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/15/21.
//

import UIKit

class CocktailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cocktailNameLabel: UILabel!
    @IBOutlet weak var cocktailImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    
    private var wasShadowInitialized = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cocktailImageView.layer.cornerRadius = 10
        cocktailImageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(!wasShadowInitialized){
            shadowView.layoutIfNeeded()
            createShadow()
            wasShadowInitialized = true
        }
    }
    
    private func createShadow(){
        shadowView.clipsToBounds = false
        shadowView.layer.cornerRadius = 10
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = 2
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: cocktailImageView.bounds, cornerRadius: 10).cgPath
    }
    
    class var identifier: String { return "CocktailCollectionViewCell" }
    
}
