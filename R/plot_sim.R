plot_sim <- function(dat){
  final_dat <- dat %>%
    mutate(
      X2_dist = factor(X2_dist),
      bias =  mean_prob_cap - marg_target,
           rr = exp(beta_2) %>% factor())
  browser()
  final_dat %>%
    split(.$X2_dist) %>%
    imap(.f = function(.dat, .group){
      # tmp <- TRUE
      browser()
      ggplot(.dat, aes(x = marg_target, y = bias, group = beta_2, color = rr)) +
        geom_point() +
        # geom_errorbar(aes(ymin = bias - MC_se, ymax = bias + MC_se)) +
        geom_line() +
        scale_y_continuous(limits = c(-0.1, 0.1)) +
        theme_minimal() +
        ggtitle(.group) +
        theme(plot.title = element_text(hjust = 0.5))
    })
}
