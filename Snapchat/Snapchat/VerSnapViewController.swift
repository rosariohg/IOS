//
//  VerSnapViewController.swift
//  Snapchat
//
//  Created by Rosario on 22/05/17.
//  Copyright © 2017 Tecsup. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import AVFoundation

class VerSnapViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    var local_url: NSURL?
    var audioURL : URL?
    var audioPlayer : AVAudioPlayer?
    
    var snap = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text? = snap.descrip
        print("---------------------------------")
        print(snap.tipo)
        if snap.tipo == "imagen"{
            imageView.sd_setImage(with: URL(string: snap.storageURL))
            playButton.isHidden = true
        } else if snap.tipo == "sonido" {
            imageView.isHidden = true
            playButton.isEnabled = false
            
            let urlstring = snap.storageURL
            let url = NSURL(string: urlstring)
            print("the url = \(url!)")
            downloadFileFromURL(url: url!)
        }
        
    }
    
    func downloadFileFromURL(url:NSURL){
        weak var weakSelf = self
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { (URL, response, error) -> Void in
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath,"audio_firebase.m4a"]
            self.audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            //weakSelf!.play(URL!)
            do {
                try FileManager.default.removeItem(at: self.audioURL!)
            } catch (let writeError) {
                print("error deleting file \(self.audioURL) : \(writeError)")
            }
            do {
                try FileManager.default.copyItem(at: URL!, to: self.audioURL!)
                self.playButton.isEnabled = true
                print("AUDIO DOWNLOADED")
                //completion()
            } catch (let writeError) {
                print("error writing file \(self.audioURL) : \(writeError)")
            }
            
        })
        
        downloadTask.resume()
    }
 
    
    @IBAction func playTapped(_ sender: Any) {
        print("__________________________")
        print("the audioURL is \(self.audioURL!)")
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: audioURL!)
            //audioPlayer?.prepareToPlay()
            //audioPlayer?.volume = 1.0
            audioPlayer?.play()
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FIRDatabase.database().reference().child("usuarios").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").child(snap.id).removeValue()
        if snap.tipo == "imagen"{
            FIRStorage.storage().reference().child("imagenes").child("\(snap.storageID).jpg").delete{(error) in
                print("Se eliminó la imagen correctamente")
            }
        } else if snap.tipo == "sonido" {
            FIRStorage.storage().reference().child("audios").child("\(snap.storageID).m4a").delete{(error) in
                print("Se eliminó el audio correctamente")
            }
         
         }
        
    }

}
