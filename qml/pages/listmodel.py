#!/usr/bin/env python
# -*- coding: utf-8 -*-


import xmlrpc.client # For VeganGuide

import vegguide

url_veganguide = 'http://veganguide.org/api'
url_vegguide = ''

def check_internet():
    proxy = xmlrpc.client.ServerProxy(url)
    status = proxy.vg.test({'apikey':'rrl53ed2ye7k'})['status']
    return status


def get_data(country, city):
    """Returns data for the model"""
    proxy = xmlrpc.client.ServerProxy(url)
    results = proxy.vg.browse.listPlacesByCity({'apikey':'rrl53ed2ye7k','lang':'en','country':country,'city':city})
    data = [ {'name':str(bytes(x['name'], 'latin1'), 'utf-8'), 'identifier':x['identifier']} for x in results['data'] ]
    return data

def get_entries(uri):
    #    data = [ {'name':x['name'], 'uri':x['uri']} for x in  vegguide.VegGuideObjectEntries(uri) ]
    data = vegguide.VegGuideObjectEntries(uri).results
    return data

def check_has_regions(seq):
    for j in range(len(seq)):
        seq[j]['has_entries'] = 0
        if int(seq[j]['entry_count']) != 0 and int(seq[j]['is_country']) != 1:
            seq[j]['has_entries'] = 1
    return seq

def get_vegguide_regions(hierarchy, uri):
    root = vegguide.VegGuideObject(uri)
    result = root.results['regions'][hierarchy]
    return check_has_regions(result)

def get_vegguide_children(uri):
    children = vegguide.VegGuideObject(uri)
    result = children.results['children']
    return check_has_regions(result)
