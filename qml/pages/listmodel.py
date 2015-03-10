#!/usr/bin/env python
# -*- coding: utf-8 -*-

import vegguide
import veggiesailor
import json

def check_has_regions(seq):
    """Updates list with missing values"""
    for j in range(len(seq)):
        seq[j]['has_entries'] = 0
        if int(seq[j]['entry_count']) != 0 and int(seq[j]['is_country']) != 1:
            seq[j]['has_entries'] = 1
    return seq


class VegGuideCache(object):
    """Cache wrapper for VegGuideObject"""
    def __init__(self, uri, obj_type):
        self.cache = veggiesailor.CacheHttp(uri)


        results = self.cache.get()

        try:
            self.results = json.loads(results)
        except TypeError:
            print("TypeError self.results", results)
            self.results = None

        if not self.results:
            provider = obj_type(uri)
            # super().__init__(uri)
            self.cache.put(json.dumps(provider.results))

class VegGuideObjectCache(vegguide.VegGuideObject):
    """Cache wrapper for VegGuideObject"""
    def __init__(self, uri):
        self.cache = veggiesailor.CacheHttp(uri)
        results = self.cache.get()

        try:
            self.results = json.loads(results)
        except TypeError:
            print("TypeError self.results", results)
            self.results = None

        if not self.results:
            super().__init__(uri)
            self.cache.put(json.dumps(self.results))

class VegGuideObjectEntriesCache(vegguide.VegGuideObjectEntries):
    """Cache wrapper for VegGuideObjectEntries"""
    def __init__(self, uri):
        self.cache = veggiesailor.CacheHttp(uri)
        results = self.cache.get()

        try:
            self.results = json.loads(results)
        except TypeError:
            print("TypeError self.results", results)
            self.results = None

        if not self.results:
            super().__init__(uri)
            self.cache.put(json.dumps(self.results))




def get_vegguide_regions(hierarchy, uri):
    # root = vegguide.VegGuideObject(uri)
    root = VegGuideObjectCache(uri)
    result = root.results['regions'][hierarchy]
    return check_has_regions(result)

def get_vegguide_children(uri):
    # children = vegguide.VegGuideObject(uri)
    children = VegGuideObjectCache(uri)
    result = children.results['children']
    return check_has_regions(result)

def get_entries(uri):
    """
    Gets entries after providing url


    """
    results = VegGuideObjectEntriesCache(uri).results
    for i in range(0, len(results)):
        if 'address2' not in results[i]:
            results[i]['address2'] = ''
    return results
