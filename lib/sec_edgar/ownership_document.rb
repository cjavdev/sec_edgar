module SecEdgar
  TRANSACTION_CODES = {
    'P' => 'Open market or private purchase of non-derivative or derivative security',
    'S' => 'Open market or private sale of non-derivative or derivative security6',
    'V' => 'Transaction voluntarily reported earlier than required',
    'A' => 'Grant, award or other acquisition pursuant to Rule 16b-3(d)',
    'D' => 'Disposition to the issuer of issuer equity securities pursuant to Rule 16b-3(e)',
    'F' => 'Payment of exercise price or tax liability by delivering or withholding securities incident to the receipt, exercise',
    'I' => 'Discretionary transaction in accordance with Rule 16b-3(f) resulting in acquisition or disposition of issuer',
    'M' => 'Exercise or conversion of derivative security exempted pursuant to Rule 16b-3',
    'C' => 'Conversion of derivative security',
    'E' => 'Expiration of short derivative position',
    'H' => 'Expiration (or cancellation) of long derivative position with value received',
    'O' => 'Exercise of out-of-the-money derivative security',
    'X' => 'Exercise of in-the-money or at-the-money derivative security',
    'G' => 'Bona fide gift',
    'L' => 'Small acquisition under Rule 16a-6',
    'W' => 'Acquisition or disposition by will or the laws of descent and distribution',
    'Z' => 'Deposit into or withdrawal from voting trust',
    'J' => 'Other acquisition or disposition (describe transaction)',
    'K' => 'Transaction in equity swap or instrument with similar characteristics',
    'U' => 'Disposition pursuant to a tender of shares in a change of control transaction'
  }

  OwnershipDocument = Struct.new(
    :schema_version,
    :document_type,
    :period_of_report,
    :not_subject_to_section_16,
    :issuer_name,
    :issuer_cik,
    :issuer_trading_symbol,
    :owner_cik,
    :owner_name,
    :owner_address,
    :is_director,
    :is_officer,
    :is_ten_percent_owner,
    :is_other,
    :officer_title,
    :transactions,
    :derivative_transactions,
    :footnotes
  ) do

    def sum_shares
      @sum ||= begin
        sum = 0
        all_trans.each do |t|
          if t.acquired_or_disposed_code == 'A'
            sum += t.shares
          else
            sum -= t.shares
          end
        end
        sum
      end
    end

    def dollar_volume
      @dollar_volume ||= begin
        sum = 0
        all_trans.each do |t|
          if t.acquired_or_disposed_code == 'A'
            sum += t.shares * t.price_per_share
          else
            sum -= t.shares * t.price_per_share
          end
        end
        sum
      end
    end

    def total_shares
      @total ||= all_trans.map(&:shares).inject(:+)
    end

    def all_trans
      trans + derivative_trans
    end

    def trans
      transactions || []
    end

    def derivative_trans
      derivative_transactions || []
    end

    SecEdgar::TRANSACTION_CODES.keys.each do |code|
      define_method("per_code_#{ code.downcase }".to_sym) do
        return 0 if total_shares == 0
        all_trans.select do |t|
          t.code.upcase == code
        end.tap do |t|
          return 0 if t.empty?
        end.map do |t|
          t.shares
        end.inject(:+) * 100.0 / total_shares
      end
    end

    def sum_shares_after
      return all_trans.map(&:shares_after).max if sum_shares > 0
      trans.map(&:shares_after).min || 0
    end

    def as_json(*)
      tran_codes = {}

      SecEdgar::TRANSACTION_CODES.keys.each do |code|
        name = "per_code_#{ code.downcase }".to_sym
        tran_codes[name] = send(name)
      end

      super
        .merge(sum_shares: sum_shares, sum_shares_after: sum_shares_after)
        .merge(tran_codes)
    end
  end
end
