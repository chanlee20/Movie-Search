//
//  ActorViewController.swift
//  ChanLee-lab4
//
//  Created by 이찬 on 10/31/22.
//

import UIKit

class ActorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    struct APIResult : Decodable{
//        let results : [Actor]
//        let total_results : Int
//    }
//
//    struct Actor : Decodable{
//        let name : String
//        let profile_path : String
//        let popularity : Int
//    }
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    struct APIResults:Decodable {
        let total_results : Int
        let results: [Actor]
    }
    
    struct Actor: Decodable {
        let name : String
        let profile_path : String
        let popularity : Double
    }
    
    var theData : [APIResults] = []
    var theActors : [Actor] = []
    var theImageCache : [UIImage] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(theImageCache.count)
        return theImageCache.count > 20 ? 20 : theImageCache.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = theActors[indexPath.row].name + " | Popularity : " + String(Int(theActors[indexPath.row].popularity))
        cell.imageView?.image = theImageCache[indexPath.row]

        return cell
    }
    

    @IBOutlet weak var actorTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Popular Actors"
        self.loadIndicator.isHidden = false;
        self.loadIndicator.startAnimating()
        self.loadIndicator.hidesWhenStopped = true
        setUpActorTableView()
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchActorData()
            self.cacheImages()
            DispatchQueue.main.async {
                self.actorTableView.reloadData()
                self.loadIndicator.stopAnimating()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func fetchActorData() {
        theActors = []
        theData = []
        theImageCache = []
        let url = URL(string: "https://api.themoviedb.org/3/person/popular?api_key=a83d8351a7880fa05c8651c59be8b237&language=en-US&page=1")
        let data = try! Data(contentsOf: url!)
        let temp = try! JSONDecoder().decode(APIResults.self, from: data)
        theData.append(temp)
        for item in theData[0].results {
            theActors.append(item)
        }
    }
    
    func cacheImages() {
        for item in theData[0].results{
                let profilePath: String = item.profile_path
                let url = URL(string: "https://image.tmdb.org/t/p/w500/\(profilePath)")
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                theImageCache.append(image!)
            
        }
    }
    
    func setUpActorTableView() {
        actorTableView.dataSource = self
        actorTableView.delegate = self
        actorTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
