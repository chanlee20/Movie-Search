//
//  ViewController.swift
//  ChanLee-lab4
//
//  Created by 이찬 on 10/21/22.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var movieSegment: UISegmentedControl!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    let api_key = "a83d8351a7880fa05c8651c59be8b237"
    
    struct APIResults:Decodable {
        let page: Int
        let total_results: Int
        let total_pages: Int
        let results: [Movie]
    }
    
    struct Movie: Decodable {
        let id: Int!
        let poster_path: String?
        let title: String
        let release_date: String?
        let vote_average: Double
        let overview: String
        let vote_count:Int!
    }
    
    var theImageCache: [UIImage] = []
    var theData: [APIResults] = []
    var theMovie: [Movie] = []
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theImageCache.count
    }
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var movieImageView: UIImageView!
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
        
        let textView = UITextView(frame: CGRect(x: 0.0, y: 90.0, width: 110.0, height: 40.0))
        textView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        textView.textColor = UIColor.white
        textView.isEditable = false
        
        if(theMovie.isEmpty){
            textView.text = ""
        }
        else{
            textView.text = theMovie[indexPath.section * 3 + indexPath.row].title
            print(theMovie[indexPath.section * 3 + indexPath.row].title)
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 110.0, height: 120))

        if(theImageCache.isEmpty){
            imageView.image = nil
        }
        else{
            imageView.image = theImageCache[indexPath.row]
        }
        
        cell.contentView.addSubview(imageView)
        cell.contentView.addSubview(textView)

        return cell
    }
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        searchBar.delegate = self
        fetchTopRatedDataForCollectionView()
        
        self.loadIndicator.isHidden = true;
        self.loadIndicator.hidesWhenStopped = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        if(movieSegment.selectedSegmentIndex == 0){
            self.collectionView.reloadData()
            self.loadIndicator.isHidden = false
            self.loadIndicator.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                self.fetchTopRatedDataForCollectionView()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.loadIndicator.stopAnimating()
                }
            }
            
        }
        else{
            self.collectionView.reloadData()
            self.loadIndicator.isHidden = false
            self.loadIndicator.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                self.fetchUpComingDataForCollectionView()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.loadIndicator.stopAnimating()
                }
            }
        }
    }
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross: CGFloat = 3
        let dim = UIScreen.main.bounds.width / cellsAcross - 10
        return CGSize(width: dim, height: dim + dim*0.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedVC = DetailedViewController()
        detailedVC.image = theImageCache[indexPath.row]
        detailedVC.imageName = theMovie[indexPath.section * 3 + indexPath.row].title
        detailedVC.id = theMovie[indexPath.section * 3 + indexPath.row].id
        detailedVC.releaseDate = theMovie[indexPath.section * 3 + indexPath.row].release_date
        detailedVC.votes = theMovie[indexPath.section * 3 + indexPath.row].vote_count
        detailedVC.voteAverage = theMovie[indexPath.section * 3 + indexPath.row].vote_average
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    

        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil){ (action) -> UIMenu? in
            
            let AddToFavorites = UIAction(title: "Add To Favorites", image: UIImage(systemName: "star.fill"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
                self.addFavorites(title: self.theMovie[indexPath.section * 3 + indexPath.row].title, num: self.theMovie[indexPath.section * 3 + indexPath.row].id)
            }
            
            
            return UIMenu(title: "Options", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [AddToFavorites])
            
        }
        return context
    }
    
    @objc func addFavorites(title: String, num: Int) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths[0]
        let path = documentPath.description.appendingFormat("/movies.plist")
        let favMoviesDict:NSMutableDictionary = NSMutableDictionary(contentsOfFile: path)!
        favMoviesDict.setValue(num, forKey: title)
        favMoviesDict.write(toFile: path, atomically: false)
        print("fav dict is \(favMoviesDict)")
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var searchedWord:String = searchBar.text ?? ""
        searchedWord = searchedWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.collectionView.reloadData()
        self.loadIndicator.isHidden = false
        self.loadIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchDataForCollectionView(word: searchedWord)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.loadIndicator.stopAnimating()
            }
        }
    }
    
    func fetchTopRatedDataForCollectionView() {
        theMovie = []
        theData = []
        theImageCache = []
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=a83d8351a7880fa05c8651c59be8b237&language=en-US&page=1")
        
        let data = try? Data(contentsOf: url!)
        let temp = try? JSONDecoder().decode(APIResults.self, from:data!)
        theData.append(temp!)
        cacheImages()
    }
    
    func fetchUpComingDataForCollectionView() {
        theMovie = []
        theData = []
        theImageCache = []
        let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=a83d8351a7880fa05c8651c59be8b237&language=en-US&page=1")
        
        let data = try? Data(contentsOf: url!)
        let temp = try? JSONDecoder().decode(APIResults.self, from:data!)
        theData.append(temp!)
        cacheImages()
    }
    
    func fetchDataForCollectionView(word: String) {
        theMovie = []
        theData = []
        theImageCache = []
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(api_key)&language=en-US&query=\(word)&page=1&include_adult=false")
 
        let data = try? Data(contentsOf: url!)
        let temp = try? JSONDecoder().decode(APIResults.self, from:data!)
        theData.append(temp!)
        cacheImages()
    }
    
    func cacheImages() {
          //URL
          //Data
          //UIImage
        for item in theData[0].results {
            theMovie.append(item)
            if(item.poster_path != nil){
                let posterPath: String = item.poster_path ?? ""
                let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                theImageCache.append(image!)
            }
        }
    }
    
    
}

