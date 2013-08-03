require 'nokogiri'

class SchlundtechXmlGateway

    def initialize(user, password, english = true)
        @user = user
        @password = password
        
        @in_english = english
    end


    def update_dyndns(domain, nameserver)
        doc = create_body(code = 202) 
        zone = Nokogiri::XML::Node.new("zone", doc)
        zone.name = name
        zone.system_ns  = nameserver
        #doc.xpath("request/task").add_next_sibling(zone)
    end


    def create_body(code = 815)
        builder = Nokogiri::XML::Builder.new(:encoding => "utf-8") do |xml|
            xml.request {
                xml.auth {
                    xml.user @user
                    xml.password @password
                    xml.context_ 10 
                }
                xml.language @in_english ? "en" : "de"
                xml.task {
                    xml.code "%04d" % code
                }

            }
        end
    end
end


if __FILE__ == $0
    foo = SchlundtechXmlGateway.new("max.muster", "i-like-little-children4breakfa$t")
    puts foo.update_dyndns("example.com", "ns1.example.com").to_xml
end
