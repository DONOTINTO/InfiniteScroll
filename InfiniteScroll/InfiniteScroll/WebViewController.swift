//
//  WebViewController.swift
//  InfiniteScroll
//
//  Created by 이중엽 on 2023/06/04.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController {
    var mainView = UIView()
    let webView = WKWebView()
    var viewURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        guard let viewURL = self.viewURL else { return }
        guard let url = URL(string: viewURL) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
