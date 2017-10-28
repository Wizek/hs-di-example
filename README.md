# hs-di-example

For some time now, people have been asking me to compare hs-di ([github][gh], [hackage][hk]) to other techniques available to Haskell programmers for achieving fully deterministic unit-testing for effectful code. And when I saw Alexis King's repository posted [on Reddit][reddit] about [an mtl-style unit-testing example][fork], and saw just how much boilerplate was required to make that style work, I thought this was a great opportunity to contrast the two approaches.

So this repository contains a working example of hs-di-style converted from the mtl-style.

According to `cloc`, we were able to get to:

```
$ cloc --exclude-dir=.stack-work .
      11 text files.
      11 unique files.
     305 files ignored.

http://cloc.sourceforge.net v 1.60  T=0.10 s (68.9 files/s, 1447.9 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Haskell                          5             19              3             66
YAML                             2             10              0             49
-------------------------------------------------------------------------------
SUM:                             7             29              3            115
-------------------------------------------------------------------------------
```

Coming from:

```
$ cloc --exclude-dir=.stack-work .
      13 text files.
      13 unique files.
     222 files ignored.

http://cloc.sourceforge.net v 1.60  T=0.30 s (29.6 files/s, 999.2 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Haskell                          7             52             34            147
YAML                             2              8              0             63
-------------------------------------------------------------------------------
SUM:                             9             60             34            210
-------------------------------------------------------------------------------
```

A better then two-fold improvement (147 SLOC -> 66 SLOC)!

## Footnotes

1. Few of the 4 mocks are slightly less complex than in the mtl example, so that may skew the sloc counts somewhat. But on the other hand, the current mocks are perfectly adequate for testing as much as we do, so I'd say less is more in this case.

2. During development, a few times I ran into a type error `... is as general as its inferred signature`. It's not present in the current state of the repository, and it's worked around for even when it would show up. But if you'd like to help me overcome this issue, and/or you'd like to read more, [head over here](https://gist.github.com/Wizek/396b0a608fa93d7d458a78dbf7c88870).


[fork]: https://github.com/lexi-lambda/mtl-style-example
[gh]: https://github.com/Wizek/hs-di#readme
[hk]: https://hackage.haskell.org/package/hs-di
[reddit]: https://www.reddit.com/r/haskell/comments/78xk5y/mtlstyleexample_a_small_selfcontained_example_of/
[error]: https://gist.github.com/Wizek/d5d66b3f7e95b329fdb2edc1d5207455
