# module SecEdgar
#   class FilingPersister
#     attr_reader :filing
#
#     def initialize(filing)
#       @filing = filing
#     end
#
#     def doc
#       @doc ||= RawFiling.for_filing(filing).parsed
#     end
#
#     def persist!
#       return form if form = Form4.find_by(link: filing.link)
#       doc_json = doc.to_json
#       return if doc_json == '{}'
#
#       form = Form4.new(
#         cik: filing.cik,
#         title: filing.title,
#         link: filing.link,
#         term: filing.term,
#         date: filing.date,
#         file_id: filing.file_id,
#         dollar_volume: doc.dollar_volume,
#         document: { d: doc_json }
#       )
#       form.company = Company.where(cik: doc.issuer_cik).first_or_initialize
#       form.company.update_attributes(
#         name: doc.issuer_name,
#         ticker: doc.issuer_trading_symbol.upcase
#       )
#
#       form.insider = Insider.where(cik: doc.owner_cik).first_or_initialize
#       form.insider.update_attributes(
#         name: doc.owner_name[0, 254]
#       )
#
#       form.day_traded_price = form.company.price_on(form.date)
#       form.day_traded_volume = form.company.volume_on(form.date)
#       form.plus_3_months_price = form.company.price_on(form.date + 3.months)
#       form.plus_6_months_price = form.company.price_on(form.date + 6.months)
#       form.plus_12_months_price = form.company.price_on(form.date + 12.months)
#       # need to find a more detailed data source
#       # form.price_to_earnings = Company.price_to_earnings_on(form.date)
#       # form.price_to_book = Company.price_to_book_on(form.date)
#
#       form.doc = doc
#       form.save!
#       form
#     end
#   end
# end
