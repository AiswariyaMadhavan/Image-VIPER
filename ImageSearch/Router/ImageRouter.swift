//
//  ImageRouter.swift
//  ImageSearch
//
//  Created by Iswariya Madhavan on 15/05/21.
//

import Foundation
import UIKit
struct ImageRouter {
    func openDetailsPage(navController: UINavigationController,
                         imageData: Data?) {
        let detailController = ImageDetailViewController.init(nibName: "ImageDetailViewController", bundle: Bundle.main)
        navController.pushViewController(detailController, animated: true)
        if let data = imageData {
            detailController.setImage(data: data)
        }
    }
}
