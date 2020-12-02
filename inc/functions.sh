#!/usr/bin/env bash

COLOR_RED=$(printf '\033[0;31m')
COLOR_GREEN=$(printf '\033[0;92m')
COLOR_CYAN=$(printf '\033[0;96m')
BGCOLOR_YELLOW=$(printf '\033[33;7m')
COLOR_DEFAULT=$(printf '\033[0m')

VERSION_TYPES=('major' 'minor' 'patch')
SEMVER_REGEX='v[0-9]*\.[0-9]*\.[0-9]*'
LAST_TAG=$(git ls-remote --tags --sort="v:refname" | grep -o "$SEMVER_REGEX" | tail -n1)

# Gets version prefix from git config
function __get_version_prefix
{
    echo $(git config --get gitflow.prefix.versiontag)
}

# Gets last tag. If doesn't exists semver tag in remote, start at 0.0.0.
function __get_last_tag
{
    if [ "$LAST_TAG" == "" ]; then
        LAST_TAG=$(__get_version_prefix)0.0.0
    fi

    echo $LAST_TAG
}

# Remove prefix from last tag.
function __get_last_tag_without_prefix
{
    LAST_TAG=$(__get_last_tag)
    LAST_SEMVER_TAG=${LAST_TAG:1}
    
    echo ${LAST_SEMVER_TAG}
}

# Checks type of version (major, minor, patch)
function __is_valid_semver
{
    FOUND=false
    for i in "${VERSION_TYPES[@]}"
    do
        if [ "$i" == "$VERSION" ] ; then
            FOUND=true
        fi
    done

    if [ $FOUND == false ]; then
        echo "ERROR${COLOR_RED}Version${COLOR_DEFAULT} ${COLOR_GREEN}${VERSION}${COLOR_DEFAULT} ${COLOR_RED}is not a valid version tag. It must be major, minor or patch.${COLOR_DEFAULT}"
        exit 77
    fi
}

# Checks if there are error from version filter
function __check_errors
{
    if  [[ $VERSION == $(__get_version_prefix)ERROR* ]] ;then
        echo "${VERSION/$(__get_version_prefix)ERROR/}"
        exit 77
    fi
}

# Checks prefix. Only lowercase "v" allowed
function __check_prefix
{
    if [ $(__get_version_prefix) != "v" ]; then
        echo "${COLOR_RED}Your default prefix is ${COLOR_DEFAULT}${BGCOLOR_YELLOW}" $(__get_version_prefix) "${COLOR_DEFAULT}${COLOR_RED}, instead ${COLOR_DEFAULT}${BGCOLOR_YELLOW} v ${COLOR_DEFAULT}${COLOR_RED}.${COLOR_DEFAULT}"
        read -n 1 -p $"${COLOR_GREEN}Do you want to change it automatically? (y/n)${COLOR_DEFAULT}? " answer
        case ${answer:0:1} in
            y|Y )
                $(git config gitflow.prefix.versiontag v)
                echo " "
                echo " "
                echo "${COLOR_CYAN}Prefix changed! Please, try again${COLOR_DEFAULT}"
                echo " "
                exit 1
            ;;
            * )
                echo " "
                exit 77
            ;;
        esac
    fi
}

function __get_next_version
{
    SEMVER_TAG=$(__get_last_tag_without_prefix)
    SEMVER=( ${SEMVER_TAG//./ } )

    if [ ${#SEMVER[@]} -ne 3 ]; then
        echo "ERROR${COLOR_RED}Semantic Version number doesn't have correct format X.Y.Z (major.minor.patch).${COLOR_DEFAULT}"
        exit 77
    fi

    case ${1:-$VERSION} in
        major)
            ((SEMVER[0]++))
            SEMVER[1]=0
            SEMVER[2]=0
            ;;

        minor)
            ((SEMVER[1]++))
            SEMVER[2]=0
            ;;

        patch)
            ((SEMVER[2]++))
            ;;

        *)
            exit 77
            ;;
    esac

    echo ${SEMVER[0]}.${SEMVER[1]}.${SEMVER[2]}
}