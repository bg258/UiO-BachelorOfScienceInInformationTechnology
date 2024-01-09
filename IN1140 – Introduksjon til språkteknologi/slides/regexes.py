import re

liste = ['6 januar 1992', '25 juni 2005', '3342 november 1988', '9 fredag 1999', '1 mars 2018', '30 juli 190221']

#liste = ['6 January 1992', '25 June 2005', '19 November 1988', '1 March 2018']


for i, e in enumerate(liste):
    regex = '([1-9]|[12][0-9]|3[01])\s(januar|februar|mars|april|mai|juni|juli|august|september|oktober|november|desember)\s((19|20)\d{2})'
    # regex = '[0-9]+\s(januar|februar|mars|april|mai|juni|juli|august|september|oktober|november|desember)\s((19|20)[0-9]+)'

    # regex = '[0-9]+\s[A-Za-z]+\s((19|20)[1-9]+)'
    found = re.search(r'\b%s\b' %regex , e)

    if found:
        print(found.group())
