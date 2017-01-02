//
//  PokedexVC.swift
//  Pokedex
//
//  Created by Paul Silver on 12/31/16.
//  Copyright © 2016 paulcsilver. All rights reserved.
//

import UIKit
import AVFoundation

class PokedexVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var pokemon = [Pokemon]()
    private var filteredPokemon = [Pokemon]()
    private var inSearchMode = false
    private var musicPlayer: AVAudioPlayer!
    
    private let kShowPokemonDetailSegue = "showPokemonDetail"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.returnKeyType = .done
        
        parsePokemonCSV()
        initAudio()
    }
    
    // MARK: Instance Methods
    
    func parsePokemonCSV() {
        if let path = Bundle.main.path(forResource: "pokemon", ofType: "csv") {
            do {
                let csv = try CSV(contentsOfURL: path)
                let rows = csv.rows
                
                for dict in rows {
                    let pokeId = Int(dict["id"]!)!
                    let name = dict["identifier"]!
                    
                    pokemon.append(Pokemon(name: name, id: pokeId))
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
    }
    
    func initAudio() {
        if let path = Bundle.main.path(forResource: "music", ofType: "mp3") {
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                musicPlayer.numberOfLoops = -1
                musicPlayer.prepareToPlay()
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
    }
    
    func collectionViewSource() -> [Pokemon] {
        
        return inSearchMode ? filteredPokemon : pokemon
    }
    
    // MARK: IBActions
    
    @IBAction func startStopMusic(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kShowPokemonDetailSegue {
            if let detailVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailVC.pokemon = poke
                }
            }
        }
    }
    
    // MARK: UICollectionView Protocols
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionViewSource().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath) as? PokemonCell {
            
            let pokemon = collectionViewSource()[indexPath.item]
            cell.configure(with: pokemon)
            
            return cell
        } else {
            
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let poke = collectionViewSource()[indexPath.item]
        performSegue(withIdentifier: kShowPokemonDetailSegue, sender: poke)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    // MARK: UISearchBarDelegate Protocol
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
        }
        
        collectionView.reloadData()
    }
    
}

