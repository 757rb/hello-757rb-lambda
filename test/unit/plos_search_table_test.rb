require 'test_helper'

class PlosSearchTableTest < HelloSpec

  before do
    plos = test_find
    plos.delete! if plos
  end

  it 'can save and find object' do
    refute test_find
    plos = PlosSearchTable.new id: 'test',
                               title: 'Test Title',
                               abstract: 'Test Abstract'
    assert plos.save
    assert test_find
  end

  private

  def test_find
    PlosSearchTable.find(id: 'test')
  end
end
