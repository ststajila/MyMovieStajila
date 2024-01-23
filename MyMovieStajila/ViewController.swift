//
//  ViewController.swift
//  MyMovieStajila
//
//  Created by STANISLAV STAJILA on 1/22/24.
//

struct MovieSearch: Codable{
    var Title: String
    var Year: String
}

struct SearchResults: Codable{
    var Search: [MovieSearch]
}

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var searchResultsTextView: UITextView!
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func search(_ sender: Any) {
        if searchTextField.text != "" {
            searchForTheMovie()
        } else{
            searchResultsTextView.textColor = UIColor.red
            searchResultsTextView.text = "Type something to search!"
        }
    }
    
    func searchForTheMovie(){
        let session = URLSession.shared
        let movieURL = URL(string: "http://www.omdbapi.com/?i=tt3896198&apikey=cafd33a0&api&s=\(searchTextField.text!.lowercased())")
        
        let dataTask = session.dataTask(with: movieURL!){
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let e = error{
                print("Error: \(e)")
            }else{
                if let d = data {
                    if let jsonObj = try? JSONSerialization.jsonObject(with: d, options: .allowFragments) as? NSDictionary{
                        print(jsonObj)
                        if let response = jsonObj.object(forKey: "Response") as? String{
                            if response == "True"{
                            if let movieObj = try? JSONDecoder().decode(SearchResults.self, from: d){
                                DispatchQueue.main.async{
                                    self.searchResultsTextView.textColor = UIColor.black
                                    self.searchResultsTextView.text = ""
                                    for movie in movieObj.Search{
                                        DispatchQueue.main.async{
                                            self.searchResultsTextView.text += "\(movie.Title): \(movie.Year)\n"
                                        }
                                    }
                                }
                                }
                            } else {
                                if let error = jsonObj.value(forKey: "Error"){
                                    DispatchQueue.main.async{
                                        self.searchResultsTextView.textColor = UIColor.red
                                        self.searchResultsTextView.text = "\(error)"
                                    }
                                }
                            }
                        }
                    }
                }
            }
                        
                    }
        dataTask.resume()
    }
    
}
