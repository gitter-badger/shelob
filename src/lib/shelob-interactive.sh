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
      debug "Answer all flag is set, answering $default_answer"
      echo "${prompt}$default_answer" |  blue | bold
    else
      while [[ ! $no =~ $response ]] && \
            [[ ! $yes =~ $response ]] && \
            [[ "$response" != "" ]];
      do
          printf "%s" "${prompt}" |  blue | bold
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
#   prompt ($2)           : Descriptive prompt to display to user
#   default_input ($3)    : Default input
# Returns:
#   0
#   1   : If variable name is not given
# Output:
#   None
#######################################
function ask_input() {
    local variable_name=${1:-}
    local __response=
    if [[ -z $variable_name ]]; then
      error "Missing variable name"
      info "Usage: ask_input <variable-name> <prompt> [default-input]"
      return 1
    fi
    local prompt=${2:-}
    local default_input=${3:-}
    if [[ ${SHELOB_ANSWER_ALL:-} = true ]]; then
      debug "Answer all flag is set, using default input: $default_input"
      printf -v "$variable_name" "%s" "$default_input"
      return 0
    else
      printf "%s" "$prompt [${default_input}]> " |  blue | bold
      read -r __response
    fi
    debug "Response: $__response"
    if [[ "$__response" = "" ]]; then
      debug "Response is empty, using default input $default_input"
      __response="$default_input";
    fi
    printf -v "$variable_name" "%s" "$__response"
}

#######################################
# Ask user to give a required input and wait to receive an input from stdin.
# Use $default_input if no input received from stdin.
# If $default_input is not given and response is empty keeps asking
#
# Globals:
#   SHELOB_ANSWER_ALL (RO) : If true, use $default_input
# Arguments:
#   variable_name ($1)    : Variable to assign given input to
#   prompt ($2)           : Descriptive prompt to display to user
#   default_input ($3)    : Default input
# Returns:
#   0
#   1                     : If variable name is not given
#   1                     : If default option is not given and answer all
#                           flag is set
# Output:
#   None
#######################################
function ask_input_required() {
    local variable_name=${1:-}
    ask_input "$@"
    while [[ -z ${!variable_name} ]]; do
      if [[ ${SHELOB_ANSWER_ALL:-} = true ]]; then
        error "There is no default input, can not auto answer"
        return 1
      fi
      ask_input "$@"
    done
}


#######################################
# Ask user to select an option and waits to receive an input from stdin.
# Use $default_answer if no input received from stdin.
#
# Globals:
#   SHELOB_ANSWER_ALL (RO) : If true, use $default_answer
# Arguments:
#   variable_name ($1)    : Variable to assign given input to
#   prompt ($2)           : Descriptive prompt to display to user
#   options ($3)          : comma separated option list ( option1, option2... )
#   default_answer ($4)   : 1-based index of given option list
# Returns:
#   0
#   1   : If variable name is not given
# Output:
#   None
#######################################
function ask_option() {
    local variable_name=${1:-}
    local prompt=${2:-}
    IFS=',' read -ra options <<< "${3:-}"
    debug "Number of options: ${#options[@]}"
    local default_answer=${4:-}
    local answer=
    local selected_option=

    if [[ -z $variable_name ]]; then
      error "Missing variable name"
      info "Usage: ask_option <variable-name> <description> <option-list> [default-option]"
      return 1
    fi

    if [[ ${#options[@]} -eq 0 ]]; then
      error "No option given, options must be a comma separated list"
      info "Usage: ask_option <variable-name> <description> <option-list> [default-option]"
      return 1
    fi

    echo "$prompt" |  blue | bold
    let count=1
    for option in "${options[@]}"; do
      echo "$count) $option" |  blue | bold
      count=$((count+1))
    done
    while [[ -z ${selected_option} ]]; do
      ask_input_required selected_option "Select an option" "$default_answer"
      if [[ $selected_option =~ ^[0-9]+$ ]] && \
         [[ $selected_option -le ${#options[@]} ]] && \
         [[ $selected_option -gt 0 ]]; then
         selected_option=$((selected_option-1)) # Adjust reponse as array index is 0-based
         answer=${options[$selected_option]}
       else
         selected_option= # Clear invalid selection
      fi
    done

    debug "Selected answer: $answer"
    printf -v "$variable_name" "%s" "$answer"
}

