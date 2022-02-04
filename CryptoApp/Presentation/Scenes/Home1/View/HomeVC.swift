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
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        addSubviews()
        populateStackView()
        initializeConstraints()
        configureTableView()
        configureSearchBar()
        
        viewModel.reloadTableView.bind { _ in
            self.cryptoListTableView.reloadData()
        }
    }
    
    
    private func addSubviews() {
        self.view.addSubview(cryptoListTableView)
        self.view.addSubview(priceAndRefreshStackView)
        self.view.addSubview(sortByMarketCapBtn)
        self.view.addSubview(searchBar)
    }
    
    private func populateStackView() {
        priceAndRefreshStackView.addArrangedSubview(sortByPriceBtn)
        priceAndRefreshStackView.addArrangedSubview(refreshBtn)
    }
    
    // MARK: - UI Configuration
    
    private func updateUI() {
        self.view.backgroundColor = .primaryColor
    }
    
    
    // MARK: - UI Elements
    
    private let cryptoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .secondaryColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        return tableView
    }()
    
    private let priceAndRefreshStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let refreshBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "refresh"), for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        button.tintColor = .secondaryColor
        return button
    }()
    
    private let sortByMarketCapBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        button.setTitle("Coin", for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let sortByPriceBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setTitle("Price", for: .normal)
        return button
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.tintColor = .secondaryColor
        searchBar.autocorrectionType = .no
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.leftView?.tintColor = .white
        return searchBar
    }()
    
}

    //MARK: - SearchBar Configuration and Delegate

extension HomeViewController: UISearchBarDelegate {
    
    
    private func configureSearchBar() {
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    
}


    //MARK: - TableView Configuration, Delegate & Datasource

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    private func configureTableView() {
        cryptoListTableView.register(CryptoListTableViewCell.self, forCellReuseIdentifier: CryptoListTableViewCell.reuseID)
        cryptoListTableView.delegate = self
        cryptoListTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.numberOfCells)
        return viewModel.numberOfCells
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cryptoListTableView.dequeueReusableCell(withIdentifier: CryptoListTableViewCell.reuseID, for: indexPath) as! CryptoListTableViewCell
        cell.layoutIfNeeded()
        cell.cellViewModel = viewModel.getCellVM(at: indexPath)
       
        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}




    // MARK: - Constraints

extension HomeViewController {
    
    private func initializeConstraints() {
        let tableViewHeightMultiplier     = CGFloat(0.6)
//        let paddingBetweenObjects         = CGFloat(15)
        let paddingBetweenObjectsNegative = CGFloat(-15)
        let tableViewLeftPadding          = CGFloat(7)
        let tableViewRightPadding         = CGFloat(-7)
        let buttonSize = CGFloat(20)
        let searchBarWidthMultiplier      = CGFloat(0.7)
//        let leftPadding = CGFloat(15)
//        let rightPadding = CGFloat(-15)
        var constraints = [NSLayoutConstraint]()
        
        // TableView
        constraints.append(cryptoListTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: tableViewHeightMultiplier))
        constraints.append(cryptoListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: tableViewLeftPadding))
        constraints.append(cryptoListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: tableViewRightPadding))
        constraints.append(cryptoListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        
        // Right-side StackView
        constraints.append(priceAndRefreshStackView.trailingAnchor.constraint(equalTo: cryptoListTableView.trailingAnchor))
        constraints.append(priceAndRefreshStackView.bottomAnchor.constraint(equalTo: cryptoListTableView.topAnchor, constant: paddingBetweenObjectsNegative))
        constraints.append(priceAndRefreshStackView.centerYAnchor.constraint(equalTo: sortByMarketCapBtn.centerYAnchor))
        
        // Sort by market cap button
        constraints.append(sortByMarketCapBtn.leadingAnchor.constraint(equalTo: cryptoListTableView.leadingAnchor, constant: tableViewLeftPadding))
        constraints.append(sortByMarketCapBtn.bottomAnchor.constraint(equalTo: cryptoListTableView.topAnchor, constant: paddingBetweenObjectsNegative))
        
        // Refresh Button
        constraints.append(refreshBtn.widthAnchor.constraint(equalToConstant: buttonSize))
        constraints.append(refreshBtn.heightAnchor.constraint(equalToConstant: buttonSize))
        
        // Search Bar
//        constraints.append(searchBar.leadingAnchor.constraint(equalTo: sortByMarketCapBtn.leadingAnchor))
        constraints.append(searchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constraints.append(searchBar.bottomAnchor.constraint(equalTo: sortByMarketCapBtn.topAnchor,constant: paddingBetweenObjectsNegative))
        constraints.append(searchBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: searchBarWidthMultiplier))
        
        NSLayoutConstraint.activate(constraints)
    }
}
