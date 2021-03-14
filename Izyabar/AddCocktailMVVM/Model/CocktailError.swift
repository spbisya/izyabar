//
//  NetworkError.swift
//  Izyabar
//
//  Created by Izya Pitersky on 3/14/21.
//

import Foundation

enum CocktailError: Error {
    
    // MARK: Cases
    
    case networkError(description: String)
    case otherError
    case fieldValidationError
    
    // MARK: Public methods
    
    func title() -> String {
        switch self {
        case .fieldValidationError:
            return "validation_error_title".localized
        default:
            return "error_title".localized
        }
    }
    
    func message() -> String {
        switch self {
        case .networkError(let description):
            return description
        case .otherError:
            return "unknown_error_message".localized
        case .fieldValidationError:
            return "validation_error_message".localized
        }
    }
    
    static func generateError(for possibleError: Error?) -> CocktailError {
        if let description = possibleError?.localizedDescription {
            return CocktailError.networkError(description: description)
        } else {
            return CocktailError.otherError
        }
    }
}
