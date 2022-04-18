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

class HomeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate  {
    
    var video = AVCaptureVideoPreviewLayer()
    //1. Настроим сессию
    let session = AVCaptureSession()
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var addNotesButton: UIButton!
    @IBOutlet weak var qrButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
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

    

    @IBAction func addPhotoTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        //picker.delegate = self
        picker.allowsEditing = true
        present(picker,animated: true)
    }
    
    /*,UIImagePickerControllerDelegate, UINavigationControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true,completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        guard let imageData = image.pngData() else{
            return
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        <#code#>
    }
    */
    
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
        
        var notes = addNotes
        
        
        let db = Firestore.firestore()
        db.collection("qf").addDocument(data: ["datetime":currentDateTime,"name":message,"uid":self.uidLL,"notes":notes ])
                {(error) in
                    if error != nil{
                        print((error?.localizedDescription)!)
                        //notesTextField.text = ""
                        //self.alert("Данные не могут сохраниться")
                    }
                }
        self.addNotes = ""
            }

    
    
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
