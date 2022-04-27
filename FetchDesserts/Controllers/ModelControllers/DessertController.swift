//
//  DessertController.swift
//  FetchDesserts
//
//  Created by Gavin Woffinden on 4/21/22.
//

// Dessert List: https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert
// Dessert Info: https://www.themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID

import Foundation

class DessertController {
    static let shared = DessertController()
    static var recipeID = ""
    static let ingredientStr = ""
    static func fetchDesserts(completion: @escaping (Result<[Dessert], LocalError>) -> Void) {
        var desserts: [Dessert] = []
        var newDes = Dessert(name: "", imageURL: "", dessertID: "")
        
        
        
        guard let dessertsURL = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {return completion(.failure(.invalidURL))}
        URLSession.shared.dataTask(with: dessertsURL) { (data, response, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            if let response = response as? HTTPURLResponse {
                print("POST STATUS CODE: \(response.statusCode)")
            }
            guard let data = data else {return completion(.failure(.noData))}
            do {
                let TopObject = try JSONDecoder().decode(Desserts.self, from: data)
                let SecondObject = TopObject.meals
                for i in SecondObject {
                    newDes = Dessert(name: i.name, imageURL: i.imageURL, dessertID: i.dessertID)
                    desserts.append(newDes)
                }
                completion(.success(desserts))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    static func fetchRecipe(completion: @escaping (Result<FinalRecipe, LocalError>) -> Void) {
        
        var newRec = FinalRecipe(name: "", instructions: "", ingredients: [], measurements: [])
        guard let recipeURL = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=" + recipeID) else {return completion(.failure(.invalidURL))}
        URLSession.shared.dataTask(with: recipeURL) { (data, response, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            if let response = response as? HTTPURLResponse {
                print("POST STATUS CODE: \(response.statusCode)")
            }
            guard let data = data else {return completion(.failure(.noData))}
            do {
                
                let TopObject = try JSONDecoder().decode(Recipe.self, from: data)
                let SecondObject = TopObject.meals
                
                for i in SecondObject {
                    
                    var ingredients: [Any] = [i.ingredient1, i.ingredient2, i.ingredient3, i.ingredient4, i.ingredient5, i.ingredient6, i.ingredient7, i.ingredient8, i.ingredient9, i.ingredient10, i.ingredient11, i.ingredient12, i.ingredient13, i.ingredient14, i.ingredient15, i.ingredient16, i.ingredient17, i.ingredient18, i.ingredient19, i.ingredient20]
                    var measurements: [Any] = [i.measurement1, i.measurement2, i.measurement3, i.measurement4, i.measurement5, i.measurement6, i.measurement7, i.measurement8, i.measurement9, i.measurement10, i.measurement11, i.measurement12, i.measurement13, i.measurement14, i.measurement15, i.measurement16, i.measurement17, i.measurement18, i.measurement19, i.measurement20]
                    
                    var finIngredients: [String] = []
                    var finMeasurements: [String] = []
                    
                    for i in ingredients.compactMap({$0}) {
                        if i is String {
                            
                            finIngredients.append(i as! String)
                        }
                    }
                    for i in measurements.compactMap({$0}) {
                        if i is String {
                            finMeasurements.append(i as! String)
                        }
                    }
                    
                    newRec = FinalRecipe(name: i.name, instructions: i.instructions, ingredients: finIngredients, measurements: finMeasurements)
                }
                completion(.success(newRec))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
}
