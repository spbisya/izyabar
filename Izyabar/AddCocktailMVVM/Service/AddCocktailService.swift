//
//  AddCocktailService.swift
//  Izyabar
//
//  Created by 1 on 10.03.2021.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol AddCocktailServiceProtocol: AnyObject {
    func addCocktail(cocktailItem: CocktailItem, complete: @escaping ( _ success: Bool, _ cocktail: CocktailItem?, _ error: Error? ) -> Void)
}

class AddCocktailService: AddCocktailServiceProtocol {
    func addCocktail(cocktailItem: CocktailItem, complete: @escaping (Bool, CocktailItem?, Error?) -> Void) {
        AF.request(
            Config.addCocktailURL,
            method: .post,
            parameters: cocktailItem,
            encoder: JSONParameterEncoder.default
        ).responseObject { (response: AFDataResponse<CocktailItem>) in
            switch response.result {
            case .success(let createdCocktail):
                complete(true, createdCocktail, nil)
            case .failure(let error):
                complete(false, nil, error)
            }
        }
    }
}
