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

def setup_mapping
  $es.indices.put_mapping(index: $opts.indexname,
                          type: 'meta',
                          body: {
                              meta: {
                                  properties: {
                                      files: {
                                          type: 'object',
                                          properties: {
                                              #these should correspond to the names in parent_reference.rb
                                              media: { type: 'string', index: 'not_analyzed'},
                                              proxy: { type: 'string', index: 'not_analyzed'},
                                              thumbnail: { type: 'string', index: 'not_analyzed'},
                                              poster: { type: 'string', index: 'not_analyzed'}
                                          }
                                      }
                                  }
                              }
                          })
end

#START MAIN
device_cache = {}

$opts = Trollop::options do
  opt :elasticsearch, "Location of the Elastic Search cluster to talk to", :type=>:string, :default=>"http://localhost:9200"
  opt :indexname, "ES index containing existing Final Cut Server information", :type=>:string, :default=>"finalcutserver_meta"
end

$es = Elasticsearch::Client.new(:hosts=>$opts.elasticsearch)
begin
  $es.cluster.health
rescue Exception=>e
  logger.error("Unable to communicate with Elastic Search on #{$opts.elasticsearch}")
  logger.error("Error returned was #{e.message}")
  exit(255)
end

setup_mapping

qbody = {
        :match_all=>{}
}

PAGESIZE = 10
n=0

begin
  result = $es.search(index:$opts.indexname, body:{:query=>qbody,:from=>n,:size=>PAGESIZE})
  #ap result
  result['hits']['hits'].each {|doc|
    logger.info("#{n}/#{result['hits']['total']}: Got record #{doc['_source']['ADDRESS']} (#{doc['_source']['CUST_TITLE']})")
    prc = ParentReferenceCollection.new(FCSClient.get_parent_links(doc['_source']['ADDRESS']), logger: logger)
    filesref = prc \
      .select { |ref| ref.is_real_media? } \
      .map { |ref| {:path=>ref.real_filepath(device_cache),:type=>ref.link_type_name}} \
      .select { |obj| File.exists?(obj[:path]) }

    update_doc = {
        doc: {
            files: filesref.reduce(Hash.new) {|accumulator,elem| accumulator[elem[:type]]=elem[:path]}
        }
    }
    ap update_doc
    $es.update(index:$opts.indexname,id: doc['_id'], body: update_doc)
    n+=1
  }
end while(result['hits']['hits'].length>=PAGESIZE)

logger.info("Run completed, processed #{n} records")
