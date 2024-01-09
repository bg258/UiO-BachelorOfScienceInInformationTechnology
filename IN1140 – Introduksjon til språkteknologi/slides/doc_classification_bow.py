from nltk.corpus import movie_reviews
from nltk import NaiveBayesClassifier # Naive Bayes klassifiserer
from nltk import classify #for å beregne accuracy
import string # denne importeres for å kunne slette tegnsetting fra tekstene
from nltk.corpus import stopwords # denne brukes for å slette stoppord fra tekstene

# Vi skal bruke movie_reviews korpuset. Du kan lese mer om det på NLTK sin webside.
# Korpuset inneholder anmeldelser av filmer.
# Hvert dokument er klassifisert som enten positive "pos" eller negative "neg".

# I denne koden, begynner vi med å bruke bag-of-words som trekk.
# Vi deretter tester våre klassifisserer på development datasettet.
# Vi utvider trekkene våres og lager bag-of-words uten stoppord.
# Vi tester klassifisereren på development datasettet en gang til,
# Vi utvider trekkene våres og lager bag-of-words trekk, men nå uten både stoppord og tegnsetting, og tester det på development datasettet.
# Vi tester etterpå bag-of-ngrams på development datasettet, før vi tester til slutt på testdataen.

#################################
# Del 1 -- Bag-of-words som trekk
#################################
print('#################################')
print('# Del 1 -- Bag-of-words som trekk')
print('#################################')
# Ideen her er å første hente alle positive og negative ord fra movie_reviews Korpuset
# Deretter bruker vi disse ordene som trekk for vår Naive Bayes
# Vi deler dataen vår i train_set, dev_set, og test_set. Vi bruker train_set for å trene, og dev_set for å teste effekten av trekkene vi bruker.

# Hente ut alle positive og negative ord som finnes i movie_reviews
def get_word_reviews(pos_reviews, neg_reviews):
    # Lage en liste av alle positive ord
    for fileid in movie_reviews.fileids('pos'):
        words = movie_reviews.words(fileid)
        pos_reviews.append(words)

    # Lage en liste av alle negative ord
    for fileid in movie_reviews.fileids('neg'):
        words = movie_reviews.words(fileid)
        neg_reviews.append(words)

    return pos_reviews, neg_reviews

# Her velger vi trekkene våre. Vi begynner med enkel bag-of-words.
def bag_of_words(words):
    words_cleaned = []

    for word in words:
        word = word.lower()
        words_cleaned.append(word)

    words_dict = dict([word, True] for word in words_cleaned)
    # Å bruke en dictionary her hjelper oss med å slette alle duplikater.

    return words_dict

pos_reviews = []
neg_reviews = []
pos_reviews, neg_reviews = get_word_reviews(pos_reviews, neg_reviews)

# lage trekk for positie anmeldelser
pos_reviews_feat = []
for words in pos_reviews:
    pos_reviews_feat.append((bag_of_words(words), 'pos'))

# lage trekk for negative anmeldelser
neg_reviews_feat = []
for words in neg_reviews:
    neg_reviews_feat.append((bag_of_words(words), 'neg'))

# Fordele dataen vår i test_set, dev_set, og train_set
test_set = pos_reviews_feat[:200] + neg_reviews_feat[:200]
dev_set = pos_reviews_feat[200:300] + neg_reviews_feat[200:300]
train_set = pos_reviews_feat[300:] + neg_reviews_feat[300:]

print(len(test_set),  len(dev_set), len(train_set))
# printer 400 200 1400

# Nå skal vi trene vår Naive Bayes klassifisserer
classifier = NaiveBayesClassifier.train(train_set)

# Så enkelt var det!
# Nå skal vi se hvor god den er ved å teste den på dev_set
accuracy = classify.accuracy(classifier, dev_set)

print("Accuracy on dev_set: %0.2f" % accuracy)
# Gir en accuracy på 0.675

# Vi kan se på de 10 mest informative trekk ved å gjøre følgende
print (classifier.show_most_informative_features(10))
# Dette viser f.eks. at ordet sucks er 13 ganger mer representativ av klassen negativ enn den er av klasen positive
# Most Informative Features
            #     captures = True              pos : neg    =     15.0 : 1.0
            #        sucks = True              neg : pos    =     13.0 : 1.0
            #    ludicrous = True              neg : pos    =     12.6 : 1.0
            #    maintains = True              pos : neg    =     11.7 : 1.0
            # breathtaking = True              pos : neg    =     11.4 : 1.0
            #        anger = True              pos : neg    =     11.0 : 1.0
            #     depicted = True              pos : neg    =     10.3 : 1.0
            #     headache = True              neg : pos    =      9.7 : 1.0
            #   astounding = True              pos : neg    =      9.7 : 1.0
            #       avoids = True              pos : neg    =      9.7 : 1.0

#################################
# Del 2 -- Bag-of-words som trekk uten stoppord
#################################
print('#################################')
print('# Del 2 -- Bag-of-words uten stoppord som trekk')
print('#################################')
# Nå skal vi teste om klassifissereren vår gjør det bedre om vi sletter alle stoppord
#  Vi kjører akkuratt samme kode, vi endrer bare bag_of_words() funksjonen til å slette stoppord

def bag_of_words_no_stopwords(words):
    words_cleaned = []

    for word in words:
        word = word.lower()
        if word not in stopwords_english:
            words_cleaned.append(word)
    words_dict = dict([word, True] for word in words_cleaned)

    return words_dict

# Hente ut alle stoppord for engelsk
stopwords_english = stopwords.words('english')

# lage trekk for positie anmeldelser
pos_reviews_feat = []
for words in pos_reviews:
    pos_reviews_feat.append((bag_of_words_no_stopwords(words), 'pos'))

# lage trekk for negative anmeldelser
neg_reviews_feat = []
for words in neg_reviews:
    neg_reviews_feat.append((bag_of_words_no_stopwords(words), 'neg'))

# Fordele dataen vår i test_set, dev_set, og train_set
test_set = pos_reviews_feat[:200] + neg_reviews_feat[:200]
dev_set = pos_reviews_feat[200:300] + neg_reviews_feat[200:300]
train_set = pos_reviews_feat[300:] + neg_reviews_feat[300:]

print(len(test_set),  len(dev_set), len(train_set))
# printer 400 200 1400

# Nå skal vi trene vår Naive Bayes klassifisserer
classifier = NaiveBayesClassifier.train(train_set)

# Så enkelt var det!
# Nå skal vi se hvor god den er ved å teste den på dev_set
accuracy = classify.accuracy(classifier, dev_set)

print("Accuracy on dev_set: %0.2f" % accuracy)
# Gir en accuracy på 0.675

# Vi kan se på de 10 mest informative trekk ved å gjøre følgende
print (classifier.show_most_informative_features(10))

#################################
# Del 3 -- Bag-of-words uten stoppord og tegnsetting som trekk
#################################
print('#################################')
print('# Del 3 -- Bag-of-words uten stoppord og tegnsetting som trekk')
print('#################################')
# Nå skal vi teste om klassifissereren vår gjør det bedre om vi sletter alle stoppord og tegnsetting
#  Vi kjører akkuratt samme kode, vi endrer bare bag_of_words() funksjonen til å slette stoppord og tegnsetting

def bag_of_words_no_stopwords_punct(words):
    words_cleaned = []

    for word in words:
        word = word.lower()
        if word not in stopwords_english and word not in string.punctuation:
            words_cleaned.append(word)
    words_dict = dict([word, True] for word in words_cleaned)

    return words_dict

# Hente ut alle stoppord for engelsk
stopwords_english = stopwords.words('english')

# lage trekk for positie anmeldelser
pos_reviews_feat = []
for words in pos_reviews:
    pos_reviews_feat.append((bag_of_words_no_stopwords_punct(words), 'pos'))

# lage trekk for negative anmeldelser
neg_reviews_feat = []
for words in neg_reviews:
    neg_reviews_feat.append((bag_of_words_no_stopwords_punct(words), 'neg'))

# Fordele dataen vår i test_set, dev_set, og train_set
test_set = pos_reviews_feat[:200] + neg_reviews_feat[:200]
dev_set = pos_reviews_feat[200:300] + neg_reviews_feat[200:300]
train_set = pos_reviews_feat[300:] + neg_reviews_feat[300:]

print(len(test_set),  len(dev_set), len(train_set))
# printer 400 200 1400

# Nå skal vi trene vår Naive Bayes klassifisserer
classifier = NaiveBayesClassifier.train(train_set)

# Så enkelt var det!
# Nå skal vi se hvor god den er ved å teste den på dev_set
accuracy = classify.accuracy(classifier, dev_set)

print("Accuracy on dev_set: %0.2f" % accuracy)
# Gir en accuracy på 0.675

# Vi kan se på de 10 mest informative trekk ved å gjøre følgende
print (classifier.show_most_informative_features(10))

# Vi kan se at dette ikke gir så gode resultater, og forbedrer egentlig ikke vår klassifiserer. Vi skal derfor teste noe helt annet. Vi skal prøve om det er best å bruke bi-grams i tilleg til enkle ord. Vi lager derfor en bag-of-words som også inneholder bi-grams, altså en bag-of-ngrams (bigrams + unigrams).
#################################
# Del 4 -- Bag-of-ngrams som trekk
#################################
print('#################################')
print('# Del 4 -- Bag-of-ngrams V.1 som trekk')
print('#################################')

from nltk import bigrams

def bag_of_ngrams(words):
    words_cleaned = []

    lowered = [w.lower() for w in words]
    for bi in bigrams(lowered):
        words_cleaned.append(bi)

    for word in words:
        word = word.lower()
        if word not in stopwords_english and word not in string.punctuation:
            words_cleaned.append(word)
    words_dict = dict([word, True] for word in words_cleaned)

    return words_dict

# Hente ut alle stoppord for engelsk
stopwords_english = stopwords.words('english')

# lage trekk for positie anmeldelser
pos_reviews_feat = []
for words in pos_reviews:
    pos_reviews_feat.append((bag_of_ngrams(words), 'pos'))

# lage trekk for negative anmeldelser
neg_reviews_feat = []
for words in neg_reviews:
    neg_reviews_feat.append((bag_of_ngrams(words), 'neg'))

# Fordele dataen vår i test_set, dev_set, og train_set
test_set = pos_reviews_feat[:200] + neg_reviews_feat[:200]
dev_set = pos_reviews_feat[200:300] + neg_reviews_feat[200:300]
train_set = pos_reviews_feat[300:] + neg_reviews_feat[300:]

print(len(test_set),  len(dev_set), len(train_set))
# printer 400 200 1400

# Nå skal vi trene vår Naive Bayes klassifisserer
classifier = NaiveBayesClassifier.train(train_set)

# Så enkelt var det!
# Nå skal vi se hvor god den er ved å teste den på dev_set
accuracy = classify.accuracy(classifier, dev_set)

print("Accuracy on dev_set: %0.2f" % accuracy)
# Printer 0.73 Dette er den beste vi har hatt så langt!

# Vi kan se på de 10 mest informative trekk ved å gjøre følgende
print (classifier.show_most_informative_features(10))
# Most Informative Features
   #       ('waste', 'of') = True              neg : pos    =     29.0 : 1.0
   #              captures = True              pos : neg    =     15.0 : 1.0
   #      ('not', 'funny') = True              neg : pos    =     15.0 : 1.0
   #      ('perfect', '.') = True              pos : neg    =     15.0 : 1.0
   # ('saving', 'private') = True              pos : neg    =     13.0 : 1.0
   #                 sucks = True              neg : pos    =     13.0 : 1.0
   #             ludicrous = True              neg : pos    =     12.6 : 1.0
   #       ('brings', 'a') = True              pos : neg    =     12.3 : 1.0
   #         ('care', '.') = True              neg : pos    =     11.7 : 1.0
   # ('the', 'ridiculous') = True              neg : pos    =     11.7 : 1.0
# Nå gjør vi fremgang, vi får bedre accuracy, og vi ser også at det er en del bigrams som er viktige her. Men mer også, at vi har ikke slettet tegnsetting og stoppord fra bigrams! Kankjse vi skal teste om resultatene blir bedre uten ?

#################################
# Del 5 -- Bag-of-ngrams versjon 2 som trekk
#################################
print('#################################')
print('# Del 5 -- Bag-of-ngrams V.2 som trekk')
print('#################################')

from nltk import bigrams

def bag_of_ngrams_no_stopwords_punct(words):
    words_cleaned = []

    lowered = [w.lower() for w in words if w not in stopwords_english and w not in string.punctuation]
    for bi in bigrams(lowered):
        words_cleaned.append(bi)

    for word in words:
        word = word.lower()
        if word not in stopwords_english and word not in string.punctuation:
            words_cleaned.append(word)
    words_dict = dict([word, True] for word in words_cleaned)

    return words_dict

# Hente ut alle stoppord for engelsk
stopwords_english = stopwords.words('english')

# lage trekk for positie anmeldelser
pos_reviews_feat = []
for words in pos_reviews:
    pos_reviews_feat.append((bag_of_ngrams_no_stopwords_punct(words), 'pos'))

# lage trekk for negative anmeldelser
neg_reviews_feat = []
for words in neg_reviews:
    neg_reviews_feat.append((bag_of_ngrams_no_stopwords_punct(words), 'neg'))

# Fordele dataen vår i test_set, dev_set, og train_set
test_set = pos_reviews_feat[:200] + neg_reviews_feat[:200]
dev_set = pos_reviews_feat[200:300] + neg_reviews_feat[200:300]
train_set = pos_reviews_feat[300:] + neg_reviews_feat[300:]

print(len(test_set),  len(dev_set), len(train_set))
# printer 400 200 1400

# Nå skal vi trene vår Naive Bayes klassifisserer
classifier = NaiveBayesClassifier.train(train_set)

# Så enkelt var det!
# Nå skal vi se hvor god den er ved å teste den på dev_set
accuracy = classify.accuracy(classifier, dev_set)

print("Accuracy on dev_set: %0.2f" % accuracy)
# Printer 0.76
# Igjen, dette er den beste accuracy vi har oppnådd til nå. 0.76 er ikke så dårlig! og jeg tror at vi kan gi oss her, men la oss ta en titt på de meste informative trekkene

print (classifier.show_most_informative_features(10))
# Most Informative Features
#        ('waste', 'time') = True              neg : pos    =     19.0 : 1.0
#                 captures = True              pos : neg    =     15.0 : 1.0
#         ('one', 'worst') = True              neg : pos    =     15.0 : 1.0
#    ('saving', 'private') = True              pos : neg    =     13.0 : 1.0
#                    sucks = True              neg : pos    =     13.0 : 1.0
#                ludicrous = True              neg : pos    =     12.6 : 1.0
#                maintains = True              pos : neg    =     11.7 : 1.0
#             breathtaking = True              pos : neg    =     11.4 : 1.0
#                    anger = True              pos : neg    =     11.0 : 1.0
#                 depicted = True              pos : neg    =     10.3 : 1.0

# Nå tenker jeg at vi kan endelig teste vår klassifiserer på vår test_set
# Resultatene blir vanligvis dårligere enn på dev_set, men det er ikke så farlig.
accuracy = classify.accuracy(classifier, test_set)
print("Accuracy on our test set: %0.2f" % accuracy)
# Accuracy on our test set: 0.73
# Det er slett ikke dårlig for en veldig enkel Naive Bayes klassifiserer :D


#################################
# Ekstra tester
#################################
print('#################################')
print('Ekstra tester')
print('#################################')
# Vi har også muligheten til å teste vår klassifiserer på enkelte setninger som følgende
#
from nltk.tokenize import word_tokenize

sent = "Main actor: the worst! I hope he got paied well for embarassing himself like this!"
sent_tokens = word_tokenize(sent)
sent_features = bag_of_ngrams_no_stopwords_punct(sent_tokens)
print("Classifying the sentense: %s" %sent)
print ("Denne setningen er: %s" %classifier.classify(sent_features)) # Output: neg

# Printe sannsynelighetene for hver klasse
prob = classifier.prob_classify(sent_features)
print ("Den mest sannsynelige klassen er: %s" %prob.max()) # Output: neg
print ("Sannsynigheten for at sentninger er negativ: %0.2f" %prob.prob("neg")) # Output: 0.98
print ("Sannsynigheten for at sentninger er positiv: %0.2f" %prob.prob("pos")) # Output: 0.01

# Test 2
sent = "He managed to not embarass himself despite the horrible script. Well done!"
sent_tokens = word_tokenize(sent)
sent_features = bag_of_ngrams_no_stopwords_punct(sent_tokens)
print("Classifying the sentense: %s" %sent)
print ("Denne setningen er: %s" %classifier.classify(sent_features)) # Output: pos

# Printe sannsynelighetene for hver klasse
prob = classifier.prob_classify(sent_features)
print ("Den mest sannsynelige klassen er: %s" %prob.max()) # Output:
print ("Sannsynigheten for at sentninger er negativ: %0.2f" %prob.prob("neg")) # Output: 0.35
print ("Sannsynigheten for at sentninger er positiv: %0.2f" %prob.prob("pos")) # Output: 0.64
