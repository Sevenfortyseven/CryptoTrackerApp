//
//  NavigationService.swift
//  CryptoApp
//
//  Created by aleksandre on 09.02.22.
//

//import Foundation
//import UIKit
//
//
//struct NavigationService {
//    
//    
//    enum Scene {
//        case home
//        case details
//    }
//    
//    enum TransferStyle {
//        case push, present
//    }
//    
//
//    
//    public static func changeScene(from currentScene: UIViewController, to targetScene: Scene, transferStyle: TransferStyle) {
//        
//        var targetVC: UIViewController
//  
//        
//        switch targetScene {
//        case .home:
//            targetVC = HomeViewController()
//        case .details:
//            targetVC = DetailsViewController()
//        }
//        
//        switch transferStyle {
//        case .push:
//            currentScene.navigationController?.pushViewController(targetVC, animated: true)
//        case .present:
//            currentScene.navigationController?.present(targetVC, animated: true)
//        }
//    }
//    
//}
