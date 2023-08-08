#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games,teams;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    # Get team name
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    # If the team name is not found
    if [[ -z $TEAM_ID ]]
    then
      # Insert team
      INSERT_TEAM_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      : 'if [[ $INSERT_TEAM_ID_RESULT == "Insert 0 1" ]]
      then
        #echo Inserted into teams, $WINNER
      fi'

      # Get new team_id
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    fi
  fi
  # Insert Opponents
  if [[ $OPPONENT != 'opponent' ]]
  then
    OPTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    #echo  $OPTEAM_ID test
    
    # If opponent is not found
    if [[ -z $OPTEAM_ID ]]
    then
      #Insert the opponent into the list
      echo Inserting Op data
      INSERT_OPTEAM_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      : 'if [[ INSERT_OPTEAM_ID_RESULT == "Insert 0 1" ]]
      then
        #echo Inserted into teams, $OPPONENT op
      fi'
      # Get new Op team ID
      OPTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    fi
  fi
  if [[ $YEAR != "year" ]]
  then
    # Insert year
    WINNERID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    OPID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    YEARINS=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNERID,$OPID,$WINNER_GOALS,$OPPONENT_GOALS);")
    : 'if [[ $YEARSINS == "Insert 0 1" ]]
    then
      #echo Inserted data
    fi'
  fi
  done
