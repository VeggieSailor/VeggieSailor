#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Veggie Sailor - SailfishOS python bootstrap / helpers / extra batteries.

Classes
-------

Cache : main cache object
"""

import os
import shutil
import sqlite3
import json

VERSION_STAMP = 1

APP_NAME = 'harbour-veggiesailor'
HARBOUR_APP_NAME = APP_NAME

HOME = os.environ['HOME']

### Implementation of Hardbour requirements
# https://harbour.jolla.com/faq#2.13.0
XDG_DATA_HOME = os.environ.get('XDG_DATA_HOME') \
    if os.environ.get('XDG_DATA_HOME') \
    else os.path.join(os.environ.get('HOME'), '.local/share/')
XDG_CONFIG_HOME = os.environ.get('XDG_CONFIG_HOME') \
    if os.environ.get('XDG_CONFIG_HOME') \
    else os.path.join(os.environ.get('HOME'), '.config/')
XDG_CACHE_HOME = os.environ.get('XDG_CACHE_HOME') \
    if os.environ.get('XDG_CACHE_HOME') \
    else os.path.join(os.environ.get('HOME'), '.cache/')

CONFIG = os.path.join(XDG_CONFIG_HOME, '%s' % APP_NAME)
DATA =  os.path.join(XDG_DATA_HOME, '%s' % APP_NAME)
CACHE =  os.path.join(XDG_CACHE_HOME, '%s' % APP_NAME)

### Logging
LOG = os.path.join(DATA,'log', 'app.log')
def init_log_dir():
    if not os.path.exists(os.path.join(DATA,'log')):
        os.makedirs(os.path.join(DATA,'log'))

#init_log_dir()
#import logging
#logging.basicConfig(filename=LOG, filemode='w', level=logging.DEBUG)

def init_cache_dir():
    """Initialise cache directory.
    """
    if not os.path.exists(CACHE):
        os.makedirs(CACHE)

def init_data_dir():
    """Initialise data directory.
    """
    if not os.path.exists(DATA):
        os.makedirs(DATA)

def init_config_dir():
    """Initialise config directory.
    """
    if not os.path.exists(CONFIG):
        os.makedirs(CONFIG)

def write_version_stamp(stamp=1):
    filestamp = os.path.join(CONFIG,'timestamp_00')
    fd = open(filestamp,'w')
    fd.write(str(stamp))
    fd.close()

def check_version_stamp(stamp=1):
    """Simply versioning.

    Notes
    -----
    Needs to be seriously improved."
    """

    init_config_dir()
    filestamp = os.path.join(CONFIG,'timestamp_00')
    if not os.path.exists(filestamp):
        write_version_stamp(VERSION_STAMP)
        return False
    current = int( open(filestamp).read().strip())


    if current >= stamp:
        return True
    else:
        write_version_stamp(stamp)
        return False





def purge_all_cache():
    """Purge all caches
    ."""
    try:
        shutil.rmtree(CACHE)
    except FileNotFoundError:
        init_cache_dir()

if not check_version_stamp(3):
    purge_all_cache()

class Cache(object):
    """Main caching class.
    """
    def __init__(self, cache_key):
        init_cache_dir()
        self.cache_filename = os.path.join(CACHE, '%s.cache' % (cache_key))

    def put(self, json_str):
        """Puts data in the cache file.
        """
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
    """Normalizes cache's key to use it as filename.

    Parameters
    ----------
    key : str
    """
    return key.translate(str.maketrans('/?&:', '____'))

class CacheHttp(Cache):
    def __init__(self, url):
        url = normalize_key(url)
        super().__init__(url)

class Storage(object):
    """Default sqlite based Storage type.

    Parameters
    ----------
    name : str
    """
    def __init__(self, name='storage'):
        init_data_dir()
        path = os.path.join(DATA, '%s.sqlite' % name)
        self.conn = sqlite3.connect(path)
        self.cursor = self.conn.cursor()

        self.conn.commit()

FAV_TYPES = {
 0: 'city',
 1: 'place',
}


class StorageFav(Storage):
    """Storage wrapper for favourites.
    """
    def __init__(self, name='storage'):
        super().__init__(name)
        self.create_table()

        if not check_version_stamp():
            self.truncate()


    def create_table(self):
        try:
            query = """CREATE TABLE favourites (key TEXT PRIMARY KEY UNIQUE NOT NULL, type INTEGER NOT NULL , json TEXT NOT NULL);"""
            self.cursor.execute(query)
        except  sqlite3.OperationalError:
            pass # table exists

    def get_cities(self):
        query = "SELECT * FROM favourites WHERE type = 1";
        self.cursor.execute(query)
        result = []
        for elem in self.cursor.fetchall():

            result.append(json.loads(elem[2]))

        return result

    def exists(self, fav_key):
        query = "select count(*) from favourites where key = ?"
        self.cursor.execute(query, (fav_key,))
        return self.cursor.fetchall()[0][0]


    def get_favorites(self, fav_type=1):
        query = "SELECT * FROM favourites WHERE type = ?";
        self.cursor.execute(query, (fav_type,))
        result = []
        for elem in self.cursor.fetchall():
            result.append(json.loads(elem[2]))
            #sub_result = [ x for x in elem ]
            #sub_result.append(json.loads(elem[2]))
            #result.append(sub_result)
        return result

    def switch(self, fav_key, fav_type, fav_data={}):
        """Insert favourite into database.

        Parameters
        ----------
        data : dict
        fav_type : int
        """

        str_data = json.dumps(fav_data)

        if self.exists(fav_key):
            self.cursor.execute("delete from  favourites where key =  ?", (fav_key,))
            self.conn.commit()
            return 0
        else:
            self.cursor.execute("insert into favourites(key, type, json) values (?, ?, ?)", (fav_key, fav_type, str_data))
            self.conn.commit()
            return 1

    def truncate(self):
        """'Truncates' the tables by recreating it.
        """

        query = "DROP TABLE favourites;";
        self.cursor.execute(query)
        self.conn.commit()
        self.create_table()




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

    s = Storage()
    sf = StorageFav()
    print(sf.get_favorites())
#    sf.truncate()

    print (sf.exists("http://www.vegguide.org/entry/12624"))

    print (s,sf)

    import time
    from random import randint
    sf.switch('aaa'+str(time.time()), 1, {randint(0,128):randint(0,128)})



