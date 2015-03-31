require 'spec_helper'

describe SecEdgar::FilingParser do
  let(:filing) { double('filing') }
  let(:filing1txt) do
    File.read(File.expand_path(File.dirname(__FILE__) + '/filing1.txt'))
  end

  let(:filing1xml) do
    Nokogiri::XML(
      File.read(
        File.expand_path(File.dirname(__FILE__) + '/filing1.xml')
      )
    ).xpath('//ownershipDocument').to_xml
  end

  it '#initialize takes the filing and exposes its content' do
    allow(filing).to receive(:content).and_return('Filing Content')
    parser = SecEdgar::FilingParser.new(filing)
    expect(parser.content).to eq('Filing Content')
  end

  it '#xml_filing returns just the xml portion of the filing content' do
    allow(filing).to receive(:content).and_return(filing1txt)
    parser = SecEdgar::FilingParser.new(filing)
    expect(parser.content).to eq(filing1txt)
    expect(parser.xml_filing.to_xml).to eq(Nokogiri::XML(filing1xml).to_xml)
  end

  describe '#parse' do
    let(:doc1) do
      allow(filing).to receive(:content).and_return(filing1txt)
      SecEdgar::FilingParser.new(filing).parse
    end

    (2..19).to_a.each do |x|
      let("filing#{ x }".to_sym) { double('filing') }

      let("filing#{ x }txt".to_sym) do
        File.read(
          File.expand_path(File.dirname(__FILE__) + "/filing#{ x }.txt")
        )
      end

      let("doc#{ x }".to_sym) do
        allow(send("filing#{ x }"))
          .to receive(:content).and_return(send("filing#{ x }txt"))
        SecEdgar::FilingParser.new(send("filing#{ x }")).parse
      end
    end

    it 'parses the footnotes' do
      expect(doc1.footnotes.count).to eq(2)
      expect(doc1.footnotes.first.content).to eq("Restricted Stock Units acquired pursuant to and under the conditions of the Legg Mason, Inc. Non-Employee Director Equity Plan, as amended.  See appendix A to the definitive proxy statement for Legg Mason, Inc.'s 2013 Annual Meeting of Stockholders.")
      expect(doc2.footnotes.count).to eq(4)
      expect(doc3.footnotes.count).to eq(0)
      expect(doc4.footnotes.count).to eq(1)
      expect(doc5.footnotes.count).to eq(2)
      expect(doc6.footnotes.count).to eq(1)
      expect(doc19.footnotes.count).to eq(4)
    end

    it 'parses the schemaVersion' do
      expect(doc1.schema_version).to eq('X0306')
      expect(doc2.schema_version).to eq('X0306')
      expect(doc3.schema_version).to eq('X0306')
      expect(doc4.schema_version).to eq('X0306')
      expect(doc5.schema_version).to eq('X0306')
      expect(doc6.schema_version).to eq('X0306')
      expect(doc7.schema_version).to eq('X0306')
      expect(doc8.schema_version).to eq('X0306')
      expect(doc9.schema_version).to eq('X0306')
      expect(doc10.schema_version).to eq('X0306')
      expect(doc11.schema_version).to eq('X0306')
      expect(doc12.schema_version).to eq('X0306')
      expect(doc15.schema_version).to eq('X0202')
      expect(doc16.schema_version).to eq('X0202')
      expect(doc17.schema_version).to eq('X0202')
      expect(doc18.schema_version).to eq('X0202')
      expect(doc19.schema_version).to eq('X0306')
    end

    it 'parses the periodOfReport' do
      expect(doc1.period_of_report).to eq(Date.parse('2014-04-21'))
      expect(doc2.period_of_report).to eq(Date.parse('2014-04-22'))
      expect(doc3.period_of_report).to eq(Date.parse('2014-04-24'))
      expect(doc4.period_of_report).to eq(Date.parse('2014-04-17'))
      expect(doc5.period_of_report).to eq(Date.parse('2014-04-23'))
      expect(doc6.period_of_report).to eq(Date.parse('2014-04-21'))
      expect(doc7.period_of_report).to eq(Date.parse('2014-04-23'))
      expect(doc8.period_of_report).to eq(Date.parse('2014-04-23'))
      expect(doc9.period_of_report).to eq(Date.parse('2014-04-23'))
      expect(doc10.period_of_report).to eq(Date.parse('2014-04-23'))
      expect(doc11.period_of_report).to eq(Date.parse('2014-04-24'))
      expect(doc12.period_of_report).to eq(Date.parse('2014-05-05'))
      expect(doc13.period_of_report).to eq(Date.parse('2014-05-12'))
      expect(doc14.period_of_report).to eq(Date.parse('2013-01-01'))
      expect(doc15.period_of_report).to eq(Date.parse('2006-10-18'))
      expect(doc16.period_of_report).to eq(Date.parse('2006-10-15'))
      expect(doc19.period_of_report).to eq(Date.parse('2015-03-27'))
    end

    it 'parses the documentType' do
      expect(doc1.document_type).to eq('4')
      expect(doc2.document_type).to eq('4')
      expect(doc3.document_type).to eq('4')
      expect(doc4.document_type).to eq('4')
      expect(doc5.document_type).to eq('4')
      expect(doc6.document_type).to eq('4')
      expect(doc7.document_type).to eq('4')
      expect(doc8.document_type).to eq('4')
      expect(doc9.document_type).to eq('4')
      expect(doc10.document_type).to eq('4')
      expect(doc11.document_type).to eq('4')
      expect(doc12.document_type).to eq('4')
      expect(doc15.document_type).to eq('4')
      expect(doc16.document_type).to eq('4')
      expect(doc19.document_type).to eq('4')
    end

    it 'parses the notSubjectToSection16' do
      expect(doc1.not_subject_to_section_16).to eq(false)
      expect(doc2.not_subject_to_section_16).to eq(false)
      expect(doc3.not_subject_to_section_16).to eq(false)
      expect(doc4.not_subject_to_section_16).to eq(false)
      expect(doc5.not_subject_to_section_16).to eq(false)
      expect(doc6.not_subject_to_section_16).to eq(false)
      expect(doc7.not_subject_to_section_16).to eq(false)
      expect(doc8.not_subject_to_section_16).to eq(false)
      expect(doc9.not_subject_to_section_16).to eq(false)
      expect(doc10.not_subject_to_section_16).to eq(false)
      expect(doc12.not_subject_to_section_16).to eq(false)
      expect(doc15.not_subject_to_section_16).to eq(false)
      expect(doc16.not_subject_to_section_16).to eq(false)
      expect(doc19.not_subject_to_section_16).to eq(false)
    end

    describe 'issuer' do
      it 'parses the issuerCik' do
        expect(doc1.issuer_cik).to eq('0000704051')
        expect(doc2.issuer_cik).to eq('0000047217')
        expect(doc3.issuer_cik).to eq('0000706129')
        expect(doc4.issuer_cik).to eq('0001490165')
        expect(doc5.issuer_cik).to eq('0000201461')
        expect(doc6.issuer_cik).to eq('0000931799')
        expect(doc7.issuer_cik).to eq('0000072207')
        expect(doc8.issuer_cik).to eq('0000088790')
        expect(doc9.issuer_cik).to eq('0000201461')
        expect(doc10.issuer_cik).to eq('0001399352')
        expect(doc11.issuer_cik).to eq('0001528985')
        expect(doc12.issuer_cik).to eq('0001069258')
        expect(doc14.issuer_cik).to eq('0001326583')
        expect(doc15.issuer_cik).to eq('0001130258')
        expect(doc16.issuer_cik).to eq('0001024795')
        expect(doc19.issuer_cik).to eq('0001569391')
      end

      it 'parses the issuerName' do
        expect(doc1.issuer_name).to eq('LEGG MASON, INC.')
        expect(doc2.issuer_name).to eq('HEWLETT PACKARD CO')
        expect(doc3.issuer_name).to eq('HORIZON BANCORP /IN/')
        expect(doc4.issuer_name).to eq('ERICKSON INC.')
        expect(doc5.issuer_name).to eq('CITY NATIONAL CORP')
        expect(doc6.issuer_name).to eq('GlyEco, Inc.')
        expect(doc7.issuer_name).to eq('NOBLE ENERGY INC')
        expect(doc8.issuer_name).to eq('INTRICON CORP')
        expect(doc9.issuer_name).to eq('CITY NATIONAL CORP')
        expect(doc10.issuer_name).to eq('HPEV, INC.')
        expect(doc11.issuer_name)
          .to eq('Inland Real Estate Income Trust, Inc.')
        expect(doc12.issuer_name)
          .to eq('KRATOS DEFENSE  SECURITY SOLUTIONS, INC.')
        expect(doc15.issuer_name).to eq('ACME PACKET INC')
        expect(doc16.issuer_name).to eq('SUN HYDRAULICS CORP')
        expect(doc19.issuer_name).to eq('KCG Holdings, Inc.')
      end

      it 'parses the issuerTradingSymbol' do
        expect(doc1.issuer_trading_symbol).to eq('LM')
        expect(doc2.issuer_trading_symbol).to eq('HPQ')
        expect(doc3.issuer_trading_symbol).to eq('HBNC')
        expect(doc4.issuer_trading_symbol).to eq('EAC')
        expect(doc5.issuer_trading_symbol).to eq('CYN')
        expect(doc6.issuer_trading_symbol).to eq('GLYE')
        expect(doc7.issuer_trading_symbol).to eq('NBL')
        expect(doc8.issuer_trading_symbol).to eq('IIN')
        expect(doc9.issuer_trading_symbol).to eq('CYN')
        expect(doc10.issuer_trading_symbol).to eq('WARM')
        expect(doc11.issuer_trading_symbol).to eq('n/a')
        expect(doc12.issuer_trading_symbol).to eq('KTOS')
        expect(doc14.issuer_trading_symbol).to eq('WBMD')
        expect(doc15.issuer_trading_symbol).to eq('APKT')
        expect(doc16.issuer_trading_symbol).to eq('SNHY')
        expect(doc19.issuer_trading_symbol).to eq('KCG')
      end
    end

    describe 'owner' do
      it 'parses the rptOwnerCik' do
        expect(doc1.owner_cik).to eq('0001206671')
        expect(doc2.owner_cik).to eq('0001160077')
        expect(doc3.owner_cik).to eq('0001137693')
        expect(doc4.owner_cik).to eq('0001546251')
        expect(doc5.owner_cik).to eq('0001012741')
        expect(doc6.owner_cik).to eq('0001537179')
        expect(doc7.owner_cik).to eq('0001575410')
        expect(doc8.owner_cik).to eq('0001217067')
        expect(doc9.owner_cik).to eq('0001390904')
        expect(doc10.owner_cik).to eq('0001565017')
        expect(doc11.owner_cik).to eq('0001311884')
        expect(doc12.owner_cik).to eq('0001094718')
        expect(doc14.owner_cik).to eq('0001443559')
        expect(doc15.owner_cik).to eq('0001376835')
        expect(doc16.owner_cik).to eq('0001225259')
        expect(doc19.owner_cik).to eq('0001580516')
      end

      it 'parses the rptOwnerName' do
        expect(doc1.owner_name).to eq('SCHMOKE KURT L')
        expect(doc2.owner_name).to eq('Andreessen Marc L')
        expect(doc3.owner_name).to eq('SWINEHART ROBERT E')
        expect(doc4.owner_name).to eq('Rizzuti Edward')
        expect(doc5.owner_name).to eq('THOMAS PETER M')
        expect(doc6.owner_name).to eq('AMATO RALPH')
        expect(doc7.owner_name).to eq('Elliott J. Keith')
        expect(doc8.owner_name).to eq('MCKENNA MICHAEL J')
        expect(doc9.owner_name).to eq('Rosenblum Bruce')
        expect(doc10.owner_name).to eq('Spirit Bear Ltd')
        expect(doc11.owner_name).to eq('McGuinness JoAnn M')
        expect(doc12.owner_name).to eq('Lund Deanna H')
        expect(doc14.owner_name).to eq('Coleman Thomas Jason')
        expect(doc15.owner_name).to eq('DOBBINS EPHRAIM')
        expect(doc16.owner_name).to eq('ROBSON PETER G')
        expect(doc19.owner_name).to eq('Daniel V. Tierney 2011 Trust')
      end

      describe 'address' do
        it 'parses the rptOwnerStreet1' do
          expect(doc1.owner_address.street1).to eq('LEGG MASON, INC')
          expect(doc2.owner_address.street1)
            .to eq('C/O HEWLETT-PACKARD COMPANY')
          expect(doc3.owner_address.street1).to eq('102 HACKNEY LANE')
          expect(doc4.owner_address.street1).to eq('C/O ERICKSON INCORPORATED')
          expect(doc5.owner_address.street1).to eq('THOMAS  MACK CO.')
          expect(doc6.owner_address.street1).to eq('2105 PLANTATION VILLAGE')
          expect(doc7.owner_address.street1).to eq('1001 NOBLE ENERGY WAY')
          expect(doc8.owner_address.street1).to eq('C/O INTRICON CORPORATION')
          expect(doc9.owner_address.street1)
            .to eq('C/O CITY NATIONAL CORPORATION')
          expect(doc10.owner_address.street1).to eq('1470 1ST AVE. #4A')
          expect(doc11.owner_address.street1).to eq('2907 BUTTERFIELD ROAD')
          expect(doc12.owner_address.street1).to eq('4820 EASTGATE MALL')
          expect(doc15.owner_address.street1).to eq('C/O ACME PACKET, INC.')
          expect(doc16.owner_address.street1).to eq('1500 W UNIVERSITY PARKWAY')
          expect(doc19.owner_address.street1).to eq('C/O WICKLOW CAPITAL, INC.')
        end

        it 'parses the rptOwnerStreet2' do
          expect(doc1.owner_address.street2).to eq('100 INTERNATIONAL DRIVE')
          expect(doc2.owner_address.street2).to eq('3000 HANOVER STREET')
          expect(doc3.owner_address.street2).to eq('')
          expect(doc4.owner_address.street2)
            .to eq('5550 SW MACADAM AVENUE, SUITE 200')
          expect(doc5.owner_address.street2)
            .to eq('2300 WEST SAHARA AVENUE, SUITE 503')
          expect(doc6.owner_address.street2).to eq('')
          expect(doc7.owner_address.street2).to eq('')
          expect(doc8.owner_address.street2).to eq('1260 RED FOX ROAD')
          expect(doc9.owner_address.street2).to eq('555 S. FLOWER STREET')
          expect(doc10.owner_address.street2).to eq('')
          expect(doc11.owner_address.street2).to eq('3RD FLOOR')
          expect(doc15.owner_address.street2).to eq('71 THIRD AVENUE')
          expect(doc19.owner_address.street2).to eq('53 W. JACKSON BLVD., SUITE 1204')
        end

        it 'parses the rptOwnerCity' do
          expect(doc1.owner_address.city).to eq('BALTIMORE')
          expect(doc2.owner_address.city).to eq('PALO ALTO')
          expect(doc3.owner_address.city).to eq('VALPARAISO')
          expect(doc4.owner_address.city).to eq('PORTLAND')
          expect(doc5.owner_address.city).to eq('LAS VEGAS')
          expect(doc6.owner_address.city).to eq('DORADO')
          expect(doc7.owner_address.city).to eq('HOUSTON')
          expect(doc8.owner_address.city).to eq('ARDEN HILLS')
          expect(doc9.owner_address.city).to eq('LOS ANGELES')
          expect(doc10.owner_address.city).to eq('NEW YORK')
          expect(doc11.owner_address.city).to eq('OAK BROOK')
          expect(doc15.owner_address.city).to eq('BURLINGTON')
          expect(doc16.owner_address.city).to eq('SARASOTA')
          expect(doc19.owner_address.city).to eq('CHICAGO')
        end

        it 'parses the rptOwnerState' do
          expect(doc1.owner_address.state).to eq('MD')
          expect(doc2.owner_address.state).to eq('CA')
          expect(doc3.owner_address.state).to eq('IN')
          expect(doc4.owner_address.state).to eq('OR')
          expect(doc5.owner_address.state).to eq('NV')
          expect(doc6.owner_address.state).to eq('PR')
          expect(doc7.owner_address.state).to eq('TX')
          expect(doc8.owner_address.state).to eq('MN')
          expect(doc9.owner_address.state).to eq('CA')
          expect(doc10.owner_address.state).to eq('NY')
          expect(doc11.owner_address.state).to eq('IL')
          expect(doc15.owner_address.state).to eq('MA')
          expect(doc16.owner_address.state).to eq('FL')
          expect(doc19.owner_address.state).to eq('IL')
        end

        it 'parses the rptOwnerZipCode' do
          expect(doc1.owner_address.zip).to eq('21202')
          expect(doc2.owner_address.zip).to eq('94304')
          expect(doc3.owner_address.zip).to eq('46385')
          expect(doc4.owner_address.zip).to eq('97239')
          expect(doc5.owner_address.zip).to eq('89102')
          expect(doc6.owner_address.zip).to eq('00646')
          expect(doc7.owner_address.zip).to eq('77070')
          expect(doc8.owner_address.zip).to eq('55112')
          expect(doc9.owner_address.zip).to eq('90071')
          expect(doc10.owner_address.zip).to eq('10075')
          expect(doc11.owner_address.zip).to eq('60523')
          expect(doc15.owner_address.zip).to eq('01803')
          expect(doc16.owner_address.zip).to eq('34243')
          expect(doc19.owner_address.zip).to eq('60604')
        end

        it 'parses the rptOwnerStateDescription' do
          expect(doc6.owner_address.state_description).to eq('PUERTO RICO')
        end
      end

      it 'parses the isDirector' do
        expect(doc1.is_director).to eq(true)
        expect(doc2.is_director).to eq(true)
        expect(doc3.is_director).to eq(true)
        expect(doc4.is_director).to eq(false)
        expect(doc5.is_director).to eq(true)
        expect(doc6.is_director).to eq(false)
        expect(doc7.is_director).to eq(false)
        expect(doc8.is_director).to eq(true)
        expect(doc9.is_director).to eq(true)
        expect(doc10.is_director).to eq(false)
        expect(doc11.is_director).to eq(true)
        expect(doc12.is_director).to eq(false)
        expect(doc15.is_director).to eq(false)
        expect(doc16.is_director).to eq(false)
        expect(doc19.is_director).to eq(false)
      end

      it 'parses the isOfficer' do
        expect(doc1.is_officer).to eq(false)
        expect(doc2.is_officer).to eq(false)
        expect(doc3.is_officer).to eq(false)
        expect(doc4.is_officer).to eq(true)
        expect(doc5.is_officer).to eq(false)
        expect(doc6.is_officer).to eq(false)
        expect(doc7.is_officer).to eq(true)
        expect(doc8.is_officer).to eq(false)
        expect(doc9.is_officer).to eq(false)
        expect(doc10.is_officer).to eq(false)
        expect(doc11.is_officer).to eq(true)
        expect(doc12.is_officer).to eq(true)
        expect(doc15.is_officer).to eq(true)
        expect(doc16.is_officer).to eq(true)
        expect(doc19.is_officer).to eq(false)
      end

      it 'parses the isTenPercentOwner' do
        expect(doc1.is_ten_percent_owner).to eq(false)
        expect(doc2.is_ten_percent_owner).to eq(false)
        expect(doc3.is_ten_percent_owner).to eq(false)
        expect(doc4.is_ten_percent_owner).to eq(false)
        expect(doc5.is_ten_percent_owner).to eq(false)
        expect(doc6.is_ten_percent_owner).to eq(true)
        expect(doc7.is_ten_percent_owner).to eq(false)
        expect(doc8.is_ten_percent_owner).to eq(false)
        expect(doc9.is_ten_percent_owner).to eq(false)
        expect(doc10.is_ten_percent_owner).to eq(true)
        expect(doc11.is_ten_percent_owner).to eq(false)
        expect(doc12.is_ten_percent_owner).to eq(false)
        expect(doc15.is_ten_percent_owner).to eq(false)
        expect(doc16.is_ten_percent_owner).to eq(false)
        expect(doc19.is_ten_percent_owner).to eq(true)
      end

      it 'parses the isOther' do
        expect(doc1.is_other).to eq(false)
        expect(doc2.is_other).to eq(false)
        expect(doc3.is_other).to eq(false)
        expect(doc4.is_other).to eq(false)
        expect(doc5.is_other).to eq(false)
        expect(doc6.is_other).to eq(false)
        expect(doc7.is_other).to eq(false)
        expect(doc8.is_other).to eq(false)
        expect(doc9.is_other).to eq(false)
        expect(doc10.is_other).to eq(false)
        expect(doc11.is_other).to eq(false)
        expect(doc12.is_other).to eq(false)
        expect(doc15.is_other).to eq(false)
        expect(doc16.is_other).to eq(false)
        expect(doc19.is_other).to eq(false)
      end

      it 'parses the officerTitle' do
        expect(doc4.officer_title).to eq('VP, Gen CounselCorp Secretary')
        expect(doc7.officer_title).to eq('Sr. VP Eastern Mediterranean')
        expect(doc11.officer_title).to eq('President and COO')
        expect(doc12.officer_title).to eq('EVP  CFO')
        expect(doc15.officer_title).to eq('Vice President Engineering')
        expect(doc16.officer_title).to eq('GENERAL MGR, SUN HYD LTD (UK)')
      end

      describe 'nonDerivativeTable' do
        it 'collects non derivative transactions' do
          expect(doc2.transactions.count).to eq(1)
          expect(doc3.transactions.count).to eq(1)
          expect(doc3.transactions.count).to eq(1)
          expect(doc4.transactions.count).to eq(2)
          expect(doc5.transactions.count).to eq(0)
          expect(doc6.transactions.count).to eq(1)
          expect(doc7.transactions.count).to eq(2)
          expect(doc8.transactions.count).to eq(0)
          expect(doc9.transactions.count).to eq(0)
          expect(doc10.transactions.count).to eq(3)
          expect(doc11.transactions.count).to eq(1)
          expect(doc12.transactions.count).to eq(1)
          expect(doc15.transactions.count).to eq(1)
          expect(doc16.transactions.count).to eq(2)
          expect(doc19.transactions.count).to eq(2)
        end

        describe 'nonDerivativeTransaction' do
          let(:doc2transaction1) { doc2.transactions.first }
          let(:doc3transaction1) { doc3.transactions.first }
          let(:doc4transaction1) { doc4.transactions.first }
          let(:doc4transaction2) { doc4.transactions.last }
          let(:doc6transaction1) { doc6.transactions.first }
          let(:doc7transaction1) { doc7.transactions.first }
          let(:doc7transaction2) { doc7.transactions.last }
          let(:doc10transaction1) { doc10.transactions[0] }
          let(:doc10transaction2) { doc10.transactions[1] }
          let(:doc10transaction3) { doc10.transactions[2] }
          let(:doc11transaction1) { doc11.transactions.first }
          let(:doc12transaction1) { doc12.transactions.first }
          let(:doc15transaction1) { doc15.transactions.first }
          let(:doc16transaction1) { doc16.transactions.first }
          let(:doc16transaction2) { doc16.transactions.last }
          let(:doc19transaction1) { doc19.transactions.first }
          let(:doc19transaction2) { doc19.transactions.last }

          it 'parses the securityTitle' do
            expect(doc2transaction1.security_title).to eq('Common Stock')
            expect(doc3transaction1.security_title).to eq('Common Stock')
            expect(doc4transaction1.security_title).to eq('Common Stock')
            expect(doc4transaction2.security_title).to eq('Common Stock')
            expect(doc6transaction1.security_title).to eq('Common Stock')
            expect(doc7transaction1.security_title)
              .to eq('Noble Energy, Inc. Common Stock')
            expect(doc7transaction2.security_title)
              .to eq('Noble Energy, Inc. Common Stock')
            expect(doc10transaction1.security_title)
              .to eq('HPEV, Inc. common stock')
            expect(doc10transaction2.security_title)
              .to eq('HPEV, Inc. common stock')
            expect(doc10transaction3.security_title)
              .to eq('HPEV, Inc. common stock')
            expect(doc11transaction1.security_title)
              .to eq('Inland Real Estate Income Trust, Inc.')
            expect(doc12transaction1.security_title).to eq('Common Stock')
            expect(doc15transaction1.security_title)
              .to eq('Common Stock, $0.001 par value')
            expect(doc16transaction1.security_title).to eq('Common Stock')
            expect(doc16transaction2.security_title).to eq('Common Stock')
            expect(doc19transaction1.security_title).to eq('Class A Common Stock, par value $0.01 per share')
            expect(doc19transaction2.security_title).to eq('Class A Common Stock, par value $0.01 per share')
          end

          it 'parses the transactionDate' do
            expect(doc2transaction1.transaction_date)
              .to eq(Date.parse('2014-04-22'))
            expect(doc3transaction1.transaction_date)
              .to eq(Date.parse('2014-04-24'))
            expect(doc4transaction1.transaction_date)
              .to eq(Date.parse('2014-04-17'))
            expect(doc4transaction2.transaction_date)
              .to eq(Date.parse('2014-04-17'))
            expect(doc6transaction1.transaction_date)
              .to eq(Date.parse('2014-04-21'))
            expect(doc7transaction1.transaction_date)
              .to eq(Date.parse('2014-04-23'))
            expect(doc7transaction2.transaction_date)
              .to eq(Date.parse('2014-04-23'))
            expect(doc10transaction1.transaction_date)
              .to eq(Date.parse('2014-04-23'))
            expect(doc10transaction2.transaction_date)
              .to eq(Date.parse('2014-04-23'))
            expect(doc10transaction3.transaction_date)
              .to eq(Date.parse('2014-04-23'))
            expect(doc11transaction1.transaction_date)
              .to eq(Date.parse('2014-04-24'))
            expect(doc12transaction1.transaction_date)
              .to eq(Date.parse('2014-05-05'))
            expect(doc15transaction1.transaction_date)
              .to eq(Date.parse('2006-10-18'))
            expect(doc16transaction1.transaction_date)
              .to eq(Date.parse('2006-10-15'))
            expect(doc16transaction2.transaction_date)
              .to eq(Date.parse('2006-10-15'))
            expect(doc19transaction1.transaction_date)
              .to eq(Date.parse('2015-03-27'))
            expect(doc19transaction2.transaction_date)
              .to eq(Date.parse('2015-03-30'))
          end

          it 'parses the transactionFormType' do
            expect(doc2transaction1.form_type).to eq('4')
            expect(doc3transaction1.form_type).to eq('4')
            expect(doc4transaction1.form_type).to eq('4')
            expect(doc4transaction2.form_type).to eq('4')
            expect(doc6transaction1.form_type).to eq('4')
            expect(doc7transaction1.form_type).to eq('4')
            expect(doc7transaction2.form_type).to eq('4')
            expect(doc10transaction1.form_type).to eq('4')
            expect(doc10transaction2.form_type).to eq('4')
            expect(doc10transaction3.form_type).to eq('4')
            expect(doc12transaction1.form_type).to eq('4')
            expect(doc15transaction1.form_type).to eq('4')
            expect(doc16transaction1.form_type).to eq('4')
            expect(doc16transaction2.form_type).to eq('4')
            expect(doc19transaction1.form_type).to eq('4')
            expect(doc19transaction2.form_type).to eq('4')
          end

          it 'parses the transactionCode' do
            expect(doc2transaction1.code).to eq('M')
            expect(doc3transaction1.code).to eq('P')
            expect(doc4transaction1.code).to eq('M')
            expect(doc4transaction2.code).to eq('F')
            expect(doc6transaction1.code).to eq('S')
            expect(doc7transaction1.code).to eq('M')
            expect(doc7transaction2.code).to eq('S')
            expect(doc10transaction1.code).to eq('S')
            expect(doc10transaction2.code).to eq('S')
            expect(doc10transaction3.code).to eq('S')
            expect(doc11transaction1.code).to eq('P')
            expect(doc12transaction1.code).to eq('P')
            expect(doc15transaction1.code).to eq('S')
            expect(doc16transaction1.code).to eq('M')
            expect(doc16transaction2.code).to eq('D')
            expect(doc19transaction1.code).to eq('S')
            expect(doc19transaction2.code).to eq('S')
          end

          it 'parses the equitySwapInvolved' do
            expect(doc2transaction1.equity_swap_involved).to eq(false)
            expect(doc3transaction1.equity_swap_involved).to eq(false)
            expect(doc4transaction1.equity_swap_involved).to eq(false)
            expect(doc4transaction2.equity_swap_involved).to eq(false)
            expect(doc7transaction1.equity_swap_involved).to eq(false)
            expect(doc7transaction2.equity_swap_involved).to eq(false)
            expect(doc10transaction1.equity_swap_involved).to eq(false)
            expect(doc10transaction2.equity_swap_involved).to eq(false)
            expect(doc10transaction3.equity_swap_involved).to eq(false)
            expect(doc15transaction1.equity_swap_involved).to eq(false)
            expect(doc16transaction1.equity_swap_involved).to eq(false)
            expect(doc16transaction2.equity_swap_involved).to eq(false)
            expect(doc19transaction1.equity_swap_involved).to eq(false)
            expect(doc19transaction2.equity_swap_involved).to eq(false)
          end

          it 'parses the transactionTimeliness'

          it 'parses the transactionShares' do
            expect(doc2transaction1.shares).to eq(14_273.9165)
            expect(doc3transaction1.shares).to eq(1_000)
            expect(doc4transaction1.shares).to eq(3_243)
            expect(doc4transaction2.shares).to eq(1_247)
            expect(doc6transaction1.shares).to eq(35_000)
            expect(doc7transaction1.shares).to eq(6_000)
            expect(doc7transaction2.shares).to eq(6_000)
            expect(doc10transaction1.shares).to eq(10_000)
            expect(doc10transaction2.shares).to eq(100)
            expect(doc10transaction3.shares).to eq(36_100)
            expect(doc11transaction1.shares).to eq(4_444.444)
            expect(doc12transaction1.shares).to eq(2_000)
            expect(doc15transaction1.shares).to eq(24_000)
            expect(doc16transaction1.shares).to eq(809.7166)
            expect(doc16transaction2.shares).to eq(809.7166)
            expect(doc19transaction1.shares).to eq(16883)
            expect(doc19transaction2.shares).to eq(29619)
          end

          it 'parses the transactionPricePerShare' do
            expect(doc2transaction1.price_per_share).to eq(0)
            expect(doc3transaction1.price_per_share).to eq(20.45)
            expect(doc4transaction1.price_per_share).to eq(0)
            expect(doc4transaction2.price_per_share).to eq(17.70)
            expect(doc6transaction1.price_per_share).to eq(1.0006)
            expect(doc7transaction1.price_per_share).to eq(45.2)
            expect(doc7transaction2.price_per_share).to eq(75.07)
            expect(doc10transaction1.price_per_share).to eq(1.87)
            expect(doc10transaction2.price_per_share).to eq(1.83)
            expect(doc10transaction3.price_per_share).to eq(1.80)
            expect(doc11transaction1.price_per_share).to eq(9)
            expect(doc12transaction1.price_per_share).to eq(7.26)
            expect(doc15transaction1.price_per_share).to eq(9.50)
            expect(doc16transaction1.price_per_share).to eq(21)
            expect(doc16transaction2.price_per_share).to eq(21)
            expect(doc19transaction1.price_per_share).to eq(12.41)
            expect(doc19transaction2.price_per_share).to eq(12.37)
          end

          it 'parses the transactionAcquiredDisposedCode' do
            expect(doc2transaction1.acquired_or_disposed_code).to eq('A')
            expect(doc3transaction1.acquired_or_disposed_code).to eq('A')
            expect(doc4transaction1.acquired_or_disposed_code).to eq('A')
            expect(doc4transaction2.acquired_or_disposed_code).to eq('D')
            expect(doc6transaction1.acquired_or_disposed_code).to eq('D')
            expect(doc7transaction1.acquired_or_disposed_code).to eq('A')
            expect(doc7transaction2.acquired_or_disposed_code).to eq('D')
            expect(doc10transaction1.acquired_or_disposed_code).to eq('D')
            expect(doc10transaction2.acquired_or_disposed_code).to eq('D')
            expect(doc10transaction3.acquired_or_disposed_code).to eq('D')
            expect(doc11transaction1.acquired_or_disposed_code).to eq('A')
            expect(doc12transaction1.acquired_or_disposed_code).to eq('A')
            expect(doc15transaction1.acquired_or_disposed_code).to eq('D')
            expect(doc16transaction1.acquired_or_disposed_code).to eq('A')
            expect(doc16transaction2.acquired_or_disposed_code).to eq('D')
            expect(doc19transaction1.acquired_or_disposed_code).to eq('D')
            expect(doc19transaction2.acquired_or_disposed_code).to eq('D')
          end

          it 'parses the sharesOwnedFollowingTransaction' do
            expect(doc2transaction1.shares_after).to eq(26_032.6435)
            expect(doc3transaction1.shares_after).to eq(32_120)
            expect(doc4transaction1.shares_after).to eq(8_347)
            expect(doc4transaction2.shares_after).to eq(7_100)
            expect(doc6transaction1.shares_after).to eq(7_554_089)
            expect(doc7transaction1.shares_after).to eq(55_960)
            expect(doc7transaction2.shares_after).to eq(49_960)
            expect(doc10transaction1.shares_after).to eq(490_000)
            expect(doc10transaction2.shares_after).to eq(489_900)
            expect(doc10transaction3.shares_after).to eq(453_800)
            expect(doc11transaction1.shares_after).to eq(4_444.444)
            expect(doc12transaction1.shares_after).to eq(56_525)
            expect(doc15transaction1.shares_after).to eq(265_582)
            expect(doc16transaction1.shares_after).to eq(809.7166)
            expect(doc16transaction2.shares_after).to eq(0)
            expect(doc19transaction1.shares_after).to eq(8726227)
            expect(doc19transaction2.shares_after).to eq(8696608)
          end

          it 'parses the directOrIndirectOwnership' do
            expect(doc2transaction1.direct_or_indirect_code).to eq('I')
            expect(doc3transaction1.direct_or_indirect_code).to eq('D')
            expect(doc4transaction1.direct_or_indirect_code).to eq('D')
            expect(doc4transaction2.direct_or_indirect_code).to eq('D')
            expect(doc6transaction1.direct_or_indirect_code).to eq('I')
            expect(doc7transaction1.direct_or_indirect_code).to eq('D')
            expect(doc7transaction2.direct_or_indirect_code).to eq('D')
            expect(doc10transaction1.direct_or_indirect_code).to eq('D')
            expect(doc10transaction2.direct_or_indirect_code).to eq('D')
            expect(doc10transaction3.direct_or_indirect_code).to eq('D')
            expect(doc11transaction1.direct_or_indirect_code).to eq('D')
            expect(doc12transaction1.direct_or_indirect_code).to eq('D')
            expect(doc15transaction1.direct_or_indirect_code).to eq('D')
            expect(doc16transaction1.direct_or_indirect_code).to eq('D')
            expect(doc16transaction2.direct_or_indirect_code).to eq('D')
            expect(doc19transaction1.direct_or_indirect_code).to eq('D')
            expect(doc19transaction2.direct_or_indirect_code).to eq('D')
          end

          it 'parses the natureOfOwnership' do
            expect(doc2transaction1.nature_of_ownership)
              .to eq('By Merrill Lynch')
            expect(doc3transaction1.nature_of_ownership).to eq('')
            expect(doc4transaction1.nature_of_ownership).to eq('')
            expect(doc4transaction2.nature_of_ownership).to eq('')
            expect(doc6transaction1.nature_of_ownership).to eq('By LLC')
          end
        end
      end

      describe 'derivativeTable' do
        it 'collects derivative transactions' do
          expect(doc2.derivative_transactions.count).to eq(1)
          expect(doc4.derivative_transactions.count).to eq(1)
          expect(doc5.derivative_transactions.count).to eq(1)
          expect(doc7.derivative_transactions.count).to eq(1)
          expect(doc8.derivative_transactions.count).to eq(1)
          expect(doc9.derivative_transactions.count).to eq(1)
          expect(doc10.derivative_transactions.count).to eq(0)
          expect(doc13.derivative_transactions.count).to eq(1)
          expect(doc14.derivative_transactions.count).to eq(1)
          expect(doc16.derivative_transactions.count).to eq(1)
        end

        describe 'derivativeTransaction' do
          let(:doc2transaction1) { doc2.derivative_transactions.first }
          let(:doc4transaction1) { doc4.derivative_transactions.first }
          let(:doc5transaction1) { doc5.derivative_transactions.first }
          let(:doc7transaction1) { doc7.derivative_transactions.first }
          let(:doc8transaction1) { doc8.derivative_transactions.first }
          let(:doc9transaction1) { doc9.derivative_transactions.first }
          let(:doc13transaction1) { doc13.derivative_transactions.first }
          let(:doc14transaction1) { doc14.derivative_transactions.first }
          let(:doc16transaction1) { doc16.derivative_transactions.first }

          it 'parses the securityTitle' do
            expect(doc2transaction1.security_title)
              .to eq('Restricted Stock Units')
            expect(doc4transaction1.security_title)
              .to eq('Restricted Stock Units')
            expect(doc5transaction1.security_title)
              .to eq('Stock Fund Units (DDCP)')
            # expect(doc6transaction1.security_title).to eq('Common Stock')
            expect(doc7transaction1.security_title)
              .to eq('Employee Stock Option Grant (right to buy)')
            expect(doc8transaction1.security_title)
              .to eq('Option to purchase common stock')
            expect(doc9transaction1.security_title)
              .to eq('Stock Fund Units (DDCP)')
            expect(doc14transaction1.security_title)
              .to eq('Stock Option (Right to Buy)')
            expect(doc16transaction1.security_title)
              .to eq('Phantom Shares')
          end

          it 'parses the conversionOrExercisePrice' do
            expect(doc7transaction1.conversion_or_exercise_price).to eq(45.2)
            expect(doc8transaction1.conversion_or_exercise_price).to eq(6.82)
            expect(doc14transaction1.conversion_or_exercise_price).to eq(14.34)
            expect(doc16transaction1.conversion_or_exercise_price).to eq(0)
          end

          it 'parses the transactionDate' do
            expect(doc2transaction1.transaction_date)
              .to eq(Date.parse('2014-04-22'))
            expect(doc4transaction1.transaction_date)
              .to eq(Date.parse('2014-04-17'))
            expect(doc5transaction1.transaction_date)
              .to eq(Date.parse('2014-04-23'))
            expect(doc7transaction1.transaction_date)
              .to eq(Date.parse('2014-04-23'))
            expect(doc8transaction1.transaction_date)
              .to eq(Date.parse('2014-04-23'))
            expect(doc9transaction1.transaction_date)
              .to eq(Date.parse('2014-04-23'))
            expect(doc13transaction1.transaction_date)
              .to eq(Date.parse('2014-05-12'))
            expect(doc14transaction1.transaction_date)
              .to eq(Date.parse('2013-01-01'))
            expect(doc16transaction1.transaction_date)
              .to eq(Date.parse('2006-10-15'))
          end

          it 'parses the transactionFormType' do
            expect(doc2transaction1.form_type).to eq('4')
            expect(doc4transaction1.form_type).to eq('4')
            expect(doc5transaction1.form_type).to eq('4')
            expect(doc7transaction1.form_type).to eq('4')
            expect(doc9transaction1.form_type).to eq('4')
            expect(doc14transaction1.form_type).to eq('4')
            expect(doc16transaction1.form_type).to eq('4')
          end

          it 'parses the transactionCode' do
            expect(doc2transaction1.code).to eq('M')
            expect(doc4transaction1.code).to eq('M')
            expect(doc5transaction1.code).to eq('A')
            expect(doc7transaction1.code).to eq('M')
            expect(doc8transaction1.code).to eq('A')
            expect(doc9transaction1.code).to eq('A')
            expect(doc14transaction1.code).to eq('A')
            expect(doc16transaction1.code).to eq('M')
          end

          it 'parses the equitySwapInvolved' do
            expect(doc2transaction1.equity_swap_involved).to eq(false)
            expect(doc4transaction1.equity_swap_involved).to eq(false)
            expect(doc7transaction1.equity_swap_involved).to eq(false)
            expect(doc8transaction1.equity_swap_involved).to eq(false)
            expect(doc9transaction1.equity_swap_involved).to eq(false)
            expect(doc14transaction1.equity_swap_involved).to eq(false)
          end

          describe 'transactionAmounts' do
            it 'parses the transactionShares' do
              expect(doc2transaction1.shares).to eq(14_225.8819)
              expect(doc4transaction1.shares).to eq(3_243)
              expect(doc5transaction1.shares).to eq(784)
              expect(doc7transaction1.shares).to eq(6_000)
              expect(doc8transaction1.shares).to eq(12_000)
              expect(doc9transaction1.shares).to eq(457)
              expect(doc14transaction1.shares).to eq(13_200)
              expect(doc16transaction1.shares).to eq(809.7166)
            end

            it 'parses the transactionPricePerShare' do
              expect(doc2transaction1.price_per_share).to eq(0)
              expect(doc4transaction1.price_per_share).to eq(0)
              expect(doc5transaction1.price_per_share).to eq(76.45)
              expect(doc7transaction1.price_per_share).to eq(0)
              expect(doc8transaction1.price_per_share).to eq(0)
              expect(doc9transaction1.price_per_share).to eq(76.45)
              expect(doc14transaction1.price_per_share).to eq(0)
              expect(doc16transaction1.price_per_share).to eq(0)
            end

            it 'parses the transactionAcquiredDisposedCode' do
              expect(doc2transaction1.acquired_or_disposed_code).to eq('D')
              expect(doc4transaction1.acquired_or_disposed_code).to eq('D')
              expect(doc5transaction1.acquired_or_disposed_code).to eq('A')
              expect(doc7transaction1.acquired_or_disposed_code).to eq('D')
              expect(doc8transaction1.acquired_or_disposed_code).to eq('A')
              expect(doc9transaction1.acquired_or_disposed_code).to eq('A')
              expect(doc14transaction1.acquired_or_disposed_code).to eq('A')
              expect(doc16transaction1.acquired_or_disposed_code).to eq('D')
            end
          end

          it 'parses the exerciseDate' do
            expect(doc7transaction1.exercise_date)
              .to eq(Date.parse('2012-02-01'))
            expect(doc13transaction1.exercise_date)
              .to eq(Date.parse('2015-05-12'))
          end

          it 'parses the expirationDate' do
            expect(doc4transaction1.expiration_date)
              .to eq(Date.parse('2015-04-17'))
            expect(doc7transaction1.expiration_date)
              .to eq(Date.parse('2021-02-01'))
            expect(doc8transaction1.expiration_date)
              .to eq(Date.parse('2024-04-23'))
            expect(doc13transaction1.expiration_date).to be_nil
            expect(doc14transaction1.expiration_date)
              .to eq(Date.parse('2023-01-01'))
          end

          describe 'underlyingSecurity' do
            it 'parses the underlyingSecurityTitle' do
              expect(doc2transaction1.underlying_security_title)
                .to eq('Common Stock')
              expect(doc4transaction1.underlying_security_title)
                .to eq('Common Stock')
              expect(doc5transaction1.underlying_security_title)
                .to eq('Common Stock')
              expect(doc7transaction1.underlying_security_title)
                .to eq('Noble Energy, Inc. Common Stock')
              expect(doc8transaction1.underlying_security_title)
                .to eq('Common Stock')
              expect(doc9transaction1.underlying_security_title)
                .to eq('Common Stock')
              expect(doc14transaction1.underlying_security_title)
                .to eq('Common Stock')
            end

            it 'parses the underlyingSecurityShares' do
              expect(doc2transaction1.underlying_security_shares)
                .to eq(14_225.8819)
              expect(doc4transaction1.underlying_security_shares).to eq(3_243)
              expect(doc5transaction1.underlying_security_shares).to eq(784)
              expect(doc7transaction1.underlying_security_shares).to eq(6_000)
              expect(doc8transaction1.underlying_security_shares).to eq(12_000)
              expect(doc9transaction1.underlying_security_shares).to eq(457)
              expect(doc14transaction1.underlying_security_shares).to eq(13_200)
            end
          end

          it 'parses the sharesOwnedFollowingTransaction' do
            expect(doc2transaction1.shares_after).to eq(0)
            expect(doc4transaction1.shares_after).to eq(3_244)
            expect(doc5transaction1.shares_after).to eq(7_089)
            expect(doc7transaction1.shares_after).to eq(14_990)
            expect(doc8transaction1.shares_after).to eq(12_000)
            expect(doc9transaction1.shares_after).to eq(4473)
            expect(doc14transaction1.shares_after).to eq(13_200)
          end

          it 'parses the directOrIndirectOwnership' do
            expect(doc2transaction1.direct_or_indirect_code).to eq('D')
            expect(doc4transaction1.direct_or_indirect_code).to eq('D')
            expect(doc5transaction1.direct_or_indirect_code).to eq('D')
            expect(doc7transaction1.direct_or_indirect_code).to eq('D')
            expect(doc8transaction1.direct_or_indirect_code).to eq('D')
            expect(doc9transaction1.direct_or_indirect_code).to eq('D')
            expect(doc14transaction1.direct_or_indirect_code).to eq('D')
          end

          it 'parses the natureOfOwnership' do
            # expect(doc2transaction1.nature_of_ownership)
            #   .to eq('By Merrill Lynch')
            # expect(doc3transaction1.nature_of_ownership).to eq('')
            # expect(doc4transaction1.nature_of_ownership).to eq('')
            # expect(doc4transaction2.nature_of_ownership).to eq('')
            # expect(doc6transaction1.nature_of_ownership).to eq('By LLC')
          end
        end
      end
    end
  end
end
