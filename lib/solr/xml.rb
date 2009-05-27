# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module Solr::XML
end
require 'rubygems'
begin
  gem 'libxml-ruby', '>= 0.7'
rescue Gem::LoadError => e 
  use_rexml = true
end
require 'xml'
use_rexml = !XML::Node.public_instance_methods.include?("attributes")

if use_rexml
  puts "Could Not Load libxml-ruby >= 0.7.\nRequiring REXML"
  require 'rexml/document'
  Solr::XML::Element = REXML::Element
else
  class XML::Node
    alias_method :add_element, :<< # element.add_element(another_element) should work
    def text=(x) # element.text = "blah" should work
      self << x.to_s
    end
  end
  Solr::XML::Element = XML::Node
end
