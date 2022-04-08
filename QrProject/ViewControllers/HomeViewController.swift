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

    @IBOutlet weak var qrButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var video = AVCaptureVideoPreviewLayer()
    //1. Настроим сессию
    let session = AVCaptureSession()
    
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
        view.layer.addSublayer(video)
        session.startRunning()
    }
    
    
    
    
    var uidLL = ""
    
    func addBase(){
        let currentDateTime = Date()
        
        let db = Firestore.firestore()
        db.collection("qf").addDocument(data: ["dateTime":currentDateTime,"uid":self.uidLL ])
                {(error) in
                    if error != nil{
                        self.alert("Данные не могут сохраниться")
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
    

    //Работа после обнаружения QRcod
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else {return}
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
            if object.type == AVMetadataObject.ObjectType.qr{
               
                let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Хорошо", style: .default, handler: { (action) in
                    //UIPasteboard.general.string = object.stringValue
                    print(object.stringValue)
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
  
    
    
}
