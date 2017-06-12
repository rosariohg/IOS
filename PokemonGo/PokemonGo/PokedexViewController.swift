//
//  PokedexViewController.swift
//  PokemonGo
//
//  Created by Rosario Huanca Gonza on 6/8/17.
//  Copyright © 2017 Rosario Huanca Gonza. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var pokemonsAtrapados:[Pokemon] = []
    var pokemonsNoAtrapados:[Pokemon] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        pokemonsAtrapados = obtenerPokemonsAtrapados()
        pokemonsNoAtrapados = obtenerPokemonsNoAtrapados()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Atrapados"
        } else{
            return "No Atrapados"
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon : Pokemon
        if indexPath.section == 0 {
            pokemon = pokemonsAtrapados[indexPath.row]
        }else{
            pokemon = pokemonsNoAtrapados[indexPath.row]
        }
        let cell = UITableViewCell()
        if pokemon.contador == nil{
            pokemon.contador = 0
        }
        cell.textLabel?.text = pokemon.nombre! + ": " +  (String(pokemon.contador))
        cell.imageView?.image = UIImage(named: pokemon.imagenNombre!)
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return pokemonsAtrapados.count
        } else{
            return pokemonsNoAtrapados.count
        }
    }
    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if indexPath.section == 0 {
                removerPokemonsAtrapado(pokemon: pokemonsAtrapados[indexPath.row])
                //pokemonsAtrapados.remove(at: indexPath.row)
                pokemonsAtrapados = obtenerPokemonsAtrapados()
                pokemonsNoAtrapados = obtenerPokemonsNoAtrapados()
                tableView.reloadData()
            }
        } else if editingStyle == .insert{
            
        }
    }

}
