//
//  IzyabarService.swift
//  Izyabar
//
//  Created by Izya Pitersky on 2/22/21.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

struct IzyabarService {
    
    static func loadCocktails(result: @escaping ([CocktailItem]) -> Void) {
        AF.request(Config.baseURL+"/cocktails").responseObject { (response: AFDataResponse<Cocktails>) in
            switch response.result {
            case .success(let cocktails):
                result(cocktails.coctails ?? Array())
            case .failure(let error):
                print(error)
                result(Array())
            }
        }
    }
}
