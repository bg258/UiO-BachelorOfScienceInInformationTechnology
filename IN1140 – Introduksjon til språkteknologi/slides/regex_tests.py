# encoding: utf-8

#Import the regular expression module
import re

## Se https://docs.python.org/3/howto/regex.html for flere eksempler og beskrivelser av de forskjellige re metodene.
## Se også forelesningsnotater. Det er flere eksempler som dere kan kopiere og teste her.

##1. Metoden match(): Determine if the RE matches at the beginning of the string.

p = re.compile('ab*') ##Compilere en pattern (mønster) som vi har lyst å finne i en streng
print("Streng 'IN1140': ")
print(p.match("IN1140"))
print('---')
print("Streng 'abb': ")
print('---')
print("Streng 'ab': ")
print(p.match("ab")) 
print('---')
print("Streng 'bab': ")
print(p.match("bab"))


print('---')
p2 = re.compile('(\w*[æøå]*\w*)*') ##Compilere en pattern (mønster) som vi har lyst å finne i en streng
print("Streng 'IN1140': ")
print(p2.match("IN1140"))
print('---')
print("Streng 'Språkteknologi': ")
print(p2.match("Språkteknologi"))
print('---')
print("Streng 'språkteknologi': ")
print(p2.match("språkteknologi"))
print('---')
print("Streng 'computer science': ")
print(p2.match("computer science"))

print('---')
## For å kunne se hva som egentlig ble matchet, altså strengen, kan du bruke metodene group(), start(), end(), og span()
m = p.match("abb")
print("Streng 'abb': ")
print(m.group())
print(m.start())
print(m.end())
print(m.span())

print('---')
m2 = p.match("ab")
print("Streng 'ab': ")
print(m2.group())
print(m2.start())
print(m2.end())
print(m2.span())

print('---')
## 2. Metoden findall(): Find all substrings where the RE matches, and returns them as a list.

p3 = re.compile('\d+') ##Compilere en pattern (mønster) som vi har lyst å finne i en streng
print("Streng 'IN1140': ")
print(p3.findall("IN1140"))

print('---')
print("Streng '12 drummers drumming, 11 pipers piping, 10 lords a-leaping': ")
print(p3.findall("12 drummers drumming, 11 pipers piping, 10 lords a-leaping"))

print('---')
## En annen måte å gjøre dette på, om du feks bare skal bruke et mønster en gang, og ikke vil compilere en pattern
m = re.findall('\w', '12 drummers drumming, 11 pipers piping, 10 lords a-leaping')
print(m)
print('---')

m = re.findall('\w*', '12 drummers drumming, 11 pipers piping, 10 lords a-leaping')
print(m)
print('---')

m = re.findall('\w+', '12 drummers drumming, 11 pipers piping, 10 lords a-leaping')
print(m)
print('---')

m = re.findall('\W', '12 drummers drumming, 11 pipers piping, 10 lords a-leaping')
print(m)
print('---')

m = re.findall('\d', '12 drummers drumming, 11 pipers piping, 10 lords a-leaping')
print(m)
print('---')

m = re.findall('\d+', '12 drummers drumming, 11 pipers piping, 10 lords a-leaping')
print(m)
print('---')

m = re.findall('\D', '12 drummers drumming, 11 pipers piping, 10 lords a-leaping')
print(m)
print('---')

m = re.findall('\D+', '12 drummers drumming, 11 pipers piping, 10 lords a-leaping')
print(m)
print('---')
