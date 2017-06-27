//
//  JugarViewController.swift
//  juego
//
//  Created by rosario on 6/26/17.
//  Copyright © 2017 Tecsup. All rights reserved.
//

import UIKit
import Firebase

class JugarViewController: UIViewController {

    @IBOutlet weak var preguntaTextView: UITextView!
    
    var preguntas : [Pregunta] = []
    var pregunta_actual : Int = 0
    var pregunta = Pregunta()
    var puntaje : Int = 0
    
    @IBOutlet weak var opcion1: UIButton!
    @IBOutlet weak var opcion2: UIButton!
    @IBOutlet weak var opcion3: UIButton!
    @IBOutlet weak var opcion4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if pregunta_actual == 0 {
        FIRDatabase.database().reference().child("preguntas").observe(FIRDataEventType.childAdded, with: {(item) in
                let pregunta = Pregunta()
            
            pregunta.nombre = item.key
            pregunta.a = (item.value as! NSDictionary)["a"] as! String
            pregunta.b = (item.value as! NSDictionary)["b"] as! String
            pregunta.c = (item.value as! NSDictionary)["c"] as! String
            pregunta.d = (item.value as! NSDictionary)["d"] as! String
            pregunta.opcion_correcta = (item.value as! NSDictionary)["opcion_correcta"] as! String
            self.preguntas.append(pregunta)
            
            self.llenarDatos()
            })
        }else {
            llenarDatos()
        }
        
    }
    
    func llenarDatos() {
        pregunta = preguntas[pregunta_actual]
        preguntaTextView.text? = pregunta.nombre
        opcion1.setTitle(pregunta.a, for: .normal)
        opcion2.setTitle(pregunta.b, for: .normal)
        opcion3.setTitle(pregunta.c, for: .normal)
        opcion4.setTitle(pregunta.d, for: .normal)
        
    }
    
    @IBAction func seleccionado(_ sender: UIButton) {
       
        var flag : Bool = false
        
        switch sender {
        case opcion1:
            if pregunta.opcion_correcta == "a" {
                print("opcion correcta")
                flag = true
            }
            
        case opcion2:
            if pregunta.opcion_correcta == "b" {
                print("opcion correcta")
                flag = true
            }
        case opcion3:
            if pregunta.opcion_correcta == "c" {
                print("opcion correcta")
                flag = true
            }
        case opcion4:
            if pregunta.opcion_correcta == "d" {
                print("opcion correcta")
                flag = true
            }
        
        default:
            break
        }
        if flag == true {
            puntaje += 10
            pregunta_actual += 1
            
            if preguntas.count == pregunta_actual {
                performSegue(withIdentifier: "finsegue", sender: self)
            }else {
            
                performSegue(withIdentifier: "correctosegue", sender: self)
            }
        } else {
            performSegue(withIdentifier: "finsegue", sender: self)        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "correctosegue" {
            let correctoVC = segue.destination as! CorrectoViewController
            
            correctoVC.puntaje = puntaje
            correctoVC.pregunta_actual = pregunta_actual
            correctoVC.preguntas = preguntas
        }else if segue.identifier == "finsegue" {
            let finalVC = segue.destination as! JuegoTerminadoViewController
            
            finalVC.puntaje = puntaje
        }
    }
    
    
  

}
