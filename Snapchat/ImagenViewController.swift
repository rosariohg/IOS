//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by DillerVaster on 21/05/17.
//  Copyright © 2017 Tecsup. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
    @IBOutlet weak var recordButton: UIButton!
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    
    var tipo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func camaraTapped(_ sender: Any) {
        tipo = "imagen"
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
   
    @IBAction func elegirContactoTapped(_ sender: Any) {

        elegirContactoBoton.isEnabled = false
        let imagenesFolder = FIRStorage.storage().reference().child("imagenes")
        let imagenData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        
        imagenesFolder.child("\(imagenID).jpg").put(imagenData, metadata: nil, completion:{(metadata,error)in
            print("Intentando subir la imagen ")
            if error != nil{
                print("Ocurrió un error:\(error)")
            }
            else{
                self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: metadata?.downloadURL()!.absoluteString)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.imagenID = imagenID
        siguienteVC.tipo = tipo
    }
}
