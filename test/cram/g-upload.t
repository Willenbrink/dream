  $ upload &> /dev/null &
  $ curl_cmd / -c cookies -b cookies | sed 's/value=.*/value=<omitted>/'
  <html>
  <body>
    <form method="POST" action="/" enctype="multipart/form-data">
      <input name="dream.csrf" type="hidden" value=<omitted>
  
      <input name="files" type="file" multiple>
      <button>Submit!</button>
    </form>
  </body>
  </html>
  
