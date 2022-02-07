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
            reloadTableView.value = true
        }
    }
    
    public var reloadTableView: ObservableObject<Bool?> = ObservableObject(value: false)
    public var globalData: ObservableObject<GlobalData?> = ObservableObject(value: nil)
    
    public var numberOfCells: Int {
        return cellVMs.count
    }
    
    public init() {
        fetchData()
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
    
 
    
    //Observers
    private var refreshDataObserver: NSObjectProtocol?
    private var reorderDataByRank: NSObjectProtocol?
    private var reorderDataByPrice: NSObjectProtocol?
    
    

    private var isAscendingByRank: Bool = true
    private var isAscendingByPrice: Bool = false
    
    
    ///Observe if data refresh or reorder  is needed
    private func observe() {
        NotificationCenter.default.addObserver(forName: .refreshData, object: nil, queue: .main) { [weak self] _ in
            self?.fetchData()
        }
        
        NotificationCenter.default.addObserver(forName: .reorderByRank, object: nil, queue: .main) { [weak self] _ in
            if self?.isAscendingByRank == true {
                self?.sortData(.RankDescending)
            } else {
                self?.sortData(.RankAscending)
            }
        }
        NotificationCenter.default.addObserver(forName: .reorderByPrice, object: nil, queue: .main) { [weak self] _ in
            if self?.isAscendingByPrice == false {
                self?.sortData(.PriceAscending)
            } else {
                self?.sortData(.PriceDescending)
            }
        }
        
    }
    
    
    private func fetchData(_ sortBy: String = EndpointCustomParams.descending.rawValue) {
        // Fetch Separate Coin data
        NetworkEngine.request(endpoint: CoinGeckoEndpoint.CoinList) { [weak self] (result: Result<CoinListDTOResponse, Error>) in
            switch result {
            case .success(let response):
                let mappedData = response.map {
                    return CoinList(name: $0.name, symbol: $0.symbol, imageURL: $0.image, currentPrice: $0.currentPrice, priceChangePercentage24H: $0.priceChangePercentage24H, marketCapRank: $0.marketCapRank)
                }
                self?.processFetchedData(mappedData)
            case .failure(let error):
                print(error)
            }
        }
        // Fetch Global market Data
        NetworkEngine.request(endpoint: CoinGeckoEndpoint.Global) { [weak self] (result: Result<GlobalDataDTOResponse, Error>) in
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
        self.cellVMs = cellViewModels
    }
    
    /// Sorts model data by given  option from SortData enum
    private func sortData(_ sortBy: SortData) {
        switch sortBy {
        case .RankAscending:
            let sortedByRankAscending =  self.cellVMs.sorted(by: { Int($0.marketCapRank)! < Int($1.marketCapRank)! })
            self.cellVMs = sortedByRankAscending
            for data in sortedByRankAscending {
                print(data.marketCapRank)
            }
            isAscendingByRank = true
        case .RankDescending:
            let sortedByRankDescending = self.cellVMs.sorted(by: { Int($0.marketCapRank)! > Int($1.marketCapRank)! })
            self.cellVMs = sortedByRankDescending
            isAscendingByRank = false
        case .PriceAscending:
            let trimmedData: [CryptoCellViewModel]
            
           // TODO: Find a way to remove $ from cellVMs.currentPrice strings
            

            isAscendingByPrice = true
        case .PriceDescending:
            print("kle")
            let sortedByPriceDescending = self.cellVMs.sorted(by: { Float($0.currentPrice)! < Float($1.currentPrice)! })
            self.cellVMs = sortedByPriceDescending
        }
        
    }
    
    
    enum SortData {
        case RankAscending
        case RankDescending
        case PriceAscending
        case PriceDescending
    }
    
}
