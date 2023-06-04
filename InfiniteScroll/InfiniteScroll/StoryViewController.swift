//
//  StoryViewController.swift
//  InfiniteScroll
//
//  Created by 이중엽 on 2023/05/19.
//

import UIKit
import SnapKit

class StoryViewController: UIViewController {
    let storyTableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    var story = ""
    var storyList: [String] = []
    var actualList: [String] = []
    var perPage = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        makeUI()
    }
    
    func initialSetup() {
        self.view.addSubview(storyTableView)
        self.navigationItem.searchController = searchController
        storyTableView.delegate = self
        storyTableView.dataSource = self
        storyTableView.prefetchDataSource = self
        storyTableView.register(StoryTableViewCell.self, forCellReuseIdentifier: "StoryTableViewCell")
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    func makeUI() {
        storyTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    func update() {
        let start = actualList.count
        
        if storyList.count - 1 != perPage {
            perPage = perPage + 10
            
            if perPage > storyList.count {
                perPage = storyList.count - 1
            }
            
            actualList.append(contentsOf: storyList[start...perPage])
            storyTableView.reloadData()
        }
    }
    
    func getBlogInfo(query: String) {
        let baseURL = "https://dapi.kakao.com/v2/search/blog"
        let Authorization = "KakaoAK b201e75e24f51413d5e1b8707ca8231a"
        
        var url = URL(string: baseURL)
        url?.append(queryItems: [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "size", value: "50")
        ])
        
        guard let url = url else { return }
        
        var request = URLRequest(url: url)
        request.setValue(Authorization, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return }
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let kakao = try decoder.decode(Kakao.self, from: data)
                let kakaoData = kakao.documents
                var blognameList: String = ""
                DispatchQueue.main.sync {
                    print(kakaoData)
                    kakaoData.forEach {
                        blognameList.append("__ \($0.blogname)")
                    }
                    self.story = blognameList
                    self.storyList = self.story.components(separatedBy: "__ ")
                    self.actualList.removeAll()
                    self.actualList.append(contentsOf: self.storyList[0...10])
                    self.storyTableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
            print(response.statusCode)
        }.resume()
    }
}

extension StoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actualList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = storyTableView.dequeueReusableCell(withIdentifier: "StoryTableViewCell", for: indexPath) as? StoryTableViewCell else { return UITableViewCell() }
        cell.initialSetup()
        cell.makeUI()
        cell.myLabel.text = "\(storyList[indexPath.row])"
        
        return cell
    }
}

extension StoryViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        update()
    }
}

extension StoryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
}

extension StoryViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let resultText = searchBar.text else { return }
        self.getBlogInfo(query: resultText)
    }
}
