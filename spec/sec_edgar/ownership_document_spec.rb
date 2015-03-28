include SecEdgar

describe OwnershipDocument do
  subject(:doc) { OwnershipDocument.new }
  1.upto(6) { |n| let("trans#{ n }".to_sym) { Transaction.new } }

  before(:each) do
    allow(trans1).to receive(:shares).and_return(15)
    allow(trans2).to receive(:shares).and_return(900)
    allow(trans3).to receive(:shares).and_return(5)
    allow(trans4).to receive(:shares).and_return(100)
    allow(trans5).to receive(:shares).and_return(200)
    allow(trans6).to receive(:shares).and_return(50)

    allow(trans1).to receive(:acquired_or_disposed_code).and_return('A')
    allow(trans2).to receive(:acquired_or_disposed_code).and_return('A')
    allow(trans3).to receive(:acquired_or_disposed_code).and_return('A')
    allow(trans4).to receive(:acquired_or_disposed_code).and_return('D')
    allow(trans5).to receive(:acquired_or_disposed_code).and_return('D')
    allow(trans6).to receive(:acquired_or_disposed_code).and_return('D')

    allow(trans1).to receive(:code).and_return('K')
    allow(trans2).to receive(:code).and_return('K')
    allow(trans3).to receive(:code).and_return('P')
    allow(trans4).to receive(:code).and_return('M')
  end

  it 'sets up transaction code percentage method' do
    expect(doc).to respond_to(:per_code_a)
  end

  describe 'calculates percentage of each transaction code per form' do
    it 'for one transaction' do
      doc.transactions = [trans1]
      expect(doc.per_code_k).to eq(100.0)
    end

    it 'for multiple transactions of same type' do
      doc.transactions = [trans1, trans2]
      expect(doc.per_code_k).to eq(100.0)
    end

    it 'for multiple transactions of different types' do
      doc.transactions = [trans1, trans2, trans3] # 915 + 5
      expect(doc.per_code_k).to eq(99.45652173913044)
      expect(doc.per_code_p).to eq(0.5434782608695652)
      expect(doc.per_code_a).to eq(0)
    end

    it 'for multiple transactions of different types' do
      doc.transactions = [trans1, trans2, trans3, trans4] # 915 + 5 + 100
      expect(doc.per_code_k).to eq(89.70588235294117)
      expect(doc.per_code_p).to eq(0.49019607843137253)
      expect(doc.per_code_m).to eq(9.803921568627452)
      expect(doc.per_code_a).to eq(0)
    end
  end

  it 'sums shares up correctly for one buy (A) transaction' do
    doc.transactions = [trans1]
    expect(doc.sum_shares).to eq(15)
  end

  it 'sums shares up correctly for multiple buy (A) transactions' do
    doc.transactions = [trans1, trans2, trans3]
    expect(doc.sum_shares).to eq(920)
  end

  it 'sums up shares correctly for one sale (D) transaction' do
    doc.transactions = [trans4]
    expect(doc.sum_shares).to eq(-100)
  end

  it 'sums up shares correctly for multiple sale (D) transactions' do
    doc.transactions = [trans4, trans5, trans6]
    expect(doc.sum_shares).to eq(-350)
  end

  it 'sums up shares across buys and sells' do
    doc.transactions = [trans1, trans2, trans3, trans4, trans5, trans6]
    expect(doc.sum_shares).to eq(570)
  end

  it 'totals up shares traded' do
    doc.transactions = [trans1, trans2, trans3, trans4, trans5, trans6]
    expect(doc.total_shares).to eq(1270)
  end
end
