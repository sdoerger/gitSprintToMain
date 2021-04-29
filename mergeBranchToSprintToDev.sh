#!/bin/bash -e
set -e
clear

branchPrefix="sprint"
branchMain="master"
branchDevelop="develop"
scriptServer="placeholder"
scriptCommand="placeholder"

branch=$(git branch --show-current)
branchSprint=$(git branch --list ""${branchPrefix}"*")
tagVersion=""

checkMergeConflicts() {
  # Check if there are conflicts and abort if
  CONFLICTS=$(git ls-files -u | wc -l)
  if [ "$CONFLICTS" -gt 0 ] ; then
    echo "There is a merge conflict. Aborting"
    git merge --abort
    exit 1
  else
    echo "No Conflicts"
    the_current_branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')
    git push --set-upstream origin "${the_current_branch}"

    echo "Current Branch:"
    git branch --show-current
  fi
}

echo "Welcome to MergeSprintDevelopMaster ?"
echo ""
echo ""

echo "IMPORTANT: Does the "${branchPrefix}" branch (choose later) contain the (tested) features you want to set live and is pushed to origin?"
echo ""
echo ""

echo "Enter y/yes or n/no (no is default):"

read answer

if [ "$answer" = 'y' ] || [ "$answer" = 'Y' ] || [ "$answer" = 'yes' ] || [ "$answer" = 'Yes' ]  || [ "$answer" = 'YES' ]
then
  echo ""
  echo ""
  echo "Please choose the "${branchPrefix}" branch you want to merge:
  "
  echo "Here are latest 3 "${branchPrefix}" branches:"

options=(`git branch -a | grep remotes/origin/"${branchPrefix}" | tail -fn 3 | sort`)
#for bash version 4 or higher use mapfile.
#Fallback to while loop if mapfile not found
# mapfile -t options < <(`git branch -a | grep remotes/origin/sprint | sort -t: -rk2,2n`) &>/dev/null \
# || while read line; do options+=( "$line" ); done \
# # < <(git for-each-ref --format='%(refname:short)' refs/heads/)

options+=('  Exit')

select opt in "${options[@]}"
# select opt in "${options[@]:0:3}"
do
    if [[ "$opt" ]] && [[ "$opt" == '  Exit' ]]; then
        echo "Bye Bye"
        exit 0
    elif [[ "$opt" ]]; then
      # VERSION='2.3.3'
      # $ echo "${VERSION//.}"

      # toBranch="${opt/\/remotes\/origin\/}"
      toBranch="${opt//remotes\/origin\/}"
      # echo "$toBranch"
      
      # Checkout desired sprintBranch
      git checkout "$toBranch"
      git pull

      # SPRINT BRANCH
      # Check if three are conflicts
      checkMergeConflicts
      git merge "$branchDevelop"
      # Check if three are conflicts
      checkMergeConflicts

      # DEVELOP BRANCH
      # Go to develop (or equivalent)
      git checkout "$branchDevelop"
      git merge "$toBranch"
      # Check if three are conflicts
      checkMergeConflicts

      # DEVELOP BRANCH
      # Go to develop (or equivalent)Oh, hatt
      git checkout "$branchMain"
      git merge "$branchDevelop"
      # Check if three are conflicts
      checkMergeConflicts
      git push origin master

      echo "Here are the latest 3 Tags"

      git tag -l | sort -V | tail -fn 3

      echo "Please enter a Version number like \"v1.11.1\""
      read tagVersion
      echo "Please enter a Versin Description like \"Build an awsome feature\"."
      read tagDescription
      echo ""
      echo "  Is tag \"${tagVersion}\",  description: \"${tagDescription}\" correct?"
      echo ""
      echo "Enter y/yes or n/no (no is default):"
      read tagAnswer

      if [ "$tagAnswer" = 'y' ] || [ "$tagAnswer" = 'Y' ] || [ "$tagAnswer" = 'yes' ] || [ "$tagAnswer" = 'Yes' ]  || [ "$tagAnswer" = 'YES' ]
      then
        echo ""
        git tag -a "$tagVersion" -m \""$tagDescription"\"
        git push --tags
        echo "Done."
        echo ""
        echo "Please log into the server by:"
        echo ""${scriptServer}""
        echo "and run script:"
        echo ""${scriptCommand}""
        exit 0
      else
        echo "Error. Probably duplicated Tag number or merge conflicts."
        echo "Bye Bye."
        exit 0
      fi
      

    else
        echo "Wrong Input. Please enter the correct input or quit"
    fi
done

else
  echo "No"
fi