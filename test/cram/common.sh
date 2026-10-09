export DREAM_PORT=$((10000 + RANDOM % 55000))

curl_cmd() {
  # Retry until the server accepts connections.
  # Avoid curl's --retry as it also retries HTTP 5xx responses
  # Instead, only retry on exit code 7 (failed to connect)
  local attempt=0
  until curl --silent "localhost:$DREAM_PORT$1" "${@:2}" 2>&1; do
    [ "$?" -eq 7 ] || break
    attempt=$((attempt + 1))
    [ "$attempt" -lt 5 ] || break
    sleep 0.1
  done \
    | sed 's/User-Agent: .*/User-Agent: <omitted>/' \
    | sed -E 's/(::1|127\.0\.0\.1):[0-9]*/<client>:<omitted>/' \
    | sed 's/dream.request_id: [0-9]*/dream.request_id: <omitted>/' \
    | sed 's/localhost:[0-9]*/localhost:<omitted>/' \
    | sed -E 's/(in file [^,]*), line [0-9]*, characters [0-9]*-[0-9]*/\1, line <omitted>, characters <omitted>/'
}
