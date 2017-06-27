//
//  CorrectoViewController.swift
//  Pods
//
//  Created by rosario on 6/26/17.
//
//

import UIKit

class CorrectoViewController: UIViewController {

    @IBOutlet weak var puntajeLabel: UILabel!
    var puntaje : Int = 0
    var pregunta_actual : Int = 0
    var preguntas : [Pregunta] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        puntajeLabel.text! = String(puntaje)
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "siguientepreguntasegue"{
            let jugarVC = segue.destination as! JugarViewController
            jugarVC.puntaje = puntaje
            jugarVC.pregunta_actual = pregunta_actual
            jugarVC.preguntas = preguntas
        }
    }

}
