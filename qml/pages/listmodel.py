#!/usr/bin/env python
# -*- coding: utf-8 -*-

import vegguide
import veggiesailor
import json

def check_has_regions(seq):
    """Updates list with missing values.

    Parameters
    ----------
    seq : list
    """
    for j in range(len(seq)):
        seq[j]['has_entries'] = 0
        if int(seq[j]['entry_count']) != 0 and int(seq[j]['is_country']) != 1:
            seq[j]['has_entries'] = 1
    return seq


class VegGuideCache(object):
    """Cache wrapper for VegGuideObject

    Parameters
    ----------
    uri : str
    obj_type :  VegGuideObject or VegGuideObjectEntries"""
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
    """Cache wrapper for VegGuideObject.

    Parameters
    ----------
    uri : str"""

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
    """Cache wrapper for VegGuideObjectEntries.
    Parameters
    ----------
    uri : str
    """

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
    """Gets entries after providing url.

    Parameters
    ----------
    uri : str

    """
    results = VegGuideObjectEntriesCache(uri).results
    for i in range(0, len(results)):
        if 'address2' not in results[i]:
            results[i]['address2'] = ''
        results[i]['hours_txt'] = ''
        if 'hours' in results[i]:
            strhours = []
            for elem in results[i]['hours']:
                #from ipdb import set_trace; set_trace()
                strhours.append(elem['days']+' '+(' , '.join(elem['hours'])))
            results[i]['hours_txt'] = ('\n').join(strhours)

        results[i]['cuisines_txt'] = ', '.join(results[i]['cuisines'])

    return results

def fav_place(uri, data={}):
    """Switch favorite status of the place.
    """
    sv = veggiesailor.StorageFav()
    return sv.switch(uri, 1, data)

def fav_place_check(uri):
    """Check is place is favorite.
    """
    return veggiesailor.StorageFav().exists(uri)

def fav_city(uridata={}):
    """Switch favorite status of the city.
    """
    sv = veggiesailor.StorageFav()
    return sv.switch(uri, 0, data)

def fav_places():
    """Get favorite places.
    """
    sv = veggiesailor.StorageFav()
    results = sv.get_favorites()
    return results


if __name__ == "__main__":
    c = get_entries('http://www.vegguide.org/region/583')

    #p = get_place('http://www.vegguide.org/entry/12300')

    from ipdb import set_trace; set_trace()

    print (c)
