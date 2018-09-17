//
//  CollectionViewCell.swift
//  MyVideoDemoApp
//
//  Created by Anoop Mallavarapu on 4/21/18.
//  Copyright © 2018 AnoopMallavarapu. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var thumnailImage: UIImageView!
    
    @IBOutlet weak var videoTitlelabel: UILabel!
    var video: Video? {
        didSet {

            videoTitlelabel.text = video?.title

            guard let imageUrlstring = video?.thumbnailImage else {return}
            guard let imageUrl = URL(string:imageUrlstring) else {return}
           // print(imageUrl)

            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in

                if let err = error {
                    print("failed to retrive our cover image: ", err)
                }

                    guard let imagedata = data else {return}
                    let image = UIImage (data:imagedata)
                    DispatchQueue.main.async {
                        self.thumnailImage.image = image
                    }
                }.resume()
        }
    }
    
    
}























