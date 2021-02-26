//
//  GridCollectionViewDelegate.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/17/21.
//

import Foundation
import UIKit

class GridCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    let sectionInsets = UIEdgeInsets(top: 25.0, left: 8.0, bottom: 0.0, right: 8.0)
    private let itemsPerRow: CGFloat = 2
    private let minimumItemSpacing: CGFloat = 6
    private let minimumLineSpacing: CGFloat = 15
    
    private var onCellClickClosure: ((_ index: Int) -> Void)? = nil
    
    func attachClickHandler(onCellClickClosure: @escaping (_ index: Int) -> Void){
        self.onCellClickClosure = onCellClickClosure
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onCellClickClosure?(indexPath.row)
    }
}
