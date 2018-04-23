//
//  ViewController.swift
//  MyVideoDemoApp
//
//  Created by Anoop Mallavarapu on 4/18/18.
//  Copyright © 2018 AnoopMallavarapu. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn



class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    

    var googleSignInButton = GIDSignInButton.init(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    googleSignInButton.center = view.center
    view.addSubview(googleSignInButton)
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().delegate = self
       
    }

    override func viewDidAppear(_ animated: Bool) {
    let signIn = GIDSignIn.sharedInstance()
    signIn?.scopes = ["https://www.googleapis.com/auth/plus.login","https://www.googleapis.com/auth/plus.me"]
    guard let check = signIn?.hasAuthInKeychain() else {return}
        if check {
            print("Signed in")
            UserDefaults.standard.set(false, forKey: "guestLogin")
            self.dismiss(animated: true, completion: nil)
            } else {
            print("Not signed in")
            }
     }
    
    
    @objc func signIn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error ?? "error")
            return
        }
     }
}

