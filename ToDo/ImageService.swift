//
//  ImageService.swift
//  ToDo
//
//  Created by Ana Mamic on 27/10/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    
    func getDirectoryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    func getImageFromDocumetsDirectory(name: String) -> UIImage? {
        let fileManager = FileManager()
        let imagePath = (getDirectoryPath() as NSString).appendingPathComponent("\(name)")
        
        if !fileManager.fileExists(atPath: imagePath) {
            return nil
        }
        
        return UIImage(contentsOfFile: imagePath)
    }
    
    func saveImageToDocumentsDirectory(name: String, imageData: Data) {
        let fileManager = FileManager()
        let imagePath = (getDirectoryPath() as NSString).appendingPathComponent("\(name)")
        fileManager.createFile(atPath: imagePath, contents: imageData, attributes: nil)
    }
    
}
