#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""VegGuide Python Api by Rafał bluszcz Zawadzki"""

import json
from urllib import request

BASE_URL = 'http://www.vegguide.org/'

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
    def __init__(self, uri):
        self.uri = uri
        req = VegGuideRequest(self.uri)
        self.results =  VegGuideParser(req).result

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

    from ipdb import set_trace; set_trace()
