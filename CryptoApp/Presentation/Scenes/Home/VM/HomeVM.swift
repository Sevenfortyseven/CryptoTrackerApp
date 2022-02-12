//
//  HomeViewModel1.swift
//  CryptoApp
//
//  Created by aleksandre on 03.02.22.
//

import Foundation


class HomeViewModel {
    
    // MARK: - Public
    
    public var cellVMs = [CryptoCellViewModel]() {
        didSet {
            cellVMWasUpdated.value = !cellVMWasUpdated.value
        }
    }
    
    
    public func initDetailsVM(for indexPath: IndexPath) -> DetailsViewModel? {
        guard let coinData = coinData else { return nil }
        return DetailsViewModel(coinID: coinData[indexPath.row].id)
    }
    
    public func initPortfolioVM() -> PortfolioViewModel? {
        guard let globalData = globalData.value else { return nil }
        return PortfolioViewModel(globalData)
        
    }
    
    // Filter cellVM-s according to the  text input
    public var searchText: String = "" {
        didSet {
            guard !searchText.isEmpty else {
                self.cellVMs = unfilteredCellVMs
                return
            }
            let textLowercased = searchText.lowercased()
            let filteredCellVms = unfilteredCellVMs.filter { coin in
                return coin.name.lowercased().contains(textLowercased) ||
                coin.symbol.lowercased().contains(textLowercased)
                
            }
            self.cellVMs = filteredCellVms
            
        }
    }
    //
    public var isCoinListDataLoading: Bool = false {
        didSet {
            dataNeedsRefetching.value = !dataNeedsRefetching.value
        }
    }
    
    public var isGlobalDataLoading: Bool = false {
        didSet {
            dataFetchInProgress.value = !dataFetchInProgress.value
        }
    }
    
    
    public var cellVMWasUpdated: ObservableObject<Bool> = ObservableObject(value: false)
    public var dataNeedsRefetching: ObservableObject<Bool> = ObservableObject(value: false)
    public var globalData: ObservableObject<GlobalData?> = ObservableObject(value: nil)
    public var dataFetchInProgress: ObservableObject<Bool> = ObservableObject(value: true)
    public var isAscendingByPrice: Bool = false
    public var isAscendingByRank: Bool = false
    
    public var numberOfCells: Int {
        return cellVMs.count
    }
    
    public init() {
        fetchData()
        isGlobalDataLoading = true
        observe()
    }
    
    deinit {
        if let observer = refreshDataObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = reorderDataByRank {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    /// Returns cellVM with current indexPath
    public func getCellVM(at indexPath: IndexPath) -> CryptoCellViewModel {
        return cellVMs[indexPath.row]
    }
    
    
    
    // MARK: - Private
    
    private var unfilteredCellVMs = [CryptoCellViewModel]()
    private var coinData: [CoinList]?
    
    //Observers
    private var refreshDataObserver: NSObjectProtocol?
    private var reorderDataByRank: NSObjectProtocol?
    private var reorderDataByPrice: NSObjectProtocol?
    
    
    
    
    ///Observe if data refresh or reorder  is needed
    private func observe() {
        NotificationCenter.default.addObserver(forName: .refreshData, object: nil, queue: .main) { [weak self] _ in
            self?.fetchData()
            self?.isAscendingByPrice = false
            self?.isAscendingByRank = false
        }
        
        NotificationCenter.default.addObserver(forName: .reorderByRank, object: nil, queue: .main) { [weak self] _ in
            if self?.isAscendingByRank == true {
                self?.sortData(.RankDescending)
                self?.isAscendingByRank = false
            } else {
                self?.sortData(.RankAscending)
                self?.isAscendingByRank = true
            }
        }
        NotificationCenter.default.addObserver(forName: .reorderByPrice, object: nil, queue: .main) { [weak self] _ in
            if self?.isAscendingByPrice == false {
                self?.sortData(.PriceAscending)
                self?.isAscendingByPrice = true
            } else {
                self?.sortData(.PriceDescending)
                self?.isAscendingByPrice = false
            }
        }
        
    }
    

    private func fetchData() {
        // Fetch Separate Coin data
        isCoinListDataLoading = true
        NetworkEngine.request(endpoint: CoinGeckoEndpoint.CoinList) { [weak self] (result: Result<CoinListDTOResponse, Error>) in
            self?.isCoinListDataLoading = false
            switch result {
            case .success(let response):
                let mappedData = response.map {
                    return CoinList(name: $0.name, symbol: $0.symbol, imageURL: $0.image, currentPrice: $0.currentPrice, priceChangePercentage24H: $0.priceChangePercentage24H, marketCapRank: $0.marketCapRank ?? 999, id: $0.id)
                }
                self?.coinData = mappedData
                self?.processFetchedData(mappedData)
            case .failure(let error):
                print(error)
            }
        }
        // Fetch Global market Data
        NetworkEngine.request(endpoint: CoinGeckoEndpoint.Global) { [weak self] (result: Result<GlobalDataDTOResponse, Error>) in
            self?.isGlobalDataLoading = false
            switch result {
            case .success(let response):
                let mappedData = GlobalData(response.data)
                self?.globalData.value = mappedData
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Transforms coin model into CellVM  model
    private func createCellVM(_ coinList: CoinList) -> CryptoCellViewModel {
        let coinSymbol = coinList.symbol
        let coinName = coinList.name
        let coinImageURL = coinList.imageURL
        let currentPrice = coinList.currentPrice
        let priceChange = coinList.priceChangePercentage24H ?? 0
        let marketCapRank = coinList.marketCapRank
        
        return CryptoCellViewModel(name: coinName, symbol: coinSymbol, iconURL: coinImageURL, currentPrice: currentPrice, priceChangePercentage24H: priceChange, marketCapRank: marketCapRank)
    }
    
    /// Transforms coin list array into CellVM-s array
    private func processFetchedData(_ coinList: [CoinList]) {
        var cellViewModels = [CryptoCellViewModel]()
        for coin in coinList {
            cellViewModels.append(createCellVM(coin))
        }
        self.unfilteredCellVMs = cellViewModels
        self.cellVMs = cellViewModels
    }
    
    /// Sorts both  model data  and cell viewModel data by given  option from SortData enum
    private func sortData(_ sortBy: SortData) {
        switch sortBy {
        case .RankAscending:
            let sortedByRankAscending =  self.cellVMs.sorted(by: { Int($0.marketCapRank)! < Int($1.marketCapRank)! })
            let coinDataSorted = self.coinData?.sorted(by: { $0.marketCapRank < $1.marketCapRank })
            coinData = coinDataSorted
            self.cellVMs = sortedByRankAscending
            isAscendingByRank = true
        case .RankDescending:
            let sortedByRankDescending = self.cellVMs.sorted(by: { Int($0.marketCapRank)! > Int($1.marketCapRank)! })
            self.cellVMs = sortedByRankDescending
            let coinDataSorted = self.coinData?.sorted(by: { $0.marketCapRank > $1.marketCapRank })
            coinData = coinDataSorted
            isAscendingByRank = false
        case .PriceAscending:
            let sortedByPriceAscending = self.cellVMs.sorted(by: {$0.currentPrice < $1.currentPrice })
            let coinDataSorted = self.coinData?.sorted(by: { $0.currentPrice < $1.currentPrice })
            coinData = coinDataSorted
            self.cellVMs = sortedByPriceAscending
            isAscendingByPrice = true
        case .PriceDescending:
            let sortedByPriceDescending = self.cellVMs.sorted(by: {$0.currentPrice > $1.currentPrice })
            let coinDataSorted = self.coinData?.sorted(by: { $0.currentPrice > $1.currentPrice })
            coinData = coinDataSorted
            self.cellVMs = sortedByPriceDescending
            isAscendingByPrice = false
        }
        
    }
    
    
    enum SortData {
        case RankAscending
        case RankDescending
        case PriceAscending
        case PriceDescending
    }
    
}
