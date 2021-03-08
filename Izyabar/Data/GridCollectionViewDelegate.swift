//
//  GridCollectionViewDelegate.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/17/21.
//

import Foundation
import UIKit

extension CocktailsListDataSource: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = GridCollectionViewConstants.sectionInsets.left + GridCollectionViewConstants.sectionInsets.right
            + GridCollectionViewConstants.minimumItemSpacing * (GridCollectionViewConstants.itemsPerRow - 1)
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / GridCollectionViewConstants.itemsPerRow
        return CGSize(width: widthPerItem, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return GridCollectionViewConstants.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return GridCollectionViewConstants.minimumItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return GridCollectionViewConstants.minimumLineSpacing
    }
}

private enum GridCollectionViewConstants {
    static let sectionInsets = UIEdgeInsets(top: 25.0, left: 8.0, bottom: 0.0, right: 8.0)
    static let itemsPerRow: CGFloat = 2
    static let minimumItemSpacing: CGFloat = 6
    static let minimumLineSpacing: CGFloat = 15
}
