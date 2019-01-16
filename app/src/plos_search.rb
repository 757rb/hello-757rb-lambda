class PlosSearch
  attr_reader :title

  CONNECTION = Faraday.new url: 'http://api.plos.org' do |f|
    f.adapter :net_http_persistent, pool_size: 5 do |http|
      http.idle_timeout = 100
      http.retry_change_requests = true
    end
  end

  def initialize(title)
    @title = title || 'Ruby'
  end

  def search
    return [] if response_data_empty?
    response_data['response']['result']['doc'].map do |doc|
      Data.new doc['str']
    end
  end

  private

  def response
    @response ||= CONNECTION.get '/search', search_params
  end

  def search_params
    {
      q: "title:#{URI.escape(title)}",
      fl: 'id,title,abstract',
      wt: 'xml'
    }
  end

  def response_xml
    response.status == 200 ? response.body : ''
  end

  def response_data
    @response_data ||= Hash.from_xml(response_xml)
  end

  def response_data_empty?
    return true if response_data.empty?
    return true if response_data['response'].nil?
    response_data['response']['result']['numFound'].to_i == 0
  end

  class Data
    attr_reader :id, :title, :abstract
    def initialize(attrs)
      @id, @title, @abstract = attrs
      find_or_create_dyno_dna_record
    end

    private

    def find_or_create_dyno_dna_record
      return if PlosSearchTable.find id: id
      plos = PlosSearchTable.new id: id, title: title, abstract: abstract
      plos.save
    end
  end
end
