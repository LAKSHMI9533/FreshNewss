//
//  Model.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 23/08/23.
//
import Foundation

struct Responce : Codable{
    var status : String?
    var totalResults : Int?
    var articles : [results]
}

struct results : Codable{
    var author : String?
    var title : String?
    var description : String?
    var url : String?
    var urlToImage : String?
    var publishedAt : String?
    var content : String?
    var nextPage : Int?
}


enum categoryEnum : Int, CaseIterable{
    case All = 0,general,business,
         entertainment,
         health,
         politics,
         science,
         sports,
         technology
         
}

var menuArray = ["View Profile","Contact Us","Log Out"]

var categoryArray = ["All","general","business","entertainment","health","politics", "science","sports","technology"]

var FavArray = ["business","entertainment"]

var searchUrl = "https://newsapi.org/v2/everything?apiKey=ef8d6b5fdee84cc6afcfd3b93b4f634b&q="

//var a = "https://newsapi.org/v2/top-headlines?country=in&apiKey=389c661b7e474bb58d0c4b149f57533b&category="
//var category = "bugines"
//
//var keys = "389c661b7e474bb58d0c4b149f57533b,hulk,ef8d6b5fdee84cc6afcfd3b93b4f634b,madhu"
//
//var  baseUrl = URL(string: "https://newsapi.org/v2/everything?domains=techcrunch.com,thenextweb.com,bbc.com&apiKey=389c661b7e474bb58d0c4b149f57533b&language=en")
//
//var second  = "https://newsdata.io/api/1/news?apikey=pub_280928dc2d16bb16f2f5a3df3e0f4a7c3877c&country=in&language=en&category="
