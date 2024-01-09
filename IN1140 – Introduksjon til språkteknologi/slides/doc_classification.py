import nltk
from nltk.corpus import movie_reviews
from nltk import NaiveBayesClassifier
from nltk import classify

# Hente alle ord fra movie_reviews, konvertere til små bokstaver og legge dem i en FreqDist
# FreqDist = A frequency distribution for the outcomes of an experiment. A frequency distribution records the number of times each outcome of an experiment has occurred.
all_words = nltk.FreqDist(w.lower() for w in movie_reviews.words())

# print(list(all_words))

# Velge de 3000 mest frekvente ord i movie_reviews
word_features = list(all_words)[:3000]

# Funksjon for å hente ut trekk til vår Naive Bayes.
def document_features(document): #tar inn et dokument
    document_words = set(document) # bruker sett for å enkelt kunne hente ut alle unike ord fra dokumentet
    features = {}
    for word in word_features: #sjekke om hvert ord i word_features finnes i dokumentet
        features['contains({})'.format(word)] = (word in document_words)
    return features

documents = []

for category in movie_reviews.categories():
    for fileid in movie_reviews.fileids(category):
        documents.append((movie_reviews.words(fileid), category)) #lage en liste av (text, klasse) par som skal brukes ved trening og testing

featuresets = [(document_features(d), c) for (d,c) in documents] #bruke forrige funksjon til å generere trekk

train_set, test_set = featuresets[100:], featuresets[:100] #dele dataen i train og test sets

classifier = nltk.NaiveBayesClassifier.train(train_set)

accuracy = classify.accuracy(classifier, test_set) #Regne ut accuracy på vår Naive Bayes
print (accuracy)
# = 0.68

print(classifier.show_most_informative_features(5)) #Vise de fem mest relevante trekk for klassifiseringen

# For meg ble dette printet:
# Most Informative Features
#     contains(astounding) = True              pos : neg    =     11.1 : 1.0 dette betyr at "astounding" er mer positiv enn negativ
#      contains(stupidity) = True              neg : pos    =      9.0 : 1.0 dette betyr at "stupidity" er mer negativ enn positiv
#     contains(recognizes) = True              pos : neg    =      8.1 : 1.0  dette betyr at "recognizes" er mer positiv enn negativ
#     contains(schumacher) = True              neg : pos    =      7.8 : 1.0 dette betyr at "schumacher" er mer negativ enn positiv
#      contains(dismissed) = True              pos : neg    =      6.3 : 1.0 dette betyr at "dismissed" er mer positiv enn negativ
