//
//  PortfolioViewController.swift
//  CryptoApp
//
//  Created by aleksandre on 12.02.22.
//

import Foundation
import UIKit


class PortfolioViewController: UIViewController {
    
    // MARK: - Instances and Properties
    public var portfolioVM: PortfolioViewModel?
    private var headerModule = HeaderModule()
    private var marketInfoModule = MarketInfoModule()
    private var searchbarModule = SearchbarModule()
    private var tableViewModule = TableViewModule()
    
    
    // MARK: - Initialization
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        addSubviews()
        updateModuleLayout()
        initializeConstraints()
        addTargets()
        startListening()
        registerTableView()
        updateUIafterDataSorting()
        addGestureRecognizers()
        configureSearchBar()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        marketInfoModule.checkForNegativeOrPositiveValues()
        updateFrames()
    }
    
    init(_ viewModel: PortfolioViewModel) {
        self.portfolioVM = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addSubviews() {
        self.view.addSubview(tableViewModule)
        self.view.addSubview(headerModule)
        self.view.addSubview(marketInfoModule)
        self.view.addSubview(searchbarModule)
    }
    
    /// Start listening to an Observable object
    private func startListening() {
        
        portfolioVM?.globalData.bind(listener: { [weak self] data in
            guard let data = data else { return }
            self?.marketInfoModule.marketInfoItem1Value.text = data.totalMarketCap
            self?.marketInfoModule.marketInfoItem1ValueUpdate.text = data.marketCapChangePercentage24HUsd
            self?.marketInfoModule.marketInfoItem2Value.text = data.totalVolume
        })
        
        portfolioVM?.holdingsTotal.bind(listener: { [weak self] data in
            self?.marketInfoModule.marketInfoItem3Value.text = data
        })
        
        portfolioVM?.dataNeedsReload.bind(listener: { [weak self] _ in
            self?.tableViewModule.cryptoListTableView.reloadData()
        })
        
        
    }
    
    
    // MARK: - UI Configuration
    
    
    private func updateUI() {
        self.view.backgroundColor = .primaryColor
        self.navigationItem.setHidesBackButton(true, animated: true)
        tableViewModule.changeLayout(.portfolio)
        navigationController?.navigationBar.tintColor = .white
    }
    
    /// Update module layout for a current Superview
    private func updateModuleLayout() {
        headerModule.changeLayout(.userPortfolio)
        marketInfoModule.changeLayout(.userPortfolio)
    }
   
    
    private func updateFrames() {
        tableViewModule.cryptoListTableView.layoutIfNeeded()
        _ = tableViewModule.cryptoListTableView.mediumCurve
    }
    
    // Update UI after sorting option changes
    private func updateUIafterDataSorting() {
        
        portfolioVM?.onAscendingByPrice = { [weak self] bool in
            switch bool {
            case true:
                self?.tableViewModule.sortingImageForPriceBtn.isHidden = false
                self?.tableViewModule.sortingImageForPriceBtn.rotateBy180(true)
            case false:
                self?.tableViewModule.sortingImageForPriceBtn.rotateBy180(false)
            }
        }
        portfolioVM?.onAscendingByRank = { [weak self] bool in
            switch bool {
            case true:
                self?.tableViewModule.sortingImageForRankBtn.isHidden = false
                self?.tableViewModule.sortingImageForRankBtn.rotateBy180(true)
            case false:
                self?.tableViewModule.sortingImageForRankBtn.rotateBy180(false)
            }
        }
        portfolioVM?.onAscendingByHoldings = { [weak self] bool in
            switch bool {
            case true:
                self?.tableViewModule.sortingImageForHoldingsBtn.isHidden = false
                self?.tableViewModule.sortingImageForHoldingsBtn.rotateBy180(true)
            case false:
                self?.tableViewModule.sortingImageForHoldingsBtn.rotateBy180(false)
            }
        }
    }
    
    
    // MARK: - UI Elements
    

    
    
    
}
    // MARK: - Button Actions and Gestures

extension PortfolioViewController {
    
    private func addGestureRecognizers() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func addTargets() {
        headerModule.portfolioPageBtn.addTarget(self, action: #selector(portfolioBtnPressed), for: .touchUpInside)
        headerModule.settingsBtn.addTarget(self, action: #selector(editPortfolioBtnPressed), for: .touchUpInside)
        tableViewModule.refreshBtn.addTarget(self, action: #selector(reloadTableView), for: .touchUpInside)
        tableViewModule.sortByRankBtn.addTarget(self, action: #selector(sortByRank), for: .touchUpInside)
        tableViewModule.sortByPriceBtn.addTarget(self, action: #selector(sortByPrice), for: .touchUpInside)
        tableViewModule.sortByHoldingsBtn.addTarget(self, action: #selector(sortByHoldings), for: .touchUpInside)
    }
    
    @objc private func portfolioBtnPressed() {
        self.navigationController?.view.layer.add(CAAnimation.customTransition, forKey: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func editPortfolioBtnPressed() {
        guard let vm = portfolioVM?.initMarketplaceVM() else { return }
        let targetVC = MarketplaceViewController(vm)
        targetVC.viewModel?.delegate = self.portfolioVM
        self.navigationController?.present(targetVC, animated: true)
    }
    
    @objc private func reloadTableView() {
        tableViewModule.cryptoListTableView.reloadData()
    }
    
    /// Sort coins by rank
    @objc private func sortByRank() {
        portfolioVM?.reorderByRank()
    }
    
    /// sort coins by price
    @objc private func sortByPrice() {
        portfolioVM?.reorderByPrice()
    }
    
    /// sort coins by holdings
    @objc private func sortByHoldings() {
        portfolioVM?.reorderByHoldings()
    }
    
}

    //MARK: - SearchBar Configuration

extension PortfolioViewController: UISearchBarDelegate {
    
    private func configureSearchBar() {
        searchbarModule.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        portfolioVM?.searchText = searchText
    }
    

}



    // MARK: - TableView Delegate & Datasource
    
extension PortfolioViewController: UITableViewDelegate, UITableViewDataSource {

    private func registerTableView() {

        tableViewModule.cryptoListTableView.register(CryptoListTableViewCell.self, forCellReuseIdentifier: CryptoListTableViewCell.reuseID)
        tableViewModule.cryptoListTableView.delegate = self
        tableViewModule.cryptoListTableView.dataSource = self

    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return portfolioVM?.cellVMs.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewModule.cryptoListTableView.dequeueReusableCell(withIdentifier: CryptoListTableViewCell.reuseID, for: indexPath) as! CryptoListTableViewCell
        cell.cellViewModel = portfolioVM?.getCellVM(indexPath)
        cell.holdingsInfoStack.isHidden = false
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }


}



    // MARK: - Constraints

extension PortfolioViewController {
    
    private func initializeConstraints() {
        let tableViewHeightMultiplier      = CGFloat(0.6)
        let paddingBetweenObjects          = CGFloat(20)
//        let paddingBetweenObjectsNegative  = CGFloat(-15)
        let topPadding                     = CGFloat(25)
        let leftPadding                    = CGFloat(25)
        let rightPadding                   = CGFloat(-25)
//        let buttonSize                     = CGFloat(20)
        let searchBarWidthMultiplier       = CGFloat(0.9)
//        let marketCapIconSize              = CGFloat(15)
        
        var constraints = [NSLayoutConstraint]()

        // Header module
        constraints.append(headerModule.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leftPadding))
        constraints.append(headerModule.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: rightPadding))
        constraints.append(headerModule.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: topPadding))
        
        // Market Info Module
        constraints.append(marketInfoModule.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leftPadding))
        constraints.append(marketInfoModule.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: rightPadding))
        constraints.append(marketInfoModule.topAnchor.constraint(equalTo: headerModule.bottomAnchor, constant: paddingBetweenObjects))
        
        
        // TableView Module
        constraints.append(tableViewModule.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leftPadding))
        constraints.append(tableViewModule.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: rightPadding))
        constraints.append(tableViewModule.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(tableViewModule.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: tableViewHeightMultiplier))
        

        // Search Bar Module
        constraints.append(searchbarModule.leadingAnchor.constraint(equalTo: tableViewModule.cryptoListTableView.leadingAnchor))
        constraints.append(searchbarModule.topAnchor.constraint(equalTo: marketInfoModule.bottomAnchor, constant: paddingBetweenObjects))
        constraints.append(searchbarModule.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: searchBarWidthMultiplier))
        NSLayoutConstraint.activate(constraints)
        
    }
}
