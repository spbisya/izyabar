//
//  DataSource.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/11/21.
//

import Foundation
import UIKit

final class DataSource: NSObject {
    
    var items: [String] = []
    private let gridDelegate = DefaultGriddedContentCollectionViewDelegate()
    
    func attach(to view: UICollectionView) {
        // Setup itself as table data source (Implementation in separated extension)
        view.dataSource = self
        view.register(UINib(nibName:"CocktailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CocktailCollectionViewCell.identifier)
        view.delegate = gridDelegate
    }
    
}

extension DataSource: UICollectionViewDataSource {
    
    // Return elements count that must be displayed in table
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // Instantiate or reused (depend on position and cell type in table view), configure cell element and return it for displaying on table
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CocktailCollectionViewCell.identifier, for: indexPath) as! CocktailCollectionViewCell
        cell.cocktailNameLabel.text = item
        return cell
    }
}

class DefaultGriddedContentCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    let sectionInsets = UIEdgeInsets(top: 25.0, left: 8.0, bottom: 0.0, right: 8.0)
    private let itemsPerRow: CGFloat = 2
    private let minimumItemSpacing: CGFloat = 6
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left + sectionInsets.right + minimumItemSpacing * (itemsPerRow - 1)
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumItemSpacing
    }
}
