# shtest

A simple test runner written in POSIX shell.


### Quickstart

First copy the `shtest` executable into the root of your project, or
into a directory in your `$PATH`, so the script is available to be run
with either `./shtest` or `shtest`.

Given a project like this:

```
$ tree
.
├── foo.sh
└── test_foo.sh

1 directory, 2 files
```

Write a quick test:

```
# test_foo.sh
. ./foo.sh

test_foo_prints_bar() {
	actual=$(foo)
	expected='bar'
	msg="'foo' printed '$actual', expected '$expected'"
	assert_equal "$actual" "$expected" "$msg"
}
```

Run the test to see it fail:

```
$ shtest test_foo.sh
test_foo_prints_bar...FAILED:
sh: 4: foo: not found
'foo' printed '', expected 'bar'

Ran 1 test(s):
Failed: 1


```

Write a function to satisfy the test:

```
# foo.sh

foo() {
	echo 'foo'
}
```

Run the tests:

```
$ shtest test_foo.sh
test_foo_prints_bar...FAILED:
'foo' printed 'foo', expected 'bar'

Ran 1 test(s):
Failed: 1

```

Woops! Fix the error:

```
$ nano test_foo.sh
```

Run the test again:

```
$ shtest test_foo.sh
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
