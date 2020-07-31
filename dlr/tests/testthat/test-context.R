test_that("Create context", {
  ctx <- .create_context()
  expect_true(inherits(ctx, "dlr_context"))
})

test_that("Create Ops and Compare", {
   ctx <- .create_context()
  # .create_ops(ctx, 13, dplyr::mutate)
  # .create_ops(ctx, 20, cars)
  # .create_ops(ctx, 45, data.frame)
  # expect_equal(.get_r_ops(ctx, 45), data.frame)
})
