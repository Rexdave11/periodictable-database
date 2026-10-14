#!/bin/bash

if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

PSQL=(psql --username=freecodecamp --dbname=periodic_table -X -t --no-align -F '|')
ELEMENT_DATA=$(printf '%s\n' "
  SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass,
         p.melting_point_celsius, p.boiling_point_celsius
  FROM elements AS e
  JOIN properties AS p USING (atomic_number)
  JOIN types AS t USING (type_id)
  WHERE e.atomic_number::text = :'input'
     OR e.symbol = :'input'
     OR e.name = :'input';
  " | "${PSQL[@]}" -v input="$1")

if [[ -z "$ELEMENT_DATA" ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|' read -r atomic_number name symbol type atomic_mass melting_point boiling_point <<< "$ELEMENT_DATA"
echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."