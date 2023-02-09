//
//  Demo_Form_Rev_03App.swift
//  Demo-Form-Rev-03
//
//  Created by Hygor Costa on 2023-02-01.
//

import SwiftUI
import Firebase
import FirebaseCore


@main
struct Demo_Form_Rev_03App: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

//@main
//struct firebaseLoginDemoApp: App {
//     register app delegate for Firebase setup
//      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  

    


/*
 //MARK: TODO -> Akshey
 //MARK: Github Branch -->  ConnectionFirebase
 Connect App to Firebase
 GET/ADD/UPDATE (SnapShot)
 Make 2 Text Fild to Test + Button Submit
 
 
 //MARK: Github Branch -->  StorageImg
 Add Button to Open Camera to take Picture + Action
 Add Button to Submit ( Action )
 Display msg "Sumited"
  
 ----> Akshay Mahajan <----
   10:15 AM
 
 @Hygor Costa @Eshwar Ben
     is currently creating a form on Swift and linking it to firebase. You guys shall be working together to come up with our proof of concept for communicating with Firebase. You guys can do pair programming or divide the tasks. But work on a shared repo that Ben is working on. We shall be using image storage as well data storage. Image storage is a bit different from data storage but nothing too complex. I am attaching a screenshot of how the UI should look. Pressing the camera button should let the user take a picture, you need to store that picture and the data into firebase. DM me if you guys are unclear about anything.
 */

