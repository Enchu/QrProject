//
//  HomeViewController.swift
//  QrProject
//
//  Created by Алексей Германов on 08.04.2022.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import FirebaseStorage
import Photos



class HomeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var video = AVCaptureVideoPreviewLayer()
    //1. Настроим сессию
    let session = AVCaptureSession()
    
    private let storageGlobal = Storage.storage().reference()
    var imagePickerController = UIImagePickerController()
    var globalURL = ""
    var globalImage = UIImage()
    var globalPhoto = Data()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addNotesButton: UIButton!
    @IBOutlet weak var qrButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        imagePickerController.delegate = self
        //imageView.alpha = 0
        imageView.contentMode = .scaleAspectFit
        startVideo()
    }
    
    func startVideo(){
        setupVideo()
        view.layer.addSublayer(video)
        session.startRunning()
    }
    
    private func setUpElements(){
        Utilities.styleFiledButton(qrButton)
        Utilities.styleFiledButton(addNotesButton)
        //Hide keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc private func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @IBAction func addNotesTapped(_ sender: Any) {
        alert("Добавить")
    }
    
    var addNotes = ""
    
    func alert (_ message:String){//complitionHandler:@escaping(String)->Void
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        let alertOK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        {(action) in
            let tfText = alert.textFields?.first
            guard let text = tfText?.text else { return}
            self.addNotes = text
            print(text)
            print(self.addNotes)
        }
        alert.addTextField{ (tf) in tf.placeholder = "Комментарий"}
        
        alert.addAction(alertOK)
        alert.addAction(UIAlertAction(title: "Отмена", style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    func addDataPhoto(){
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
                let url = URL(string: urlString) else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.imageView.image = image
            }
        }
        task.resume()
    }

    @IBAction func addPhotoTapped(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.imagePickerController.allowsEditing = true
        self.present(self.imagePickerController,animated: true,completion: nil)
    }
    
    var maxRes = 1
    func listAllPhoto(){
        let storageReference = storageGlobal.child("images/")
        storageReference.list(maxResults: Int64(maxRes)) { (result, error) in
            if let error = error {
              print("No way")
            }
            print(self.maxRes)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true,completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        guard let imageData = image.pngData() else{
            return
        }
        listAllPhoto()
        self.maxRes = maxRes + 1
        storageGlobal.child("images/file\(maxRes).png").putData(imageData,metadata: nil,completion: { [self]_,error in
            guard error == nil else{
                print("Failed to upload")
                return
            }
            self.storageGlobal.child("images/file\(maxRes).png").downloadURL(completion: {url,error in
                guard let url = url,error == nil else {
                    return
                }
                self.globalURL = url.absoluteString//Global URL To add Data
                let urlString  = url.absoluteString
                print("Dowload URL:\(urlString)")
                UserDefaults.standard.set(urlString, forKey: "url")
                self.addDataPhoto()
            })
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }
    
    
    @objc private func keyboardWillHide(){
        self.view.frame.origin.y = 0
    }
    
    
    func setupVideo(){
        //2.Настроиваем устройство видео
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        //3.Настроим input
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch{
            print(error)
            fatalError(error.localizedDescription)
        }
        //4.Настроим output
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        //5
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds // Менять тут
        //video.frame.size = cameraView.frame.size
        //video.videoGravity = AVLayerVideoGravity.resizeAspectFill
    }

    var uidLL = ""
    
    func addBase(_ message:String){
        
        let dateString = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        let currentDateTime = dateFormatter.string(from: dateString)

        let notes = addNotes
        let db = Firestore.firestore()
        if globalURL != ""{
            db.collection("qf").addDocument(data: ["datetime":currentDateTime,"name":message,"uid":self.uidLL,"notes":notes,"photo":globalURL ])
            {(error) in
                        if error != nil{
                            print((error?.localizedDescription)!)
                        }
                    }
        }
        else{
            db.collection("qf").addDocument(data: ["datetime":currentDateTime,"name":message,"uid":self.uidLL,"notes":notes ])
                    {(error) in
                        if error != nil{
                            print((error?.localizedDescription)!)
                        }
                    }
        }
        self.addNotes = ""
        self.globalURL = ""
            }//End

    
    
    @IBAction func qrTapped(_ sender: Any) {
        //setupVideo()
    }
    
    @IBAction func backTappedBar(_ sender: Any) {
        self.loginToHome()
    }
    func loginToHome(){
        let loginViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginViewController
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
    
    //Работа после обнаружения QRcod
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else {return}
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
            if object.type == AVMetadataObject.ObjectType.qr{
                let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Хорошо", style: .default, handler: { (action) in
                    print(object.stringValue!)
                }))
                present(alert, animated: true, completion: {
                    self.addBase(object.stringValue!)
                })
            }
        }
    }
  
  
}
