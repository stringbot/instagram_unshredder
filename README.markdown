Instagram "Unshredder" Challenge
================================

This is my solution for the Instagram engineering team's ["Unshredder"
challenge][unshred].

It only encompasses the strip-matching portion, I haven't had time to do
the strip-width detection portion.

Run It:
------

```
$ ./bin/unshred inputs/TokyoPanoramaShredded.png 32

$ ./bin/unshred inputs/big_sean_shredded.png 20

$ ./bin/unshred inputs/lenna_shredded.png 32

$ ./bin/unshred inputs/mona_lisa_shredded.png 32

$ ./bin/unshred inputs/windowlicker_shredded.png 20
```

[unshred]: http://instagram-engineering.tumblr.com/post/12651721845/instagram-engineering-challenge-the-unshredder
