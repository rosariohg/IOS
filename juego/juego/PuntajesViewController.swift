//
//  PuntajesViewController.swift
//  juego
//
//  Created by rosario on 6/27/17.
//  Copyright © 2017 Tecsup. All rights reserved.
//

import UIKit
import Firebase

class PuntajesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var usuarios : [Usuario] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        FIRDatabase.database().reference().child("usuarios").observe(FIRDataEventType.childAdded, with: {(user) in
            
                let usuario = Usuario()
                usuario.email = (user.value as! NSDictionary)["email"] as! String
                usuario.id = user.key
                usuario.puntaje = (user.value as! NSDictionary)["puntaje"] as! String
                usuario.foto = (user.value as! NSDictionary)["foto"] as! String
            
                self.usuarios.append(usuario)
                self.tableView.reloadData()
            })
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email + " - " + usuario.puntaje
        //var imageView = new; UIImageView()
        //cell.imageView?.image = w(with: URL(string: usuario.foto))
        if (usuario.charge_foto) {
            cell.imageView?.image = usuario.foto_img
        }
        
        var imgURL: NSURL = NSURL(string: usuario.foto)!
        let request: NSURLRequest = NSURLRequest(url: imgURL as URL)
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler: {(response: URLResponse?, data: Data?, error: Error?) -> Void in
            if error == nil {
                //cell.imageView?.image = UIImage(data:data!)
                
                usuario.foto_img = UIImage(data:data!)
                usuario.charge_foto = true
                
                //cell.imageView?.image =
                //cell.reloadInputViews()
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        })
        
        return cell
    }

   
}
