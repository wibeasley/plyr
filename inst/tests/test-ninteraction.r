context("ninteraction")

simple_vectors <- list(
  letters,
  sample(letters),
  1:26
)

test_that("for vector, equivalent to rank", {
  for(case in simple_vectors) {
    rank <- rank(case, ties = "min")
    rank_df <- ninteraction(as.data.frame(case))

    expect_that(rank, is_equivalent_to(rank_df))
  }
})

test_that("duplicates numbered sequentially", {
  for(case in simple_vectors) {
    rank <- rep(rank(case, ties = "min"), each = 2)
    rank_df <- ninteraction(as.data.frame(rep(case, each = 2)))

    expect_that(rank, is_equivalent_to(rank_df))
  }
})

test_that("n calculated correctly", {
  n <- function(x) attr(ninteraction(x), "n")
  for(case in simple_vectors) {
    expect_that(n(as.data.frame(case)), equals(26))
  }

})

test_that("for vector + constant, equivalent to rank", {
  for(case in simple_vectors) {
    rank <- rank(case, ties = "min")

    after <- ninteraction(data.frame(case, x = 1))
    before <- ninteraction(data.frame(x = 1, case))

    expect_that(rank, is_equivalent_to(before))
    expect_that(rank, is_equivalent_to(after))
  }
})

test_that("grids are correctly ranked", {
  df <- expand.grid(1:10, 1:2)

  expect_that(ninteraction(df), is_equivalent_to(1:20))
  expect_that(ninteraction(df, drop = T), is_equivalent_to(1:20))
})

test_that("NAs are placed last", {
  expect_that(id_var(c(NA, 1)), is_equivalent_to(c(2, 1)))
})

