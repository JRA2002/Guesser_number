#!/bin/bash
NUM_RANDOM=$((RANDOM % 10))
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER_GUESS() {
GAMES_COUNT=$($PSQL "SELECT games FROM number_guess WHERE username='$USER'")
BEST_GAME=$($PSQL "SELECT best_game FROM number_guess WHERE username='$USER'")
if [[ -z $GAMES_COUNT && -z $BEST_GAME ]]
then
  NEW_BEST_GAME=0
  GAMES_COUNT=0
fi

while [ $NUMBER != $NUM_RANDOM ]
do
  if [[ $NUMBER -lt $NUM_RANDOM ]]
  then
  echo -e "\nIt's lower than that, guess again:"
  let NEW_BEST_GAME=NEW_BEST_GAME+1
  echo $NEW_BEST_GAME
  let GAMES_COUNT=GAMES_COUNT+1
  read NUMBER

  else
  echo -e "\nIt's higher than that, guess again:"
  let NEW_BEST_GAME=NEW_BEST_GAME+1
  let GAMES_COUNT=GAMES_COUNT+1
  read NUMBER
  fi
done

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
  
  
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_COUNT games, and your best game took $BEST_GAME guesses."
  NUMBER=''
  VERIFY_NUMBER
  NUMBER_GUESS
  
  if [[ $NEW_BEST_GAME -lt $BEST_GAME ]]
  then
    echo "$($PSQL "UPDATE number_guess SET best_game=$NEW_BEST_GAME WHERE username='$USER'")"
  fi
  echo "$($PSQL "UPDATE number_guess SET games=$GAMES_COUNT WHERE username='$USER'")"
  
else
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  NUMBER=''
  VERIFY_NUMBER
  GAMES_COUNT=0
  NUMBER_GUESS
  if [[ $NEW_BEST_GAME -eq 0 ]]
  then
    let NEW_BEST_GAME=NEW_BEST_GAME+1
    let GAMES_COUNT=GAMES_COUNT+1
    echo -e "\nwiiiin"
    echo "$($PSQL "INSERT INTO number_guess(username,games,best_game) VALUES('$USERNAME',$GAMES_COUNT,$NEW_BEST_GAME)")"
  else
    echo "$($PSQL "INSERT INTO number_guess(username,games,best_game) VALUES('$USERNAME',$GAMES_COUNT,$NEW_BEST_GAME)")"
  fi
fi




