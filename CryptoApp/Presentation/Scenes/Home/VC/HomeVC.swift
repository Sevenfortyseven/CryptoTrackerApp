//
//  HomeViewController1.swift
//  CryptoApp
//
//  Created by aleksandre on 03.02.22.
//

import UIKit


class HomeViewController: UIViewController {
    
    // MARK: - Instances and Properties
    
    var viewModel = HomeViewModel()
    
    /// Reusable Modules
    private var headerModule = HeaderModule()
    private var marketInfoModule = MarketInfoModule()
    private var searchbarModule = SearchbarModule()
    private var tableViewModule = TableViewModule()
 
    /// Bool value for an imageView that updates after user presses sortBy options
//    private var isPriceImageRotated: Bool = false
//    private var isRankImageRotated: Bool = false
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        addSubviews()
        initializeConstraints()
        configureTableView()
        configureSearchBar()
        startListening()
        addTapGestureRecognizer()
        addTargets()
        updateUIAfterInteraction()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(viewModel.sharedData.count)
        UIView.animate(withDuration: 0.2) {
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        updateFrames()
        marketInfoModule.checkForNegativeOrPositiveValues()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.2) {
    
        }
    }
    
    private func addSubviews() {
        self.view.addSubview(tableViewModule)
        self.view.addSubview(searchbarModule)
        self.view.addSubview(headerModule)
        self.view.addSubview(marketInfoModule)
        self.view.addSubview(loadingContainer)
        loadingContainer.addSubview(loadingSpinnerGlobal)
    }
    
    
    private func startListening() {
        viewModel.dataFetchInProgress.bind { [weak self] _ in
            if self?.viewModel.isGlobalDataLoading == true {
                self?.loadingContainer.alpha = 1
                self?.loadingSpinnerGlobal.startAnimating()
            } else {
                UIView.animate(withDuration: 1) {
                    self?.loadingSpinnerGlobal.stopAnimating()
                    self?.loadingContainer.alpha = 0
                }
            }
        }
        
        viewModel.cellVMWasUpdated.bind { [weak self] _ in
            self?.tableViewModule.cryptoListTableView.reloadData()
        }
        viewModel.dataNeedsRefetching.bind { [weak self]_ in
            if self?.viewModel.isCoinListDataLoading == true {
                self?.tableViewModule.tableViewLoadingSpinner.startAnimating()
                UIView.animate(withDuration: 0.2) {
                    self?.tableViewModule.cryptoListTableView.alpha = 0.0
                }
            } else {
                self?.tableViewModule.tableViewLoadingSpinner.stopAnimating()
                UIView.animate(withDuration: 0.5) {
                    self?.tableViewModule.cryptoListTableView.alpha = 1.0
                }
                
            }
        }
        
        viewModel.globalData.bind { [weak self] listener in
            self?.marketInfoModule.marketInfoItem1Value.text = listener?.totalMarketCap
            self?.marketInfoModule.marketInfoItem1ValueUpdate.text = listener?.marketCapChangePercentage24HUsd
            self?.marketInfoModule.marketInfoItem2Value.text = listener?.totalVolume
            self?.marketInfoModule.marketInfoItem3Value.text = listener?.marketCapPercentage
        }
    }
    
    // MARK: - UI Configuration
    
    private func updateUI() {
        self.view.backgroundColor = .primaryColor
        navigationController?.navigationBar.barTintColor = .primaryColor
    }
    
    private func updateFrames() {
        tableViewModule.cryptoListTableView.layoutIfNeeded()
        _ = tableViewModule.cryptoListTableView.mediumCurve
        loadingContainer.frame = self.view.bounds
        loadingSpinnerGlobal.center = loadingContainer.center
    }
    
   
    
    
    
    
    // Check for UI changes after sorting buttons are pressed
    private func updateUIAfterInteraction() {
        
        viewModel.onAscendingByRank = { [weak self] bool in
            switch bool {
            case true:
                self?.tableViewModule.sortingImageForRankBtn.isHidden = false
                self?.tableViewModule.sortingImageForRankBtn.rotateBy180(true)
            case false:
                self?.tableViewModule.sortingImageForRankBtn.rotateBy180(false)
            }
        }
        viewModel.onAscendingByPrice = { [weak self] bool in
            switch bool {
            case true:
                self?.tableViewModule.sortingImageForPriceBtn.isHidden = false
                self?.tableViewModule.sortingImageForPriceBtn.rotateBy180(true)
            case false:
                self?.tableViewModule.sortingImageForPriceBtn.rotateBy180(false)
            }
        }

        
    }
    
    
    // MARK: - UI Elements

    private let loadingContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .primaryColor
        return container
    }()
    
    private let loadingSpinnerGlobal: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = .borderColor
        return spinner
    }()
    
}

    //MARK: - SearchBar Configuration and Delegate

extension HomeViewController: UISearchBarDelegate {
    
    
    private func configureSearchBar() {
        searchbarModule.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
    
 
}

    //MARK: - Button Actions and Tap Recognizers

extension HomeViewController {
    
    /// Add targers for UIButtons
    private func addTargets(){
        /// Header Module
        headerModule.settingsBtn.addTarget(self, action: #selector(settingsBtnPressed), for: .touchUpInside)
        headerModule.portfolioPageBtn.addTarget(self, action: #selector(portfolioBtnPressed), for: .touchUpInside)
        
        /// TableView Module
        tableViewModule.refreshBtn.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
        tableViewModule.sortByRankBtn.addTarget(self, action: #selector(reorderDataByRank), for: .touchUpInside)
        tableViewModule.sortByPriceBtn.addTarget(self, action: #selector(reorderDataByPrice), for: .touchUpInside)
        
        
    }
    
    /// Updates VM to refresh Data
    @objc private func refreshData() {
        NotificationCenter.default.post(name: .refreshData, object: nil)
        tableViewModule.refreshBtn.rotate()
//        updateUI()
    }
    
    /// Updates VM to re-order Coin data by ascending or descending
    @objc private func reorderDataByRank() {
        NotificationCenter.default.post(name: .reorderByRank, object: nil)
    }
    
    /// Updates VM to re-order Coin data by price ascending or descending
    @objc private func reorderDataByPrice() {
        NotificationCenter.default.post(name: .reorderByPrice, object: nil)
    }
    
    ///Dismiss keyboard when the tap is recognized
    @objc private func dismissKeyboard() {
        ///Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    private func addTapGestureRecognizer() {
        // Look for single or multiple taps
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func settingsBtnPressed() {
        print("settings pressed")
    }
    
    @objc func portfolioBtnPressed() {
        guard let portfolioVM = viewModel.initPortfolioVM() else { return }
        let targetVC = PortfolioViewController(portfolioVM)
        targetVC.portfolioVM?.shareDataDelegate = self.viewModel
        navigationController?.view.layer.add(CAAnimation.customTransition, forKey: nil)
        navigationController?.pushViewController(targetVC, animated: true)
    }
    
}


    //MARK: - TableView Configuration, Delegate & Datasource

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    private func configureTableView() {
        tableViewModule.cryptoListTableView.register(CryptoListTableViewCell.self, forCellReuseIdentifier: CryptoListTableViewCell.reuseID)
        tableViewModule.cryptoListTableView.delegate = self
        tableViewModule.cryptoListTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewModule.cryptoListTableView.dequeueReusableCell(withIdentifier: CryptoListTableViewCell.reuseID, for: indexPath) as! CryptoListTableViewCell
        cell.cellViewModel = viewModel.getCellVM(at: indexPath)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // Navigate to Details Screen and pass appropriate viewModel
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsVM  = viewModel.initDetailsVM(for: indexPath) else { return }
        let detailsVC = DetailsViewController(detailsVM)
        navigationController?.pushViewController(detailsVC, animated: true)
    }

}




    // MARK: - Constraints

extension HomeViewController {
    
    private func initializeConstraints() {
        let tableViewHeightMultiplier      = CGFloat(0.6)
        let paddingBetweenObjects          = CGFloat(20)
        let topPadding                     = CGFloat(25)
        let leftPadding                    = CGFloat(25)
        let rightPadding                   = CGFloat(-25)
        let searchBarWidthMultiplier       = CGFloat(0.9)
 
        var constraints = [NSLayoutConstraint]()
        
        // TableView Module
        constraints.append(tableViewModule.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leftPadding))
        constraints.append(tableViewModule.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: rightPadding))
        constraints.append(tableViewModule.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(tableViewModule.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: tableViewHeightMultiplier))
        

        // Search Bar Module
        constraints.append(searchbarModule.leadingAnchor.constraint(equalTo: tableViewModule.cryptoListTableView.leadingAnchor))
        constraints.append(searchbarModule.topAnchor.constraint(equalTo: marketInfoModule.bottomAnchor, constant: paddingBetweenObjects))
        constraints.append(searchbarModule.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: searchBarWidthMultiplier))

        // Header Module
        constraints.append(headerModule.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: topPadding))
        constraints.append(headerModule.leadingAnchor.constraint(equalTo: self.view.leadingAnchor , constant: leftPadding))
        constraints.append(headerModule.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: rightPadding))
        
        // Market Info Module
        constraints.append(marketInfoModule.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leftPadding))
        constraints.append(marketInfoModule.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: rightPadding))
        constraints.append(marketInfoModule.topAnchor.constraint(equalTo: headerModule.bottomAnchor, constant: paddingBetweenObjects))
    
        NSLayoutConstraint.activate(constraints)
    }
}
