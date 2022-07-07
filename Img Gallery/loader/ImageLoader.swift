//
//  ImageLoader.swift
//  MediaBrowser
//
//  Created by Gardner von Holt on 7/9/20.
//

import UIKit
import Combine

class ImageLoader {

    static func readImage(file: ImageFile, completionHandler: @escaping ((_ file: ImageFile) -> Void)) {
        if file.imageReady {
            completionHandler(file)
            return
        }
        let url = file.imageUrl
        let urlRequest: URLRequest = URLRequest(url: url)
        let session = AppData.sharedInstance.session
        guard session != nil else { return }

        let task = session!.dataTask(with: urlRequest) { data, response, error in
            guard error == nil && data != nil else {
                let errorDescription = error?.localizedDescription ?? "unknown".localizedWithComment(comment: "message in message in image loader")
                let errorReadingImageUrl = "error.reading.image.url".localizedWithComment(comment: "message in message in image loader")
                let forUrl = "for.url".localizedWithComment(comment: "message in message in image loader")
                print("\(errorReadingImageUrl) : \(errorDescription) \(forUrl) \(url.absoluteString)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    let filePath = file.getFullPath()
                    let errorForFile = "error.for.file".localizedWithComment(comment: "message in message in image loader")
                    let status = "status".localizedWithComment(comment: "message in message in image loader")
                    print("\(errorForFile) : \(filePath) \(status) : \(httpResponse.statusCode)")
                    return
                }
            }

            guard let data = data else { return }
            DispatchQueue.main.async {
                let uiImage = UIImage(data: data)
                if uiImage != nil {
                    file.setImage(uiImage!)
                    AppData.sharedInstance.imageDisplay.updateImage(file: file)
                    completionHandler(file)
                } else {
                    let imageMissingForFile = "imageMissing.forFile".localizedWithComment(comment: "message in image loader")
                    print("\(imageMissingForFile) \n\(file.getFullPath())")
                }
            }
        }
        task.resume()
    }
}
