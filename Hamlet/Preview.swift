//
//  Preview.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/1/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Mapper

struct Preview {
    let variantSource: Variant
    let variantGIF: Variant?
    let variantMP4: Variant?
}

extension Preview: Convertible {
    static func fromMap(_ value: Any) throws -> Preview {
        guard let preview = value as? NSDictionary, let images = preview["images"] as? NSArray, let actualImages = images[0] as? NSDictionary, let source = getVariant(json: actualImages) else {
            throw MapperError.convertibleError(value: value, type: Preview.self)
        }
        
        var gif: Variant? = nil
        var mp4: Variant? = nil
        
        if let variants = actualImages["variants"] as? NSDictionary {
            if let gifData = variants["gif"] as? NSDictionary {
                gif = getVariant(json: gifData)
            }
            if let mp4Data = variants["mp4"] as? NSDictionary {
                mp4 = getVariant(json: mp4Data)
            }
        }
        
        return Preview(variantSource: source, variantGIF: gif, variantMP4: mp4)
    }
    
    private static func getVariant(json: NSDictionary) -> Variant? {
        guard let sourceData = json["source"] as? NSDictionary, let resolutionsData = json["resolutions"] as? NSArray, let source = Image.from(sourceData), let resolutions = Image.from(resolutionsData) else {
            return nil
        }
        return Variant(source: source, resolutions: resolutions)
    }
}
