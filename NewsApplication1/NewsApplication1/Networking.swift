//
//  Networking.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 23/08/23.
//

import Foundation
import Combine
import UIKit

var searchUrl = "https://newsapi.org/v2/everything?apiKey=389c661b7e474bb58d0c4b149f57533b&q="

var can =  Set<AnyCancellable>()
var cacheData = NSCache<AnyObject,AnyObject>()

var a = "https://newsapi.org/v2/top-headlines?country=in&apiKey=389c661b7e474bb58d0c4b149f57533b&pageSize=100&category="

var keys = "389c661b7e474bb58d0c4b149f57533b,hulk,ef8d6b5fdee84cc6afcfd3b93b4f634b,madhu"

var  baseUrl = URL(string: "https://newsapi.org/v2/everything?domains=techcrunch.com,thenextweb.com,bbc.com&apiKey=389c661b7e474bb58d0c4b149f57533b&pageSize=100&language=en")
var baseUrlString = "https://newsapi.org/v2/everything?domains=techcrunch.com,thenextweb.com,bbc.com&apiKey=389c661b7e474bb58d0c4b149f57533b&pageSize=100&language=en"
var second  = "https://newsdata.io/api/1/news?apikey=389c661b7e474bb58d0c4b149f57533b&country=in&language=en&category="

func addingCatToUrl( category : categoryEnum)->String{
    
    switch category{
    case .business :
        var q = a + "business"
        return q
    case .entertainment:
        let q = a + "entertainment"
        return q
    case .health:
        let q = a + "health"
        return q
    case .politics:
        let q = a + "politics"
        return q
    case .science:
        let q = a + "science"
        return q
    case .sports:
        let q = a + "sports"
        return q
    case .technology:
        let q = a + "technology"
        return q
    case .general:
        let q = a + "general"
        return q
    case .All:
        return baseUrlString
    }
    return ""
}


func apiCall(catApiUrl : String = "")->Future<Responce,Error>{
    Future{ promice in
        if catApiUrl != ""{
            baseUrl = URL(string: "\(catApiUrl)")
        }
        
        var task = URLSession(configuration:.default).dataTask(with: baseUrl!) { Data, urlresponce, error in
            if Data != nil{
                do{
                    let reData = try JSONDecoder().decode(Responce.self, from: Data!)
                    promice(.success(reData))
                } catch {
                    print(error)
                }
            } else {
                promice(.failure(error!))
            }
            
        }.resume()
    }
}

func apiCallForImage(uurl : String)->Future<UIImage,Error>{
    Future{ promice in
        if let url = URL(string: uurl){
            if let imageCache = cacheData.object(forKey: url.absoluteString as AnyObject) as? UIImage{
                promice(.success(imageCache))
            }
            var imgTask = URLSession(configuration:.default).dataTask(with: url) { Data, urlresponce, error in
                if let data = Data{
                    do{
                        if let reData = try UIImage(data: data){
                            cacheData.setObject(reData, forKey: url.absoluteString as AnyObject)
                            promice(.success(reData))
                        }
                    } catch {
                        print(error)
                    }
                } else {
                    promice(.failure(error!))
                }
            }.resume()
        } else {
            print("unable to convert string to url\(uurl)")
        }
    }
}
