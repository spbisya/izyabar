//
//  CocktailsProvider.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/17/21.
//

import Foundation
import UIKit

struct CocktailsProvider {
    
    static func provideCocktails() -> [CocktailItem]{
        return [
            CocktailItem(
                image: UIImage(named: "absintheMohito"),
                name: "Absinthe Mohito",
                description: "Mint, Lemonade"
            ),
            CocktailItem(
                image: UIImage(named: "blueLady"),
                name: "Blue Lady",
                description: "Blue Curacao, Egg white"
            ),
            CocktailItem(
                image: UIImage(named: "ginBasilSmash"),
                name: "Gin Basil Smash",
                description: "Sour, Refreshing"
            ),
            CocktailItem(
                image: UIImage(named: "blueLagoon"),
                name: "Blue Lagoon",
                description: "Sweet, Vodka"
            ),
            CocktailItem(
                image: UIImage(named: "electricLemonade"),
                name: "Electric Lemonade",
                description: "Sprite, Sweet"
            ),
            CocktailItem(
                image: UIImage(named: "pineappleMartini"),
                name: "Pineapple Martini",
                description: "Tropical, Vodka"
            ),
            CocktailItem(
                image: UIImage(named: "blueKamikaze"),
                name: "Blue Kamikaze",
                description: "Shot, Vodka"
            )
        ]
    }
}
