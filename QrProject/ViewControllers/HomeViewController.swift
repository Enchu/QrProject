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

class HomeViewController: UIViewController {

    @IBOutlet weak var qrButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var qrScan = AVCaptureVideoPreviewLayer()
    
    func setupQr(){
        
        /*let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            sessions.addInput(input)
            
        }*/
        
    }
    var uidLL = ""
    func addBase(){
        
    }

    @IBAction func qrTapped(_ sender: Any) {
        
    }
    

}
