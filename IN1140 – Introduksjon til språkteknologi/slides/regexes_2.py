import re

liste = ['beltedyr', 'morgen', 'simba', 'Kl.09', 'Simon', '1140']

print('-------------------NEW------------------')
for element in liste:
    print(element)
    regex1 = '[^be]'
    regex2 = '[^A-Z]'
    regex3 = '[^bA-Z0-9]'

    found1 = re.findall(r'%s' %regex1 , element)
    found2 = re.findall(r'%s' %regex2 , element)
    found3 = re.findall(r'%s' %regex3 , element)

    if found1:
        print('Første regex:' + str(found1))

    if found2:
        print('Andre regex:' + str(found2))

    if found3:
        print('Tredje regex: ' +str(found3))

#------------------------------------------------------------
print('\n#------------------------------------------------------------#\n')
#------------------------------------------------------------

#streng = 'ser etter a^b i en streng'
#streng = 'se etter e^ nå'
#regex = 'a\^b|e\^'


#found = re.search(r'%s' %regex , streng)

#if found:
#    print('Regex strengen: ' + str(found.group()))

#------------------------------------------------------------
#print('\n#------------------------------------------------------------#\n')
#------------------------------------------------------------

# streng = ' How much wood could a woodchuck chuck If a woodchuck could chuck wood? As much wood as woodchucks could chuck, If woodchucks could chuck wood.'
#
# regex = "woodchucks?"
#
# found = re.findall(r'\b%s\b' %regex, streng)
#
# if found:
#     print('Matches: ' + str(found))

#------------------------------------------------------------
#print('\n#------------------------------------------------------------#\n')
#------------------------------------------------------------
#
# streng = 'I see your true colours. I can see your colors too'
#
# regex = "colou?rs"
#
# found = re.findall(r'\b%s\b' %regex, streng)
#
# if found:
#     print('Matches: ' + str(found))

#------------------------------------------------------------
#print('\n#------------------------------------------------------------#\n')
#------------------------------------------------------------

#streng = "beltedyr er en familie av gomlere som er i utgangspunktet en ren søramerikansk gruppe, og Sør-Amerika pluss de sørlige delene av Nord-Amerika er de eneste stedene hvor beltedyr finnes vilt i dag"

#regex = "beltedyr.*beltedyr"

#found = re.search(r'\b%s\b' %regex, streng)

#if found:
#    print('Matches: ' + str(found.group()))

#------------------------------------------------------------
#print('\n#------------------------------------------------------------#\n')
#------------------------------------------------------------

# streng = "Det hvite huset."
#
# regex = "Det hvite huset\.$"
#
# found = re.search(regex, streng)
#
# if found:
#     print('Matches: ' + str(found.group()))

#------------------------------------------------------------
#print('\n#------------------------------------------------------------#\n')
#------------------------------------------------------------

#streng = "Kolone 1 Kolone 2 Kolone 3 Kolone 1 Kolone 2  "

#regex = "(Kolone\s[0-9]+\s)*"

#found = re.search(regex, streng)

#if found:
#    print('Matches: ' + str(found.group()))

#------------------------------------------------------------
#print('\n#------------------------------------------------------------#\n')
#------------------------------------------------------------

#streng = 'once upon a time'

#regex = '[a-z]*'

#found = re.search(regex, streng)

#if found:
#    print('Matches: ' + str(found.group()))

#------------------------------------------------------------
#print('\n#------------------------------------------------------------#\n')
#------------------------------------------------------------

#streng = 'I see your true colours. I can see your colors too'

#nyStreng = re.sub('colors', 'colours', streng)

#print('Original:' + streng + '\n' + 'Sub:' + nyStreng)

#------------------------------------------------------------
#print('\n#------------------------------------------------------------#\n')
#------------------------------------------------------------
