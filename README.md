# shtest

A simple test runner written in POSIX shell.


### Quickstart

Write a couple of quick tests:
```
# tests/a/test_not_equal.sh

test_1_is_not_equal_to_0() {
	! assert_equal 1 0 '1 = 0'
}
```
```
# tests/b/test_foo.sh

. ./main.sh

test_foo_prints_bar() {
	actual=$(foo)
	expected='bar'
	msg="'foo' printed '$actual', expected '$expected'"
	assert_equal "$actual" "$expected" "$msg"
}
```

Write a function to satisfy the tests:
```
# main.sh

foo() {
	echo 'foo'
}
```

Run all tests:
```
$ ./shtest
test_1_is_not_equal_to_0...OK
test_foo_prints_bar...FAILED:
'foo' printed 'foo', expected 'bar'

Ran 2 test(s):
Passed: 1
Failed: 1

```

Fix the error:
```
$ vi tests/b/test_foo.sh
```

Run just the failing test:
```
$ ./shtest tests/b
test_foo_prints_bar...OK:

Ran 1 test(s):
Passed: 1
```


### Assert functions

`shtest` provides three assert functions for use in your tests:

```
assert() {
	# Usage: assert <command> [<message>]
	#
	# Execute <command>. If it succeeds, return success. Otherwise,
	# print <message> to stderr and return failure.
	#
	cmd="$1"
	msg="$2"
	if eval "$cmd"; then
		return 0
	fi
	if test -n "$msg"; then
		echo "$msg" >&2
	fi
	return 1
}

assert_equal() {
	# Usage: assert_equal <actual> <expected> [<message>]
	#
	# If <actual> is equal to <expected>, return success. Otherwise,
	# print <message> to stderr and return failure.
	#
	actual="$1"
	expected="$2"
	msg="$3"
	if test -z "$msg"; then
		msg=$(printf "expected: '%s'\nactual: '%s'\n" \
			"$expected" "$actual")
	fi
	assert "test '$actual' = '$expected'" "$msg"
}

assert_regex_match() {
	# Usage: assert_regex_match <output> <regex> [<message>]
	#
	# If <output> matches the POSIX basic regular expression (BRE)
	# <regex>, return success. Otherwise, print <message> to stderr
	# and return failure.
	#
	output="$1"
	regex="$2"
	msg="$3"
	if test -z "$msg"; then
		msg=$(printf 'regex: /%s/\ndid not match output:\n%s\n' \
			"$regex" "$output")
	fi
	assert "expr '$output' : '$regex'" "$msg"
}
```
