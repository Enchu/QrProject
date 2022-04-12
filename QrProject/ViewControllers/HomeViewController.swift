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

class HomeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    var video = AVCaptureVideoPreviewLayer()
    //1. Настроим сессию
    let session = AVCaptureSession()
    
    @IBOutlet weak var qrButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFiledButton(qrButton)
        Utilities.styleFiledButton(backButton)
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
            fatalError(error.localizedDescription)
        }
        //4.Настроим output
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        //5
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
    }
    
    func startRunning(){
        setupVideo()
        view.layer.addSublayer(video)
        session.startRunning()
    }
    
    
    var uidLL = ""
    
    func addBase(_ message:String){
        
        let dateString = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        let currentDateTime = dateFormatter.string(from: dateString)
        
        
        let db = Firestore.firestore()
        db.collection("qf").addDocument(data: ["datetime":currentDateTime,"name":message,"uid":self.uidLL ])
                {(error) in
                    if error != nil{
                        print((error?.localizedDescription)!)
                        //self.alert("Данные не могут сохраниться")
                    }
                }
            }

    func alert (_ message:String){
        let alert = UIAlertController(title: message, message: self.uidLL, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func qrTapped(_ sender: Any) {
        startRunning()
    }
    @IBAction func backTapped(_ sender: Any) {
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
                    self.backButton.alpha = 1
                })
            }
        }
        
    }
  
    
    
}
