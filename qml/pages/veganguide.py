#!/usr/bin/env python
# -*- coding: utf-8 -*-

import xmlrpc.client # For VeganGuide

url_veganguide = 'http://veganguide.org/api'

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

