  $ cp ../../example/h-sql/db.sqlite .
  $ sql &> /dev/null &
  $ curl_cmd / -c cookies -b cookies | sed 's/value=.*/value=<omitted>/'
  <html>
  <body>
  
  
  
    <form method="POST" action="/">
      <input name="dream.csrf" type="hidden" value=<omitted>
  
      <input name="text" autofocus>
    </form>
  
  </body>
  </html>
  
  $ pkill -P $$
