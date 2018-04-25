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
    
    
    func addGoogleBtn(){
        let googleSignInButton : UIButton = {
            let button = UIButton ()
            button.backgroundColor = UIColor.white
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
            button.layer.cornerRadius = 5
            button.setTitle("SIGN IN", for: .normal )
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = UIColor.red
            return button
            }()
        view.addSubview(googleSignInButton)
        
        googleSignInButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        googleSignInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleSignInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    addGoogleBtn()
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().delegate = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
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

