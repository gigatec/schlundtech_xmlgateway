require 'nokogiri'

class SchlundtechXmlGateway

    def initialize(user, password)
        @user = user
        @password = password
    end


    def create_body
        builder = Nokogiri::XML::Builder.new(:encoding => "utf-8") do |xml|
            xml.request {
                xml.auth {
                    xml.user @user
                    xml.password @password
                    xml.context_ 10 
                }
                xml.task { }
            }
        end
    end
end


if __FILE__ == $0
    foo = SchlundtechXmlGateway.new("max.muster", "i-like-little-children4breakfa$t")
    puts foo.create_body.to_xml
end
