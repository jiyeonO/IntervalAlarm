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

enum RegexType {

    case intervalMinutes
    case hours
    case minutes

    var regex: String {
        switch self {
        case .intervalMinutes:
            "^(0|[0-9]|[1-5][0-9]|60)$"
        case .hours:
            "^(0|[0-9]|[1][0-2]|12)$"
        case .minutes:
            "^(0|[0-9]|[1-5][0-9])$"
        }
    }

}

extension String {

    func filteredByRegex(by type: RegexType) -> String {
        guard !self.isEmpty else { return "" }

        if let range = self.range(of: type.regex, options: .regularExpression),
           range == self.startIndex..<self.endIndex {
            return self
        }

        return String(self.dropLast())
    }

}
