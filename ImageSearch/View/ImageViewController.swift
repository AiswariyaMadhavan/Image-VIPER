//
//  ImageViewController.swift
//  ImageSearch
//
//  Created by Iswariya Madhavan on 14/05/21.
//

import UIKit

class ImageViewController: UIViewController, PresenterProtocol {

    fileprivate var imagePresentor = ImagePresentor()
    fileprivate var imageDecodedArray =  [PageDecoderArray]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchView: UISearchBar?
    @IBOutlet weak var lblNoImage: UILabel?
    var width: CGFloat!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(UINib(nibName: "ImageCollectionCellCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ImageCollectionCellCollectionViewCell")
        width = (collectionView.frame.size.width - 45) / 2
        imagePresentor.presenterDelegate = self
       // Do any additional setup after loading the view.
    }

}
extension ImageViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            searchBar.endEditing(true)
            imagePresentor.fetchImages(searchText: searchBar.text!, width: Float(width))
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
extension ImageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width - 10 , height: width * (3 / 4))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return imageDecodedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCellCollectionViewCell", for: indexPath) as? ImageCollectionCellCollectionViewCell {
            cell.backgroundColor = .red
            if let url = imageDecodedArray[indexPath.row].thumbnail?.source {
                imagePresentor.fetchImage(url: url, id: (imageDecodedArray[indexPath.row].pageid)!) { (imageData) in
                    DispatchQueue.main.async {
                        cell.imageMovie?.image = UIImage(data: imageData)
                    }
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imagePresentor.openDetailPage(navController: self.navigationController!, imageId: (imageDecodedArray[indexPath.row].pageid)!)

    }
}
extension ImageViewController {
    func presentImages(imageResponse: [PageDecoderArray]?) {
        imageDecodedArray.removeAll()
        if let response = imageResponse {
            imageDecodedArray = response
            lblNoImage?.isHidden = true
        }
        else {
            lblNoImage?.isHidden = false
        }
        collectionView?.reloadData()
    }
    
    func fetchImageFailed()  {
        let alertVC =  UIAlertController.init(title: "Error In Search", message: "The requested item is not available, Please search for a new item", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel , handler: nil))
        self.present(alertVC, animated: false, completion: nil)
    }
}
