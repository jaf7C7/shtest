# tests/b/test_foo.sh

. ./main.sh

test_foo_prints_bar ()
{
    actual=$(foo)
    expected='bar'
    assert "$actual" "$expected" "'foo' printed '$actual', expected '$expected'"
}
