#!/bin/zsh
# Use the system CSPRNG and reject candidates missing a character category.
[[ -x /usr/bin/openssl ]] || exit 1
while true; do
  password=$(/usr/bin/openssl rand -base64 18) || exit 1
  [[ ${#password} == 24 && "$password" == *[A-Z]* && "$password" == *[a-z]* && "$password" == *[0-9]* && "$password" == *[+/]* ]] && break
done
printf '{"version":1,"action":"copy","text":"%s"}\n' "$password"
