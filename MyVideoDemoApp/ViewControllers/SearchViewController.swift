//
//  SearchViewController.swift
//  MyVideoDemoApp
//
//  Created by Anoop Mallavarapu on 4/21/18.
//  Copyright © 2018 AnoopMallavarapu. All rights reserved.
//

import UIKit
import GoogleSignIn

class SearchViewController: UIViewController,UISearchBarDelegate, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    var videosArray = [Video]()
    var selectedCell = CollectionViewCell()
    let transition = TransitionAnimator()
    
   
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var mainSearchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        checkLogin()
        navigationItem.title = "Video Search"
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        
        transition.dismissCompletion = {
            self.selectedCell.isHidden = false
        }

       self.hideKeyboard()
        
        mainSearchBar.delegate = self
        loadVideos(searchString: "")
    }

    
    //MARK:checking login and if not presenting login view controller
    func checkLogin() {
        let signIn = GIDSignIn.sharedInstance()
        signIn?.scopes = ["https://www.googleapis.com/auth/plus.login","https://www.googleapis.com/auth/plus.me"]
        guard let check = signIn?.hasAuthInKeychain() else {return}
        if check {
            print("Signed in")
        } else {
            print("Not signed in")
            presentLoginController()
        }
    }
    func presentLoginController() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
            return print("Could not instantiate view controller with identifier of type SecondViewController")
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: SignOut Action
   @IBAction func signoutButton(_ sender: UIBarButtonItem) {
        print("logout")
        GIDSignIn.sharedInstance().signOut()
        presentLoginController()
    }
    
    
   
   //MARK: Searchbar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let string = mainSearchBar.text {
            print(string)
            searchBar.endEditing(true)
            loadVideos(searchString: string)
        }
        
    }
    func formatString(string: String) -> String {
        let newString = string.replacingOccurrences(of: " ", with: "+")
        return newString
    }
    
    //MARK: Parsing data
    func loadVideos(searchString: String) {
        let querryString = formatString(string: searchString)
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=\(querryString)&type=video&key=AIzaSyB9-UWwhs6edZ_dNVEZ_hEexW9wEp1ZfbA"
        //print(urlString)
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let err = error {
                print("Unable to Reqst from Url : \(err)")
            }
            guard let dataa = data else {return}
            do {
                
                if let jsonData = try JSONSerialization.jsonObject(with: dataa, options: []) as? [String:Any]{
                    
                    guard let items = jsonData["items"] as? [[String:Any]] else {return}
                    //print(items)
                    self.videosArray = []
                    for item in items {
                        
                        guard let id = item["id"] as? [String:Any] else{return}
                        guard let videoId = id["videoId"] as? String else {return}
                        
                        guard let snippet = item["snippet"] as? [String:Any] else{return}
                        guard let title = snippet["title"] as? String else {return}
                        guard let thumbnails = snippet["thumbnails"] as? [String:Any] else{return}
                        guard let mediumThumbnail = thumbnails["medium"] as? [String:Any] else{return}
                        guard let mediumThumbnailImage = mediumThumbnail["url"] as? String else {return}
//                        print("********")
//                        print(videoId)
//                        print(mediumThumbnailImage)
//                        print("********")

                        let video = Video(videoId: videoId, thumbnailImage: mediumThumbnailImage, title: title)
                        self.videosArray.append(video)
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.mainCollectionView.reloadData()
                        //print(self.videosArray.count)
                    }
                    
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            
            }.resume()
        
    }
    
    
    
    
    //MARK: Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videosArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CollectionViewCell
        cell.video = videosArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 35 , height: view.frame.width - 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "videoPlayController") as? VideoPlayerViewController else {
            return print("Could not instantiate view controller with identifier of type VideoPlayerViewController")
        }
        selectedCell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        vc.transitioningDelegate = self
        self.navigationController?.present(vc, animated: true, completion: nil)
        vc.video = videosArray[indexPath.item]
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }


}

//MARK: Transition
extension SearchViewController: UIViewControllerTransitioningDelegate {
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let originFrame = selectedCell.superview?.convert(selectedCell.frame, to: nil) else {
            return transition
        }
        transition.originFrame = originFrame
        transition.presenting = true
        selectedCell.isHidden = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}

