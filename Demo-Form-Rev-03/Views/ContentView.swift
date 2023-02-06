//
//  ContentView.swift
//  Demo-Form-Rev-03
//
//  Created by Hygor Costa on 2023-02-01.
//

import SwiftUI
import Firebase
//import FirebaseFirestore
import FirebaseStorage

struct ContentView: View {
    
    @ObservedObject var model = ViewModel()
    
    @State var imageData : Data = .init(capacity: 0)
    @State var show = false
    @State var imagepicker = false
    @State var source : UIImagePickerController.SourceType = .photoLibrary
    
    @State var tempIn = ""
    @State var tempOut = ""
    @State var comments = ""

    @State var note = ""
    @State var description = ""
    
//    var error = ""
//    var metadata = ""
    
    var body: some View {
    
        //MARK: Home DISPLAY
        VStack {
            
//            List (model.list) { item in
//                Text(item.first)
//
////MARK: Delete Button and Call Delete function
////                HStack {
////                    Text(item.first)
////                    Spacer()
////                    Button(action: {
////
////                        //Delete todo
////                        model.deleteData(Delete: item)
////                    }, label: {
////                        Image(systemName: "minus.circle")
////                    })
////
////                }
//
//
//            }
            
            Spacer(minLength: 15)
            Text("T-building").font(.largeTitle)
            
            VStack(spacing: 10) {
                Text("Pump 1")
                    .offset(x: -155)
                    .fontWeight(.bold)
                    
                
                HStack(spacing: 140){
                    
                
                    Text("In")
                        .offset(x: 15)
                    Text("Out")
                        .offset(x: 11)
                }
                HStack {
                    Text("Temp")
                        .fontWeight(.bold)
                    
                    TextField("tempIn", text: $tempIn)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                  
                    
                    
                    TextField("tempOut", text: $tempOut)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                
                //MARK: IMMAGE PLACE HOLDER + BUTTON
                
                NavigationView{
                    
                VStack{
                    VStack {
                        ZStack{
                            NavigationLink(destination: ImagePicker(show: $imagepicker, image: $imageData, source: source), isActive: $imagepicker) {
                                Text(" ")
                            }
                            VStack {
                                Spacer()
                                HStack(spacing: 40){
//                                    IMAGE Place Holder
                                    if imageData.count != 0 {
                                        Image(uiImage:UIImage(data: self.imageData)!)
                                            .resizable()
                                            .clipShape(Rectangle())
                                            .frame(width: 200, height: 200)
                                            .overlay(Rectangle().stroke(Color.gray, lineWidth: 3))
                                            .foregroundColor(Color.purple)
                                        
                                    } else {
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .clipShape(Rectangle())
                                            .frame(width: 160, height: 160
                                            )
                                            .overlay(Rectangle().stroke(Color.gray, lineWidth: 3))
                                            .foregroundColor(Color.gray)
                                    }


// Button Camera
                                    Button(action: {
                                        self.show.toggle()
                                    }) {
                                        Image(systemName: "camera.fill")
                                        //Text("Take a Photo!!")
                                            .resizable()
                                        //.scaledToFit()
// Camera Image Color                   .foregroundColor(Color.)
                                            .frame(width: 40, height: 40, alignment: .center)
                                        
                                    }
                                }
                            }
                            .actionSheet(isPresented: $show) {
                                ActionSheet(title: Text("Take a photo or select from Library"), message: Text(" "), buttons:
                                                [.default(Text("Photo Library "), action: {
                                    self.source = .photoLibrary
                                    self.imagepicker.toggle()
                                }),.default(Text("Camera"), action: {
                                    self.source = .camera
                                    self.imagepicker.toggle()
                                }),.default(Text("Cancel"), action: {
                                    self.source = .camera
                                    
                                })
                                                ]
                                            
                                )
                            }
                            
                        }
                        
                    
                            Spacer()
                        Text(" Add a comment ")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.bold)
                            .offset(x: 5)
                        
                        TextField("Type here:", text: $comments)
                            .textSelection(.enabled)
                            .frame(height: 150, alignment: .top)
                            .overlay(Rectangle().stroke(Color.gray, lineWidth: 0.5))
                            .padding(.top )

                        
                            Spacer()
                        Button(action: {
                            
                            //Call
                            model.addData(tempIn: tempIn, tempOut: tempOut, comments: comments)
               
                            
                            //Clear TextField
                            tempIn = ""
                            tempOut = ""
                            comments = ""
                            
                        }, label: {
                            Text("Save")
                            
                        }) .padding()
                            .frame(width: 120)
                            .background(Color .blue)
                            .foregroundColor(.white)
                            .font(.headline)
                             
                                
                            
                        }
                    }
                
                }
            
                
                
            }
            .padding()
        }
      }
    
    init() {
        model.getData()
       
    }
    }
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//MARK: IMAGE --> Functions
struct ImagePicker : UIViewControllerRepresentable {
    @Binding var show : Bool
    @Binding var image : Data
    var source : UIImagePickerController.SourceType
    
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(parent1: self)
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) ->
    UIImagePickerController {
    
        let controller = UIImagePickerController()
        controller.sourceType = source
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context:                                 UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent : ImagePicker
        init(parent1 : ImagePicker) {
            
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.show.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
            
            let image = info[.originalImage] as! UIImage
            let data = image.pngData()
            self.parent.image = data!
            self.parent.show.toggle()
            
           
            //MARK: ------------------------------------------- <<<< 2 >>>> ------------------------
            
            let storage = Storage.storage()
            storage.reference().child("Image-X").putData(image.jpegData(compressionQuality: 0.35)!, metadata: nil) { (_, err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }
                print(" <<<< SUCCESSSSSSSSSS >>>>")
            }
//            parent.show.toggle()
        }
    }
}

//TODO: -
/*
 Rotate Sample Display IMG
 Creat a Ref. at Storage
 Save when click instaded just take a picture
 */



/* 1) Google docs recommend using the application delegate before we use cloud storage. It's what we discussed on friday and is commented out in the main swift file. It may be giving you trouble.
 
 2) You're using ActionSheet, a feature that has been deprecated as per apple documentation. You may need to replace it with a confirmation dialog, or something else.
S---> Modal/Menu Context/Alert
 
 3) I'm curious as to why you're converting image into jpegData when you already converted into pngData before.
 
 4) Maybe we're missing something, or it's a path issue, we'll figure it out...Great work!
*/
