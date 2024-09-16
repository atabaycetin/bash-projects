#! /bin/bash

# This is an interactive Bash program that uses PostgreSQL to track the customers and appointments for your salon
# It is part of the Relational Database Certification

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?"
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICES() {
  SERVICE_LIST=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICE_LIST" | while IFS='  |' read SERVICE_ID SERVICE_NAME
  do
    echo -e "$SERVICE_ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]*$ ]]
  then
    SERVICES "I could not find that service. What would you like today?"
  else

    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_CHECK=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_CHECK ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
    SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    SELECTED_CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo -e "\nWhat time would you like your$SELECTED_SERVICE,$SELECTED_CUSTOMER_NAME?"
    read SERVICE_TIME
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED)")
    echo -e "\nI have put you down for a$SELECTED_SERVICE at $SERVICE_TIME,$SELECTED_CUSTOMER_NAME."
  fi
}

SERVICES
