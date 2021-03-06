//
//  ViewController.swift
//  CryptoApp
//
//  Created by aleksandre on 02.02.22.
//

import UIKit
import Charts

class DetailsViewController: UIViewController {
    
    
    // MARK: - Properties and Instances
    
    let detailsVM: DetailsViewModel
    
    var homepageLink: URL?
    var redditPageLink: URL?
    var blockchainLink: URL?
    
    
    /// Bool value for readMore button
    var isMorePressed: Bool = false
    
    // MARK: - Initialization
    
    public init(_ viewModel: DetailsViewModel) {
        self.detailsVM = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        addSubviews()
        populateStackView()
        initializeConstraints()
        startListening()
        setUpNavBar()
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainScrollView.layoutIfNeeded()
        updateFrames()
        checkPositiveOrNegativeValues()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func addSubviews() {
        self.view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        self.contentView.addSubview(cryptoChart)
        self.contentView.addSubview(chartTimelineLabel)
        self.contentView.addSubview(coingLogo)
        self.contentView.addSubview(coinDescriptionLabel)
        self.contentView.addSubview(additionalDetailsLabel)
        self.contentView.addSubview(coinDescriptionStack)
        self.contentView.addSubview(coinInfoStack)
        self.contentView.addSubview(additionalDetailsStack)
        self.contentView.addSubview(externalLinksLabel)
        self.contentView.addSubview(homepageLinkButton)
        self.contentView.addSubview(externalLinksStack)
        self.contentView.addSubview(LoadingViewContainer)
        self.LoadingViewContainer.addSubview(loadingSpinner)
        
    }
    
    private func populateStackView() {
        coinDescriptionStack.addArrangedSubview(coinDescriptionTextView)
        coinDescriptionStack.addArrangedSubview(readMoreBtn)
        coinInfoStack.addArrangedSubview(currentPriceAndRankStack)
        coinInfoStack.addArrangedSubview(marketCapAndVolumeStack)
        currentPriceAndRankStack.addArrangedSubview(currentPriceStack)
        currentPriceAndRankStack.addArrangedSubview(rankStack)
        currentPriceStack.addArrangedSubview(currrentPriceLabel)
        currentPriceStack.addArrangedSubview(currentPriceValue)
        currentPriceStack.addArrangedSubview(currentPriceValueUpdateAndImageStack)
        rankStack.addArrangedSubview(rankLabel)
        rankStack.addArrangedSubview(rankValue)
        currentPriceValueUpdateAndImageStack.addArrangedSubview(currentPriceUpdateImage)
        currentPriceValueUpdateAndImageStack.addArrangedSubview(currentPriceValueUpdate)
        marketCapAndVolumeStack.addArrangedSubview(marketCapStack)
        marketCapAndVolumeStack.addArrangedSubview(volumeStack)
        marketCapStack.addArrangedSubview(marketCapLabel)
        marketCapStack.addArrangedSubview(marketCapValue)
        marketCapStack.addArrangedSubview(marketCapUpdateAndImageStack)
        marketCapUpdateAndImageStack.addArrangedSubview(marketCapValueUpdateImage)
        marketCapUpdateAndImageStack.addArrangedSubview(marketCapValueUpdate)
        volumeStack.addArrangedSubview(volumeLabel)
        volumeStack.addArrangedSubview(volumeValue)
        additionalDetailsStack.addArrangedSubview(additionalDetailsChildLeft)
        additionalDetailsStack.addArrangedSubview(additionalDetailsChildRight)
        additionalDetailsChildLeft.addArrangedSubview(priceHigh24HStack)
        additionalDetailsChildLeft.addArrangedSubview(priceChange24HStack)
        additionalDetailsChildLeft.addArrangedSubview(blockTimeStack)
        additionalDetailsChildRight.addArrangedSubview(priceLow24HStack)
        additionalDetailsChildRight.addArrangedSubview(marketCapChange24HStack)
        additionalDetailsChildRight.addArrangedSubview(hashingAlgorithmStack)
        priceHigh24HStack.addArrangedSubview(priceHigh24HLabel)
        priceHigh24HStack.addArrangedSubview(priceHigh24HValue)
        priceChange24HStack.addArrangedSubview(priceChange24HLabel)
        priceChange24HStack.addArrangedSubview(priceChange24HValue)
        priceChange24HStack.addArrangedSubview(priceChange24HValueUpdateStack)
        blockTimeStack.addArrangedSubview(blockTimeLabel)
        blockTimeStack.addArrangedSubview(blockTimeValue)
        priceLow24HStack.addArrangedSubview(priceLow24HLabel)
        priceLow24HStack.addArrangedSubview(priceLow24HValue)
        marketCapChange24HStack.addArrangedSubview(marketCapChange24HLabel)
        marketCapChange24HStack.addArrangedSubview(marketCapChange24HValue)
        marketCapChange24HStack.addArrangedSubview(marketCapChange24HValueUpdateStack)
        hashingAlgorithmStack.addArrangedSubview(hashingAlgorithmLabel)
        hashingAlgorithmStack.addArrangedSubview(hashingAlgorithmValue)
        priceChange24HValueUpdateStack.addArrangedSubview(priceChange24HValueUpdateImage)
        priceChange24HValueUpdateStack.addArrangedSubview(priceChange24HValueUpdate)
        marketCapChange24HValueUpdateStack.addArrangedSubview(marketCapChange24HValueUpdateImage)
        marketCapChange24HValueUpdateStack.addArrangedSubview(marketCapChange24HValueUpdate)
        externalLinksStack.addArrangedSubview(homepageLinkButton)
        externalLinksStack.addArrangedSubview(redditLinkButton)
        externalLinksStack.addArrangedSubview(blockChainLinkButton)
        
    }
    
    
    private func startListening() {
        detailsVM.chartData.bind { [weak self] pricesListener in
            
            self?.cryptoChart.data = pricesListener
            
        }
        
        detailsVM.dataLoading.bind { [weak self] _ in
            self?.waitForLoad()
        }
        
        detailsVM.coinData.bind { [weak self] data in
            /// Get an image from url
            guard let url = data?.imageURL else { return }
            self?.coingLogo.loadImage(urlString: url)
            
            /// Check if there any description text
            guard data?.overview != "" else {
                self?.coinDescriptionTextView.text = "No info available"
                return
            }
            
            self?.coinDescriptionTextView.text = data?.overview
            self?.currentPriceValue.text = data?.currentPrice
            self?.currentPriceValueUpdate.text = data?.priceChangePercentage60D
            self?.rankValue.text = data?.marketCapRank
            self?.marketCapValue.text = data?.marketCap
            self?.marketCapValueUpdate.text = data?.marketCapChangePercentage24H
            self?.volumeValue.text = data?.totalVolume
            self?.priceHigh24HValue.text = data?.highestPriceIn24H
            self?.priceLow24HValue.text = data?.lowestPriceIn24H
            self?.priceChange24HValue.text = data?.priceChangeIn24H
            self?.priceChange24HValueUpdate.text = data?.priceChangePercentage24H
            self?.marketCapChange24HValue.text = data?.marketCapChange24H
            self?.marketCapChange24HValueUpdate.text = data?.marketCapChangePercentage24H
            self?.blockTimeValue.text = data?.blockTimeInMinutes
            self?.hashingAlgorithmValue.text = data?.hashingAlgorithm
            
        }
        detailsVM.homepageLink.bind { [weak self] url in
            self?.homepageLink = url
        }
        detailsVM.redditLink.bind { [weak self] url in
            self?.redditPageLink = url
        }
        detailsVM.blockchainLink.bind { [weak self] url in
            self?.blockchainLink = url
        }
        
    }
    
    // MARK: - UI Configuration
    
    private func updateUI() {
        self.view.backgroundColor = .primaryColor
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func updateFrames() {
        
        _ = coinInfoStack.smallCurve
        LoadingViewContainer.frame = contentView.bounds
        loadingSpinner.center = LoadingViewContainer.center
    }
    
    private func setUpNavBar() {
        self.navigationItem.titleView?.alpha = 1
        
    }
    
    private func waitForLoad() {
        if detailsVM.isFetchingInProgress {
            UIView.animate(withDuration: 0.2) {
                self.LoadingViewContainer.alpha = 1
                self.loadingSpinner.startAnimating()
            }
            
        } else {
            UIView.animate(withDuration: 0.9) {
                self.LoadingViewContainer.alpha = 0
                self.loadingSpinner.stopAnimating()
            }
        }
    }
    
    /// Updates value / image color depending on the value data
    private func checkPositiveOrNegativeValues() {
        if currentPriceValueUpdate.text?.getFirstChar() == "-" {
            currentPriceUpdateImage.tintColor = .negativeRed
            currentPriceUpdateImage.rotateBy180(true)
            currentPriceValueUpdate.textColor = .negativeRed
        } else {
            currentPriceUpdateImage.tintColor = .positiveGreen
            currentPriceValueUpdate.textColor = .positiveGreen
        }
        
        if marketCapValueUpdate.text?.getFirstChar() == "-" {
            marketCapValueUpdateImage.tintColor = .negativeRed
            marketCapValueUpdateImage.rotateBy180(true)
            marketCapValueUpdate.textColor = .negativeRed
        } else {
            marketCapValueUpdateImage.tintColor = .positiveGreen
            marketCapValueUpdate.textColor = .positiveGreen
        }
        if priceChange24HValueUpdate.text?.getFirstChar() == "-" {
            priceChange24HValueUpdateImage.tintColor = .negativeRed
            priceChange24HValueUpdateImage.rotateBy180(true)
            priceChange24HValueUpdate.textColor = .negativeRed
        } else {
            priceChange24HValueUpdateImage.tintColor = .positiveGreen
            priceChange24HValueUpdate.textColor = .positiveGreen
        }
        
        if marketCapChange24HValueUpdate.text?.getFirstChar() == "-" {
            marketCapChange24HValueUpdateImage.tintColor = .negativeRed
            marketCapChange24HValueUpdate.textColor = .negativeRed
        } else {
            marketCapChange24HValueUpdateImage.tintColor = .positiveGreen
            marketCapChange24HValueUpdate.textColor = .positiveGreen
        }
        
    }
    
    // MARK: - UI Elements
    
    private let LoadingViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryColor
        return view
    }()
    
    
    private let cryptoChart: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        _ = chart.customChartOptions
        chart.clipsToBounds = true
        chart.rightAxis.labelFont = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        chart.rightAxis.labelTextColor = .letterColor
        chart.isUserInteractionEnabled = false
        chart.animate(xAxisDuration: 3.0)
        return chart
    }()
    
    private let chartTimelineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Weekly Timeline"
        label.font = .preferredFont(forTextStyle: .title1 , compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let coingLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let coinDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "About"
        label.font = .preferredFont(forTextStyle: .title1, compatibleWith: .init(legibilityWeight: .bold))
        label.textColor = .white
        return label
    }()
    
    private let coinDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .secondaryColor
        textView.textColor = .letterColor
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.textContainer.maximumNumberOfLines = 3
        textView.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .unspecified))
        return textView
    }()
    
    private let readMoreBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Read more", for: .normal)
        button.tintColor = .borderColor
        button.alpha = 0.5
        button.addTarget(self, action: #selector(expandCoinDetailsTextView), for: .touchDown)
        button.titleLabel?.font = .preferredFont(forTextStyle: .footnote, compatibleWith: .init(legibilityWeight: .bold))
        return button
    }()
    
    private let coinDescriptionStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = -5
        stack.isUserInteractionEnabled = true
        stack.axis = .vertical
        return stack
    }()
    
    private let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .borderColor
        return spinner
    }()
    
    private let mainScrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primaryColor
        view.automaticallyAdjustsScrollIndicatorInsets = false
        return view
    }()
    /// ContentView for scrollView
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let coinInfoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 120
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let currentPriceAndRankStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        stack.alignment = .fill
        return stack
    }()
    
    
    private let currentPriceStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 3
        stack.distribution = .fill
        return stack
    }()
    
    private let currentPriceValueUpdateAndImageStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private let currrentPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Price"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let currentPriceValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let currentPriceValueUpdate: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let currentPriceUpdateImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "triangle_Fill")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let marketCapAndVolumeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    private let marketCapStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 3
        stack.alignment = .fill
        return stack
    }()
    
    private let marketCapLabel: UILabel = {
        let label = UILabel()
        label.text = "Market Cap"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let marketCapValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let marketCapUpdateAndImageStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let marketCapValueUpdate: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let marketCapValueUpdateImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "triangle_Fill")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let rankStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 3
        stack.alignment = .fill
        return stack
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.text = "Market Rank"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let rankValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let volumeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 3
        return stack
    }()
    
    private let volumeLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Volume"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let volumeValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let additionalDetailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Additional Details"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title1, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let additionalDetailsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        //        stack.spacing = 120
        stack.alignment = .center
        return stack
    }()
    
    private let additionalDetailsChildLeft: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        stack.alignment = .fill
        return stack
    }()
    
    private let additionalDetailsChildRight: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        stack.alignment = .fill
        return stack
    }()
    
    private let priceHigh24HStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 3
        stack.distribution = .fill
        return stack
    }()
    
    private let priceLow24HStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 3
        stack.distribution = .fill
        return stack
    }()
    
    private let priceChange24HStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 3
        stack.distribution = .fill
        return stack
    }()
    
    private let marketCapChange24HStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 3
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    private let hashingAlgorithmStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 3
        stack.alignment = .fill
        return stack
    }()
    
    private let blockTimeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 3
        stack.alignment = .fill
        return stack
    }()
    
    private let priceChange24HValueUpdateStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    private let marketCapChange24HValueUpdateStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private let priceHigh24HLabel: UILabel = {
        let label = UILabel()
        label.text = "24h High"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let priceHigh24HValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let priceLow24HLabel: UILabel = {
        let label = UILabel()
        label.text = "24h Low"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let priceLow24HValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let priceChange24HLabel: UILabel = {
        let label = UILabel()
        label.text = "24h Price Change"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let priceChange24HValue: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .white
        return label
    }()
    
    private let priceChange24HValueUpdate: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let priceChange24HValueUpdateImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "triangle_Fill")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let marketCapChange24HLabel: UILabel = {
        let label = UILabel()
        label.text = "24h Market Cap"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let marketCapChange24HValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let marketCapChange24HValueUpdate: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let marketCapChange24HValueUpdateImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "triangle_Fill")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let blockTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Block Time"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let blockTimeValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let hashingAlgorithmLabel: UILabel = {
        let label = UILabel()
        label.text = "Hashing Alg"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let hashingAlgorithmValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let externalLinksLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "External Links"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let externalLinksStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let homepageLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Homepage", for: .normal)
        button.addTarget(self, action: #selector(openHomepage), for: .touchUpInside)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .bold))
        return button
    }()
    
    private let redditLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(openRedditPage), for: .touchUpInside)
        button.setTitle("Reddit", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .bold))
        return button
    }()
    
    private let blockChainLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Blockchain", for: .normal)
        button.addTarget(self, action: #selector(openBlockchainPage), for: .touchUpInside)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .bold))
        return button
    }()
}

// MARK: - Button actions

extension DetailsViewController {
    
    @objc private func expandCoinDetailsTextView() {
        
        /// Get the number of lines for textView
        let numLines = Int(coinDescriptionTextView.contentSize.height / coinDescriptionTextView.font!.lineHeight)
        if !isMorePressed, numLines > 3 {
            coinDescriptionTextView.textContainer.maximumNumberOfLines = 0
            coinDescriptionTextView.invalidateIntrinsicContentSize()
            readMoreBtn.setTitle("Less", for: .normal)
            isMorePressed = true
        } else {
            coinDescriptionTextView.textContainer.maximumNumberOfLines = 3
            coinDescriptionTextView.invalidateIntrinsicContentSize()
            readMoreBtn.setTitle("Read More", for: .normal)
            isMorePressed = false
        }
    }
    
    @objc private func openHomepage() {
        guard let url = homepageLink  else {
            print("URL not available")
            return
        }
        UIApplication.shared.open(url)
    }
    @objc private func openRedditPage() {
        guard let url = redditPageLink else{
            print("URL not available")
            return
        }
        UIApplication.shared.open(url)
    }
    @objc private func openBlockchainPage() {
        guard let url = blockchainLink else {
            print("URL not available")
            return
        }
        UIApplication.shared.open(url)
    }
}




// MARK: - Constraints

extension DetailsViewController {
    
    private func initializeConstraints() {
        let chartHeightMultiplier          = CGFloat(0.2)
        let topPadding                     = CGFloat(25)
        let imagePaddingRight              = CGFloat(-15)
        let leftPadding                    = CGFloat(25)
        let contentViewWidthMultiplier             = CGFloat(0.96)
        //        let rightPadding                   = CGFloat(-25)
        let paddingBetweenObjects          = CGFloat(20)
        
        var constraints = [NSLayoutConstraint]()
        
        /// Crypto chart
        constraints.append(cryptoChart.centerXAnchor.constraint(equalTo: contentView.centerXAnchor))
        constraints.append(cryptoChart.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: contentViewWidthMultiplier))
        constraints.append(cryptoChart.topAnchor.constraint(equalTo: chartTimelineLabel.bottomAnchor, constant: paddingBetweenObjects))
        constraints.append(cryptoChart.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: chartHeightMultiplier))
        
        /// Coin logo
        constraints.append(coingLogo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: imagePaddingRight))
        constraints.append(coingLogo.centerYAnchor.constraint(equalTo: coinDescriptionLabel.centerYAnchor))
        
        /// Coin name label
        constraints.append(chartTimelineLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: leftPadding))
        constraints.append(chartTimelineLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: topPadding))
        
        
        /// Coin description label
        constraints.append(coinDescriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: leftPadding))
        constraints.append(coinDescriptionLabel.topAnchor.constraint(equalTo: cryptoChart.bottomAnchor, constant: paddingBetweenObjects))
        
        /// Coin description Stack
        constraints.append(coinDescriptionStack.topAnchor.constraint(equalTo: coinDescriptionLabel.bottomAnchor, constant: paddingBetweenObjects))
        constraints.append(coinDescriptionStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor))
        constraints.append(coinDescriptionStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: contentViewWidthMultiplier))
        constraints.append(coinDescriptionTextView.widthAnchor.constraint(equalTo: coinDescriptionStack.widthAnchor))
        
        /// ScrollView
        constraints.append(mainScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        constraints.append(mainScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        constraints.append(mainScrollView.topAnchor.constraint(equalTo: self.view.topAnchor))
        constraints.append(mainScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        
        /// ContentView
        constraints.append(contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor))
        constraints.append(contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor))
        constraints.append(contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor))
        constraints.append(contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor))
        constraints.append(contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor))
        
        /// Coin Data Stack
        constraints.append(coinInfoStack.topAnchor.constraint(equalTo: coinDescriptionStack.bottomAnchor, constant: paddingBetweenObjects))
        //        constraints.append(coinInfoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding))
        constraints.append(coinInfoStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor))
        
        
        /// Additional Details Label
        constraints.append(additionalDetailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding))
        constraints.append(additionalDetailsLabel.topAnchor.constraint(equalTo: coinInfoStack.bottomAnchor, constant: paddingBetweenObjects))
        
        /// Additional Details stack
        //        constraints.append(additionalDetailsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding))
        constraints.append(additionalDetailsStack.topAnchor.constraint(equalTo: additionalDetailsLabel.bottomAnchor, constant: paddingBetweenObjects))
        constraints.append(additionalDetailsChildLeft.leadingAnchor.constraint(equalTo: currentPriceAndRankStack.leadingAnchor))
        //        constraints.append(additionalDetailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -200))
        constraints.append(additionalDetailsChildRight.leadingAnchor.constraint(equalTo: marketCapAndVolumeStack.leadingAnchor))
        //        constraints.append(additionalDetailsStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor))
        
        /// External links label
        constraints.append(externalLinksLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftPadding))
        constraints.append(externalLinksLabel.topAnchor.constraint(equalTo: additionalDetailsStack.bottomAnchor, constant: paddingBetweenObjects))
        
        
        /// Homepage link button
        constraints.append(externalLinksStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor))
        constraints.append(externalLinksStack.topAnchor.constraint(equalTo: externalLinksLabel.bottomAnchor, constant: paddingBetweenObjects))
        constraints.append(externalLinksLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150))
        
        NSLayoutConstraint.activate(constraints)
        
    }
}

