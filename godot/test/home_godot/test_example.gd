extends GutTest
func before_each():
    gut.p("ran setup", 2)

func after_each():
    gut.p("ran teardown", 2)

func before_all():
    gut.p("ran run setup", 2)

func after_all():
    gut.p("ran run teardown", 2)

func test_something_else():
    assert_true(true, "didn't work")