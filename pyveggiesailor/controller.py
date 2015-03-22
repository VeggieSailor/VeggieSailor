#!/usr/bin/env python
# -*- coding: utf-8 -*-

def lala4(var):
    return var*3

from pyveggiesailor.vegguide_cache import VGOCache

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

def get_root():
    """Get root VegGuide regions data tree.
    """
    root = VGOCache('https://www.vegguide.org/')

    return check_has_regions(root.results['regions']['primary'])




if __name__ == "__main__":
    from  vegguide import VegGuideObject

    get_root()

    root = VGOCache('https://www.vegguide.org/')
    print(get_root())
    europe = VGOCache('https://www.vegguide.org/region/52')
    spain2 = VGOCache('https://www.vegguide.org/region/66')
    giblartar = VGOCache('https://www.vegguide.org/region/2236')


    bcn = VGOCache('https://www.vegguide.org/entry/14683')
    bar  = VGOCache('https://www.vegguide.org/entry/12300')

#    for i in (spain2,giblartar, bcn, bar):
#        print(i, i.has_children())
#        print(i, i.has_entries())
#        print(i, i.entries())
#        print(i, i.is_country())
#        print(i, i.is_entry())
#        print(i, i.children())



