//
//  iniciarSesionViewController.swift
//  Snapchat
//
//  Created by Rosario on 21/05/17.
//  Copyright © 2017 Tecsup. All rights reserved.
//

import UIKit
import Firebase

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            print("Intentamos Iniciar Sesión")
            if error != nil {
                print("Tenemos el siguiente error:\(error)")
                FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    print("Intentamos crear un usuario")
                    if error != nil{
                        print("Tenemos el siguiente error:\(error)")
                    }
                    else{
                        print("El usario fue creado exitosamente")
                        FIRDatabase.database().reference().child("usuarios").child(user!.uid).child("email").setValue(user!.email)
                        self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                    }
                })
            }else{
                print("Inicio de Sesion exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        })
    }

}

