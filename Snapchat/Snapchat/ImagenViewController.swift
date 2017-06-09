//
//  VerSnapViewController.swift
//  Snapchat
//
//  Created by Rosario on 22/05/17.
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
    
    @IBOutlet weak var grabarButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    var tipo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false
        
        setupRecorderAudio()
        playButton.isEnabled = false
    }
    
    
    func setupRecorderAudio () {
        do{
            //creando una sesión de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //Creando una dirección para el archivo de audio
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            //Crear opciones para el grabador de audio
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            //settings[AVEncoderAudioQualityKey] = AVAudioQuality.max.rawValue as AnyObject?
            //settings[AVEncoderBitRateKey] = 320000 as AnyObject?
            
            //Crear el objeto de grabacios de audio
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        } catch let error as NSError{
            print(error)
        }
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
    
    
    @IBAction func grabarTapped(_ sender: Any) {
        tipo = "sonido"
        if audioRecorder!.isRecording{
            //Detener la grabación
            audioRecorder?.stop()
            //Cambiar el texto del boton grabar
            grabarButton.setTitle("Grabar", for: .normal)
            playButton.isEnabled = true
            elegirContactoBoton.isEnabled = true
        }
        else{
            // empezar a grabar
            audioRecorder?.record()
            //cambiar el titulo del boton a detener
            grabarButton.setTitle("Stop", for: .normal)
            
        }
    }

    @IBAction func playTapped(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf:audioURL!)
            audioPlayer!.play()
        }
        catch{}
    }
    
    @IBAction func elegirContactoTapped(_ sender: Any) {

        elegirContactoBoton.isEnabled = false

        
        if (tipo == "imagen"){
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
            
        
        }else if( tipo == "sonido"){
            let sonidoFolder = FIRStorage.storage().reference().child("audios")
            let sonidoData = NSData(contentsOf: audioURL!)
            
            sonidoFolder.child("\(imagenID).m4a").put(sonidoData as! Data, metadata: nil, completion:{(metadata,error)in
                print("Intentando subir el audio ")
                if error != nil{
                    print("Ocurrió un error:\(error)")
                }
                else{
                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: metadata?.downloadURL()!.absoluteString)
                }
            })
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.imagenID = imagenID
        siguienteVC.tipo = tipo
    }
}
