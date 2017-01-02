//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Paul Silver on 12/31/16.
//  Copyright © 2016 paulcsilver. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var currentEvolutionImage: UIImageView!
    @IBOutlet weak var nextEvolutionImage: UIImageView!
    @IBOutlet weak var evolutionLabel: UILabel!
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = pokemon.name.capitalized
        mainImage.image = UIImage(named: "\(pokemon.id)")
        currentEvolutionImage.image = UIImage(named: "\(pokemon.id)")
        pokedexLabel.text = "\(pokemon.id)"
        
        pokemon.downloadPokemonDetails {
            // Update UI
            self.updateUI()
        }
    }
    
    // MARK: Instance Methods
    
    // MARK: Private Methods
    private func updateUI() {
        attackLabel.text = pokemon.attack
        defenseLabel.text = pokemon.defense
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        typeLabel.text = pokemon.type
        descriptionTextView.text = pokemon.description
        
        if pokemon.nextEvolutionPokedexId == -1 {
            evolutionLabel.text = "No Evolutions"
            nextEvolutionImage.isHidden = true
        } else {
            nextEvolutionImage.isHidden = false
            nextEvolutionImage.image = UIImage(named: "\(pokemon.nextEvolutionPokedexId)")
            let evolutionText = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
            evolutionLabel.text = evolutionText
        }
    }

    // MARK: IBActions
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
