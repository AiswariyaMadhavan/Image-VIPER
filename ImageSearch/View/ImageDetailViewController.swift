//
//  ImageDetailViewController.swift
//  ImageSearch
//
//  Created by Iswariya Madhavan on 15/05/21.
//

import UIKit

class ImageDetailViewController: UIViewController {
    @IBOutlet weak var imageDetails: UIImageView?
    var imageData: Data?
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "DetailView"
        if let data = imageData {
            self.imageDetails?.image = UIImage(data: data)
        }
    }

    func setImage (data: Data) {
        imageData = data
    }
}
