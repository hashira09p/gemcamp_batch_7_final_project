module Admin::InviteListsHelper
  def total_used_coins(total_deposit, coins, order_coin)
    total_coins = total_deposit + order_coin
    coins_used = coins - total_coins
    coins_used.abs
  end
end