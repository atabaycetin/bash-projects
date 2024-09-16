#!/bin/bash

# This is a program to get information about an element from a database 
# that I created using Bash to get my Relational Databases Certification

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

ARGUMENT=$1
DETECT_ARGUMENT() {
  if [[ $ARGUMENT =~ ^[0-9]+$ ]]
  then
    ELEMENT_INPUT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ARGUMENT;")

  
  elif [[ $ARGUMENT =~ ^[a-z]*$i ]]
  then
    str_length=${#ARGUMENT}
    if [[ str_length -gt 2 ]]
    then
      ELEMENT_INPUT=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ARGUMENT';")
    else
      ELEMENT_INPUT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ARGUMENT';")
    fi
  fi
}

PRINT_OUTPUT() {
  ATOMIC_NUMBER=$ELEMENT_INPUT
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types FULL JOIN properties ON properties.type_id=types.type_id WHERE atomic_number=$ATOMIC_NUMBER")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  MELTING_POINT_C=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  BOILING_POINT_C=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  echo -n "The element with atomic number" $ATOMIC_NUMBER is $NAME \(
  echo -n  $SYMBOL
  echo \). It\'s a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_C celsius and a boiling point of $BOILING_POINT_C celsius.
}

if [[ -z $1 ]]; then echo "Please provide an element as an argument."
else
  DETECT_ARGUMENT
  if [[ -z $ELEMENT_INPUT ]]
  then
    echo "I could not find that element in the database."
  else
    PRINT_OUTPUT
  fi
fi
