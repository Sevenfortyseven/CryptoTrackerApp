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
            if self.marketInfoItem1ValueUpdate.text?.getFirstChar() == "-" {
                self.marketInfoItem1ValueUpdateImage.tintColor = .negativeRed
                self.marketInfoItem1ValueUpdateImage.rotateBy180(true)
            } else {
                self.marketInfoItem1ValueUpdateImage.tintColor = .positiveGreen
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
            marketInfoItem3Label.text = "Portfolio Value"
            
        }
    }
    
    
    private func addSubviews() {
        self.addSubview(marketInfoStackView)
        marketInfoStackView.addArrangedSubview(marketInfoChildStack1)
        marketInfoStackView.addArrangedSubview(marketInfoChildStack2)
        marketInfoStackView.addArrangedSubview(marketInfoChildStack3)
        marketInfoChildStack1.addArrangedSubview(marketInfoItem1Label)
        marketInfoChildStack1.addArrangedSubview(marketInfoItem1Value)
        marketInfoChildStack1.addArrangedSubview(marketInfoItem1ValueUpdateStack)
        marketInfoItem1ValueUpdateStack.addArrangedSubview(marketInfoItem1ValueUpdateImage)
        marketInfoItem1ValueUpdateStack.addArrangedSubview(marketInfoItem1ValueUpdate)
        marketInfoChildStack2.addArrangedSubview(marketInfoItem2label)
        marketInfoChildStack2.addArrangedSubview(marketInfoItem2Value)
        marketInfoChildStack3.addArrangedSubview(marketInfoItem3Label)
        marketInfoChildStack3.addArrangedSubview(marketInfoItem3Value)
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
    
    public let marketInfoItem1Label: UILabel = {
        let label = UILabel()
        label.text = "Market Cap"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    public let marketInfoItem1Value: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    public let marketInfoItem1ValueUpdateImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "triangle_Fill")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let marketInfoItem1ValueUpdateStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        return stackView
    }()
    
    public let marketInfoItem1ValueUpdate: UILabel = {
        let label = UILabel()
        label.text = "12"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let marketInfoChildStack1: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    private let marketInfoItem2label: UILabel = {
        let label = UILabel()
        label.text = "24h Volume"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    public let marketInfoItem2Value: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let marketInfoChildStack2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    public let marketInfoItem3Label: UILabel = {
        let label = UILabel()
        label.text = "BTC Dominance"
        label.textColor = .borderColor
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    public let marketInfoItem3Value: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let marketInfoChildStack3: UIStackView = {
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
        constraints.append(marketInfoItem1ValueUpdateImage.widthAnchor.constraint(equalToConstant: marketCapIconSize))
        constraints.append(marketInfoItem1ValueUpdateImage.heightAnchor.constraint(equalToConstant: marketCapIconSize))
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
