//
//  DataSource.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/11/21.
//

import Foundation
import UIKit
import SkeletonView

final class CocktailsListDataSource: NSObject {
    
    // MARK: Properties
    
    private var items: [CocktailItem] = []
    private var stopListIds: [Int] = []
    private var onCellClickClosure: ( (CocktailItem) -> Void)?
    
    // MARK: Public methods
    
    func attach(to view: UICollectionView, onCellClickClosure: @escaping (CocktailItem) -> Void) {
        view.isUserInteractionEnabled = true
        view.dataSource = self
        view.register(UINib(nibName: "CocktailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CocktailCollectionViewCell.identifier)
        
        self.onCellClickClosure = onCellClickClosure
        view.delegate = self
    }
    
    func handleCocktails(_ cocktails: [CocktailItem]) {
        self.items = cocktails
        reloadCocktailsWithStopList()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onCellClickClosure?(self.items[indexPath.row])
    }
    
    func addCocktail(_ cocktailItem: CocktailItem) -> Int {
        items.append(cocktailItem)
        return items.count - 1
    }
    
    func updateCocktail(with cocktail: CocktailItem) -> Int {
        guard let existingCocktailIndex = items.firstIndex(where: {$0.id == cocktail.id}) else {
            return -1
        }
        items[existingCocktailIndex] = cocktail
        return existingCocktailIndex
    }
    
    func deleteCocktail(for cocktailId: Int) -> Int {
        guard let indexToDelete = items.firstIndex(where: {$0.id == cocktailId}) else {
            return -1
        }
        items.remove(at: indexToDelete)
        return indexToDelete
    }
    
    func updateStopList(with ids: [Int]) {
        stopListIds = ids
        reloadCocktailsWithStopList()
    }
    
    func reloadCocktailsWithStopList() {
        let disabledCocktails = items.filter { cocktail in
            return stopListIds.contains(cocktail.id ?? 0)
        }
        items.removeAll { cocktail in
            return stopListIds.contains(cocktail.id ?? 0)
        }
        items.append(contentsOf: disabledCocktails)
    }
    
    func cocktailAt(index: Int) -> CocktailItem? {
        return index < items.count ? items[index] : nil
    }
}

// MARK: - SkeletonCollectionViewDataSource

extension CocktailsListDataSource: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return CocktailCollectionViewCell.identifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let isInStopList = stopListIds.contains(item.id ?? 0)
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CocktailCollectionViewCell.identifier,
            for: indexPath
        ) as? CocktailCollectionViewCell else {
            fatalError("Cell was of the wrong type")
        }
        
        cell.configure(with: item, isInStopList)
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CocktailsListDataSource: UICollectionViewDelegateFlowLayout {
    
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

// MARK: - GridCollectionViewConstants

private enum GridCollectionViewConstants {
    static let sectionInsets = UIEdgeInsets(top: 25.0, left: 8.0, bottom: 0.0, right: 8.0)
    static let itemsPerRow: CGFloat = 2
    static let minimumItemSpacing: CGFloat = 6
    static let minimumLineSpacing: CGFloat = 15
}
