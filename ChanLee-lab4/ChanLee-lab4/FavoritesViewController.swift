//
//  FavoritesViewController.swift
//  ChanLee-lab4
//
//  Created by 이찬 on 10/28/22.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var favoriteMovies:[String] = []
    var favoriteMoviesDict:[String : Int] = [:]
    var favMoviesDict:NSMutableDictionary = [:]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths[0]
        let path = documentPath.description.appendingFormat("/movies.plist")
        favMoviesDict = NSMutableDictionary(contentsOfFile: path)!
        favMoviesDict.removeObject(forKey: favoriteMovies[indexPath.row])
        favMoviesDict.write(toFile: path, atomically: false)

        if(editingStyle == .delete){
            favoriteMovies.remove(at: indexPath.row)
            print(favoriteMovies)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = favoriteMovies[indexPath.row]
        return cell
    }
    
    func dataFromPropertyList() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths[0]
        let path = documentPath.description.appendingFormat("/movies.plist")
        let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: path))){
            let bundle : String = Bundle.main.path(forResource: "movies", ofType: ".plist")!
            do {
                try fileManager.copyItem(atPath: bundle, toPath: path)
            }
            catch {
                print(error)
            }
        }
        favMoviesDict = NSMutableDictionary(contentsOfFile: path)!

        for (key, value) in favMoviesDict {
            if(!favoriteMovies.contains(key as! String)){
                favoriteMovies.append(key as! String)
            }
            favoriteMoviesDict[key as! String] = value as? Int
        }
        
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoritesDetailedVC = FavoritesDetailedViewController()
        favoritesDetailedVC.movieTitle = favoriteMovies[indexPath.row]
        favoritesDetailedVC.movieId = favoriteMoviesDict[favoriteMovies[indexPath.row]] ?? -1
        self.present(favoritesDetailedVC, animated: true)
    }
    
   
    @IBAction func clearTableView(_ sender: Any) {
        print("clearing")
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths[0]
        let path = documentPath.description.appendingFormat("/movies.plist")
        favMoviesDict = NSMutableDictionary(contentsOfFile: path)!
        favMoviesDict.removeAllObjects()
        favMoviesDict.write(toFile: path, atomically: false)
        favoriteMovies.removeAll()
        print(favMoviesDict)
        print(favoriteMovies)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataFromPropertyList()
        setupTableView()
        self.tableView.reloadData()

    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
