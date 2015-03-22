#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""VegGuide Python Api by Rafał bluszcz Zawadzki"""

import json
from urllib import request

BASE_URL = 'https://www.vegguide.org/'

class VegGuideRequest(request.Request):
    def __init__(self, url=BASE_URL):
        super().__init__(url, headers={'X-Requested-WIth':'XMLHttpRequest'})

class VegGuideParser:
    def __init__(self, vegguide_request):
        req = request.urlopen(vegguide_request)
        data = req.readall().decode('utf-8')
        self.result = json.loads(data)

class VegGuideTree(object):
    def __init__(self, name, tree,
            subkeys=['children', 'uri', 'name', 'entries_uri']):
        self.__setattr__(name, tree)
        self.regions = tree
        for key in self.regions[name].keys():
            val = self.regions[name][key]
            self.__setattr__(key, val)

            for subkey in subkeys:
                try:
                    self.__setattr__('%s_%s_list' % (key, subkey), [ x[subkey] for x in val ])
                except KeyError:
                    pass

class RegionsTree(VegGuideTree):
    def __init__(self, tree_regions):
        super().__init__("regions", tree_regions)

    def get_countries(self, region_name):
        result = [ x for x in regions.primary if x['name'] == region_name ][0]
        return result['children']

    def get_country(self, region_name, country):
        country = [ y for y in
            [ x for x in regions.primary
                if x['name'] ==  region_name][0]['children']
                    if y['name'] == country ][0]

        req = VegGuideRequest(country['uri'])
        par = VegGuideParser( req)
        country['data'] = par.result
        return country

    def get_city(self, region_name, country, city):
        country_data = self.get_country(region_name, country)
        city = [ x for x in country_data['data']['children'] if x['name'] == city][0]

        req = VegGuideRequest(city['uri'])
        par = VegGuideParser( req)
        city['data'] = par.result
        return city

    def get_places(self,region_name, country, city):
        city = self.get_city(region_name, country, city)
        places = []
        for place_data in city['data']:
            place = Place(place_data)
            places.append(place)
        return places


class VegGuideObject(object):
    """Basic VegGuide Object.
    """
    def __init__(self, uri, parent=None, payload_json=None, cache_class=None):
        """Initialization of the VegGuideObject

        Parameters
        ----------
        url : str
        parent : VegGuideObject
        payload_json : json str
        cache_class : class
        """
        self.cache_class = cache_class
        self.uri = uri
        self.vgo_id = uri.replace('https://www.vegguide.org/', '')
        self.parent = parent

        if payload_json == None:
            req = VegGuideRequest(self.uri)
            self.results =  VegGuideParser(req).result
            self.results_json = json.dumps(self.results)
        else:
           self.results_json = payload_json
           self.results = json.loads(self.results_json)

        self._children = []
        self._entries = []

        if self.is_country():
            self.vgo_type = 'region'
        elif self.is_entry():
            self.vgo_type = 'entry'
        elif self.is_entries():
            self.vgo_type = 'entries'
        else:
            self.vgo_type = 'unknown'

    def __str__(self):
        return '<VegGuideObject-%s-/%s>' % (self.vgo_type,self.vgo_id)

    def is_country(self):
        try:
            return self.results['is_country'] == '1'
        except KeyError:
            return False
        except TypeError:
            return False

    def is_entry(self):
        if self.uri.find('/entry/')>-1:
            return True
        return False

    def is_entries(self):
        if self.uri.find('/entries/')>-1:
            return True
        return False

    def children(self):
        if not self._children:
            self.fetch_children()
        return self._children

    def entries(self):
        if not self._entries:
            self.fetch_entries()
        return self._entries

    def fetch_entries(self, force=False):
        if len(self._entries)==0 or force == True:
            if self.has_entries():
                if self.cache_class:
                    entries_tmp = self.cache_class(self.results['entries_uri'])
                else:
                    entries_tmp = VegGuideObject(self.results['entries_uri'], self)
                for child in entries_tmp.results:
                    if self.cache_class:
                        vgo = self.cache_class(child['uri'])
                    else:
                        vgo = VegGuideObject(child['uri'], self)
                    self._entries.append(vgo)




    def fetch_children(self, force=False):
        if len(self._children)==0 or force == True:
            if self.has_children():
                for child in self.results['children']:
                    if self.cache_class:
                        vgo = self.cache_class(child['uri'])
                    else:
                        vgo = VegGuideObject(child['uri'], self)
                    self._children.append(vgo)

    def has_children(self):
        return 'children' in self.results

    def has_entries(self):
        try:
            return int(self.results['entry_count']) > 0
        except KeyError:
            return False

class VegGuideObjectEntries(object):
    def __init__(self, uri):
        self.entries_uri = '%s/entries' % (uri)
        req = VegGuideRequest(self.entries_uri)
        self.results =  VegGuideParser(req).result

class Place(object):
    def __init__(self, data):
        self.data_dict = data
        for key in data:
            self.__setattr__(key, data[key])
if __name__ == '__main__':
    req = VegGuideRequest()
    vgp = VegGuideParser( req)
    regions = RegionsTree(vgp.result)

    ### barcelona
    barcelona = VegGuideObjectEntries('http://www.vegguide.org/region/583')

    ### Hello debug :)
    from pprint import PrettyPrinter
    pp = PrettyPrinter()
    root = VegGuideObject('http://www.vegguide.org')
    len(root.results['regions']['primary'])

    #from ipdb import set_trace; set_trace()
