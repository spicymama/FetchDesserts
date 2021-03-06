//
//  DetailViewController.swift
//  FetchDesserts
//
//  Created by Gavin Woffinden on 4/25/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var instructionBox: UITextView!
    @IBOutlet weak var measurementTextView: UITextView!
    @IBOutlet weak var ingredientTextView: UITextView!
    
    var selectedDessert: Dessert?
    var newRecipe: FinalRecipe?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        DessertController.fetchRecipe { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newRec):
                    
                    self.newRecipe = newRec
                    self.nameLabel.text = newRec.name
                    self.instructionBox.text = newRec.instructions
//included newline after each ingredient/ measurement to streamline formatting
                    for i in self.newRecipe!.ingredients {
                        self.ingredientTextView.text.append(i + "\n")
                    }
                    for i in self.newRecipe!.measurements {
                        self.measurementTextView.text.append(i + "\n")
                    }
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
}
