#!/usr/bin/env ruby
$: << "./lib"
require 'device'
require 'parent_reference_collection'
require 'awesome_print'
require 'elasticsearch'
require 'trollop'
require 'logger'
require 'awesome_print'

logger = Logger.new(STDOUT)

#START MAIN
device_cache = {}

opts = Trollop::options do
  opt :elasticsearch, "Location of the Elastic Search cluster to talk to", :type=>:string, :default=>"http://localhost:9200"
  opt :indexname, "ES index containing existing Final Cut Server information", :type=>:string, :default=>"finalcutserver_meta"
end

es = Elasticsearch::Client.new(:hosts=>opts.elasticsearch)
begin
  es.cluster.health
rescue Exception=>e
  logger.error("Unable to communicate with Elastic Search on #{opts.elasticsearch}")
  logger.error("Error returned was #{e.message}")
  exit(255)
end

qbody = {
        :match_all=>{}
}

PAGESIZE = 10
n=0

begin
  result = es.search(index:opts.indexname, body:{:query=>qbody,:from=>n,:size=>PAGESIZE})
  #ap result
  result['hits']['hits'].each {|doc|
    logger.info("#{n}/#{result['hits']['total']}: Got record #{doc['_source']['ADDRESS']} (#{doc['_source']['CUST_TITLE']})")
    prc = ParentReferenceCollection.new(FCSClient.get_parent_links(doc['_source']['ADDRESS']), logger: logger)
    ap prc \
      .select { |ref| ref.is_real_media? } \
      .map { |ref| {:path=>ref.real_filepath(device_cache),:type=>ref.link_type_name}} \
      .select { |obj| File.exists?(obj[:path]) }
  }
  n+=PAGESIZE
end while(result['hits']['hits'].length>=PAGESIZE)

# pr = ParentReferenceCollection.new(FCSClient.get_parent_links("/asset/824227"))
#
# ap pr.map { |ref|
# 	ref.real_filepath(device_cache)
# }

