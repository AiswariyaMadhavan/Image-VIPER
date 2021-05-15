//
//  ImageInteractor.swift
//  ImageSearch
//
//  Created by Iswariya Madhavan on 14/05/21.
//

import Foundation
import RxAlamofire
import CoreData
import RxSwift
protocol ImageInteractorProtocol: class{
    func fetchSucceeded(imageResponse: [PageDecoderArray]?)
    func fetchFailed()
}
class ImageInteractor {
    private var baseURL = "https://en.wikipedia.org/w/api.php?action=query&prop=pageimages&format=json&piprop=thumbnail&pithumbsize=%d&pilimit=100&generator=prefixsearch&gpssearch=%@"
    var interactorProtocol: ImageInteractorProtocol?
    var disposeBag = DisposeBag()

    // Method to fetch all images from a given url
    func fetchImages (searchText: String, width: Float) {
        let baseURLString = String.init(format: baseURL, Int(width),searchText)
        print(baseURLString)
        RxAlamofire.data(.get, baseURLString)
            .subscribe { [weak self] respone  in
                let decodedObject = try? JSONDecoder().decode(ImageEntity.self, from: respone)
                
                self?.interactorProtocol?.fetchSucceeded(imageResponse: decodedObject?.query.pages.pagesArray)
                
            } onError: { (error) in
                self.interactorProtocol?.fetchFailed()
            } onCompleted: {
                print("completed")
            }
            .disposed(by: disposeBag)
    }
    
    /*******
     Method to fetch a specific image from a given url. Once the image is fetched the same would be stored in core data for later usage
     ******/
    func getImageForUrl(url: String, id: Int,completion: @escaping (_ imageData: Data) -> Void) -> Void  {
        RxAlamofire
            .requestData(.get, url)
            .subscribe { [weak self] response, data in
                self?.save(imageData: data, id: id)
                completion(data)
            } onError: { (error) in
                print(error)
            } onCompleted: {
                print("completed")
            }
            .disposed(by: disposeBag)
    }
    
    /***********
     Core Data Methods
    save  - saves the image in the core data for later usage
     *********/
    func save(imageData: Data, id: Int) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let imageEntity = ImageModel(context: managedContext)
        imageEntity.id = Int64(id)
        imageEntity.imageData = imageData
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    /*******
     Fetch Image for a given Id and return the same.
     *******/
    func fetchImageFromStorage(id: Int) -> Data? {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ImageModel>(entityName: "ImageModel")
        fetchRequest.predicate = NSPredicate(format: "id == %d",id)
        do {
            let imageEntity = try managedContext.fetch(fetchRequest)
            if !imageEntity.isEmpty, let imageData = imageEntity.first!.imageData {
                return imageData
            }
            return nil
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
}
