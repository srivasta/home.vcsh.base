#!/usr/bin/env ruby

=begin

Ruby->HTML Pretty Printer
 
Copyright: 2004 Gregor Rayman
           rayman@grayman.de 
           http://www.grayman.de
           
Please send bug reports and suggestions to rayman@grayman.de
 
License:

  Released under the GNU General Public License. 
  For the full text see http://www.gnu.org/licenses/gpl.txt
  Please contact me (rayman@grayman.de), if you wish to use 
  this source under another license.
 
=end


require 'irb/ruby-lex'
require 'cgi'

module RubyToken
  class << Token

    def to_html(text)
      "<span class='#{html_class}'>#{CGI.escapeHTML(text)}</span>"
    end
    def html_class

      "any"
    end 
  end
  
  class << TkSPACE
    def to_html(text)

      text
    end
  end
  
  class << TkNL
    def to_html(text)

      text
    end
  end

  @HtmlClasses = {

    'Keyword' => [:TkId],
    'Symbol' => [:TkOp, :TkASSIGN, :TkDOT, :TkLPAREN, :TkLBRACK, :TkLBRACE, :TkRPAREN, :TkRBRACK, :TkRBRACE, 
                 :TkCOMMA, :TkSEMICOLON, :TkfLPAREN, :TkfLBRACK, :TkfLBRACE, :TkSTAR, :TkAMPER, :TkSYMBEG,

           :TkBACKSLASH, :TkAT, :TkDOLLAR, :TkUnknownChar],

    'Comment' => [:TkCOMMENT],
    'RDocComment' => [:TkRD_COMMENT],

    'String' => [:TkSTRING, :TkXSTRING, :TkDSTRING, :TkDXSTRING],

    'RegExp' => [:TkREGEXP, :TkDREGEXP ],
    'RegExpRef' => [:TkNTH_REF, :TkBACK_REF],

    'Name' => [:TkIDENTIFIER, :TkFID, :TkGVAR, :TkCVAR, :TkIVAR],

    'Constant' => [:TkCONSTANT],
    'Value' => [:TkVal],

    'Error' => [:TkError]
  }

  @HtmlClasses.each_pair do |html, tokens|

    tokens.each do |token|
      begin
        eval("class << #{token}; def html_class() '#{html}'; end; end;")

      rescue NameError
      end
    end
  end
end

class RubyToHtml
  @RCS_ID='-$Id: ruby_html.rb,v 1.2 2004/01/26 22:01:49 gra Exp $-'
  Template = <<EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
  <meta http-equiv="Content-Type" content="text/html;charset=US-ASCII">
  <title>%s</title>
  <link rel="stylesheet" type="text/css" href="/styles/ruby.css">

</head>
<body>
%s
</body>
</html>
EOF

  class << self

    def ruby_html(input)
      result = "<pre class='ruby'>\n"
      lex = RubyLex.new

      lex.set_input(input)
      
      while tk = lex.token

        text = lex.get_readed
        # break if text.empty?
        result << tk.class.to_html(text)

      end 
      result << "</pre>\n"
    end
    
    def process

      if ENV['QUERY_STRING']
        fileName = ENV['QUERY_STRING']

        filePath = ENV['DOCUMENT_ROOT'] + '/' + fileName      
        print "Content-Type: text/html;charset=US-ASCII\n\n"

      elsif ENV['PATH_TRANSLATED']
        filePath = ENV['PATH_TRANSLATED']

        print "Content-Type: text/html;charset=US-ASCII\n\n"
      elsif ARGV[0]
        filePath = ARGV[0]

      else  
        filePath = $0
      end
      
      fileName = File.split(filePath)[-1]

      #Note: The source file MUST end with \n otherwise 
      # endles loop can happen
      File.open(filePath) do |input|

         printf(Template, fileName, ruby_html(input))
      end

    end
  end
end 

RubyToHtml::process()

