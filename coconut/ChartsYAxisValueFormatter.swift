//
//  ChartsYAxisValueFormatter.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import Foundation
import Charts
class YAxisValueFormatter: NSObject, IAxisValueFormatter {
    
    let numFormatter: NumberFormatter
    
    override init() {
        
        numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        numFormatter.maximumFractionDigits = 2
        numFormatter.minimumFractionDigits = 2

    }
    
    /// Called when a value from an axis is formatted before being drawn.
    ///
    /// For performance reasons, avoid excessive calculations and memory allocations inside this method.
    ///
    /// - returns: The customized label that is drawn on the axis.
    /// - parameter value:           the value that is currently being drawn
    /// - parameter axis:            the axis that the value belongs to
    ///
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return numFormatter.string(from: NSNumber(floatLiteral: value))!
    }
}
