# shellcheck shell=bash
#
#
# Bash utility functions for interaction with user

include "shelob-logger.sh"


#######################################
# based on: https://github.com/pearl-core/pearl/blob/master/lib/utils/utils.sh
# Ask a question and wait to receive an answer from stdin.
# It returns $default_answer if no answer has been received from stdin.
#
# Globals:
#    SHELOB_ANSWER_ALL (RO) : If true, answer yes and continue
# Arguments:
#   question ($1)       : The question to ask.
#   default_answer ($2) : Possible values: 'Y', 'y', 'N', 'n' (default: 'Y')
# Returns:
#   0                   : If user replied with either 'Y' or 'y'.
#   1                   : If user replied with either 'N' or 'n'.
# Output:
#   Print a warning if default answer is invalid
#   Print the question to ask.
#######################################
function ask_yes_no(){
    local question=${1:-}
    local default_answer=${2:-invalid}
    local yes="Y y"
    local no="N n"
    local alternate="n"
    local response="invalid"
    local prompt

    if [[ "$yes" =~ $default_answer ]]; then
      default_answer="Y"
    elif [[ "$no" =~ $default_answer ]]; then
      default_answer="N"
    else
      warning "The default answer: $default_answer is invalid. Setting default answer as Y"
      default_answer="Y"
    fi

    [[ "$no" =~ $default_answer ]] && alternate="y" || alternate="n"

    prompt="$question (${default_answer}/${alternate})> "

    if [[ ${SHELOB_ANSWER_ALL:-} = true ]]; then
      debug "Answer all flag is set, answering yes"
      echo "${prompt}y"
      return 0
    else
      while [[ ! $no =~ $response ]] && \
            [[ ! $yes =~ $response ]] && \
            [[ "$response" != "" ]];
      do
          printf "%s" "${prompt}"
          read -r response
          debug "Reponse $response"
      done
    fi

    if [[ "$response" = "" ]]; then
      debug "Response is empty, using default answer"
      response="$default_answer";
    fi

    [[ $yes =~ $response ]]
}


#######################################
# Ask user to give an input and wait to receive an input from stdin.
# Use $default_input if no input received from stdin.
#
# Globals:
#   SHELOB_ANSWER_ALL (RO) : If true, use $default_input
# Arguments:
#   variable_name ($1)    : Variable to assign given input to
#   description ($2)      : Input description
#   default_input ($3)    : Default input
# Returns:
#   0
#   1   : If variable name is not given
# Output:
#   None
#######################################
function ask_input() {
    local variable_name=${1:-}
    if [[ -z $variable_name ]]; then
      error "Missing variable name"
      info "Usage: ask_input <variable-name> <description> [default-input]"
      return 1
    fi
    local description=${2:-}
    local default_input=${3:-}
    if [[ ${SHELOB_ANSWER_ALL:-} = true ]]; then
      debug "Answer all flag is set, using default input: $default_input"
      printf -v "$variable_name" "%s" "$default_input"
      return 0
    else
      printf "%s" "$description [${default_input}]> "
      read -r response
    fi
    debug "Response: $response"
    if [[ "$response" = "" ]]; then
      debug "Response is empty, using default input $default_input"
      response="$default_input";
    fi
    printf -v "$variable_name" "%s" "$response"
}

#######################################
# Ask user to give a required input and wait to receive an input from stdin.
# Use $default_input if no input received from stdin.
#
# Globals:
#   SHELOB_ANSWER_ALL (RO) : If true, use $default_input
# Arguments:
#   variable_name ($1)    : Variable to assign given input to
#   description ($2)      : Input description
#   default_input ($3)    : Default input
# Returns:
#   0
#   1                     : If variable name is not given
# Output:
#   None
#######################################
function ask_input_required() {
    local variable_name=${1:-}
    ask_input "$@"
    while [[ -z $variable_name ]]; do
      ask_input "$@"
    done
}



