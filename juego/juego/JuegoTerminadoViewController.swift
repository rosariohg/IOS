//
//  JuegoTerminadoViewController.swift
//  juego
//
//  Created by rosario on 6/27/17.
//  Copyright © 2017 Tecsup. All rights reserved.
//

import UIKit
import Firebase

class JuegoTerminadoViewController: UIViewController {

    @IBOutlet weak var puntajeFinal: UILabel!
    var puntaje : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        puntajeFinal.text! = String(puntaje)
        // Do any additional setup after loading the view.
        let usuario = FIRAuth.auth()!.currentUser!.uid
        print("el usuario es: ")
        print(usuario)
        let puntos =  ["puntaje" : String(puntaje)]
        FIRDatabase.database().reference().child("usuarios").child(usuario).child("puntaje").setValue(String(puntaje))
    }

    
}
