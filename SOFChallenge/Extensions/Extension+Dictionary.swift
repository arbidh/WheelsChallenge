//
//  Extension+Dictionary.swift
//  SOFChallenge
//
//  Created by Arbi on 01/10/2019.
//  Copyright © 2019 org.code.ios.com. All rights reserved.
//

import Foundation

extension Dictionary where Key == String {
    
    func stringForKey(key: String) -> String {
        if let string = self[key] as? String {
            return string
        }
        if let number = self[key] as? NSNumber {
            return number.stringValue
        }
        return ""
    }
    
    func intForKey(key: String) -> Int {
        if let intValue = self[key] as? Int {
            return intValue
        }
        if let intValue = Int(self.stringForKey(key: key)) {
            return intValue
        }
        return 0
    }
    
    func floatForKey(key: String) -> Float {
        guard let value = self[key] as? Float else {
            let strValue = self.stringForKey(key: key) as NSString
            return Float(strValue.floatValue)
        }
        return value
    }
    
    func boolForKey(key: String) -> Bool {
        guard let value = self[key] as? Bool else {
            return false
        }
        return value
    }
    
    func dateForKey(key: String, format: String = "yyyy-MM-dd'T'HH:mm:ssxxxxx") -> Date? {
        guard let dateString = self[key] as? String else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from:dateString)
    }
    
    func arrayForKey(key: String) -> [Any] {
        guard let value = self[key] as? [Any] else {
            return []
        }
        return value
    }
    
    func jsonDictionaryForKey(key: String) -> [String: Any]? {
        guard let value = self[key] as? [String: Any] else {
            return nil
        }
        return value
    }
    
    func enumForKey<E: RawRepresentable>(key: String) -> E? {
        guard let rawValue = self[key] as? E.RawValue else {
            return nil
        }
        return E(rawValue: rawValue)
    }
}
