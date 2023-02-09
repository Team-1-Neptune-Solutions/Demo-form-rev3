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
    
    @State var isConfirming = false
        
//    var error = ""
//    var metadata = ""
    
    var body: some View {
        VStack {
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
                NavigationStack{
                VStack{
                    VStack {
                        ZStack{
// I kept this code because we will have versions older than 16 on the iPhone base.
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
                                        isConfirming = true
                                    }) {
                                        Image(systemName: "camera.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40, alignment: .center)
                                    }
                                }
                            }
                            
                            .confirmationDialog(Text("Take a photo or select from Library"), isPresented: $isConfirming)
                            {
                                Button{
                                    self.source = .camera
                                    self.imagepicker.toggle()
                                } label: {
                                    Text(" Camera ")
                                }
                                Button{
                                    self.source = .photoLibrary
                                    self.imagepicker.toggle()
                                } label: {
                                    Text(" Album Library")
                                }
                                
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
                            self.imageData = Data(capacity: 0)
                       
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
    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(parent1: self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = source
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent : ImagePicker
        init(parent1 : ImagePicker) {
            parent = parent1
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.show.toggle()
            
     
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as! UIImage
            let data = image.pngData()
            
            self.parent.image = data!
            self.parent.show.toggle()
           
// Add Dialog Box to confirm or No
            let alert = UIAlertController(title: "Save Image", message: "Do you want to save this image?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                
//  RUN WHEN CLICK "YES" CONFIRM SAVE ------------------------/
                let storage = Storage.storage()
                storage.reference().child("Image-X").putData(image.jpegData(compressionQuality: 0.35)!, metadata: nil) { (_, err) in

                    if err != nil {
                        print((err?.localizedDescription)!)
                        return
                    }
                    print(" <<<< SUCCESSSSSSSSSS >>>>")
                }
                self.parent.show.toggle()
                self.parent.presentationMode.wrappedValue.dismiss()
                           
//                ---------------------------------------------/
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneWindow = scene.windows.first(where: { $0.isKeyWindow }) else {
                return
            }
            sceneWindow.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}

//TODO: -
/*
 Rotate Sample Display IMG
 Creat. Ref. at Storage
 */

/* 1) Google docs recommend using the application delegate before we use cloud storage. It's what we discussed on friday and is commented out in the main swift file. It may be giving you trouble.
*/
