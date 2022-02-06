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
        startListening()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateFrames()
    }
    
    
    private func addSubviews() {
        self.view.addSubview(cryptoListTableView)
        self.view.addSubview(priceAndRefreshStackView)
        self.view.addSubview(sortByMarketCapBtn)
        self.view.addSubview(searchBar)
        self.view.addSubview(navigationStackView)
        self.view.addSubview(marketInfoStackView)
    }
    
    private func populateStackView() {
        priceAndRefreshStackView.addArrangedSubview(sortByPriceBtn)
        priceAndRefreshStackView.addArrangedSubview(refreshBtn)
        navigationStackView.addArrangedSubview(editPortfolioPageBtn)
        navigationStackView.addArrangedSubview(currentPageTitle)
        navigationStackView.addArrangedSubview(portfolioPageBtn)
        marketInfoStackView.addArrangedSubview(marketCapStackView)
        marketInfoStackView.addArrangedSubview(volume24HStackView)
        marketInfoStackView.addArrangedSubview(btcDominanceStackView)
        marketCapStackView.addArrangedSubview(marketCapLabel)
        marketCapStackView.addArrangedSubview(marketCapValue)
        marketCapStackView.addArrangedSubview(marketCapValueUpdateStackView)
        marketCapValueUpdateStackView.addArrangedSubview(marketCapValueImage)
        marketCapValueUpdateStackView.addArrangedSubview(marketCapValueUpdate)
        volume24HStackView.addArrangedSubview(volume24HLabel)
        volume24HStackView.addArrangedSubview(volume24HLabelValue)
        btcDominanceStackView.addArrangedSubview(btcDominanceLabel)
        btcDominanceStackView.addArrangedSubview(btcDominanceValueLabel)
    }
    
    private func startListening() {
        viewModel.reloadTableView.bind { _ in
            self.cryptoListTableView.reloadData()
        }
        viewModel.globalData.bind { [weak self] listener in
            self?.marketCapValue.text = listener?.totalMarketCap
        }
    }
    
    // MARK: - UI Configuration
    
    private func updateUI() {
        self.view.backgroundColor = .primaryColor
    }
    
    private func updateFrames() {
        cryptoListTableView.layoutIfNeeded()
        _ = cryptoListTableView.mediumCurve
     
    }
    
    
    // MARK: - UI Elements
    
    private let cryptoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .secondaryColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.borderColor.cgColor
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
    
    private let navigationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let marketInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let marketCapLabel: UILabel = {
        let label = UILabel()
        label.text = "Market Cap"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let marketCapValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let marketCapValueImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "triangle_Fill")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let marketCapValueUpdateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let marketCapValueUpdate: UILabel = {
        let label = UILabel()
        label.text = "12"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let marketCapStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    private let volume24HLabel: UILabel = {
        let label = UILabel()
        label.text = "24h Volume"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let volume24HLabelValue: UILabel = {
        let label = UILabel()
        label.text = "2424"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let volume24HStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let btcDominanceLabel: UILabel = {
        let label = UILabel()
        label.text = "BTC Dominance"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let btcDominanceValueLabel: UILabel = {
        let label = UILabel()
        label.text = "24242"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let btcDominanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.axis = .vertical
        return stackView
    }()
    
    
    private let currentPageTitle: UILabel = {
        let label = UILabel()
        label.text = "Live Prices"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title1, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let portfolioPageBtn: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .borderColor
        button.setImage(UIImage(named: "next"), for: .normal)
        return button
    }()
    
    private let editPortfolioPageBtn: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .borderColor
        button.setImage(UIImage(named: "plus"), for: .normal)
        return button
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
        searchBar.searchTextField.backgroundColor = .secondaryColor
        searchBar.searchTextField.textColor = .white
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
        let tableViewHeightMultiplier      = CGFloat(0.6)
        let paddingBetweenObjects          = CGFloat(20)
        let paddingBetweenObjectsNegative  = CGFloat(-15)
        let topPadding                     = CGFloat(25)
        let leftPadding                    = CGFloat(25)
        let rightPadding                   = CGFloat(-25)
        let navigationButtonSize           = CGFloat(40)
        let buttonSize                     = CGFloat(20)
        let searchBarWidthMultiplier       = CGFloat(0.9)
        let marketCapIconSize              = CGFloat(15)

        var constraints = [NSLayoutConstraint]()
        
        // TableView
        constraints.append(cryptoListTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: tableViewHeightMultiplier))
        constraints.append(cryptoListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leftPadding))
        constraints.append(cryptoListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: rightPadding))
        constraints.append(cryptoListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        
        // Right-side StackView
        constraints.append(priceAndRefreshStackView.trailingAnchor.constraint(equalTo: cryptoListTableView.trailingAnchor))
        constraints.append(priceAndRefreshStackView.bottomAnchor.constraint(equalTo: cryptoListTableView.topAnchor, constant: paddingBetweenObjectsNegative))
        constraints.append(priceAndRefreshStackView.centerYAnchor.constraint(equalTo: sortByMarketCapBtn.centerYAnchor))
        
        // Sort by market cap button
        constraints.append(sortByMarketCapBtn.leadingAnchor.constraint(equalTo: cryptoListTableView.leadingAnchor))
        constraints.append(sortByMarketCapBtn.bottomAnchor.constraint(equalTo: cryptoListTableView.topAnchor, constant: paddingBetweenObjectsNegative))
        
        // Refresh Button
        constraints.append(refreshBtn.widthAnchor.constraint(equalToConstant: buttonSize))
        constraints.append(refreshBtn.heightAnchor.constraint(equalToConstant: buttonSize))
        
        // Search Bar
        constraints.append(searchBar.searchTextField.leadingAnchor.constraint(equalTo: cryptoListTableView.leadingAnchor))
        constraints.append(searchBar.bottomAnchor.constraint(equalTo: sortByMarketCapBtn.topAnchor,constant: paddingBetweenObjectsNegative))
        constraints.append(searchBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: searchBarWidthMultiplier))
        
        // Top navigationStack
        constraints.append(navigationStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: topPadding))
        constraints.append(navigationStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor , constant: leftPadding))
        constraints.append(navigationStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: rightPadding))
        
        // Navigation Buttons
        constraints.append(portfolioPageBtn.widthAnchor.constraint(equalToConstant: navigationButtonSize))
        constraints.append(editPortfolioPageBtn.widthAnchor.constraint(equalToConstant: navigationButtonSize))
        constraints.append(portfolioPageBtn.heightAnchor.constraint(equalToConstant: navigationButtonSize))
        constraints.append(editPortfolioPageBtn.heightAnchor.constraint(equalToConstant: navigationButtonSize))
        
        // Market Info StackView
        constraints.append(marketInfoStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leftPadding))
        constraints.append(marketInfoStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: rightPadding))
        constraints.append(marketInfoStackView.topAnchor.constraint(equalTo: navigationStackView.bottomAnchor, constant: paddingBetweenObjects))
        constraints.append(marketCapValueImage.widthAnchor.constraint(equalToConstant: marketCapIconSize))
        constraints.append(marketCapValueImage.heightAnchor.constraint(equalToConstant: marketCapIconSize))
        
        
        
        NSLayoutConstraint.activate(constraints)
    }
}
