# A simple commit tool

If you have the dooming task of deploying a new commit and have a similar workflow like:

- Merge Feature into Sprint Branch
- Merge Sprint into Develop Branch
- Merge Develop into Main
- Set a version tag a and push

That might save a little time

*If sprint unknown: It is basically a branch, where every feature branch (after they got testet) are merged*

## Project setup

The variables are self explaining:

```bash
branchPrefix="sprint"
branchMain="main"
branchDevelop="develop"
scriptServer="placeholder"
scriptCommand="placeholder"
```

scriptServer and scriptCommand are just text, to easily copy paste commands.
Script looks for every remote branch which begins iwth the branchPrefix and echos the latest 3.

## Prequesitions

If you plan to deploy a feature branch, make sure that you merge the sprint branch (or with whatever your branch begins with) into you feature branch – to avoid conflicts in sprint/develop/main branch.

## Start script

Go into your projects directory, checkout you target sprint branch and run the script by bash `<pathToScript>/mergeBranchToSprintToDev.sh`

## Important note

If you fuck up, the script fucks up ... i. e., if you say no at any point, it just stops.
If there is a merge conlfict or other error, it just stops.
If you stop, it just stops.