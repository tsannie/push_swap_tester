#!/bin/bash
# Tester for push_swap by @tsannie


# C0l0r$
# Regular Colors
BLACK="\033[0;30m"        # BLACK
RED="\033[0;31m"          # RED
GREEN="\033[0;32m"        # GREEN
YELLOW="\033[0;33m"       # YELLOW
BLUE="\033[0;34m"         # BLUE
PURPLE="\033[0;35m"       # PURPLE
CYAN="\033[0;36m"         # CYAN
WHITE="\033[0;37m"        # WHITE

# Bold
BBLACK="\033[1;30m"       # BLACK
BRED="\033[1;31m"         # RED
BGREEN="\033[1;32m"       # GREEN
BYELLOW="\033[1;33m"      # YELLOW
BBLUE="\033[1;34m"        # BLUE
BPURPLE="\033[1;35m"      # PURPLE
BCYAN="\033[1;36m"        # CYAN
BWHITE="\033[1;37m"       # WHITE

END="\033[0m"

TMP='.tmp'
STRING_ERR='empty'

printf "$BCYAN\n\t ____            _          ____  _        _\n"
printf "\t|  _ \\ _   _ ___| |__      / ___|| |_ __ _| |_ ___\n"
printf "\t| |_) | | | / __|  _ \ ____\___ \| __/ _  | __/ __|\n"
printf "\t|  __/| |_| \__ \ | | |_____|__) | || (_| | |_\__ \ \n"
printf "\t|_|    \____|___/_| |_|    |____/ \__\____|\__|___/\n\n\n\n$END"

printf "${YELLOW}(${RED}-1${YELLOW} for any test)\n"
printf "${CYAN}or size of the interval (Number ${PURPLE}>${CYAN} 1) : ${BWHITE}"
read NBR

if [ $NBR -le 0 ] && [ $NBR -ne -1 ] ; then
	printf "${RED}Error size not valid.\n${END}"
	exit
fi;
printf "${CYAN}Choose the number of executions (Number ${PURPLE}>${CYAN} 1) : ${BWHITE}"
read NB_EXEC
printf "${END}"

LOAD1=$(($NB_EXEC/10))
LOAD2=$(($NB_EXEC/3))
LOAD3=$(($NB_EXEC/2))
LOAD4=$(($NB_EXEC-$NB_EXEC/3))

load()
{
	if [ $@ -eq $LOAD1 ]; then
		echo -ne "\t|$BPURPLE####$BYELLOW....................$END|"  $BGREEN'  10%\r'$END
	fi;
	if [ $@ -eq $LOAD2 ]; then
		echo -ne "\t|$BPURPLE########$BYELLOW................$END|"  $BGREEN'  30%\r'$END
	fi;
	if [ $@ -eq $LOAD3 ]; then
		echo -ne "\t|$BPURPLE#############$BYELLOW...........$END|"  $BGREEN'  50%\r'$END
	fi;
	if [ $@ -eq $LOAD4 ]; then
		echo -ne "\t|$BPURPLE##################$BYELLOW......$END|"  $BGREEN'  70%\r'$END
	fi;
}

classic_test()
{
	NB_TEST=0
	I=0
	MOY=0
	MAX=-1
	MIN=-1
	CPT=0
	printf "\n${YELLOW}Start analyse...$END\n\n"
	echo -ne "\t|$BYELLOW........................$END|"  $BGREEN'   0%\r'$END
	while [ $I -lt $NB_EXEC ]
	do
		if [ $(( $@ % 2)) -eq 0 ]; then
			GENERATE=`ruby -e "puts ((($@ / 2) * -1)..(($@ / 2) - 1)).to_a.shuffle.join(' ')"`
		else
			GENERATE=`ruby -e "puts ((($@ / 2) * -1)..($@ / 2)).to_a.shuffle.join(' ')"`
		fi
		.././push_swap $GENERATE > $TMP
		NB_LINE=$(wc -l < $TMP)
		RESULT=$(.././checker $GENERATE < $TMP)
		if [[ $RESULT == "OK" ]]; then
			if [ $MIN -eq "-1" ] || [ $NB_LINE -lt $MIN ]; then
				MIN=$NB_LINE
				STRING_MIN=$GENERATE
			fi

			if [ $MAX -eq "-1" ] || [ $NB_LINE -gt $MAX ]; then
				MAX=$NB_LINE
				STRING_MAX=$GENERATE
			fi
			((CPT++))
			MOY=$(($MOY + $NB_LINE))
		else
			STRING_ERR=$GENERATE
		fi

		load "$I"

		((NB_TEST++))
		((I++))
		rm ${TMP}
	done

	MOY=$(($MOY / $CPT))

	echo -ne "\t|$BPURPLE########################$END|"  $BGREEN' 100%\r'$END

	printf "\n\n\nResults for $BCYAN$NB_EXEC$END tests with an interval [${BCYAN}1-$@$END] : \n\n"

	printf "Minimum : $BGREEN%d$END\n" "$MIN"
	printf "Average : $BYELLOW%d$END\n" "$MOY"
	printf "Maximum : $BRED%d$END\n" "$MAX"

	printf "MIN = \"%s\"\n\nMAX = \"%s\"\n\nERR = \"%s\"" "$STRING_MIN" "$STRING_MAX" "$STRING_ERR" > results.txt

	if [[ $CPT -eq $NB_TEST ]]; then
		printf "Good sort : $GREEN%d/%d$END \n" "$CPT" "$NB_TEST"
	else
		printf "Good sort : $RED%d/%d$END \n" "$CPT" "$NB_TEST"
	fi
	printf "More information about number sequences in ${BWHITE}results.txt${END}\n"
}

if [ $NBR -eq -1 ]; then
	classic_test "500"
	classic_test "100"
	classic_test "5"
	classic_test "3"
else
	classic_test $NBR
fi
