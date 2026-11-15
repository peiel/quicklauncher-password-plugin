#!/bin/zsh
# Base64 characters from random bytes are uniformly distributed. Reject whole
# candidates until each advertised character class is present.
[[ -x /usr/bin/openssl ]] || exit 1
IFS= read -r request || exit 1
[[ "$request" =~ '"passwordLength"[[:space:]]*:[[:space:]]*([0-9]+)' ]] || exit 1
length=$match[1]
(( length >= 8 && length <= 128 )) || exit 1
bytes=$(( (length * 3 + 3) / 4 ))
while true; do
  password=$(/usr/bin/openssl rand -base64 "$bytes") || exit 1
  password=${password//$'\n'/}
  password=${password//=/}
  password=${password[1,$length]}
  [[ ${#password} == $length && "$password" == *[A-Z]* && "$password" == *[a-z]* && "$password" == *[0-9]* && "$password" == *[+/]* ]] && break
done
printf '{"version":1,"action":"copy","text":"%s"}\n' "$password"
