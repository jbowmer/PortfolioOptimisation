library(PortfolioAnalytics)
library(ROI)
library(ROI.plugin.quadprog)
library(ROI.plugin.glpk)
library(foreach)


#A simple program to perform optimisation.

#Load a portfolio of funds.
data(edhec)

#A step to load the return data of our portfolio. stockPortfolio provides a number of helper functions.

returns = edhec[, 1:6]
fund_names = colnames(returns)
head(returns)

initial_portfolio = portfolio.spec(assets = fund_names)

#Initial portfolio without constraints is equal weighted.
print.default(initial_portfolio)


#Investment constraints. Full investment, long only. Other constrains which can be imposed: leverage, position limit, diversification etc.
initial_portfolio = add.constraint(portfolio = initial_portfolio, type = "full_investment")
initial_portfolio = add.constraint(portfolio= initial_portfolio, type="box", min=c(0.02, 0.05, 0.03, 0.02, 0.02, 0.02), max=c(0.55, 0.6, 0.65, 0.5, 0.5, 0.5))


#Portoflio objectives:

#Portfolio return objective
max_mean = add.objective(portfolio=initial_portfolio, type="return", name="mean")

print(max_mean)

#Now that the constraints have been provided, we optimise the portfolio. Note ROI here stands for R Optimisation infrastructure,
#not return on investment.

#maiximise mean return:
opt_max_mean = optimize.portfolio(R = returns, portfolio = max_mean, optimize_method ="ROI", trace = TRUE)

print(opt_max_mean)
