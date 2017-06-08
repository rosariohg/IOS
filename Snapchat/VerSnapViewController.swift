//
//  VerSnapViewController.swift
//  Snapchat
//
//  Created by DillerVaster on 22/05/17.
//  Copyright © 2017 Tecsup. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class VerSnapViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var snap = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text? = snap.descrip
        print("---------------------------------")
        print(snap.tipo)
        if snap.tipo == "imagen"{
            imageView.sd_setImage(with: URL(string: snap.storageURL))
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /*FIRDatabase.database().reference().child("usuarios").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").child(snap.id).removeValue()
        if snap.tipo == "imagen"{
            FIRStorage.storage().reference().child("imagenes").child("\(snap.storageID).jpg").delete{(error) in
                print("Se eliminó la imagen correctamente")
            }
        }
        */
        
    }

}
