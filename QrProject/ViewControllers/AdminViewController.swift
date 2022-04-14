//
//  AdminViewController.swift
//  QrProject
//
//  Created by Алексей Германов on 12.04.2022.
//

import UIKit
import SwiftUI

class AdminViewController: UIViewController {

    @IBOutlet weak var theContainer:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let chieldView = UIHostingController(rootView: ContentView())
        addChild(chieldView)
        chieldView.view.frame = theContainer.bounds
        theContainer.addSubview(chieldView.view)
    }
}
