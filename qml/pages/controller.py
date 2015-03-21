#!/usr/bin/env python
# -*- coding: utf-8 -*-


if __name__ == "__main__":
    from  vegguide import VegGuideObject
    from  listmodel import VGOCache
    root = VGOCache('https://www.vegguide.org/')
    europe = VGOCache('https://www.vegguide.org/region/52')
    spain2 = VGOCache('https://www.vegguide.org/region/66')
    giblartar = VGOCache('https://www.vegguide.org/region/2236')


    bcn = VGOCache('https://www.vegguide.org/entry/14683')
    bar  = VGOCache('https://www.vegguide.org/entry/12300')

    for i in (spain2,giblartar, bcn, bar):
        print(i, i.has_children())
        print(i, i.has_entries())
        print(i, i.entries())
        print(i, i.is_country())
        print(i, i.is_entry())
        print(i, i.children())



