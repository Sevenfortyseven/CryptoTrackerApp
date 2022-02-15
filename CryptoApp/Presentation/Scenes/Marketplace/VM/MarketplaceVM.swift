//
//  EditPortfolioVM.swift
//  CryptoApp
//
//  Created by aleksandre on 13.02.22.
//

import Foundation

class MarketPlaceViewModel {
    
    
    weak var delegate: UpdateHoldingsDelegate?
    private var isSearching: Bool = false
    
    // MARK: - Public
    
    public var collectionCellVM = [MarketplaceCellViewModel]() {
        didSet {
            cellVMWasUpdated.value = !cellVMWasUpdated.value
        }
    }
    /// Get a single cellVM
    public func getCellVM(_ indexpath: IndexPath) -> MarketplaceCellViewModel {
        return collectionCellVM[indexpath.row]
    }
    
    init(_ coinData: [CoinList]) {
        self.coinData = coinData
        self.filteredData = coinData
        processData(coinData)
    }
    
    
    public var cellVMWasUpdated: ObservableObject<Bool> = ObservableObject(value: false)
    public var totalPriceValue: ObservableObject<String?> = ObservableObject(value: nil)
    public var currentIndex: IndexPath?
       
    
    
    /// Number of Items inside coin cache
    public var numberOfItems: Int {
        return collectionCellVM.count
    }
    
    /// Get Data for the coin
    public func getData(for indexpath: IndexPath) -> MarketplaceCellViewModel {
        return collectionCellVM[indexpath.row]
    }
    
    /// Transform current VM object price and input amount into total price string
    public func getTotalValue(_ value: String?) -> String? {
        guard let currentIndex = currentIndex, let value = value else {
            return nil
        }
        guard let currentPrice = collectionCellVM[currentIndex.row].coinPriceDouble else {
            return nil
        }
        
        guard let valueInDouble = Double(value) else { return nil }
        self.numberOfCoinsBought = valueInDouble
        let totalHoldings = (valueInDouble * currentPrice)
        self.totalHoldings = totalHoldings
        return totalHoldings.transformToCurrencyWith6Decimals()
        
    }
    
    public var totalHoldings: Double?
    
    /// Update total holdings value for delegate VM
    public func updateTotalHoldings() {
        guard let totalHoldings = totalHoldings else {
            return
        }
        delegate?.totalHoldingsValue = totalHoldings
        updateOwnedCoins()
    }
    
    /// Update coin data for delegate VM
    public func updateOwnedCoins() {
        var coinBought: CoinList
        guard let coinData = coinData, let indexPath = currentIndex else { return }
        if isSearching {
             coinBought = filteredData[indexPath.row]
        } else {
             coinBought = coinData[indexPath.row]
        }
        
        coinBought.isOwned = true
        coinBought.holdings = Int(numberOfCoinsBought!)
        self.updatedCoinData.append(coinBought)
    }
    
    /// Update data after text change within searchbar
    public func updateData(_ searchText: String) {
        let textUppercased = searchText.uppercased()
        guard let coinData = coinData else { return }
        guard !searchText.isEmpty else {
            filteredData.removeAll()
            processData(coinData)
            return
            
        }
        
        filteredData = coinData.filter({ data in
            data.name.uppercased().contains(textUppercased) || data.id.uppercased().contains(textUppercased)
        })

        processData(filteredData)
    }
    
    
    
    // MARK: - Private
    
    /// Coin cache
    private var updatedCoinData = [CoinList]() {
        didSet {
            delegate?.updatedCoinList = updatedCoinData
            updatedCoinData = []
        }
    }
    private var coinData: [CoinList]?
    
    private var filteredData = [CoinList]() {
        didSet {
            if filteredData.isEmpty {
                isSearching = false
            } else {
                isSearching = true
            }
        }
    }
    
    private var numberOfCoinsBought: Double?
    
    private func processData(_ coinData: [CoinList]) {
        var vms = [MarketplaceCellViewModel]()
        for coin in coinData {
            vms.append(createCellVM(coin))
        }
        collectionCellVM = vms
    }
    
    private func createCellVM(_ coin: CoinList) -> MarketplaceCellViewModel {
        let imageURL = coin.imageURL
        let coinName = coin.name
        let coinID = coin.symbol
        let coinPrice = coin.currentPrice
        
        return MarketplaceCellViewModel(imageURL: imageURL, coinName: coinName, coinID: coinID, coinPrice: coinPrice)
        
    }
    
}
