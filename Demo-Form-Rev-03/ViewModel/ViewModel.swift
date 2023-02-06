//
//  ViewModel.swift
//  Demo-Form-Rev-03
//
//  Created by Hygor Costa on 2023-02-01.
//

import Foundation
import Firebase

class ViewModel: ObservableObject {
    
    @Published var list = [Model]()
    
    //MARK: GET DATA from FireBase
    func getData() {
        
        //Get a reference to the database
        let db = Firestore.firestore()
        
        
        //Read the documents at a specific path
        db.collection("Equipment").getDocuments { snapshot, error in
            
            // Check Errors
            if error == nil {
                
                // No errors
                
                
                if let snapshot = snapshot {
                    
                    //Update the list property in the main thread
                    DispatchQueue.main.async {
                        
                        
                        //Get all the documents and create Todos
                        self.list = snapshot.documents.map { d in
                            
                            //Create a TODO item for each document returned
                            return Model(id: d.documentID,
                                        tempIn: d["tempIn"] as? String ?? " ",
                                        tempOut: d["tempIn"] as? String ?? " ",
                                        comments: d["comments"] as? String ?? " ")
                            
                            
                        }
                    }
                    
                    
                }
            }
            else {
                // Handle the error
            }
        }
        
    }
    
    //MARK: ADD DATA to FireBase
    func addData(tempIn: String, tempOut: String, comments: String ) {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        //Add a document to a collection
        db.collection("Equipment").addDocument(data: ["tempIn":tempIn, "tempOut":tempOut, "comments":comments]) { error in
            
            // ----------------------------------------------------
            //TODO
            //MARK: How could creat a Especific ID in DataBase ???
            //-----------------------------------------------------
            
            
            // Errors ?
            if error == nil {
                //No errors
                
                //Call Get data
                self.getData()
                
            } else {
                // Handle Error
            }
        }
    }
    
    //MARK: DELETE Func
//    func deleteData(Delete: Todo) {
//
//        // Get a reference to the database
//        let db = Firestore.firestore()
//
//        //Specify the document to delete
//        db.collection("todos").document(Delete.id).delete { error in
//
//            //Check for errors
//            if error == nil {
//
//                //no Errors
//
//                DispatchQueue.main.async {
//
//                    //Remove the todo that just deleted
//                    self.list.removeAll { todo in
//
//                        return todo.id == Delete.id
//                    }
//                }
//            }
//
//        }
//    }
    
    
}

    

