//
//  AuthDataSource.swift
//  Izyabar
//
//  Created by Izya Pitersky on 3/8/21.
//

import Foundation

struct AuthDataManager {
    
    fileprivate static let isEditorModeEnabledStoreKey = "isEditorModeEnabledStoreKey"
    
    static func enableEditorMode() {
        UserDefaults.standard.set(true, forKey: isEditorModeEnabledStoreKey)
    }
    
    static func isEditorModeEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: isEditorModeEnabledStoreKey) 
    }
}
