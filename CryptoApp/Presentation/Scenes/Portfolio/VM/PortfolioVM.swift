//
//  portfolioVM.swift
//  CryptoApp
//
//  Created by aleksandre on 12.02.22.
//

import Foundation


class PortfolioViewModel: UpdateHoldingsDelegate {
   
    weak var shareDataDelegate: SharedDataDelegate?
    
    
    public var cellVMs = [CryptoCellViewModel]() {
        didSet {

            dataNeedsReload.value = !dataNeedsReload.value
            shareData()
        }
    }
    
    
    var totalHoldingsValue: Double? {
        didSet {
            guard let totalHoldingsValue = totalHoldingsValue else {
                return
            }
            if self.holdingsTotalInDouble != nil {
                holdingsTotalInDouble! += totalHoldingsValue
            } else {
                holdingsTotalInDouble = totalHoldingsValue
            }
        }
    }
    
    var updatedCoinList: [CoinList]? {
        didSet {
            guard let updatedCoinList = updatedCoinList else {
                return
            }
            processData(updatedCoinList)
        }
    }
    
    
    
    
    // MARK: - Public

    
    public var portfolioCellVM = [CryptoCellViewModel]() {
        didSet {
            cellVMWasUpdated.value = !cellVMWasUpdated.value
        }
    }
    
    public func initMarketplaceVM() -> MarketPlaceViewModel? {
        guard let coinList = coinList else { return nil}
        return MarketPlaceViewModel(coinList)
    }
    
    
    public var dataNeedsReload: ObservableObject<Bool> = ObservableObject(value: false)
    public var holdingsTotal: ObservableObject<String?> = ObservableObject(value: nil)
    public var globalData: ObservableObject<GlobalData?> = ObservableObject(value: nil)
    public var coinList: [CoinList]?
    
    
    
    // MARK: -  Data sorting
    
    public var onAscendingByPrice: ((Bool) -> Void)?
    public var onAscendingByRank : ((Bool) -> Void)?
    public var onAscendingByHoldings: ((Bool) -> Void)?
    
    public var isAscendingByPrice: Bool = false {
        didSet {
            onAscendingByPrice?(isAscendingByPrice)
        }
    }
    public var isAscendingByRank: Bool = false {
        didSet {
            onAscendingByRank?(isAscendingByRank)
        }
    }
    public var isAscendingByHoldings: Bool = false {
        didSet {
            onAscendingByHoldings?(isAscendingByHoldings)
        }
    }
    
    public func reorderByRank() {
        isAscendingByRank ? sortData(sort: .rankDescending) : sortData(sort: .rankAscending)
    }
    public func reorderByPrice() {
        isAscendingByPrice ? sortData(sort: .priceDescending) : sortData(sort: .priceAscending)
    }
    public func reorderByHoldings() {
        isAscendingByHoldings ? sortData(sort: .holdingsDescending) : sortData(sort: .holdingsAscending)
    }
    
    
    // Sort Data by Rank
    private func sortData(sort by: SortOptions) {
        var sortedCellVMs = [CryptoCellViewModel]()
        switch by {
        case .rankAscending:
            sortedCellVMs = cellVMs.sorted { Int($0.marketCapRank)! < Int($1.marketCapRank)! }
            self.cellVMs = sortedCellVMs
            isAscendingByRank = true
        case .rankDescending:
            sortedCellVMs = cellVMs.sorted { Int($0.marketCapRank)! > Int($1.marketCapRank)! }
            self.cellVMs = sortedCellVMs
            isAscendingByRank = false
        case .priceAscending:
            sortedCellVMs = cellVMs.sorted { $0.currentPrice < $1.currentPrice }
            self.cellVMs = sortedCellVMs
            isAscendingByPrice = true
        case .priceDescending:
            sortedCellVMs = cellVMs.sorted { $0.currentPrice > $1.currentPrice }
            self.cellVMs = sortedCellVMs
            isAscendingByPrice = false
        case .holdingsAscending:
            sortedCellVMs = cellVMs.sorted { $0.holdingsValue! < $1.holdingsValue! }
            self.cellVMs = sortedCellVMs
            isAscendingByHoldings = true
        case .holdingsDescending:
            sortedCellVMs = cellVMs.sorted { $0.holdingsValue! > $1.holdingsValue! }
            self.cellVMs = sortedCellVMs
            isAscendingByHoldings = false
        }
    }

    enum SortOptions {
        case rankAscending
        case rankDescending
        case priceAscending
        case priceDescending
        case holdingsAscending
        case holdingsDescending
    }
    
    
    public var cellVMWasUpdated: ObservableObject<Bool> = ObservableObject(value: false)
    
    init(_ globalData: GlobalData, _ coinData: [CoinList], _ initialCellVms: [CryptoCellViewModel], sharedHoldings: Double) {
        self.globalData.value = globalData
        self.coinList = coinData
        self.cellVMs = initialCellVms
        self.unfilteredCellVMs = initialCellVms
        self.updatedHoldings = initialCellVms
        self.holdingsTotalInDouble = sharedHoldings
        self.holdingsTotal.value = sharedHoldings.transformToCurrencyWith6Decimals()
    }
    
    public func getCellVM(_ indexPath: IndexPath) -> CryptoCellViewModel {
        return cellVMs[indexPath.row]
    }
    


    /// Holdings cache
    public var updatedHoldings = [CryptoCellViewModel]() {
        didSet {
            cellVMs = updatedHoldings
            unfilteredCellVMs = updatedHoldings
        }
    }
    
    
    // Data filter
    public var searchText: String = "" {
        didSet {
            guard !searchText.isEmpty else {
                self.cellVMs = unfilteredCellVMs
                return
            }
            let textLowercased = searchText.lowercased()
            let filteredCellVMs = unfilteredCellVMs.filter { coin in
                return coin.name.lowercased().contains(textLowercased) || coin.symbol.lowercased().contains(textLowercased)
            }
            self.cellVMs = filteredCellVMs
        }
    }
    
    private var unfilteredCellVMs = [CryptoCellViewModel]()
    

    
    ///  Total holdings cache in double
    private var holdingsTotalInDouble: Double? {
        didSet {
            guard let holdingsTotalInDouble = holdingsTotalInDouble else {
                return
            }
            self.holdingsTotal.value = holdingsTotalInDouble.transformToCurrencyWith6Decimals()
            shareDataDelegate?.sharedHoldingsValue = holdingsTotalInDouble
        }
    }
    
    /// Creates Cell ViewModel
    private func createPortfolioCellVM(_ coinList: CoinList) -> CryptoCellViewModel? {
            
        let coinSymbol = coinList.symbol
        let coinName = coinList.name
        let coinImageURL = coinList.imageURL
        let currentPrice = coinList.currentPrice
        let priceChange = coinList.priceChangePercentage24H ?? 0
        let marketCapRank = coinList.marketCapRank
        let holdingsValue = (Double(coinList.holdings) * coinList.currentPrice)
        let holdingsCount = coinList.holdings
        
        
        if updatedHoldings.contains(where: { vm in
            vm.name == coinList.name
        }) {
            let duplicateElement = updatedHoldings.first { $0.name == coinList.name }
            updatedHoldings.removeAll { $0.name == coinList.name }
            let holdingsCountUpdated = (duplicateElement?.holdingsCount)! + holdingsCount
    
            let holdingsValueUpdated = (duplicateElement?.holdingsValue)! + holdingsValue
   
            let duplicateVM = CryptoCellViewModel(name: coinName, symbol: coinSymbol, iconURL: coinImageURL, currentPrice: currentPrice, priceChangePercentage24H: priceChange, marketCapRank: marketCapRank, holdingsCount: holdingsCountUpdated, holdingsValue: holdingsValueUpdated)
            return duplicateVM

        } else {
            return CryptoCellViewModel(name: coinName, symbol: coinSymbol, iconURL: coinImageURL, currentPrice: currentPrice, priceChangePercentage24H: priceChange, marketCapRank: marketCapRank, holdingsCount: holdingsCount, holdingsValue: holdingsValue)
        }
        
       
    }
    
    /// Process Data after a Successfull Init
    private func processData(_ coinList: [CoinList])  {
        for coin in coinList {
            if coin.isOwned {
                updatedHoldings.append(createPortfolioCellVM(coin)!)
            }
        }
            
    }
    
    // Poor man's core Data
    private func shareData() {
        shareDataDelegate?.sharedData = unfilteredCellVMs
    }
    

    
}
