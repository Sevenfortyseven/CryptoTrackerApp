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
    private var portfolioVM: PortfolioViewModel?
    
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        marketInfoModule.checkForNegativeOrPositiveValues()
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
            self?.marketInfoModule.btcDominanceValue.text = data.marketCapPercentage
            self?.marketInfoModule.marketCapValue.text = data.totalMarketCap
            self?.marketInfoModule.marketCapValueUpdate.text = data.marketCapChangePercentage24HUsd
            self?.marketInfoModule.volume24HLabelValue.text = data.totalVolume
        })
        
    }
    
    
    // MARK: - UI Configuration
    
    
    private func updateUI() {
        self.view.backgroundColor = .primaryColor
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    /// Update module layout for a current Superview
    private func updateModuleLayout() {
        headerModule.changeLayout(.userPortfolio)
        marketInfoModule.changeLayout(.userPortfolio)
    }
   
    
    private func updateFrames() {
        
        
    }
    
    
    // MARK: - UI Elements
    

    
    
    
}
    // MARK: - Button Actions and Gestures

extension PortfolioViewController {
    
    private func addTargets() {
        headerModule.portfolioPageBtn.addTarget(self, action: #selector(portfolioBtnPressed), for: .touchUpInside)
    }
    
    @objc private func portfolioBtnPressed() {
        self.navigationController?.view.layer.add(CAAnimation.customTransition, forKey: nil)
        self.navigationController?.popViewController(animated: true)
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
