module SecEdgar
  Transaction = Struct.new(
    :acquired_or_disposed_code,
    :nature_of_ownership,
    :code,
    :shares,
    :security_title,
    :direct_or_indirect_code,
    :form_type,
    :equity_swap_involved,
    :transaction_date,
    :shares_after,
    :price_per_share
  ) do
    def holdings_change
      return 0 if shares_after == 0
      shares.fdiv(shares_after)
    end
  end
end
