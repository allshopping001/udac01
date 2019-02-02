//
//  CoinIcons.swift
//  coinDash
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import Foundation
import UIKit

enum ConvertSymbol {

    case eth
    case dash
    case btc
    case ltc
    case xrp
    case xlm
    case doge
    case zec
    case eos
    case trx
    case bcc
    case etc
    case neo
    case `default`
    
    
    init(symbolString: String) {
        switch symbolString {
        case "ETH": self = .eth
        case "BTC": self = .btc
        case "LTC": self = .ltc
        case "Ξ": self = .eth
        case "DASH": self = .dash
        case "Ƀ": self = .btc
        case "Ł": self = .ltc
        case "XRP": self = .xrp
        case "XLM": self = .xlm
        case "DOGE": self = .doge
        case "ZEC": self = .zec
        case "EOS": self = .eos
        case "TRX": self = .trx
        case "BCC": self = .bcc
        case "ETC": self = .etc
        case "NEO": self = .neo
        default: self = .default
        }
    }
}

extension ConvertSymbol {
    var image: UIImage {
        switch self {
        case .eth: return #imageLiteral(resourceName: "EthereumIcon")
        case .dash: return #imageLiteral(resourceName: "DashIcon")
        case .btc: return #imageLiteral(resourceName: "BitcoinIcon")
        case .ltc: return #imageLiteral(resourceName: "LiteCoinIcon")
        case .xrp: return #imageLiteral(resourceName: "Ripple-icon")
        case .xlm: return #imageLiteral(resourceName: "StellarIcon")
        case .doge: return #imageLiteral(resourceName: "DogeIcon")
        case .zec: return #imageLiteral(resourceName: "ZcashIcon")
        case .eos: return #imageLiteral(resourceName: "EosIcon")
        case .trx: return #imageLiteral(resourceName: "TronixIcon")
        case .bcc: return #imageLiteral(resourceName: "BccIcon")
        case .etc: return #imageLiteral(resourceName: "EtcIcon")
        case .neo: return #imageLiteral(resourceName: "NeoIcon")
        case .default: return #imageLiteral(resourceName: "BitcoinIcon")
            
        }
    }
    var name: String {
        switch self {
        case .btc: return "Bitcoin"
        case .dash: return "Dash"
        case .eth: return "Ethereum"
        case .ltc: return "Litecoin"
        case .xrp: return "Ripple"
        case .xlm: return "Stellar"
        case .zec: return "Zcash"
        case .doge: return "Doge"
        case .eos : return "Eosio"
        case .trx: return "Tron"
        case .bcc: return "Bitcoin Classic"
        case .etc: return "Ethereum Classic"
        case .neo: return "Neo"
        default: return "Bitcoin"
        }
    }
    
    var tickerSymbol: String {
        switch self {
        case .btc: return "BTC"
        case .dash: return "DASH"
        case .eth: return "ETH"
        case .ltc: return "LTC"
        case .xrp: return "XRP"
        case .xlm: return "XLM"
        case .zec: return "ZEC"
        case .doge: return "DOGE"
        case .eos : return "EOS"
        case .trx: return "TRX"
        case .bcc: return "BCC"
        case .etc: return "ETC"
        case .neo: return "NEO"
        default: return "BTC"
        }
    }
}

enum ConvertCurrency {
    
    case usd
    case brl
    case gbp
    case eur
    case cny
    
    
    init(currencyString:String){
        switch currencyString {
        case "$": self = .usd
        case "R$": self = .brl
        case "£": self = .gbp
        case "¥": self = .cny
        case "€": self = .eur
        case "USD": self = .usd
        case "BRL": self = .brl
        case "GBP": self = .gbp
        case "EUR": self = .eur
        case "CNY": self = .cny
        default: self = .usd
        }
    }
    
    var name : String {
        switch self {
        case .usd: return "USD"
        case .brl: return "BRL"
        case .gbp: return "GBP"
        case .cny: return "CNY"
        case .eur: return "EUR"
        }
    }
}


enum ConvertOption {
    case pt_BR
    case en_US
    case en_UK
    case zh_CN
    //case ja_JP
    case de_DE
    case btc_BTC
    case eth_ETH
    case `default`
    
    init(_ optionString: String) {
        switch optionString{
        case "btc_BTC": self = .btc_BTC
        case "pt_BR": self = .pt_BR
        case "en_US": self = .en_US
        case "en_UK": self = .en_UK
        case "zh_CN": self = .zh_CN
        //case "ja_JP": self = .ja_JP
        case "de_DE": self = .de_DE
        case "eth_ETH": self = .eth_ETH
        default: self = .default
        }
    }
}

extension ConvertOption {
    var image: UIImage {
        switch self{
        case .en_UK: return #imageLiteral(resourceName: "united-kingdom (1)")
        case .en_US: return #imageLiteral(resourceName: "united-states-of-america (1)")
        case .pt_BR: return #imageLiteral(resourceName: "brazil (1)")
        case .zh_CN: return #imageLiteral(resourceName: "china")
        //case .ja_JP: return #imageLiteral(resourceName: "japan (1)")
        case .de_DE: return #imageLiteral(resourceName: "european-union (1)")
        case .btc_BTC: return #imageLiteral(resourceName: "BitcoinIcon")
        case .eth_ETH: return #imageLiteral(resourceName: "EthereumIcon")
        case .default: return #imageLiteral(resourceName: "united-states-of-america (1)")
        }
    }
    
    var imageOnCell: UIImage {
        switch self{
        case .eth_ETH: return #imageLiteral(resourceName: "EthereumIcon")
        case .btc_BTC: return #imageLiteral(resourceName: "BitcoinIcon")
        case .en_UK: return #imageLiteral(resourceName: "united-kingdom (3)")
        case .en_US: return #imageLiteral(resourceName: "united-states (5)")
        case .pt_BR: return #imageLiteral(resourceName: "brazil (3)")
        case .zh_CN: return #imageLiteral(resourceName: "china (2)")
        //case .ja_JP: return #imageLiteral(resourceName: "japan")
        case .de_DE: return #imageLiteral(resourceName: "european-union")
        case .default: return #imageLiteral(resourceName: "united-states (5)")
        }
    }
    
    var toCurrency: String {
        switch self {
        case .eth_ETH: return "ETH"
        case .btc_BTC: return "BTC"
        case .en_UK: return "GBP"
        case .en_US: return "USD"
        case .pt_BR: return "BRL"
        case .zh_CN: return "CNY"
        //case .ja_JP: return "JPY"
        case .de_DE: return "EUR"
        case .default: return "USD"
        }
    }
}
