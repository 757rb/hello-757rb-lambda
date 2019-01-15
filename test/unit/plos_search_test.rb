require 'test_helper'

class PlosSearchTest < HelloSpec
  it '#search - Ruby' do
    data = search('Ruby')
    data.length.must_equal 2
    d = data[0]
    d.id.must_equal '10.1371/journal.pone.0077003'
    d.title.must_equal 'Glucose Transporter Expression in an Avian Nectarivore: The Ruby-Throated Hummingbird (Archilochus colubris)'
  end

  private

  def search(title)
    PlosSearch.new(title).search
  end
end
