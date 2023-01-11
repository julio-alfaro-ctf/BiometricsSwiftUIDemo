//
//  StorageManager.swift
//  BiometricsDemo
//
//  Created by Julio Rico on 11/1/23.
//

import Foundation

protocol LocalStoreProtocol {
    func save<T>(value: T, for key: String)
    func get<T>(for key: String) -> T?
    func remove(for key: String)
}


final class StoreManager: LocalStoreProtocol {
    func save<T>(value: T, for key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func get<T>(for key: String) -> T? {
        UserDefaults.standard.object(forKey: key) as? T
    }
    
    func remove(for key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
