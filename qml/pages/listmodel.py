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
    """Get regions for the url.

    Parameters
    ----------
    hierarchy : str
    uri : str
    """
    root = VegGuideObjectCache(uri)
    result = root.results['regions'][hierarchy]
    return check_has_regions(result)

def get_vegguide_children(uri):
    """Get children from the results object.

    Parameters
    ----------
    uri : str
    """
    children = VegGuideObjectCache(uri)
    result = children.results['children']
    return check_has_regions(result)

def adjust_entry(entry):
    """Adjust entry - add missing fields and flat some lists.

    Parameters
    ----------
    entry : dict
    """
    if 'address2' not in entry:
        entry['address2'] = ''
    entry['hours_txt'] = ''
    if 'hours' in entry:
        strhours = []
        for elem in entry['hours']:
            strhours.append(elem['days']+' '+(' , '.join(elem['hours'])))
        entry['hours_txt'] = ('\n').join(strhours)
    entry['cuisines_txt'] = ', '.join(entry['cuisines'])
    if 'tags' not in entry:
        entry['tags'] = []
    entry['tags_txt'] = ', '.join(entry['tags'])


    if not 'veg_level' in entry:
        entry['veg_level'] = 5

    if int(entry['veg_level']) == 0:
         entry['color_txt'] = '#fab20a'
    elif int(entry['veg_level']) == 1:
        entry['color_txt'] = '#97a509'
    elif int(entry['veg_level']) == 2:
        entry['color_txt'] = '#155196'
    elif int(entry['veg_level']) == 3:
        entry['color_txt'] = '#e55e16'
    elif int(entry['veg_level']) == 4:
        entry['color_txt'] = '#b00257'
    elif int(entry['veg_level']) == 5:
        entry['color_txt'] = '#16ac48'
    return entry
    #97a509 155196 fab20a  e55e16

def get_vegguide_entry(uri):
    """Get cached entry.

    Paramaters
    ----------
    uri : str
    """
    entry = VegGuideObjectCache(uri)
    result = adjust_entry(entry.results)
    return result

def get_entries(uri):
    """Gets entries after providing url.

    Parameters
    ----------
    uri : str

    """
    results = VegGuideObjectEntriesCache(uri).results
    results = [ adjust_entry(x) for x in results ]
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
    print (c)
