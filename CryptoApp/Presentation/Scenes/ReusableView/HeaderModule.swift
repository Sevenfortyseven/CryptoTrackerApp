//
//  HeaderModule.swift
//  CryptoApp
//
//  Created by aleksandre on 11.02.22.
//

import Foundation
import UIKit

/// Reusable Header Module

class HeaderModule: UIView {
        
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeHeader()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeHeader() {
        self.addSubview(navigationStackView)
        navigationStackView.addArrangedSubview(settingsBtn)
        navigationStackView.addArrangedSubview(currentPageTitle)
        navigationStackView.addArrangedSubview(portfolioPageBtn)
        self.translatesAutoresizingMaskIntoConstraints = false
        initializeConstraints()
     
 
        
}
    /// SuperView options
    enum LayoutStyle {
        case userPortfolio
        case managePortfolio
    }
    
    ///Change Layout Depending on current SuperView
    public func changeLayout(_ currentView: LayoutStyle) {
        switch currentView {
        case .userPortfolio:
            currentPageTitle.text = "Portfolio"
            portfolioPageBtn.setImage(UIImage(named: "next_rotated"), for: .normal)
            settingsBtn.setImage(UIImage(named: "plus"), for: .normal)
        case .managePortfolio:
            print("1")
        }
    }
    
    
    // MARK: - UI Elements
    
    public let navigationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public let currentPageTitle: UILabel = {
        let label = UILabel()
        label.text = "Live Prices"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title1, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    public let portfolioPageBtn: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .borderColor
        button.setImage(UIImage(named: "next"), for: .normal)
        return button
    }()
    
    public let settingsBtn: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .borderColor
        button.setImage(UIImage(named: "info"), for: .normal)
        return button
    }()
    
    private func initializeConstraints() {
        var constraints          = [NSLayoutConstraint]()
        let navigationButtonSize = CGFloat(40)
        
        constraints.append(navigationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        constraints.append(navigationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        constraints.append(navigationStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        constraints.append(navigationStackView.topAnchor.constraint(equalTo: self.topAnchor))
        
        constraints.append(portfolioPageBtn.widthAnchor.constraint(equalToConstant: navigationButtonSize))
        constraints.append(portfolioPageBtn.heightAnchor.constraint(equalToConstant: navigationButtonSize))
        constraints.append(settingsBtn.widthAnchor.constraint(equalToConstant: navigationButtonSize))
        constraints.append(settingsBtn.heightAnchor.constraint(equalToConstant: navigationButtonSize))
        
        NSLayoutConstraint.activate(constraints)
        
    }
}
