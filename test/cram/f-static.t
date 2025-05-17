  $ mkdir testdata
  $ echo "Hello" > helloworld
  $ echo "World" > testdata/helloworld
  $ static &> /dev/null &
  $ $CURL localhost:8080/static/helloworld
  Hello
  $ $CURL localhost:8080/static/testdata/helloworld
  World
  $ pkill -P $$
