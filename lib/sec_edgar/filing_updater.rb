module SecEdgar
  class FilingUpdater
    attr_reader :form

    def initialize(form)
      @form = form
    end

    def doc
      @doc ||= RawFiling.for_form(form).parsed
    end

    def update
      doc_json = doc.to_json
      return if doc_json == '{}'

      form.update({
        dollar_volume: doc.dollar_volume,
        document: { d: doc_json }
      })

      unless form.company
        form.company = Company.where(cik: doc.issuer_cik).first_or_initialize
        form.company.update_attributes(
          name: doc.issuer_name,
          ticker: doc.issuer_trading_symbol.upcase
        )
      end

      unless form.insider
        form.insider = Insider.where(cik: doc.owner_cik).first_or_initialize
        form.insider.update_attributes(
          name: doc.owner_name[0, 254]
        )
      end

      dt = Date.parse(form.date)
      form.day_traded_price = form.company.price_on(dt)
      form.day_traded_volume = form.company.volume_on(dt)
      form.plus_3_months_price = form.company.price_on(dt + 3.months)
      form.plus_6_months_price = form.company.price_on(dt + 6.months)
      form.plus_12_months_price = form.company.price_on(dt + 12.months)
      # need to find a more detailed data source
      # form.price_to_earnings = Company.price_to_earnings_on(form.date)
      # form.price_to_book = Company.price_to_book_on(form.date)

      form.doc = doc
      form.save!
      form
    end
  end
end
