test_that("Create context", {
  ctx <- .create_context()
  expect_true(inherits(ctx, "dlr_context"))
})

test_that("Register operations", {
   ctx <- .create_context()
   dplyr.ptr <- register_ops(ctx, dplyr::mutate)
   cars.ptr  <- register_ops(ctx, cars)
   df.ptr    <- register_ops(ctx, data.frame)
   x <- cpu_tensor(5, dims = 1)
   all.ops <- get_all_ops_ptr(ctx)
   expect_true(is_in_pointer_list(x@pointer,  all.ops))
})
