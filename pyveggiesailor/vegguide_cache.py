#!/usr/bin/env python
# -*- coding: utf-8 -*-

import vegguide
import veggiesailor


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
