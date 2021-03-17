//
//  StopListService.swift
//  Izyabar
//
//  Created by Izya Pitersky on 3/17/21.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol StopListServiceProtocol: AnyObject {
    func loadStopList(complete: @escaping ( _ stopListCocktailsIds: [Int]?, _ error: Error? ) -> Void)
    
    func addCocktailToStopList(cocktailId: Int, complete: @escaping ( _ success: Bool, _ error: Error? ) -> Void)
    
    func removeCocktailFromStopList(cocktailId: Int, complete: @escaping ( _ success: Bool, _ error: Error? ) -> Void)
}

class StopListService: StopListServiceProtocol {
    func loadStopList(complete: @escaping ([Int]?, Error?) -> Void) {
        AF.request(Config.stopListURL).responseObject { (response: AFDataResponse<StopList>) in
            switch response.result {
            case .success(let stopList):
                complete(stopList.ids ?? [], nil)
            case .failure(let error):
                complete(nil, error)
            }
        }
    }
    
    func addCocktailToStopList(cocktailId: Int, complete: @escaping (Bool, Error?) -> Void) {
        AF.request(
            Config.addToStopListURL,
            method: .post,
            parameters: StopListPostModel(id: cocktailId),
            encoder: JSONParameterEncoder.default
        ).responseObject { (response: AFDataResponse<StopListChangedModel>) in
            switch response.result {
            case .success(let successModel):
                complete(successModel.success == true, nil)
            case .failure(let error):
                complete(false, error)
            }
        }
    }
    
    func removeCocktailFromStopList(cocktailId: Int, complete: @escaping (Bool, Error?) -> Void) {
        AF.request(
            Config.removeFromStopListURL,
            method: .post,
            parameters: StopListPostModel(id: cocktailId),
            encoder: JSONParameterEncoder.default
        ).responseObject { (response: AFDataResponse<StopListChangedModel>) in
            switch response.result {
            case .success(let successModel):
                complete(successModel.success == true, nil)
            case .failure(let error):
                complete(false, error)
            }
        }
    }
}
