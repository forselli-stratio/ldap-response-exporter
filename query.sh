#!/bin/bash
ldapsearch -xLLL -H "'$LDAPURI'" -D "'$BINDDN'" -w "'$PASSWORD'" -b "'$SEARCHBASE'" "'$USERTOSEARCH'"



#ldapsearch -xLLL -H "ldaps://ad.sanitas.dom:636" -D "CN=adeos-pro,CN=Users,DC=sanitas,DC=dom" -w "eTvo7roJzRnhXNje4PhX" -b "DC=sanitas,DC=dom" "(sAMAccountName=adeos-pro)"
