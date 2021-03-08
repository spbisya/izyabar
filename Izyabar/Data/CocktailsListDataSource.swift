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
    
    private var items: [CocktailItem] = []
    private var onCellClickClosure: ( (CocktailItem) -> Void)?
    
    func attach(to view: UICollectionView, onCellClickClosure: @escaping (CocktailItem) -> Void) {
        view.isUserInteractionEnabled = true
        view.dataSource = self
        view.register(UINib(nibName: "CocktailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CocktailCollectionViewCell.identifier)
        
        self.onCellClickClosure = onCellClickClosure
        view.delegate = self
        
        view.isSkeletonable = true
        view.showAnimatedSkeleton()
        IzyabarService.loadCocktails { result in
            self.items = result
            view.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                view.hideSkeleton(transition: .crossDissolve(0.25))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onCellClickClosure?(self.items[indexPath.row])
    }
}

extension CocktailsListDataSource: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return CocktailCollectionViewCell.identifier
    }
    
    // Return elements count that must be displayed in table
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // Instantiate or reused (depend on position and cell type in table view), configure cell element and return it for displaying on table
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CocktailCollectionViewCell.identifier,
            for: indexPath
        ) as? CocktailCollectionViewCell else {
            fatalError("Cell was of the wrong type")
        }
                
        cell.configure(with: item)
        
        return cell
    }
    
}
