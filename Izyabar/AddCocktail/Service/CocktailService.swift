//
//  AddCocktailService.swift
//  Izyabar
//
//  Created by 1 on 10.03.2021.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol CocktailServiceProtocol: AnyObject {
    func addCocktail(cocktailItem: CocktailItem, complete: @escaping ( _ cocktail: CocktailItem?, _ error: Error? ) -> Void)
    
    func deleteCocktail(cocktailId: Int, complete: @escaping ( _ success: Bool, _ error: Error? ) -> Void)
}

class CocktailService: CocktailServiceProtocol {
    func addCocktail(cocktailItem: CocktailItem, complete: @escaping (CocktailItem?, Error?) -> Void) {
        AF.request(
            Config.cocktailURL,
            method: .post,
            parameters: cocktailItem,
            encoder: JSONParameterEncoder.default
        ).responseObject { (response: AFDataResponse<CocktailItem>) in
            switch response.result {
            case .success(let createdCocktail):
                complete(createdCocktail, nil)
            case .failure(let error):
                complete(nil, error)
            }
        }
    }
    
    func deleteCocktail(cocktailId: Int, complete: @escaping (Bool, Error?) -> Void) {
        AF.request(Config.cocktailURL+"/\(cocktailId)", method: .delete).responseObject { (response: AFDataResponse<CocktailItem>) in
            switch response.result {
            case .success(_):
                complete(true, nil)
            case .failure(let error):
                complete(false, error)
            }
        }
    }
}
