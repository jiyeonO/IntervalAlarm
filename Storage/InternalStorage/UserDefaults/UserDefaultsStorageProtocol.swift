//
//  UserDefaultsStorageProtocol.swift
//  InternalStorage
//
//  Created by 오지연 on 11/22/24.
//
import Foundation

public protocol UserDefaultsStorageKey: RawRepresentable { }

public protocol UserDefaultsStorageProtocol: AnyObject {
    
    associatedtype K: UserDefaultsStorageKey where K.RawValue == String
    
    var standard: UserDefaults { get }
    func loadObject<T: Decodable>(_ key: K) -> T?
    func loadObjects<T: Decodable>(_ key: K) -> [T]?
    func saveObject<T: Encodable>(_ newValue: T?, key: K)
    func saveObjects<T: Encodable>(_ newValue: [T]?, key: K)
    func deleteObject(_ key: K)
    
    subscript<T>(key: K) -> T? { get set }
    
}

public extension UserDefaultsStorageProtocol {
    
    func loadObject<T: Decodable>(_ key: K) -> T? {
        guard
            let savedData = standard.object(forKey: key.rawValue) as? Data,
            let loadedData = try? JSONDecoder().decode(T.self, from: savedData)
            else { return nil }
        return loadedData
    }
    
    func loadObjects<T: Decodable>(_ key: K) -> [T]? {
        guard
            let savedData = standard.object(forKey: key.rawValue) as? Data,
            let loadedData = try? JSONDecoder().decode([T].self, from: savedData)
            else { return nil }
        return loadedData
    }
    
    func saveObject<T: Encodable>(_ newValue: T?, key: K) {
        if let encoded = try? JSONEncoder().encode(newValue) {
            standard.set(encoded, forKey: key.rawValue)
        } else {
            standard.set(nil, forKey: key.rawValue)
        }
    }
    
    func saveObjects<T: Encodable>(_ newValue: [T]?, key: K) {
        if let encoded = try? JSONEncoder().encode(newValue) {
            standard.set(encoded, forKey: key.rawValue)
        } else {
            standard.set(nil, forKey: key.rawValue)
        }
    }
    
    func deleteObject(_ key: K) {
        standard.set(nil, forKey: key.rawValue)
    }
    
    subscript<T>(key: K) -> T? {
        get { return standard.object(forKey: key.rawValue) as? T }
        set { standard.set(newValue, forKey: key.rawValue) }
    }
    
}
