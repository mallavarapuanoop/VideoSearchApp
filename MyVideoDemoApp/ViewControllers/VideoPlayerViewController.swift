//
//  VideoPlayerViewController.swift
//  MyVideoDemoApp
//
//  Created by Anoop Mallavarapu on 4/23/18.
//  Copyright © 2018 AnoopMallavarapu. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideoPlayerViewController: UIViewController, YouTubePlayerDelegate {

    var didCamefromOreintation : UIDeviceOrientation?
    var video: Video? {
        
        didSet {
            videoPlayer.loadVideoID((video?.videoId)!)
        }
    }
    
    var dismissButton: UIButton = {
        
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints  = false
        button.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var videoPlayer : YouTubePlayerView = {
    let vPlayer = YouTubePlayerView()
    vPlayer.translatesAutoresizingMaskIntoConstraints = false
        return vPlayer
    }()
    
    var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.lightGray
        
        return scrollView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(videoPlayer)
        
        setupUI()
        videoPlayer.delegate = self
        didCamefromOreintation = UIDevice.current.orientation
    }
    
    func setupUI() {
       view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(dismissButton)
        scrollView.addSubview(videoPlayer)
        
        dismissButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        dismissButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        videoPlayer.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 7).isActive = true
        videoPlayer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        videoPlayer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        let videoPlayerHeight = (view.frame.width/16) * 9
        videoPlayer.heightAnchor.constraint(equalToConstant: videoPlayerHeight).isActive = true
     }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width:self.view.frame.size.width, height: 1000)
    }
    
    @objc func dismissButtonPressed() {

        if  didCamefromOreintation == UIDeviceOrientation.landscapeRight && UIDevice.current.orientation.isPortrait {

            let value =  UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()

        } else if didCamefromOreintation == UIDeviceOrientation.landscapeLeft && UIDevice.current.orientation.isPortrait {

            let value =  UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()

        } else if !UIDevice.current.orientation.isPortrait {

            let value =  UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        videoPlayer.play()
    }
    

    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            print(text)
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
        case .landscapeLeft:
            text="LandscapeLeft"
        case .landscapeRight:
            text="LandscapeRight"
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }

    
    
    
 
}
