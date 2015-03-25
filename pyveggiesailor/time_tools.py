#!/usr/bin/env python
# -*- coding: utf-8 -*-

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
