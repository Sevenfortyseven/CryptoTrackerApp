//
//  HomeVM.swift
//  CryptoApp
//
//  Created by aleksandre on 02.02.22.
//

import Charts
import Foundation

class DetailsViewModel {
    
    // MARK: - Public
    
    
    public var chartData: ObservableObject<LineChartData?> = ObservableObject(value: nil)
    public var coinData: ObservableObject<CoinData?> = ObservableObject(value: nil)
    public var dataLoading: ObservableObject<Bool?> = ObservableObject(value: false)
    
    public var isFetchingInProgress: Bool = false {
        didSet {
            dataLoading.value = !dataLoading.value!
        }
    }
    
    init(coinID: String) {
        self.coinID = coinID
        fetchData()
    }
    
    

    
    
    // MARK: - Private
    
    private var coinID: String
    
    
    private func fetchData() {
        self.isFetchingInProgress = true
        NetworkEngine.request(endpoint: CoinGeckoEndpoint.coinData(id: coinID)) { [weak self] (result: Result<CoinDataDTOResponse, Error>) in
            self?.isFetchingInProgress = false
            switch result {
            case .success(let response):
                let mappedData = CoinData(response)
                self?.transformIntoChartData(prices: mappedData.sparkLine7D)
                self?.coinData.value = mappedData
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    
    
    ///Transform fetched market prices into chart Data
    private func transformIntoChartData(prices: [Double]) {
        var entries = [ChartDataEntry]()
        var pricesAccending = prices.sorted { $0 < $1 }
        for price in prices {
            if !pricesAccending.isEmpty {
                entries.append(ChartDataEntry(x: pricesAccending.removeFirst(), y: price))
            }
        }
        let set = LineChartDataSet(entries: entries, label: "Weekly Timeline")
        _ = set.customSetOptions
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        self.chartData.value = data
    }
    
}
