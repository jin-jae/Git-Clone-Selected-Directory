#!/bin/bash

# made by JINJAE


# welcome message
for var in {1..100}
do
    echo -n "-"
done
echo ""

echo "Clone git repository's special directory only"
echo ""
echo "version 1.0"

for var in {1..100}
do
    echo -n "-"
done
echo ""


# directory 입력 받기
read -p "Enter git repository URL >> " GIT_DIRECTORY
DIR_ARRAY=(`echo $GIT_DIRECTORY | tr '\/' ' '`)
DIR_ARRAY_LEN=${#DIR_ARRAY[@]}
echo "debug DIR_ARRAY: ${DIR_ARRAY[@]}"
echo "debug DIR_ARRAY_LEN: $DIR_ARRAY_LEN"


# base url (Repository 주소) 얻기
GIT_BASE_URL="${DIR_ARRAY[0]}//${DIR_ARRAY[1]}/${DIR_ARRAY[2]}/${DIR_ARRAY[3]}"
echo -n "Now trying to clone \""
echo -n "$GIT_BASE_URL"
echo "\"..."
echo ""


# clone 받을 목적지 설정
read -p "Choose destination to clone repository (default: $HOME/Code/) >> " CLONE_DIRECTORY
if [ -n "$CLONE_DIRECTORY" ]; then
    CLONE_DIRECTORY="$CLONE_DIRECTORY"
    echo "Repository will be cloned to: $CLONE_DIRECTORY"
else
    CLONE_DIRECTORY="$HOME/Code/"
    echo "Repository will be cloned to: $CLONE_DIRECTORY"
fi
# echo "debug CLONE_DIRECTORY: $CLONE_DIRECTORY"

# clone 작업
(
    echo "Now moving to git directory"
    cd $CLONE_DIRECTORY

    git clone -n --depth=1 --filter=tree:0 $GIT_BASE_URL
    cd ${DIR_ARRAY[3]}

    # 기본 브랜치 경로에서만 가능함
    BASE_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
    echo "debug BASE_BRANCH: $BASE_BRANCH"

    BRANCHES=($(git branch -r))

    declare -a BRANCHES_WITHOUT_ORIGIN

    for ((var = 0; var < ${#BRANCHES[@]}; var++))
    do
        if [[ ${BRANCHES[var]} == origin/* ]]; then
            BRANCHES_WITHOUT_ORIGIN[var]="${BRANCHES[var]#origin/}"
        else
            BRANCHES_WITHOUT_ORIGIN[var]="${BRANCHES[var]}"
        fi
    done

    echo "debug BRANCHES :"
    for BRANCH in "${BRANCHES_WITHOUT_ORIGIN[@]}"; do
        echo $BRANCH
    done

    FLAG=0
    for VARS in "${BRANCHES_WITHOUT_ORIGIN[@]}"; do
        if [ "$VARS" = "${DIR_ARRAY[5]}" ]; then
            FLAG=1
            break
        fi
    done

    TO_BE_ADDED_ROUTE=""
    if [ "$FLAG" -eq 1 ]; then
        echo "Can clone with minimum traffic..."
        BASE_BRANCH_CHECK=(`echo $BASE_BRANCH | tr '\/' ' '`)
        CHECK_BRANCH_LEN=${#BASE_BRANCH_CHECK[@]}

        let "I = 5 + CHECK_BRANCH_LEN"
        for ((var = I; var < DIR_ARRAY_LEN; var++))
        do
            TO_BE_ADDED_ROUTE+="${DIR_ARRAY[$var]}/"
        done
    else
        echo "Cannot clone with minimum traffic..."
        echo "Now trying with full clone process..."

        echo "Now moving to git directory..."
        cd $CLONE_DIRECTORY
        rm -rf ${DIR_ARRAY[3]}
        git init ${DIR_ARRAY[3]}
        cd ${DIR_ARRAY[3]}

        git remote add origin $GIT_BASE_URL

        # sparse checkout 가능하도록 설정
        git config core.sparsecheckout true

        git sparse-checkout set --no-cone "$TO_BE_ADDED_ROUTE"

        read -p "Enter branch >> " ENTERED_BRANCH

        ENTERED_BRANCH_CHECK=(`echo $ENTERED_BRANCH | tr '\/' ' '`)
        CHECK_ENTERED_BRANCH_LEN=${#ENTERED_BRANCH_CHECK[@]}

        let "I = 5 + CHECK_ENTERED_BRANCH_LEN"
        for ((var = I; var < DIR_ARRAY_LEN; var++))
        do
            TO_BE_ADDED_ROUTE+="${DIR_ARRAY[$var]}/"
        done
    fi

    echo "debug TO_BE_ADDED_ROUTE: $TO_BE_ADDED_ROUTE"

    git sparse-checkout set "$TO_BE_ADDED_ROUTE"

    # git pull
    git pull origin $BASE_BRANCH

)

# closing message
echo ""
echo "Clone done! Enjoy"
for var in {1..100}
do
    echo -n "-"
done
echo ""
