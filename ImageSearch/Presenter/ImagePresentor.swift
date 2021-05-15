//
//  ImagePresentor.swift
//  ImageSearch
//
//  Created by Iswariya Madhavan on 14/05/21.
//

import Foundation
import UIKit
protocol PresenterProtocol: class {
    func presentImages(imageResponse: [PageDecoderArray]?)
    func fetchImageFailed()
}
class ImagePresentor :ImageInteractorProtocol {
    fileprivate var imageInteractor = ImageInteractor()
    fileprivate var imageRouter = ImageRouter()
    var presenterDelegate: PresenterProtocol?
    init() {
        imageInteractor.interactorProtocol = self
    }
    func fetchImages(searchText: String, width: Float)  {
        imageInteractor.fetchImages(searchText: searchText, width: width)
    }
    func fetchImage(url: String,id: Int ,completion: @escaping (_ imageData: Data) -> Void)  {
        print("fetching \(id)")
        imageInteractor.getImageForUrl(url: url, id: id) { (data) in
            completion(data)
        }
    }
    /******
     Interactor - Delegate Methods for displaying the images
     *******/
    func fetchSucceeded(imageResponse: [PageDecoderArray]?) {
        presenterDelegate?.presentImages(imageResponse: imageResponse)
    }
    //Handle failure in case of an error
    func fetchFailed() {
        presenterDelegate?.fetchImageFailed()
    }
    
    //Router Delegate - To handle navigation
    func openDetailPage(navController: UINavigationController , imageId: Int) {
        let imageData = imageInteractor.fetchImageFromStorage(id: imageId)
        imageRouter.openDetailsPage(navController: navController, imageData: imageData)
    }
}
