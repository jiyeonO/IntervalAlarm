//
//  String+Extension.swift
//  IntervalAlarm
//
//  Created by 오지연 on 11/27/24.
//

extension String {
    
    var toInt: Int {
        Int(self) ?? 0
    }
    
}

extension String {
    
    func filteredMinutes() -> String {
        let regex = "^([0-9]|[1-5][0-9]|60)$"
            
        if let range = self.range(of: regex, options: .regularExpression),
           range.lowerBound == self.startIndex,
           range.upperBound == self.endIndex {
            return self
        }
        
        return ""
    }
    
}
