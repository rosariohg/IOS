//
//  IniciarSesionViewController.swift
//  juego
//
//  Created by Tecsup on 26/06/17.
//  Copyright © 2017 Tecsup. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class IniciarSesionViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
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
                        
                        //FIRDatabase.database().reference().child("usuarios").child(user!.uid).child("email").setValue(user!.email)
                        
                        // agregamos la foto
                        let imagenesFolder = FIRStorage.storage().reference().child("imagenes")
                        let imagenData = UIImageJPEGRepresentation(self.imagenPerfil.image!, 0.1)!
                        
                        self.imagenID = NSUUID().uuidString
                        
                        imagenesFolder.child("\(self.imagenID).jpg").put(imagenData, metadata: nil, completion:{(metadata,error)in
                            print("Intentando subir la imagen ")
                            if error != nil{
                                print("Ocurrió un error:\(error)")
                            }
                            else{
                                //FIRDatabase.database().reference().child("usuarios").child(user!.uid).child("foto").setValue(metadata?.downloadURL()!.absoluteString)
                                //FIRDatabase.database().reference().child("usuarios").child(user!.uid).child("puntaje").setValue("0")
                                let nuevo_user = [
                                    "email":user!.email,
                                    "puntaje": "0",
                                    "foto": metadata?.downloadURL()!.absoluteString
                                ]
                                FIRDatabase.database().reference().child("usuarios").child(user!.uid).setValue(nuevo_user)
                                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                            }
                        })
                        
                        
                        //self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                    }
                })
            }else{
                print("Inicio de Sesion exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagenPerfil.image = image
        imagenPerfil.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }

}

