```
_________________________________________________/\/\___________________
_/\/\/\/\/\__/\/\__/\/\____/\/\/\/\__/\/\__/\/\__/\/\________/\/\/\/\___
_____/\/\______/\/\/\____/\/\________/\/\__/\/\__/\/\/\/\____/\/\__/\/\_
___/\/\________/\/\/\____/\/\__________/\/\/\____/\/\__/\/\__/\/\__/\/\_
_/\/\/\/\/\__/\/\__/\/\____/\/\/\/\______/\______/\/\/\/\____/\/\__/\/\_
________________________________________________________________________
```

`Zxcvbn` attempts to give sound password advice through pattern matching and conservative entropy calculations. It finds 10k common passwords, common American names and surnames, common English words, and common patterns like dates, repeats (aaa), sequences (abcd), and QWERTY patterns.




[JavaScript](https://github.com/dropbox/zxcvbn) (well, CoffeeScript) or the [Python port](https://github.com/dropbox/python-zxcvbn).

For full motivation, see [zxcvbn: realistic password strength estimation](https://blogs.dropbox.com/tech/2012/04/zxcvbn-realistic-password-strength-estimation/).



# Acknowledgments

Thanks to Dropbox for supporting independent projects and open source software.

A huge thanks to [Dan Wheeler](https://github.com/lowe) for the original [CoffeeScript implementation](https://github.com/dropbox/zxcvbn). Thanks to [Ryan Pearl](https://github.com/dropbox/python-zxcvbn) for his [Python port](). I've enjoyed copying your code :)

Echoing the acknowledgments from earlier libraries...

Many thanks to Mark Burnett for releasing his 10k top passwords list:

http://xato.net/passwords/more-top-worst-passwords

and for his 2006 book,
"Perfect Passwords: Selection, Protection, Authentication"

Huge thanks to Wiktionary contributors for building a frequency list
of English as used in television and movies:
http://en.wiktionary.org/wiki/Wiktionary:Frequency_lists

Last but not least, big thanks to xkcd :)
https://xkcd.com/936/

