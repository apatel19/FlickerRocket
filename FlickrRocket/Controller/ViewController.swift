//
//  ViewController.swift
//  FlickrRocket
//
//  Created by Apurva Patel on 4/26/18.
//  Copyright © 2018 Apurva Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var shots = [Shot] ()
    var urlServices = URLService()
    var errorMessageServices = ErrorMessageService()
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        loadSnippets ()
    }
    
    //MARK :- UICollectioView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let showObj = shots[indexPath.item]
        asyncLoadShotImage(url: showObj.url, imageView: cell.flickrImage, index: indexPath.item, actIndi: cell.downloadingIndicator)
        asyncLoadUserName(url: showObj.userNameURL, labelView : cell.userName, index: indexPath.item)
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: "detainImageView", sender: cell)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func numberOfCellPerRow (){
        let numberOfCellsPerRow: CGFloat = 2
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            let cellWidth = (view.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        }
    }
    
    //MARK :- Flicker API Calling and converting JSON to ImageURL
   
    func loadSnippets (){
        guard let url = URL(string: urlServices.getFlickerURL()) else {fatalError("\(self.errorMessageServices.urlConstructionError(with: "FlickerAPIUrl"))")}
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                let photosContent = parsedData["photos"] as! [String:Any]
                let photoContent = photosContent["photo"] as! [[String:Any]]
                DispatchQueue.main.async() {
                    self.loadShotsAndReloadView(with: photoContent)
                }
            } catch let error as NSError {
                print(error)
            }
        }).resume()
    }
    
    func loadShotsAndReloadView (with photos : [[String : Any]]){
        for photo in photos {
            let showObj = Shot()
            showObj.url = urlServices.createImageURL(with : photo)
            showObj.id = photo["id"] as! String
            showObj.userNameURL = urlServices.createUserNameURL(with : showObj.id)
            shots.append(showObj)
        }
        self.collectionView.reloadData()
   }
    
    func asyncLoadUserName(url: String, labelView : UILabel, index : Int) {
        guard let url = URL(string: url) else {fatalError("\(self.errorMessageServices.urlConstructionError(with: "userNameURL"))")}
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                guard let photo =  parsedData["photo"] as? [String : Any] else {fatalError("\(self.errorMessageServices.jsonParsingError(with: "photo"))")}
                guard let owner =  photo["owner"] as? [String:Any] else {fatalError("\(self.errorMessageServices.jsonParsingError(with: "owner"))")}
                DispatchQueue.main.async() {
                    self.shots[index].userName = owner["username"] as! String
                    labelView.text = "\(owner["username"]!)"
                }
            } catch let error as NSError {
                print(error)
            }
        }).resume()
    }
    func asyncLoadShotImage(url: String, imageView : UIImageView, index : Int, actIndi : UIActivityIndicatorView) {
        let serialQueue = DispatchQueue(label: "queuename")
        actIndi.startAnimating()
        var image : UIImage?
        if let cachedImage = imageCache.object(forKey: self.shots[index].url as AnyObject) as? UIImage{
            imageView.image = cachedImage
            actIndi.stopAnimating()
            return
        }
        else {
            serialQueue.async {
            let url = URL(string: url)
            do {
                let data = try Data(contentsOf: url!)
                image = UIImage(data: data)!
            }
            catch {
                actIndi.stopAnimating()
                self.errorMessageServices.imageRelatedError(with: "Cache")
            }
            DispatchQueue.main.async {
                if let image = image{
                imageView.image = image
                self.shots[index].image = image
                self.imageCache.setObject(image, forKey: self.shots[index].url as AnyObject)
                actIndi.stopAnimating()
                }
                else {
                    self.errorMessageServices.imageRelatedError(with: "Downloading")
                    actIndi.stopAnimating()
                }
            }
        }
        }
    }
    //MARK :- Prepare for segueMethods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detainImageView"{
            let destinationVC = segue.destination as! DetailViewController
            let cell = sender as! CollectionViewCell
            if let indexPath = self.collectionView.indexPath(for: cell) {
                destinationVC.image = shots[indexPath.item].image
                destinationVC.userName = shots[indexPath.item].userName
            }
        }
    }
}
