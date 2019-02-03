//
//  Formatters.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import Foundation

class Formatters {

    // Format Double to Currency Type with Option
    func setDoubleFormat(_ double: Double, option: String) -> String {
        let localFormatter = NumberFormatter().formatWithSeparation
        localFormatter.locale = Locale(identifier: option)
        return localFormatter.string(from: NSNumber(value: double))!
    }
    // Format Double to Double(Currency Type) with Option
    func setChartFormatter(option: String) -> NumberFormatter {
        let localFormatter = NumberFormatter().formatWithSeparation
        localFormatter.locale = Locale(identifier: option)
        return localFormatter
    }
    
    // Format ISO8601 to String 
    func setDateFromString(_ string: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withFullDate
        let date = formatter.date(from: string)
        let string = date!.fullDate
        return string
        }
    }


extension NumberFormatter{
    var formatWithSeparation: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }
}
    
extension String {
    var monthDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withFullDate
        let date = formatter.date(from: self)
        let string = date?.monthDate
        return string!
    }
    var fullDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withInternetDateTime
        let date = formatter.date(from: self)
        let string = date?.fullDate
        return string!
    }
    var completeDate: String{
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withFullDate
        let date = formatter.date(from: self)
        let string = date?.completeDate
        return string!
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension Date {
    var fullDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yy"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        return formatter.string(from: self)
    }
   
    var monthDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: self)
    }
    var fullISO8601: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withInternetDateTime
        return formatter.string(from: self)
    }

    var yesterdayDate: Date {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        return yesterday
    }
    var todayTime: String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        return "\(hour):\(minutes):\(seconds)"
        
    }
    
    var completeDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        return formatter.string(from: self)
    }

}

extension Double {

    var currencyFormatString: String {
        let numberformatter = NumberFormatter().formatWithSeparation
        numberformatter.numberStyle = .currency
        let string = numberformatter.string(for: self)
        return string!
    }
    var decimalFormatString: String {
        let numberFormartter = NumberFormatter().formatWithSeparation
        let string = numberFormartter.string(for: self)
        return string!
    }
    
    var percentFormatString: String {
        let numberFormatter = NumberFormatter().formatWithSeparation
        numberFormatter.numberStyle = .percent
        let string = numberFormatter.string(for: self)
        return string!
    }
}



