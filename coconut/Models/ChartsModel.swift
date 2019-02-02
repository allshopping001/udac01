//
//  Model.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import Foundation

// BarChartView Model
struct ModelGraph: Codable {
    
    var periodStart : String
    var periodEnd: String
    var timeOpen : String
    var timeClose: String
    var priceOpen: Double
    var priceHigh: Double
    var priceLow: Double
    var priceClose: Double
    var volumeTraded: Double
    var tradesCount: Int
 
     enum CodingKeys: String, CodingKey{
         case periodStart = "time_period_start"
         case periodEnd = "time_period_end"
         case timeOpen = "time_open"
         case timeClose = "time_close"
         case priceOpen = "price_open"
         case priceHigh = "price_high"
         case priceLow = "price_low"
         case priceClose = "price_close"
         case volumeTraded = "volume_traded"
         case tradesCount = "trades_count"
    }
 }

