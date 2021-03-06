//
//  ApiService.swift
//  CongLinhApp
//
//  Created by nguyen van cong linh on 07/04/2018.
//  Copyright © 2018 nguyen van cong linh. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    static let shareInstance = ApiService()
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideo(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/home.json", completion: completion)
    }
    
    func fetchTrendingFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/trending.json", completion: completion)
    }
    
    func fetchSubscriptionFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "https://s3-us-west-2.amazonaws.com/youtubeassets/subscriptions.json") { (videos) in
            completion(videos)
        }
    }
    
    func fetchFeedForUrlString(urlString: String, completion: @escaping ([Video]) -> ())
    {
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
            if error != nil {
                print("error")
                return
            }
            
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
            var videos = [Video]()
            print(json)
            for dictionary in json as! [[String: AnyObject]]{
                let video = Video()
                video.title = dictionary["title"] as? String
                video.thumbnail_image_name = dictionary["thumbnail_image_name"] as? String
                video.number_of_views = dictionary["number_of_views"] as? NSNumber
                
//                video.setValuesForKeys(dictionary)
                
                let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                
                let channel = Channel()
                channel.name = channelDictionary["name"] as? String
                channel.profileImageName = channelDictionary["profile_image_name"] as? String
                    
                video.channel = channel
                videos.append(video)
            }
                
            DispatchQueue.main.async {
                completion(videos)
            }
                
        } catch let jsonError {
            print(jsonError)
        }
        }.resume()
    }
    
}


//let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
//
//var videos = [Video]()
//print(json)
//for dictionary in json as! [[String: AnyObject]]{
//    let video = Video()
//    video.title = dictionary["title"] as? String
//    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
//
//    let channelDictionary = dictionary["channel"] as! [String: AnyObject]
//
//    let channel = Channel()
//    channel.name = channelDictionary["name"] as? String
//    channel.profileImageName = channelDictionary["profile_image_name"] as? String
//
//    video.channel = channel
//    videos.append(video)
//}
//
//DispatchQueue.main.async {
//    completion(videos)
//}









