//
//  Utils.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 17/10/21.
//

import Foundation

func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}
