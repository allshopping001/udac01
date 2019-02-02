//
//  QueryBuilder.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import Foundation

class QueryBuilder {
    let coinQuery0 : [String] = ["BTC","DASH","ETH","LTC","XRP","XLM","DOGE","ZEC"]
    let coinQuery : [String] = ["BTC","DASH","ETH","LTC", "XRP", "EOS", "TRX", "ETC", "BCC", "NEO"]
    
    var currencyQuery : String = ""

    func buildQueryExchange(_ location: String) -> [String]{
        switch location{
            case "btc_BTC": currencyQuery = "BTC&e=CCCAGG"
            case "eth_ETH": currencyQuery = "ETH&e=CCCAGG"
            case "en_US": currencyQuery = "USD&e=CCCAGG"
            case "pt_BR": currencyQuery = "BRL&e=CCCAGG"
            case "en_UK": currencyQuery = "GBP&e=CCCAGG"
            case "zh_CN": currencyQuery = "CNY&e=CCCAGG"
            case "de_DE": currencyQuery = "EUR&e=CCCAGG"
            default: currencyQuery = "USD"
        }
        var query : [String] = []
        let baseUrl = "data/generateAvg?"
        for i in 0..<coinQuery.count {
            query.append(baseUrl + "fsym=" + coinQuery[i] + "&tsym=" + currencyQuery)
        }
        return query
    }
    
    func buildQueryGraph(idBase: String, idQuote: String, queryDate: String, limit: Int) -> String {
        let baseUrl = "v1/ohlcv/"
        var idQuoteFinal = ""
        let idQuoteBrazil = "BRAZILIEX_SPOT_"
        let idQuoteOther = "KRAKEN_SPOT_"
        if idQuote.contains("BRL"){
            idQuoteFinal = idQuoteBrazil
        } else {
            idQuoteFinal = idQuoteOther
        }
        let baseQuery = baseUrl + idQuoteFinal + idBase + "_" + idQuote
        let finishQuery = "/latest?period_id=" + queryDate + "&limit=" + "\(limit)"
        let query = baseQuery + finishQuery
        return query
    }
}

