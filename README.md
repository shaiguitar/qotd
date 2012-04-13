## Quote of the day server

See more info: http://en.wikipedia.org/wiki/QOTD

It's a real protocol: http://tools.ietf.org/html/rfc865

## Example

You should be able to get random quotes by doing something like this:

`nc alpha.mike-r.com 17`

## Running your own server

`ruby qotd.rb quotes_file.txt`

Then you should be able to randomly see quotes by connecting to it:

`nc localhost 17`

## See also

http://www.subgenius.com/
