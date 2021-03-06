source("test/main_pkgs.R", encoding = "utf-8")

# file <- "data-raw/"
# file <- "data-raw/table1_rawData.xlsx"
df   <- read_xlsx("data-raw/2019年11月GDM再发最终分析数据.xlsx") %>% as.data.table()

d <- df[, .(days2 = pweek2*7+pday2, days1 = pweek1*7+pday1, mode2, weight1_1, weight2_1, mode1)]
varnames <- c("days", "weight", "model") %>% set_names(., .)

## 2. previous version ------------------------------------------------------------
# list(second = d[, lapply(.SD, label_sd), .(mode2), .SDcols = c("days2", "weight1_1")],
#     first = d[, lapply(.SD, label_sd), .(mode1), .SDcols = c("days1", "weight2_1")])
df %<>% mutate(`wght_db2` = wght_d2 - wght_b2,
              `wght_db1` = wght_d1 - wght_b1)
df %<>% mutate(`pweek2` = pweek2 + pday2/7,
               `pweek1` = pweek1 + pday1/7)
varnames <- c("OGTT2_0_d", "OGTT2_1_d", "OGTT2_2_d", "CHOL2_d", "TG2_d", "HDL2_d", "LDL2_d", "pweek2", "weight2_1", "wght_b2","wght_d2", "wght_db2", "age2",
              "OGTT1_0_d", "OGTT1_1_d", "OGTT1_2_d", "CHOL1_d", "TG1_d", "HDL1_d", "LDL1_d", "pweek1", "weight1_1", "wght_b1", "wght_d1", "wght_db1", "age1")

n = length(varnames)/2
varnames_2 = varnames[1:n]
varnames_1 = varnames[-(1:n)]
# varnames_new = grep("_d")
varnames_new <- c("OGTT0_d", "OGTT1_d", "OGTT2_d", "CHOL_d", "TG_d", "HDL_d", "LDL_d",
                  "pweek", "weight", "wght_b","wght_d", "wght_db", "age") %>% set_names(., .)
d    <- df[, lapply(.SD, label_sd), .SDcols = varnames]
# nums <- df[, lapply(.SD, length_valid), .SDcols = varnames]

# write_list2xlsx(list(d = d), "mean_sd.xlsx")
df2 <- list(first = df[, ..varnames_1], second = df[, ..varnames_2]) %>%
    map(~set_names(., varnames_new)) %>%
    melt_list("order")
df2$OGTT0_d %<>% as.numeric()
df2$age %<>% as.numeric()

d1 = df2[order == "first", -1]
d2 = df2[order == "second", -1]
t_test2.data.frame(d1, d2, "table1_result2.xlsx")

# res = foreach(varname = varnames_new, i = icount()) %do% {
#     check_diff(df2, varname)
# }
# info <- do.call(rbind, res) %>% cbind(variable = varnames_new, .)
# write_list2xlsx(list(info = info), "second-first.xlsx")

c("first", "second", "group", "name", "birth", "age2", "delvdate2", "famhis2",
  "insulin2", "hypoins2", "gender2_1", "weight2_1", "brth2_1", "out2_1", "ptimes2",
  "dtimes2", "pweek2", "pday2", "mode2", "wght_b2", "wght_d2", "height2", "diagn2",
  "hist2", "HBA2_d", "OGTT2_0_d", "OGTT2_1_d", "OGTT2_2_d", "CHOL2_d", "TG2_d",
  "HDL2_d", "LDL2_d", "TSH", "FT3", "FT4", "GLU2_d", "HBA2_a",
  "OGTT2_0_a", "OGTT2_1_a", "OGTT2_2_a", "CHOL2_a", "TG2_a", "HDL2_a", "LDL2_a",
  "insu2_0_a", "uglu2_1_a", "uglu2_2_a", "age1", "delvdate1", "gender1_1", "weight1_1", "brth1_1", "out1_1", "insulin1", "hypoins1", "ptimes1", "dtimes1", "pweek1", "pday1", "mode1", "wght_b1", "wght_d1", "height1", "HBA1_d", "OGTT1_0_d", "OGTT1_1_d", "OGTT1_2_d", "OGTT1_3_d", "CHOL1_d", "TG1_d", "HDL1_d", "LDL1_d", "HBA1_a", "OGTT1_0_a", "OGTT1_1_a", "OGTT1_2_a", "CHOL1_a", "TG1_a", "HDL1_a", "LDL1_a", "insu1_0_a", "uglu1_1_a", "uglu1_2_a", "wght_db2", "wght_db1")



