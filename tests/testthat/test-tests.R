test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

#testing pheno_select() returns a data.frame
test_that("phenotype dataframe outputted", {
  expect_s3_class(pheno_select(pheno_data, "hypertension"), class = "data.frame")
})

#testing join returns columns from both data.frames
test_that("join works", {
  expect_named(join_scores(pheno_data, score_data), c("hypertension", "age", "sex", "IID", "diabetes", "ms", "prs"))
})

#test simple logistic regression return glm model
test_that("simple logistic reg works", {
  expect_s3_class(simple_logistic_reg(test_data, "hypertension"), "glm")
})

#test proc returns correct image
test_that("roc object created", {
  expect_s3_class(proc_analysis(test_data, "hypertension", glm(hypertension~prs, family = "binomial", data = test_data)), "roc")
})

#test that positive_subjects() returns a numeric
test_that("integer returned", {
  expect_type(positive_subjects(test_data, "hypertension"), "integer")
})

#kfold cross validation needs work here

#test that score_distribtution() returns a histogram
test_that("histogram returned", {
  expect_s3_class(score_distribtuion(test_data, "prs"), "histogram")
})

#test that boxplot message outputs
test_that("message exists", {
  expect_message(compare_boxplots(test_data, "hypertension", "prs"))
})

#test that kfold outputs a message indicating cases and control values
test_that("message outputs", {
  expect_message(k_fold("hypertension", "prs", test_data))
})

#devtools::test()
