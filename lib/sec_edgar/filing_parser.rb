module SecEdgar
  class FilingParser
    attr_reader :xsd_uri

    def initialize(filing)
      @xsd_uri = 'lib/sec4/ownership4Document.xsd.xml'
      @filing = filing
      @content = filing.content
    end

    def content
      if @content.start_with?('-----BEGIN PRIVACY-ENHANCED MESSAGE-----')
        @content = strip_privacy_wrapper(@content)
      end
      @content
    end

    def doc
      @doc ||= SecEdgar::OwnershipDocument.new
    end

    def parse(&error_blk)
      if block_given? && !xml_valid?
        error_blk.call(xml_errors)
        puts "Error: returning NilObjectDocument #{ @filing.link }"
        return SecEdgar::NilOwnershipDocument.new
      end

      footnotes | transactions | derivative_transactions # eager init
      parse_doc(xml_doc)
      parse_issuer(xml_doc.xpath('//issuer'))
      parse_owner(xml_doc.xpath('//reportingOwner'))
      parse_non_derivative_table(xml_doc.xpath('//nonDerivativeTable'))
      parse_derivative_table(xml_doc.xpath('//derivativeTable'))
      parse_footnotes(xml_doc.xpath('//footnotes'))
      doc
    end

    def footnotes
      doc.footnotes ||= []
    end

    def transactions
      doc.transactions ||= []
    end

    def derivative_transactions
      doc.derivative_transactions ||= []
    end

    def xml_filing
      Nokogiri::XML(xml_doc.to_xml)
    end

    private

    def strip_privacy_wrapper(raw)
      lines = raw.split("\n")
      lines.shift until lines.first.start_with?('<SEC-DOCUMENT>')
      lines.pop if lines.last.start_with?('-----END PRIVACY-ENHANCED MESSAGE--')
      lines.join("\n")
    end

    def parse_transaction(el)
      transaction = SecEdgar::Transaction.new
      transaction.security_title = el.xpath('securityTitle').text.strip
      transaction.transaction_date = Date.parse(el.xpath('transactionDate').text)

      parse_transaction_amounts(transaction, el.xpath('transactionAmounts'))
      parse_transaction_ownership_nature(transaction, el.xpath('ownershipNature'))
      parse_transaction_coding(transaction, el.xpath('transactionCoding'))

      # post transaction amounts
      transaction.shares_after = el
        .xpath('postTransactionAmounts/sharesOwnedFollowingTransaction/value')
        .text
        .to_f
      transactions << transaction
    end

    def parse_footnote(el)
      footnote = SecEdgar::Footnote.new
      footnote.content = el.text.strip
      footnote.id = el.attribute("id").value
      footnotes << footnote
    end

    def parse_derivative_transaction(el)
      transaction = SecEdgar::DerivativeTransaction.new

      transaction.security_title = el.xpath('securityTitle').text.strip
      transaction.transaction_date = Date.parse(el.xpath('transactionDate').text)
      transaction.conversion_or_exercise_price = el.xpath('conversionOrExercisePrice').text.to_f

      unless (expiration_date = el.xpath('expirationDate/value').text).blank?
        transaction.expiration_date = Date.parse(expiration_date)
      end

      unless (exercise_date = el.xpath('exerciseDate/value').text).blank?
        transaction.exercise_date = Date.parse(exercise_date)
      end

      parse_transaction_amounts(transaction, el.xpath('transactionAmounts'))
      parse_transaction_ownership_nature(transaction, el.xpath('ownershipNature'))
      parse_transaction_coding(transaction, el.xpath('transactionCoding'))
      parse_transaction_underlying(transaction, el.xpath('underlyingSecurity'))

      # post transaction amounts
      transaction.shares_after = el
        .xpath('postTransactionAmounts/sharesOwnedFollowingTransaction/value')
        .text
        .to_f
      derivative_transactions << transaction
    end

    def parse_transaction_underlying(transaction, el)
      transaction.underlying_security_title = el.xpath('underlyingSecurityTitle/value').text
      transaction.underlying_security_shares =
        el.xpath('underlyingSecurityShares/value').text.to_f
    end

    def parse_non_derivative_table(el)
      el.xpath('//nonDerivativeTransaction').each do |transaction_el|
        parse_transaction(transaction_el)
      end
    end

    def parse_derivative_table(el)
      el.xpath('//derivativeTransaction').each do |transaction_el|
        parse_derivative_transaction(transaction_el)
      end
    end

    def parse_footnotes(el)
      el.xpath('//footnote').each do |note_el|
        parse_footnote(note_el)
      end
    end

    def parse_transaction_amounts(transaction, el)
      transaction.acquired_or_disposed_code =
        el.xpath('transactionAcquiredDisposedCode/value').text
      transaction.shares =
        el.xpath('transactionShares/value').text.to_f
      transaction.price_per_share =
        el.xpath('transactionPricePerShare/value').text.to_f
    end

    def parse_transaction_coding(transaction, el)
      transaction.code = el.xpath('transactionCode').text
      transaction.form_type = el.xpath('transactionFormType').text
      transaction.equity_swap_involved = el.xpath('equitySwapInvolved').text == '1'
    end

    def parse_transaction_ownership_nature(transaction, el)
      transaction.nature_of_ownership = el.xpath('natureOfOwnership/value').text
      transaction.direct_or_indirect_code = el.xpath('directOrIndirectOwnership/value').text
    end

    def parse_doc(el)
      doc.schema_version = el.xpath('//schemaVersion').text
      doc.document_type = el.xpath('//documentType').text
      doc.not_subject_to_section_16 =
        (el.xpath('//notSubjectToSection16').text == '1' ||
         el.xpath('//notSubjectToSection16').text == 'true')
      doc.period_of_report = Date.parse(el.xpath('//periodOfReport').text)
      # p doc.period_of_report
    rescue ArgumentError => e
      puts "parse_doc error: #{ el.inspect }"
      puts e
      raise e
    end

    def parse_issuer(el)
      doc.issuer_cik = el.xpath('//issuerCik').text
      doc.issuer_name = el.xpath('//issuerName').text
      doc.issuer_trading_symbol = el.xpath('//issuerTradingSymbol').text
    end

    def parse_owner(el)
      doc.owner_cik = el.xpath('//rptOwnerCik').text
      doc.owner_name = el.xpath('//rptOwnerName').text
      doc.is_director = el.xpath('//isDirector').text == '1'
      doc.is_ten_percent_owner = el.xpath('//isTenPercentOwner').text == '1'
      doc.is_other = el.xpath('//isOther').text == '1'
      doc.is_officer =
        (el.xpath('//isOfficer').text == '1' ||
         el.xpath('//isOfficer').text.downcase == 'true')
      doc.officer_title = el.xpath('//officerTitle').text

      address = SecEdgar::Address.new
      address.street1 = el.xpath('//rptOwnerStreet1').text
      address.street2 = el.xpath('//rptOwnerStreet2').text
      address.city = el.xpath('//rptOwnerCity').text
      address.state = el.xpath('//rptOwnerState').text
      address.zip = el.xpath('//rptOwnerZipCode').text
      address.state_description = el.xpath('//rptOwnerStateDescription').text
      doc.owner_address = address
    end

    def xml_doc
      Nokogiri::XML(content).xpath('//ownershipDocument')
    end

    def xml_schema
      @schema ||= Nokogiri::XML::Schema(IO.read(xsd_uri))
    end

    def xml_valid?
      xml_errors.empty? && !content.blank?
    end

    def xml_errors
      @errors ||= xml_schema.validate(xml_filing)
    end
  end
end
