//
//  ImageFilter.swift
//  ImageFilterMac
//
//  Created by Alfian Losari on 25/02/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import MetalPetal

let serialQueue = DispatchQueue(label: "com.alfianlosari.imagefilter")

enum ImageFilter: String, Identifiable, Hashable, CaseIterable {
    
    var id: ImageFilter { self }
    
    case `default` = "Default"
    case contrast = "Contrast"
    case saturation = "Saturation"
    case pixellate = "Pixellate"
    case inverted = "Inverted"
    case dotScreen = "Dot Screen"
    case vibrance = "Vibrance"
    case skinSmoothing = "Skin Smoothing"
    case colorHalfTone = "Halftone"
    
    func performFilter(with image: CPImage, queue: DispatchQueue = serialQueue, completion: @escaping(CPImage) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let outputImage: CPImage
            
            switch self {
            case .default:
                outputImage = image
                
            case .pixellate:
                outputImage = self.processFilterWithMetal(image: image) { (inputImage) -> MTIImage? in
                    let filter = MTIPixellateFilter()
                    filter.inputImage = inputImage
                    return filter.outputImage
                }
                
            case .saturation:
                outputImage = self.processFilterWithMetal(image: image) { (inputImage) -> MTIImage? in
                    let filter = MTISaturationFilter()
                    filter.saturation = 0
                    filter.inputImage = inputImage
                    return filter.outputImage
                }
                
            case .dotScreen:
                outputImage = self.processFilterWithMetal(image: image) { (inputImage) -> MTIImage? in
                    let filter = MTIDotScreenFilter()
                    filter.inputImage = inputImage
                    return filter.outputImage
                }
                
            case .inverted:
                outputImage = self.processFilterWithMetal(image: image) { (inputImage) -> MTIImage? in
                    let filter = MTIColorInvertFilter()
                    filter.inputImage = inputImage
                    return filter.outputImage
                }
                
            case .vibrance:
                outputImage = self.processFilterWithMetal(image: image) { (inputImage) -> MTIImage? in
                    let filter = MTIVibranceFilter()
                    filter.amount = 0.5
                    filter.inputImage = inputImage
                    return filter.outputImage
                }
                
            case .skinSmoothing:
                outputImage = self.processFilterWithMetal(image: image) { (inputImage) -> MTIImage? in
                    let filter = MTIHighPassSkinSmoothingFilter()
                    filter.amount = 1
                    filter.radius = 5
                    
                    filter.inputImage = inputImage
                    return filter.outputImage
                }
                
            case .contrast:
                outputImage = self.processFilterWithMetal(image: image) { (inputImage) -> MTIImage? in
                    let filter = MTIContrastFilter()
                    filter.contrast = 1.5
                    filter.inputImage = inputImage
                    return filter.outputImage
                }
                
            case .colorHalfTone:
                outputImage = self.processFilterWithMetal(image: image) { (inputImage) -> MTIImage? in
                    let filter = MTIColorHalftoneFilter()
                    filter.scale = 2
                    
                    filter.inputImage = inputImage
                    return filter.outputImage
                }
                
                
                
   
                
            }
            
            DispatchQueue.main.async {
                completion(outputImage)
            }
        }
    }
    
    private func processFilterWithMetal(image: CPImage, filterHandler: (MTIImage) -> MTIImage?) -> CPImage {
        guard let ciImage = image.coreImage else {
            return image
        }
        
        let imageFromCIImage = MTIImage(ciImage: ciImage).unpremultiplyingAlpha()
        
        guard let outputFilterImage = filterHandler(imageFromCIImage), let device = MTLCreateSystemDefaultDevice(), let context = try? MTIContext(device: device)  else {
            return image
        }
        do {
            let outputCGImage = try context.makeCGImage(from: outputFilterImage)
            let nsImage = outputCGImage.cpImage
            
            return nsImage
        } catch {
            print(error)
            return image
        }
    }
}
