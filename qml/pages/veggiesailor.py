#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import shutil

APPNAME = 'veggiesailor'
HOME = os.environ['HOME']
CONFIG = os.path.join(HOME, '.config', '.%s' % APPNAME)
DATA =  os.path.join(HOME, APPNAME)
CACHE =  os.path.join(DATA, 'cache')

### Logging
LOG = os.path.join(DATA,'log', 'app.log')
def init_log_dir():
    if not os.path.exists(os.path.join(DATA,'log')):
        os.makedirs(os.path.join(DATA,'log'))

#init_log_dir()
#import logging
#logging.basicConfig(filename=LOG, filemode='w', level=logging.DEBUG)


def init_cache_dir():
    if not os.path.exists(CACHE):
        os.makedirs(CACHE)

def init_config_dir():
    if not os.path.exists(CONFIG):
        os.makedirs(CONFIG)

def purge_all_cache():
    """Purges all caches"""
    shutil.rmtree(CACHE)


class Cache(object):
    def __init__(self, cache_key):
        init_cache_dir()
        self.cache_filename = os.path.join(CACHE, '%s.cache' % (cache_key))

    def put(self, json_str):
        fd = open(self.cache_filename, 'w')
        fd.write(json_str)
        fd.close()
        return True

    def get(self):
        try:
            fd = open(self.cache_filename)
            data = fd.read()
            fd.close()
        except FileNotFoundError:
            return None
        return data



    def remove(sel):
        os.remove(self.cache_filename)

def normalize_key(key):
    return key.translate(str.maketrans('/?&:', '____'))


class CacheHttp(Cache):
    def __init__(self, url):
        url = normalize_key(url)
        super().__init__(url)

if __name__=="__main__":
    init_cache_dir()
    init_config_dir()
    ch = CacheHttp("http://www.vegguide.org/region/2255/entries")
    print(ch.cache_filename)

    import json
    test_dict = {'a':2, 'b':3}
    test_json = json.dumps(test_dict)
    ch.put(test_json)
    purge_all_cache()



