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
        #print ("cipka",str(seq[j]).encode('utf-8'))
        if int(seq[j]['entry_count']) != 0 and int(seq[j]['is_country']) != 1:
            seq[j]['has_entries'] = 1

        if int(seq[j]['entry_count']) != 0 and ('regions' not in seq[j] or 'children' not in seq[j]) :
            seq[j]['has_entries'] = 1
        #print ("cipka",str(seq[j]).encode('utf-8'))
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

class VGCache(object):
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

class VGOCache(vegguide.VegGuideObject):
    """Cache wrapper for VegGuideObject.

    Parameters
    ----------
    uri : str"""

    def __init__(self, uri):
        self.cache = veggiesailor.CacheHttp(uri)
        results = self.cache.get()

        try:
            self.results_json = results
        except TypeError:
            print("TypeError - maybe not in cache self.results", results)
            self.results_json = None



        if not self.results_json:
            super().__init__(uri)
            print (self.results_json)
            self.cache.put(self.results_json)
        else:
            super().__init__(uri, payload_json=self.results_json,cache_class=self.__class__)
        def __str__(self):
            return '<VGOCache-%s-/%s>' % (self.vgo_type,self.vgo_id)

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
            print("TypeError Entries self.results", results)
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

    Notes
    -----
    TODO: Due to this issues: https://github.com/bluszcz/VeggieSailor/issues/9
    there must be performed extra check if we are not loosing any data.
    """

    print("MY URI", uri)

    children = VegGuideObjectCache(uri)
    try:
        result = children.results['children']
    except KeyError: # https://github.com/bluszcz/VeggieSailor/issues/9
        """TODO: Perhaps only entries, but please verify it"""
        result = []
    print("MY URI", uri)
    print('CHECK', str(result).encode('utf-8'))

    return check_has_regions(result)

def adjust_entry(entry):
    """Adjust entry - add missing fields and flat some lists.

    Parameters
    ----------
    entry : dict

    Notes
    -----

    Followed colors are being used:

    #b00257 - very dark red
    #e55e16 - red (bad one)
    #155196 - dark blue
    #fab20a - orange
    #97a509 - greenish yellow
    #16ac48 - light green
    """
    if 'address2' not in entry:
        entry['address2'] = ''
    entry['hours_txt'] = ''
    if 'hours' in entry:
        strhours = []
        for elem in entry['hours']:
            strhours.append(elem['days']+' '+(' , '.join(elem['hours'])))
        entry['hours_txt'] = ('\n').join(strhours)
    else:
        entry['hours'] = []
    entry['hours_parsed'] = get_hours_dict(entry['hours'])
    entry['cuisines_txt'] = ', '.join(entry['cuisines'])
    if 'tags' not in entry:
        entry['tags'] = []
    entry['tags_txt'] = ', '.join(entry['tags'])


    if 'weighted_rating' not in entry:
        entry['weighted_rating'] = '0.0'


    entry['rating_parsed'] = int(round(float(entry['weighted_rating'])))



    if not 'veg_level' in entry:
        entry['veg_level'] = 5

    if int(entry['veg_level']) == 0:
         entry['color_txt'] = '#b00257'
    elif int(entry['veg_level']) == 1:
        entry['color_txt'] = '#97a509'
    elif int(entry['veg_level']) == 2:
        entry['color_txt'] = '#155196'
    elif int(entry['veg_level']) == 3:
        entry['color_txt'] = '#fab20a'
    elif int(entry['veg_level']) == 4:
        entry['color_txt'] = '#97a509'
    elif int(entry['veg_level']) == 5:
        entry['color_txt'] = '#16ac48'
    return entry

def get_vegguide_entry(uri):
    """Get cached entry.

    Parameters
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


def parse_hour(hour):
    """Parse VegGuide hour.

    Parameters
    ----------
    hour : str
    """
    hour = hour.strip()

    if hour=='midnight':
        return '2400'
    elif hour=='noon':
        return '1200'

    if hour.find('am')!=-1:
        hour = hour.replace('am','')
        hour = hour.replace(':','')
        hour = hour.strip()
        if len(hour)<3:
            hour = hour + "00"
        return hour
    elif hour.find('pm')!=-1:
        hour = hour.replace('pm','')
        opening = hour.split(':')
        if len(opening)==2:
            return ''.join([str(int(opening[0])+12),opening[1]])
        else:
            return str(int(opening[0])+12)+'00'

days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
def parse_hours(hours):
    """Parse VegGuide hours dictionary.

    Parameters
    ----------
    hours : list of dicts
    """
    result = []
    struct = {}
    for hour in hours:
        data = hour['days'].replace(' ','').split('-')
        if len(data)==2:
            new_data = days[days.index(data[0]):days.index(data[1])+1]
        else:
            new_data = data
        if data[0] == 'Daily':
            new_data = days
        open_hours_tmp = hour['hours']
        for day in new_data:
            struct[day] = []
            for elem in open_hours_tmp:
                new_hours = []
                for j in elem.split('-'):
                    new_hours.append(parse_hour(j))
                struct[day].append(new_hours)
        for day in days:
            if day not in struct:
                struct[day]  = []
        result.append(struct)
    return struct

def to_from(arr):
    """Convert two elements list into dictionary 'to-from'.
    """
    try:
        return {'from':arr[0], 'to':arr[1]}
    except IndexError:
        return None

def modify_hours(hours):
    """Modify all elements for hour structure.
    """

    result = []
    for day in days:
        subresult = []
        try:
            for opening in hours[day]:
                subresult.append(to_from(opening))
        except KeyError:
            """No opening for this day.
            """
        result.append(subresult)
    return result


def get_hours_dict(hours_dicts_list):
    """Get hours in 'to-from' format after providing VegGuide format.

    Parameters
    ----------
    hours_dicts_list - list of dicts
    """
    return modify_hours(parse_hours(hours_dicts_list))


if __name__ == "__main__":

    #regs = get_vegguide_regions('http://www.vegguide.org/region/2236')
    #    print(regs)
    ccc = get_vegguide_children('http://www.vegguide.org/region/2236')
    print(ccc)

    ccc = get_vegguide_children('http://www.vegguide.org/region/583')
    print(ccc)


    ccc = get_vegguide_children('http://www.vegguide.org/region/66')
#    print(ccc)
#    from ipdb import set_trace; set_trace()
    #bcn = get_entries('https://www.vegguide.org/region/583')
    #print (bcn[0]['hours'], get_hours_dict(bcn[0]['hours']))
