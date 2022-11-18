//
//  WebImageView.swift
//  Vk
//
//  Created by Евгений Кононенко on 18.11.2022.
//

import Foundation
import UIKit

class WebImageView: UIImageView {
    func set(imageUrl: String?) {
        guard let imageUrl = imageUrl ,let url = URL(string: imageUrl) else {
            self.image = nil
            return
        }
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    self?.image = UIImage(data: data)
                    self?.handleLoadImage(data: data, response: response!)
                }
            }
        }
        dataTask.resume()
    }
    
    private func handleLoadImage(data: Data, response: URLResponse){
        guard let responseUrl = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseUrl))
    }
}
