require 'cgi'

module Onix3
  module Parser
    class Divider < Base

      def each_single_document
        base = '<?xml version="1.0" encoding="UTF-8"?>'
        move_to_root
        prefix = reader.prefix
        attribs = reader.attributes.to_a.map{ |a| " "+a[0]+"="+CGI.escapeHTML(a[1]) }
        tag = (@root_prefix ? @root_prefix+":" : "") + reader.tag("ONIXMessage")
        opening = "<#{tag}#{attribs}>"
        closing = "</#{tag}>"
        move_to_header
        header = reader.outer_xml
        start = base + opening + header
        count = 0
        while move_to_next_product
          count += 1
          yield( start + reader.outer_xml + closing )
        end
        count
      end

    protected

      def enclosed_in_root_tag
        tag = (@root_prefix ? @root_prefix+":" : "") + reader.tag("ONIXMessage")
        att = @root_attr.to_a.map{ |a| " "+a[0]+"="+CGI.escapeHTML(a[1]) }
        "<#{tag} #{att}>#{yield}</#{tag}>"
      end

      def analyze_header
        @header_xml = reader.outer_xml
      end

    end
  end
end