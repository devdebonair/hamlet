//
//  Variant.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/2/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Mapper

struct Variant {
    let source: Media
    let resolutions: [Media]
    
    init(source: Media, resolutions: [Media]) {
        self.source = source
        self.resolutions = resolutions
    }
}

extension Variant: Convertible {
    static func fromMap(_ value: Any) throws -> Variant {
        guard let variant = value as? NSDictionary, let sourceData = variant["source"] as? NSDictionary, let source = Media.from(sourceData) else {
            throw MapperError.convertibleError(value: value, type: Variant.self)
        }
        var resolutions: [Media] = []
        if let resolutionsData = variant["resolutions"] as? NSArray, let parsedResolutions = Media.from(resolutionsData) {
            resolutions = parsedResolutions
        }
        return Variant(source: source, resolutions: resolutions)
    }
}
