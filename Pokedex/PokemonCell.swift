//
//  PokemonCell.swift
//  Pokedex
//
//  Created by Paul Silver on 12/31/16.
//  Copyright © 2016 paulcsilver. All rights reserved.
//

import UIKit

class PokemonCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configure(with pokemon: Pokemon) {
        self.pokemon = pokemon
        
        nameLabel.text = self.pokemon.name.capitalized
        thumbnail.image = UIImage(named: "\(self.pokemon.id)")
    }
    
}
