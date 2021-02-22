//
//  IzyabarService.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/22/21.
//

import Foundation
import Alamofire

struct IzyabarService {
    
    static func loadCocktails(result: @escaping (Array<CocktailItem>) -> Void) {
        AF.request(Config.baseURL+"/cocktails", method: .get, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let json):
                let responseJson = json as! NSDictionary
                let cocktailsList = responseJson.mutableArrayValue(forKey: "cocktails")
                let coctailsParsedList = cocktailsList.map { cocktail in CocktailItem(json: cocktail)}
                result(coctailsParsedList)
            case .failure(let error):
                print(error)
            }
        }
    }
}
