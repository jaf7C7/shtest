# tests/b/test_foo.sh

. ./main.sh

test_foo_prints_bar ()
{
    actual=$(foo)
    expected='bar'
    msg="'foo' printed '$actual', expected '$expected'"
    assert_equal "$actual" "$expected" "$msg"
}
