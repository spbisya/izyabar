//
//  DataSource.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/11/21.
//

import Foundation
import UIKit

final class DataSource: NSObject {
    
    var items: [CocktailItem] = []
    private let gridDelegate = GridCollectionViewDelegate()
    private var navigationController: UINavigationController?
    
    func attach(to view: UICollectionView, navigationController: UINavigationController?) {
        // Setup itself as table data source (Implementation in separated extension)
        view.dataSource = self
        view.register(UINib(nibName:"CocktailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CocktailCollectionViewCell.identifier)
        view.delegate = gridDelegate
        self.navigationController = navigationController
    }
    
}

extension DataSource: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Return elements count that must be displayed in table
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // Instantiate or reused (depend on position and cell type in table view), configure cell element and return it for displaying on table
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CocktailCollectionViewCell.identifier, for: indexPath) as! CocktailCollectionViewCell
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showSecondViewController()
    }
    
    @IBAction func showSecondViewController() {
        let storyboard = UIStoryboard(name: "CocktailsList", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "CocktailDetailsViewController")
        navigationController?.show(secondVC, sender: self)
    }
}
