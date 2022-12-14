#!/bin/bash

UTPLSQL_BUILD_NO=$( expr ${GITHUB_RUN_NUMBER} + ${UTPLSQL_BUILD_NO_OFFSET} )
UTPLSQL_VERSION=$(.github/scripts/get_project_version.sh)

echo "UTPLSQL_BUILD_NO=${UTPLSQL_BUILD_NO}" >> $GITHUB_ENV
echo "UTPLSQL_VERSION=${UTPLSQL_VERSION}" >> $GITHUB_ENV
echo UTPLSQL_BUILD_VERSION=$(echo ${UTPLSQL_VERSION} | sed -E "s/(v?[0-9]+\.)([0-9]+\.)([0-9]+)(-.*)?/\1\2\3\.${UTPLSQL_BUILD_NO}\4/")  >> $GITHUB_ENV

echo "CURRENT_BRANCH=${CI_ACTION_REF_NAME}" >> $GITHUB_ENV
