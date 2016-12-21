#!/usr/bin/env python3

from bs4 import BeautifulSoup
from sys import argv
from sys import exit
import urllib.request
import re

def cleanFrom(element):
    try:
        for link in element.strong.find_all('a'):
            link.extract()
    except AttributeError as e:
        pass    # No anchor elements, move on
    word = element.strong.text

    try:
        for span in element.em.find_all('span'):
            span.extract()
    except AttributeError as e:
        pass    # No span element, move on

    wordType = element.em.text
    if wordType != "":
        fromWrd.append("<b>"+word+"</b> "
                       +"<small><i>("+wordType+")</i></small>")
    else:
        fromWrd.append("<b>"+word+"</b>")


def cleanTo(element):
    try:
        for link in element.find_all('a'):
            link.extract()
    except AttributeError as e:
        pass    # No anchor elements, move on
    try:
        for span in element.em.find_all('span'):
            span.extract()
    except AttributeError as e:
        pass    # No span element, move on
    wordType = element.em.extract().text
    word = element.text
    if wordType != "":
        toWrd.append(word+" <small><i>("+wordType+")</i></small>")
    else:
        toWrd.append(word)


if len(argv) != 3:
    exit(-1)

lang = argv[1]
searchTerm = argv[2].replace(" ", "+")
url = "http://www.wordreference.com/"

user_agent = 'Mozilla/5.0 (Windows NT 6.1; Win64; x64)'
headers = {'User-Agent': user_agent}

req = urllib.request.Request(url+lang+"/"+searchTerm, headers=headers)

page = urllib.request.urlopen(req).read()

soup = BeautifulSoup(page, 'html.parser')
selector = "table.WRD > tr[id^='"+lang+"']"
fromWrd, toWrd = [], []

for res in soup.select(selector):
    for inner in res.select("td.FrWrd"):
        cleanFrom(inner)
    for inner in res.select("td.ToWrd"):
        cleanTo(inner)

for frm, to in zip(fromWrd, toWrd):
    print(frm, to, sep=": ")