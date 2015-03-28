module SecEdgar
  DerivativeTransaction = Struct.new(
    :acquired_or_disposed_code,
    :conversion_or_exercise_price,
    :deemed_execution_date,
    :exercise_date,
    :expiration_date,
    :underlying_security_title,
    :underlying_security_shares,
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
  )
end
