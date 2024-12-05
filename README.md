# SUBSCRIBE Tech Test

# Thoughts on decisions

## Non-DRY tests

Tests by their nature should be as simple as possible; the more complication there is in a test, the more chance of false positives now or in the future as the code evolves. So I personally prefer to keep tests on the repetitive side and not DRY too enthusiastically.

It also makes them more readable as I can read a test and understand it without jumping back and forth between the test code and the custom matcher code.

This is also a useful "test smell" - if large swathes of code are repeated in a test, it may indicate the need to factor out components.

I must point out that I believe common use cases, like testing an attr accessor exists, can certainly be tested using factored out helpers or custom matchers, as the overhead is worth the constant repetition across an entire codebase. As with all things, there is a balance between overhead and tidiness that must be found.

Sometimes a test body is repeated for several tests, because the test is testing different behaviour. In those cases, I want the test descriptions to be like documentation and the bodies to be examples. Example: see Basket tests.
