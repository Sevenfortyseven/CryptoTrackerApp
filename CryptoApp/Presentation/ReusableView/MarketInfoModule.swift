//
//  MarketInfoModule.swift
//  CryptoApp
//
//  Created by aleksandre on 12.02.22.
//

import Foundation
import UIKit

/// Module that  presents Market Data

class MarketInfoModule: UIView {
    
    //MARK: - Initialization
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        addSubviews()
        self.translatesAutoresizingMaskIntoConstraints = false
        initializeConstraints()
       
        
    }
    
    // Check for negative or positive value and rotate image/ change it's color accordingly
    public func checkForNegativeOrPositiveValues() {
        DispatchQueue.main.async {
            if self.marketCapValueUpdate.text?.getFirstChar() == "-" {
                self.marketCapValueImage.tintColor = .negativeRed
                self.marketCapValueImage.rotateBy180(true)
            } else {
                self.marketCapValueImage.tintColor = .positiveGreen
            }
        }
        
        
    }
    
    //Change Layout depending according to current superview
    enum CurrentView {
        case userPortfolio
    }
    
    
    public func changeLayout(_ currentView: CurrentView) {
        switch currentView {
        case .userPortfolio:
            btcDominanceLabel.text = "Portfolio Value"
            
        }
    }
    
    
    private func addSubviews() {
        self.addSubview(marketInfoStackView)
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
        btcDominanceStackView.addArrangedSubview(btcDominanceValue)
    }
    
    //MARK: - UI Elements
    
    
    private let marketInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public let marketCapLabel: UILabel = {
        let label = UILabel()
        label.text = "Market Cap"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    public let marketCapValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    public let marketCapValueImage: UIImageView = {
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
    
    public let marketCapValueUpdate: UILabel = {
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
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    private let volume24HLabel: UILabel = {
        let label = UILabel()
        label.text = "24h Volume"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    public let volume24HLabelValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let volume24HStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    public let btcDominanceLabel: UILabel = {
        let label = UILabel()
        label.text = "BTC Dominance"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    public let btcDominanceValue: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let btcDominanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.axis = .vertical
        return stackView
    }()
    
    
    //MARK: Constraints
    
    private func initializeConstraints() {
        var constraints       = [NSLayoutConstraint]()
        let marketCapIconSize = CGFloat(15)
   
        constraints.append(marketInfoStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        constraints.append(marketInfoStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        constraints.append(marketInfoStackView.topAnchor.constraint(equalTo: self.topAnchor))
        constraints.append(marketInfoStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        constraints.append(marketInfoStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constraints.append(marketCapValueImage.widthAnchor.constraint(equalToConstant: marketCapIconSize))
        constraints.append(marketCapValueImage.heightAnchor.constraint(equalToConstant: marketCapIconSize))
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
