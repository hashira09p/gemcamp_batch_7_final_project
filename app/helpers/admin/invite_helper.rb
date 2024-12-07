module Admin::InviteHelper
  def total_used_coins(total_deposit, coins)

    coins_used = coins - total_deposit
    coins_used.abs
  end
end