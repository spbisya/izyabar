//
//  DataSource.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/11/21.
//

import Foundation
import UIKit
import SkeletonView

final class DataSource: NSObject {
    
    private var items: [CocktailItem] = []
    
    private weak var gridDelegate = GridCollectionViewDelegate()
    
    func attach(to view: UICollectionView, onCellClickClosure: @escaping (CocktailItem) -> Void) {
        // Setup itself as table data source (Implementation in separated extension)
        view.isUserInteractionEnabled = true
        view.dataSource = self
        view.register(UINib(nibName: "CocktailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CocktailCollectionViewCell.identifier)
        
        gridDelegate?.attachClickHandler { index in
            onCellClickClosure(self.items[index])
        }
        view.delegate = gridDelegate
        
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
}

extension DataSource: SkeletonCollectionViewDataSource {
    
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
