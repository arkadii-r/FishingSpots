//
//  FieldValidation.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 22.03.2026.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        guard !isEmpty else { return false }
        let trimmedEmail = trimmingCharacters(in: .whitespacesAndNewlines)
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let range = NSRange(trimmedEmail.startIndex..<trimmedEmail.endIndex, in: trimmedEmail)
        
        guard
            let matches = detector?.matches(
                in: trimmedEmail,
                options: [],
                range: range
            ),
            let match = matches.first,
            matches.count == 1,
            let url = match.url,
            url.scheme == "mailto",
            match.range == range,
            let urlStr = url.absoluteString.split(separator: ".").last,
            urlStr.count > 1
        else {
            return false
        }
        
        return true
    }
    
    var isValidEmailOrEmpty: Bool {
        return isValidEmail || isEmpty
    }
    
    var isEightSymbolsOrMore: Bool {
        return self.count >= 8
    }
    
    var isContainsNumber: Bool {
        self.contains { $0.isNumber }
    }
    
    var isContainsLowercaseLetter: Bool {
        self.contains { $0.isLowercase }
    }
    
    var isContainsUppercaseLetter: Bool {
        self.contains { $0.isUppercase }
    }
    
    var isContainsSpecialCharacters: Bool {
        self.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*")) != nil
    }
    
    var isValidPassword: Bool {
        return isEightSymbolsOrMore &&
        isContainsUppercaseLetter &&
        isContainsLowercaseLetter &&
        isContainsNumber &&
        isContainsSpecialCharacters
    }
}
