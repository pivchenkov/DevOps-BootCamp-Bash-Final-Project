#!/bin/bash
#
# Upload/download files to/from transfer.sh service


#######################################
# Uploads files to transfer.sh using curl
# Globals:
#   None
# Arguments:
#   $@
# Outputs:
#   Writes upload process and result info to stdout
# Returns:
#   1 on error
#######################################
upload() {
  for arg in "$@"; do
    echo "Uploading $arg"
    curl_output=$(curl --progress-bar --upload-file ./$arg `
    ` https://transfer.sh/$arg) && echo "Transfer File URL: $curl_output"`
    ` || return 1
  done
}


#######################################
# Downloads a single file from transfer.sh using curl
# Globals:
#   None
# Arguments:
#   $@
# Outputs:
#   Writes download info to stdout
#   Writes files to file system
# Returns:
#   1 on error
#######################################
single_download() {
  echo "Downloading $4"
  http_code=$(curl --progress-bar --write-out "%{http_code}" `
  ` https://transfer.sh/$3"/"$4 --output $2"/"$4)
  print_download_response $http_code || return 1
}


#######################################
# Prints download result
# Is called from singleDownload finction
# Globals:
#   None
# Arguments:
#   http_code
# Outputs:
#   Writes HTTP GET response code to stdout
# Returns:
#   1 on error
#######################################
print_download_response() {
  if [[ $http_code == "200" ]]; then
    echo "Success!"
  else
    echo "Error: $http_code"
    return 1
  fi
}


#######################################
# Prints help information about using this script
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Writes help information to stdout
#######################################
help() {
  echo "Description: Bash tool to transfer files from the command line.
  Usage:
    -d  ...
    -h  Show the help ... 
    -v  Get the tool version
  Examples:
  <Write a couple of examples, how to use your tool>
  ./transfer.sh test.txt ..."
}

#######################################
# Checks input for parameters and pass them to functions
# Globals:
#   None
# Arguments:
#   $@
# Outputs:
#   Writes version info to stdout
#######################################
main() {
  if [[ $1 == "-d" ]]; then
    single_download "$@"
  elif [[ $1 == "-h" ]]; then
    help
  elif [[ $1 == "-v" ]]; then
    echo "0.0.1"
  else
    upload "$@"
  fi
}


main "$@"