require 'nokogiri'
require 'net/https'
require "uri"

class SchlundtechXmlGateway

    GATEWAY = "https://gateway.schlundtech.de"

    def initialize(user, password, context, english = true)
        @user = user
        @password = password
        @context = context
        
        @in_english = english
    end

    def zone_update(domain, zone)
        builder = create_body(code = "0202")
        builder.doc.xpath("//request/task").first.add_child(zone)

        send_request(builder)
    end

    def zone_inquire(domain, nameserver)
        builder = create_body(code = "0205")
        Nokogiri::XML::Builder.with(builder.doc.xpath("//request/task").first) do |xml|
            xml.zone {
                xml.name domain
                xml.system_ns nameserver
            }
        end

        send_request(builder)
    end

    def create_body(code = "815")
        builder = Nokogiri::XML::Builder.new(:encoding => "utf-8") do |xml|
            xml.request {
                xml.auth {
                    xml.user @user
                    xml.password @password
                    xml.context_ "%d" % @context
                }
                xml.language @in_english ? "en" : "de"
                xml.task {
                    xml.code code
                }
            }
        end
    end

    def send_request(request)
        puts request.to_xml

        uri = URI.parse(SchlundtechXmlGateway::GATEWAY)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE # BAD!

        http_request = Net::HTTP::Post.new(uri.request_uri)
        http_request.body = request.to_xml
        http_request["Content-Type"] = "text/xml"

        response = http.request(http_request)
    end
end


if __FILE__ == $0
    foo = SchlundtechXmlGateway.new("max.muster", "i-like-little-children4breakfa$t", 18)
    response = foo.zone_inquire("example.com", "ns1.example.com")
    puts response.code + " " + response.msg
end
