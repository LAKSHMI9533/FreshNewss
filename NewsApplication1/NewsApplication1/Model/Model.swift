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

var menuArray = ["View Profile","SavedNews","Contact Us","Log Out"]

var categoryArray = ["All","general","business","entertainment","health","politics", "science","sports","technology"]

var FavArray = ["business","entertainment"]

