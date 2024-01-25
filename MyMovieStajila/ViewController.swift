//
//  ViewController.swift
//  MyMovieStajila
//
//  Created by STANISLAV STAJILA on 1/22/24.
//

public class SelectedMovieInfo{
    static var movie: MovieSearch?
}

struct MovieSearch: Codable{
    var Poster: String
    var Title: String
    var `Type`: String
    var Year: String
    var imdbID: String
}

struct SearchResults: Codable{
    var Search: [MovieSearch]
}

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var errorTrackingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var searchResultsArray: [MovieSearch] = []
    
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        errorTrackingLabel.textColor = UIColor.green
        errorTrackingLabel.text = "Everything Looks Good"
        
    }
    
    @IBAction func search(_ sender: Any) {
        if searchTextField.text != "" {
            searchForTheMovie()
        } else{
            errorTrackingLabel.textColor = UIColor.red
            errorTrackingLabel.text = "Type something to search!"
        }
    }
    
    func searchForTheMovie(){
        
        errorTrackingLabel.textColor = UIColor.green
        errorTrackingLabel.text = "Everything Looks Good"
        
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
                                    self.searchResultsArray = movieObj.Search
                                    DispatchQueue.main.async{
                                        self.tableView.reloadData()
                                    }
                                }
                            } else {
                                if let error = jsonObj.value(forKey: "Error") as? String{
                                    DispatchQueue.main.async{
                                        self.errorTrackingLabel.textColor = UIColor.red
                                        self.errorTrackingLabel.text = "\(error)"
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel!.text = "\(searchResultsArray[indexPath.row].Title): \(searchResultsArray[indexPath.row].Year)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedMovieInfo.movie = searchResultsArray[indexPath.row]
        performSegue(withIdentifier: "moreInfo", sender: self)
    }
    
}
