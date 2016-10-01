//
//  Preview.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/1/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Mapper

struct Preview {
    let source: Image
    let resolutions: [Image]
}

extension Preview: Convertible {
    static func fromMap(_ value: Any) throws -> Preview {
        guard let preview = value as? NSDictionary, let images = preview["images"] as? NSArray, let actualImages = images[0] as? NSDictionary, let sourceData = actualImages["source"] as? NSDictionary, let resolutionsData = actualImages["resolutions"] as? NSArray, let source = Image.from(sourceData), let resolutions = Image.from(resolutionsData) else {
            throw MapperError.convertibleError(value: value, type: Preview.self)
        }
        return Preview(source: source, resolutions: resolutions)
    }
}
