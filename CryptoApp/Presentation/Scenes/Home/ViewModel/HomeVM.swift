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
    }
    
    /// Returns cellVM with current indexPath
    public func getCellVM(at indexPath: IndexPath) -> CryptoCellViewModel {
        return cellVMs[indexPath.row]
    }
    
    
    
    // MARK: - Private
    
    
    
    private func fetchData() {
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
                print(response)
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
    
    
    
}
