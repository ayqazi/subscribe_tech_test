# SUBSCRIBE Tech Test

# Thoughts on decisions

## Non-DRY tests

Tests by their nature should be as simple as possible; the more complication there is in a test, the more chance of false positives now or in the future as the code evolves. So I personally prefer to keep tests on the repetitive side and not DRY too enthusiastically.

It also makes them more readable as I can read a test and understand it without jumping back and forth between the test code and the custom matcher code.

This is also a useful "test smell" - if large swathes of code are repeated in a test, it may indicate the need to factor out components.
