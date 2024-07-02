#!/bin/bash
NUM_RANDOM=$((RANDOM % 5))
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER_GUESS() {

NEW_BEST_GAME=1
NEW_GAMES_COUNT=1

while [ $NUMBER != $NUM_RANDOM ]
do
  if [[ $NUMBER -lt $NUM_RANDOM ]]
  then
  echo -e "\nIt's lower than that, guess again:"
  let NEW_BEST_GAME=NEW_BEST_GAME+1
  echo $NEW_BEST_GAME
  let NEW_GAMES_COUNT=NEW_GAMES_COUNT+1
  read NUMBER

  else
  echo -e "\nIt's higher than that, guess again:"
  let NEW_BEST_GAME=NEW_BEST_GAME+1
  let NEW_GAMES_COUNT=NEW_GAMES_COUNT+1
  read NUMBER
  fi
done
echo -e "\nYou guessed it in $NEW_BEST_GAME tries. The secret number was $NUM_RANDOM. Nice job!"
}

VERIFY_NUMBER() {
  while true
  do
    echo -e "\nGuess the secret number between 1 and 1000:"
    read NUMBER
    if [[ $NUMBER =~ ^[0-9]+$ ]]
    then
      break
    else
      echo "That is not an integer, guess again:"
    fi
  done
}

echo -e "\n---WELCOME TO MY GAME---\n"
echo -e "Enter your username:\n"
read USERNAME

USER=$($PSQL "SELECT username FROM number_guess WHERE username='$USERNAME'")

if [[ $USERNAME = $USER ]]
then
  GAMES_COUNT=$($PSQL "SELECT games FROM number_guess WHERE username='$USER'")
  BEST_GAME=$($PSQL "SELECT best_game FROM number_guess WHERE username='$USER'")
  
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_COUNT games, and your best game took $BEST_GAME guesses."
  NUMBER=''
  VERIFY_NUMBER
  NUMBER_GUESS

  let GAMES_COUNT=GAMES_COUNT+NEW_GAMES_COUNT
  
  if [[ $NEW_BEST_GAME -lt $BEST_GAME ]]
  then
    echo "$($PSQL "UPDATE number_guess SET best_game=$NEW_BEST_GAME WHERE username='$USER'")"
  fi
  echo "$($PSQL "UPDATE number_guess SET games=$GAMES_COUNT WHERE username='$USER'")"
  
else
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  NUMBER=''
  VERIFY_NUMBER
  NUMBER_GUESS
  
  echo "$($PSQL "INSERT INTO number_guess(username,games,best_game) VALUES('$USERNAME',$NEW_GAMES_COUNT,$NEW_BEST_GAME)")"
fi




