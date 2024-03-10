# tests/a/test_not_equal.sh

test_1_is_not_equal_to_0 ()
{
    ! assert_equal 1 0 '1 = 0'
}
