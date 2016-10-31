#!/usr/bin/env ruby
$: << "./lib"
require 'device'
require 'parent_reference_collection'
require 'awesome_print'

device_cache = {}

pr = ParentReferenceCollection.new(FCSClient.get_parent_links("/asset/824227"))

ap pr.map { |ref|
	ref.real_filepath(device_cache)
}
