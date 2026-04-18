//
//  Coordinator.swift
//  
//
//  Created by Madina Samadzoda on 18/04/26.
//

import Foundation


final class DetailCoordinator {

    func openDetail() {
        let vc = DetailViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
