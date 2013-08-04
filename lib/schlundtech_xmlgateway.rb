require 'nokogiri'

class SchlundtechXmlGateway

    def initialize(user, password, context, english = true)
        @user = user
        @password = password
        @context = context
        
        @in_english = english
    end

    def update_dyndns(domain, nameserver)
        builder = create_body(code = 202) 
        Nokogiri::XML::Builder.with(builder.doc.xpath("//request/task").first) do |xml|
            xml.zone {
                xml.name domain
                xml.system_ns nameserver
            }
        end
    end

    def create_body(code = 815)
        builder = Nokogiri::XML::Builder.new(:encoding => "utf-8") do |xml|
            xml.request {
                xml.auth {
                    xml.user @user
                    xml.password @password
                    xml.context @context
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
