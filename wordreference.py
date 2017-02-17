#!/usr/bin/env python3

from bs4 import BeautifulSoup
from sys import argv
from sys import exit
from sys import exit
import urllib.request
import subprocess as sp
import re
import argparse


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
        fromWrd.append("<b>" + word + "</b> " +
                       "<small><i>(" + wordType + ")</i></small>")
    else:
        fromWrd.append("<b>" + word + "</b>")


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
        toWrd.append(word + " <small><i>(" + wordType + ")</i></small>")
    else:
        toWrd.append(word)


languages = ["en", "it", "es", "fr"]
forbidden = ["it", "es", "fr"]

prog_description = "This is used to get a quick translation from italian, french or spanish to english OR viceversa. NOTE: translation from non-english to non-english or from same-language to same-language is forbidden"

parser = argparse.ArgumentParser(description=prog_description)

parser.add_argument("interface_language", help="Interface language", choices=languages)
parser.add_argument("source_language", help="Source translation language", choices=languages)
parser.add_argument("target_language", help="Target translation language", choices=languages)
args = parser.parse_args()

if args.source_language == args.target_language or (args.source_language in forbidden and args.target_language in forbidden):
    parser.print_help()
    exit(-1)

# Interface translaton variables
translateFrom = dict()
wordToTranslate = dict()
translationsFound = dict()

wordToTranslate["en"] = "Word to translate: "
wordToTranslate["it"] = "Parola da tradurre: "
wordToTranslate["fr"] = "Mot à traduire: "
wordToTranslate["es"] = "Palabra para traducir: "

translationsFound["en"] = "Translations: "
translationsFound["it"] = "Traduzioni: "
translationsFound["fr"] = "Traductions: "
translationsFound["es"] = "Traducciones: "

word_to_translate_cmd = "echo ' ' | rofi -dmenu -p '{}'".format(wordToTranslate[args.interface_language])
# Run the command then remove the ending newline, and decode the bytestring as a normal utf-8 string
word_to_translate = sp.run(word_to_translate_cmd, shell=True, stdout=sp.PIPE).stdout[:-1].decode('utf-8')

lang = args.source_language + args.target_language
searchTerm = str(word_to_translate).replace(" ", "+")
url = "http://www.wordreference.com/"

user_agent = 'Mozilla/5.0 (Windows NT 6.1; Win64; x64)'
headers = {'User-Agent': user_agent}

req = urllib.request.Request(url + lang + "/" + searchTerm, headers=headers)

page = urllib.request.urlopen(req).read()

soup = BeautifulSoup(page, 'html.parser')
selector = "table.WRD > tr[id^='" + lang + "']"
fromWrd, toWrd = [], []

for res in soup.select(selector):
    for inner in res.select("td.FrWrd"):
        cleanFrom(inner)
    for inner in res.select("td.ToWrd"):
        cleanTo(inner)


output = ""
if len(fromWrd) == 0 or len(toWrd) == 0:
    output = "<b>NO TRANSLATIONS FOUND</b>\n"
else:
    for frm, to in zip(fromWrd, toWrd):
        output += "{}: {}\n".format(frm, to)
# Remove last newline
output = output[:-1]
print_translation_cmd = "echo \"{}\" | rofi -markup-rows -i -dmenu -p \"{}\"".format(output, translationsFound[args.interface_language])
sp.run(print_translation_cmd, shell=True, stdout=sp.PIPE)
