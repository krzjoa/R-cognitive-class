test_that("Create context", {
  ctx <- .create_context()
  expect_true(inherits(ctx, "dlr_context"))
})

test_that("Register operations", {
   ctx <- .create_context()
   dplyr.ptr <- register_ops(ctx, dplyr::mutate)
   cars.ptr  <- register_ops(ctx, cars)
   df.ptr    <- register_ops(ctx, data.frame)
   nodes <- 
})
