#                              -*- Mode: Cperl -*- 
# gen_color.pl --- 
# Author           : Manoj Srivastava ( srivasta@glaurung.internal.golden-gryphon.com ) 
# Created On       : Thu May 20 13:09:30 2004
# Created On Node  : glaurung.internal.golden-gryphon.com
# Last Modified By : Manoj Srivastava
# Last Modified On : Mon May 31 13:57:30 2004
# Last Machine Used: glaurung.internal.golden-gryphon.com
# Update Count     : 247
# Status           : Unknown, Use with caution!
# HISTORY          : 
# Description      : 
# 
# 

# 
# The Hue Saturation Value (or HSV) model defines a color space in terms
# of three constituent components; hue, saturation, and value. HSV is
# used in color progression s.

# Hue , the color type (such as red, blue, or yellow); Measured in
#       values of 0-360 (the angle determining position of the color
#       on the wheel)by the central tendency of its wavelength (also
#       called tint, or family).

# Saturation , the 'intensity' of the color (or how much greyness is
#       present -- 100 % is the most saturated color, 0 is a shade of
#       gray), Measured in values of 0-100% by the amplitude of the
#       wavelength (also called shade or purity). Purity is how much
#       white is added to the color, so S=1 makes the purest color (no
#       white).

# Value , the brightness of the color.  Measured in values of 0-100%
#       by the spread of the wavelength (tone or intensity). (100 % is
#       lightest shade, 0 is black).

# HSV is a non-linear transformation of the RGB color space .

# The coordinate system is cylindrical, and the colors are defined
# inside a hexcone. The hue value H runs from 0 to 360 degrees. The
# saturation S is the degree of strength or purity and is from 0 to
# 1. Purity is how much white is added to the color, so S=1 makes the
# purest color (no white).  Brightness V also ranges from 0 to 1, where
# 0 is the black.

# BEGIN {
#   ($main::MYNAME     = $main::0) =~ s|.*/||;
#   $main::Author      = "Manoj Srivastava";
#   $main::AuthorMail  = "manoj.srivastava\@stdc.com";
#   $main::Version     = (qw$Revision: 1.5 $ )[-1];
#   $main::Version_ID  = q$Id: draw-col,v 1.5 2003/12/29 01:45:58 srivasta Exp $;
# }

use 5.008;
use strict;
use warnings;

use Carp;

package Report;
use Graphics::ColorObject;

use XML::LibXML::Common qw(:libxml);
use XML::LibXML;
{
  my %Report =
    (
     DOM => '',
     DTD => '',
     Root => '',
     Defaults => {
		  "DB Port"   => '',
		 },
    );

  for my $datum (keys %Report ) {
    no strict "refs";
    *$datum = sub {
      use strict "refs";
      my ($self, $newvalue) = @_;
      $Report{$datum} = $newvalue if @_ > 1;
      return $Report{$datum};
    }
  }
}



sub new{
  my $this = shift;
  my %params = @_;
  my $class = ref($this) || $this;
  my $self = {};

  warn "Creating new Report Object" if $::ConfOpts{'TRACE_SUBS'};

  bless $self, $class;

  $self->{Dot_Dir}=$ENV{HOME} || $ENV{LOGNAME} || (getpwuid($>))[7] ;
  $self->{' _Debug'} = 0;
  return $self;
}

sub add_link_node {
  my $this  = shift;
  my ($dl, $href, $term, $def) = @_;
  my $dt = $this->DOM()->createElement("dt");
  my $a;
  my $strong;
  my $dd;
  
  if ($href) {
    $a = $this->DOM()->createElement("a");
    $a->setAttribute("href", "$href");
  }
  if ($term) {
    $strong = $this->DOM()->createElement("strong");
    $strong->appendTextNode("$term");
    if ($a) {
      $a->appendChild($strong);
      $dt->appendChild($a);
    }
    else {
      $dt->appendChild($strong);
    }
    $dl->appendChild($dt);
  }
  if ($def) {
    $dd = $this->DOM()->createElement("dd");
    $dd->appendTextNode("$def");
    $dl->appendChild($dd);
  }
}



sub footer {
  my $this  = shift;

  my $rule    = $this->DOM()->createElement("hr");
  $this->{body}->appendChild($rule);

  my $address = $this->DOM()->createElement("address");
  my $a       = $this->DOM()->createElement("a");

  $address->appendTextNode("Manoj Srivastava");
  $a->setAttribute("href", "mailto:srivasta\@golden-gryphon.com");
  $a->appendTextNode("<srivasta\@golden-gryphon.com>");
  $address->appendChild($a);
  $this->{body}->appendChild($address);

  my $txt =<<EOF1;

        document.write("<p>Last Updated:");
        document.writeln(document.lastModified);
        document.writeln("</p>");

EOF1

  my $div = $this->DOM()->createElement("div");
  my $script = $this->DOM()->createElement("script");
  my $comment = $this->DOM()->createComment($txt);

  $script->setAttribute("type", "text/javascript");
  $script->appendChild($comment);
  $div->appendChild($script);
  $this->{body}->appendChild($div);

  $txt =<<EOF2;
Keep this comment at the end of the file
Local variables:
mode: xml
sgml-indent-data:t
sgml-live-element-indicator: t
sgml-set-face: t
sgml-omittag:nil
sgml-shorttag:nil
sgml-namecase-general:nil
sgml-general-insert-case:lower
sgml-minimize-attributes:nil
sgml-always-quote-attributes:t
sgml-indent-step:2
sgml-parent-document:nil
sgml-exposed-tags:nil
sgml-local-catalogs:nil
sgml-local-ecat-files:nil
End:
EOF2
  $comment = $this->DOM()->createComment($txt);
  $this->Root()->appendChild($comment);
}

sub glossary {
  my $this  = shift;

  my $div = $this->DOM()->createElement("div");
  $div->setAttribute("class", "glossary");

  my $header = $this->DOM()->createElement("h2");
  $header->setAttribute("class", "section");
  $header->appendTextNode("Glossary");
  $div->appendChild($header);
  my $dl = $this->DOM()->createElement("dl");
  my $dt = $this->DOM()->createElement("dt");
  my $dd = $this->DOM()->createElement("dd");
  my $strong = $this->DOM()->createElement("strong");

  $strong->appendTextNode("Hue");
  $dt->appendChild($strong);
  $dl->appendChild($dt);

  $dd->appendTextNode(<<EOTXT);
          This is the color type, (such as red, blue, or yellow);
          Measured in values of 0-360 (the angle determining position
          of the color on the color wheel) by the central tendency of
          its wavelength (also  called tint, or family).
EOTXT
  $dl->appendChild($dd);

  $dt = $this->DOM()->createElement("dt");
  $dd = $this->DOM()->createElement("dd");
  $strong = $this->DOM()->createElement("strong");
  $strong->appendTextNode("Saturation");
  $dt->appendChild($strong);
  $dl->appendChild($dt);

  $dd->appendTextNode("The ");
  my $em = $this->DOM()->createElement("em");
  $em->appendTextNode("intensity");
  $dd->appendChild($em);
  $dd->appendTextNode(<<EOTXT1);
           or strength of the color (or how much
	  greyness is present -- 100 % is the most saturated color, 0
	  is a shade of gray), Measured in values of 0-100% by the
	  amplitude of the wavelength (also called shade or
	  purity). Purity is how much white is added to the color, so
	  S=1 makes the purest color (no white).
EOTXT1
  my $p = $this->DOM()->createElement("p");
  $p->appendTextNode(<<EOTXT1p1);

   Also called Chroma or colorfullness: All terms refer to purity of a
   color. Saturation is an aperture color term for color purity - the
   amount of white apparently mixed with a pure color. Chroma is
   similar, but refers specifically to the purity of a color compared
   to an achromatic light of the same lightness. As a result, chroma
   is usually the right concept in surface color description and
   natural scenes. However, if there are no areas of achromatic color
   to act as references, then saturation might still be the correct
   concept even in natural scenes. As if all this were not complicated
   enough, there is yet another term,
EOTXT1p1
  $em = $this->DOM()->createElement("em");
  $em->appendTextNode("colorfulness,");
  $p->appendChild($em);
  $p->appendTextNode(<<EOTXT1p2);
   which is the total amount of chromatic content. It is composed of
   saturation, colorfulness in proportion to brightness, and chroma,
   colorfulness relative to scene brightness. Fortunately, most
   designers can safely ignore the distinctions among these terms, but
   they worth noting because the terms frequently appear in articles
   on color.
EOTXT1p2
  $dd->appendChild($p);
  $dl->appendChild($dd);

  $dt = $this->DOM()->createElement("dt");
  $dd = $this->DOM()->createElement("dd");
  $strong = $this->DOM()->createElement("strong");
  $strong->appendTextNode("Lightness");
  $dt->appendChild($strong);
  $dl->appendChild($dt);

  $dd->appendTextNode(<<EOTXT2);
 The brightness of the color.  Measured in values of 0-100% by the
 spread of the wavelength (tone or intensity). (100 % is lightest
 shade, 0 is black). 
EOTXT2
  $p = $this->DOM()->createElement("p");
  $p->appendTextNode(<<EOTXT1p3);
 Also called Lightness or Value. Brightness is the quantity of light
 apparently coming from an object. Lightness (sometimes called
EOTXT1p3
  $em = $this->DOM()->createElement("em");
  $em->appendTextNode("value");
  $p->appendChild($em);
  $p->appendTextNode(", ");

  $em = $this->DOM()->createElement("em");
  $em->appendTextNode("albedo");
  $p->appendChild($em);
  $p->appendTextNode(" or ");

  $em = $this->DOM()->createElement("em");
  $em->appendTextNode("whiteness");
  $p->appendChild($em);
  $p->appendTextNode(<<EOTXT1p5);
 ) is amount of light which an object appears to emit compared to its
 background or other scene objects. Some use the terms lightness and
 brightness interchangeably but this is an error. Brightness is a
 concept from disembodied aperture color while lightness is a relative
 comparison of different objects and is a property of surface
 color. To make this distinction even clearer, lightness was once
 called
EOTXT1p5
  $em = $this->DOM()->createElement("em");
  $em->appendTextNode("comparative brightness.");
  $p->appendChild($em);
  $p->appendTextNode(<<EOTXT1p6);
 Another way to think of the difference is that brightness is a
 property of a light while lightness is a property of an object - its
 reflectance. Roughly speaking, the visual system compares the
 reflectance of objects and their backgrounds. Objects which reflect
 less light than their backgrounds appear dark (low albedo) while
 objects reflecting more light appear lighter (high albedo). For
 example, writing paper has high reflectance so it appears white in
 both dim indoor and intense outdoor light. Conversely, coal almost
 always looks black because it reflects less light than its
 background. I say almost because there is the
EOTXT1p6
  $em = $this->DOM()->createElement("em");
  $em->appendTextNode("Gelb Effect,");
  $p->appendChild($em);
  $p->appendTextNode(<<EOTXT1p7);
 a demonstration which turns black objects to white. The trick is to
 use a 0 reflectance background (it is not hard to do), so that even
 low reflectance surfaces send back more light. Lastly, some use the
 term
EOTXT1p7
  $em = $this->DOM()->createElement("em");
  $em->appendTextNode("value");
  $p->appendChild($em);
  $p->appendTextNode(<<EOTXT1p8);
 to mean lightness, brightness, or both.
EOTXT1p8

  $dd->appendChild($p);
  $dl->appendChild($dd);

  $div->appendChild($dl);
  $header = $this->DOM()->createElement("h2");
  $header->setAttribute("class", "section");
  $header->appendTextNode("Links");
  $div->appendChild($header);

  
  $header = $this->DOM()->createElement("h3");
  $header->setAttribute("class", "section");
  $header->appendTextNode("Links farms");
  $div->appendChild($header);

  $dl = $this->DOM()->createElement("dl");

  $this->add_link_node($dl,
		"http://www.efg2.com/Lab/Library/Color/Science.htm",
		"efg's Color Reference Library -- Color Science / Color Theory",
		"Links to other color resources.");

  $this->add_link_node($dl,
		"http://easyrgb.com/links.html",
		"EasyRGB - A collection of links to resources related to Web color technology.",
                   "This is a collection of links to resources related to color
                    technology. Primarily focused on resources for people
                    dealing with Web or computer based color presentation.");

  $this->add_link_node($dl,
		"http://www.fred.net/dhark/graphics",
		"Graphic Design for the Web");

  $div->appendChild($dl);

  $header = $this->DOM()->createElement("h3");
  $header->setAttribute("class", "section");
  $header->appendTextNode("Color Theory and Physics");
  $div->appendChild($header);

  $dl = $this->DOM()->createElement("dl");

  $this->add_link_node($dl,
		"http://www.cs.bham.ac.uk/~mer/colour/cie.html",
		"Basic color theory: Gamuts, and CIE",
		"A very basic, but illuminating discourse on the CIE model");
  $this->add_link_node($dl,
		"http://nebulus.org/index.html?pg=tutorial_ps.asp",
		"Nebulus Designs, Graphic Design and Web Development",
		"The color tutorials here have the best descriptions");

  $this->add_link_node($dl,
		"http://www.ncsu.edu/scivis/lessons/colormodels/color_models2.html",
		"Color Principles - Hue, Saturation, and Value",
		"Neat graphics -- gives a saturation/value slice for a hue");
  $this->add_link_node($dl,
		"http://www.handprint.com/HP/WCL/color2.html",
		"colormaking attributes",
		"Detailed exposition of the principles.");
  $this->add_link_node($dl,
		"http://www.poynton.com/notes/colour_and_gamma/ColorFAQ.html",
		"Color FAQ - Frequently Asked Questions Color",
		"Also has formulae");

  $this->add_link_node($dl,
		"http://www.nebulus.org/tutorials/2d/pictpub/colormerge/",
		"An Introduction to Color, or Color Physics 101");
  $this->add_link_node($dl,
		"http://escience.anu.edu.au/lecture/cg/Color/printCG.en.html",
		"Computer Graphics : Colors",
		"Complete with physiology.");
  $this->add_link_node($dl,
		"http://www.neuro.sfc.keio.ac.jp/~aly/polygon/info/color-space-faq.html",
		"Color space FAQ");

  $this->add_link_node($dl,
		"http://www.cs.bham.ac.uk/~mer/colour/cie.html",
		"The CIE Colour System");


  $this->add_link_node($dl,
		"http://developer.apple.com/documentation/mac/ACI/ACI-48.html",
		"Color Spaces",
		"A slightly more detailed color theory");
  $this->add_link_node($dl,
		"http://www.colourware.co.uk/cpfaq.htm",
		"Colour Physics FAQ");

  $div->appendChild($dl);

  $header = $this->DOM()->createElement("h3");
  $header->setAttribute("class", "section");
  $header->appendTextNode("Designing with Color");
  $div->appendChild($header);

  $dl = $this->DOM()->createElement("dl");

  $this->add_link_node($dl,
		"http://www.ergogero.com/FAQ/Part1/cfaqPart1.html",
		"SBFAQ Part I: Basic Terms and Definitions");
  $this->add_link_node($dl,
		"http://www.ergogero.com/pages/baddesign.html",
		"Designers Behaving Badly");

  $div->appendChild($dl);

  $header = $this->DOM()->createElement("h3");
  $header->setAttribute("class", "section");
  $header->appendTextNode("Color Scheme");
  $div->appendChild($header);

  $dl = $this->DOM()->createElement("dl");
  $this->add_link_node($dl,
		"http://www.color-wheel-pro.com/color-theory-basics.html",
		"Color Wheel Pro: Color Theory Basics");

  $this->add_link_node($dl,
		"http://www.color-wheel-pro.com/color-schemes.html",
		"Color Wheel Pro: Classic Color Schemes",
		"description of classic color schemes.");
  $this->add_link_node($dl,
		"http://www.color-wheel-pro.com/color-meaning.html",
		"Color Wheel Pro: Color Meaning");

  $this->add_link_node($dl,
		"http://www.webwhirlers.com/colors/combining.asp",
		"Colours on the web - color theory and color matching",
		"The defining color schemes page");

  $this->add_link_node($dl,
		"http://www.nebulus.org/tutorials/2d/pictpub/hsl/",
		"Hue, Saturation, Lightness",
		"Developing a color pallette");

  $this->add_link_node($dl,
		"http://freedesktop.org/Standards/colorscheme-spec/colorscheme-spec-0.1.html",
		"Desktop Colorscheme Specification",
		"rules of thumb for fore/back colors");
  $this->add_link_node($dl,
		"http://www.colorcombo.com/",
		"Visualize color combinations for web-design.");
  $div->appendChild($dl);

  $header = $this->DOM()->createElement("h3");
  $header->setAttribute("class", "section");
  $header->appendTextNode("Color Conversion Links");
  $div->appendChild($header);

  $dl = $this->DOM()->createElement("dl");

  $this->add_link_node($dl,
		"http://www.brucelindbloom.com/index.html?ColorCalcHelp.html",
		"Useful Color Equations",
		"The most complete conversion equations and explanations");
  $this->add_link_node($dl,
		"http://www.dcs.ed.ac.uk/home/mxr/gfx/faqs/colorconv.faq",
		"The Color Conversion FAQ");

  $this->add_link_node($dl,
		"http://www.axiphos.com/Reports/ColorDifferences.pdf",
		"Color Differences (application/pdf Object");
  $this->add_link_node($dl,
		"http://www.cs.rit.edu/~ncs/color/t_convert.html",
		"Color Conversion Algorithms",
		"In C/java");

  $this->add_link_node($dl,
		"http://www.color-tec.com/color/p11.htm",
		"The Mathematics of color difference.");

  $this->add_link_node($dl,
		"http://semmix.pl/color/extrans/etr80.htm",
		"Transformation CIE XYZ and RGB, part 1",
		"Develops some conversion formulae");
  $this->add_link_node($dl,
		"http://www.psc.edu/~burkardt/src/colors/colors.html",
		"COLORS - Color Conversion",
		"Fortran conversion software");

  $div->appendChild($dl);

  return $div;
}

sub col_table {
  my $this  = shift;
  my ($c1, $c2, $c3, $c4, $c5, $c6, $c7) = @_;

  # c1 = c1d6ff
  # c2 = E0EBFF
  # c3 = eff5ff
  # c4 = D1D6DF
  # c5 = 8E98AA
  # c6 = 474C55
  # c7 = A8B0BF

  my $div = $this->DOM()->createElement("div");
  $div->setAttribute("class", "SampleTable");

  my $table = $this->DOM()->createElement("table");
  $table->setAttribute
    ("style", 
     "table-layout: fixed; font-size : xx-small; width: 74em; border-collapse: collapse; padding: 3ex; cellspacing: 0;");


  # Row one, all the way across
#       <tr>
#       <td style="padding: 1em; background-color: #$c4;" colspan="20">&nbsp;</td>
#       </tr>
  my $tr = $this->DOM()->createElement("tr");
  my $td = $this->DOM()->createElement("td");

  $td->setAttribute("style", "padding: 1em; background-color: #$c4;");
  $td->setAttribute("colspan", "20");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $table->appendChild($tr);

  # Row two
#       <tr>
#       <td style="padding: 1em; background-color: #$c6;">&nbsp;</td>
#       <td style="padding: 1em; color: Black; background-color: #$c1;" colspan="8">Black Text</td>
#       <td style="padding: 1em; color: White; background-color: #$c1;" colspan="8">White Text</td>
#       <td style="padding: 1em; color: White; background-color: #$c4;">&nbsp;</td>
#       <td style="padding: 1em; color: White; background-color: #$c1;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c7;">&nbsp;</td>
#       </tr>

  $tr = $this->DOM()->createElement("tr");

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c6;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; color: Black; background-color: #$c1;");
  $td->setAttribute("colspan", "8");
  $td->appendTextNode('Black Text');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em;  color: White; background-color: #$c1;");
  $td->setAttribute("colspan", "8");
  $td->appendTextNode('White Text');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c4");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c1;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em;  background-color: #$c7;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $table->appendChild($tr);


#       <tr>
#       <td style="padding: 1em; background-color: #$c6;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #c1d6ff;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c1;" colspan="5">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c1;" >&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c1;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c4;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c1;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c7;">&nbsp;</td>
#       </tr>

  $tr = $this->DOM()->createElement("tr");

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c6;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c1;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c1;");
  $td->setAttribute("colspan", "5");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c1;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c1;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c4;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c1;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c7;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $table->appendChild($tr);

#       <tr>
#       <td style="padding: 1em; background-color: #$c6;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c1;" colspan="1">&nbsp;</td>
#       <td style="border-left: 3px solid white; border-top: 1px solid white; padding: 1em; background-color: #$c1;">&nbsp;</td>
#       <td style="border-top: 1px solid white; padding: 1em; background-color: #$c2;" colspan="2">&nbsp;</td>
#       <td style="border-top: 1px solid white; padding: 1em; background-color: #$c1;" colspan="5">&nbsp;</td>
#       <td style="border-top: 1px solid white; padding: 1em; background-color: #$c3;" colspan="2">&nbsp;</td>
#       <td style="border-top: 1px solid white; padding: 1em; background-color: #$c1;">&nbsp;</td>
#       <td style="border-top: 1px solid white; padding: 1em; background-color: #$c5;" colspan="2">&nbsp;</td>
#       <td style="border-right: 3px solid Black; border-top: 1px solid white; padding: 1em; background-color: #$c1;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c1;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c4;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c1;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c7;">&nbsp;</td>
#       </tr>

  $tr = $this->DOM()->createElement("tr");

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c6;");
  $td->setAttribute("colspan", "1");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c1;");
  $td->setAttribute("colspan", "1");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "border-left: 3px solid white; border-top: 1px solid white; padding: 1em; background-color: #$c1;");
  $td->setAttribute("colspan", "1");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; border-top: 1px solid white; background-color: #$c2;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "border-top: 1px solid white; padding: 1em; background-color: #$c1;");
  $td->setAttribute("colspan", "5");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "border-top: 1px solid white; padding: 1em; background-color: #$c3;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "border-top: 1px solid white; padding: 1em; background-color: #$c1;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "border-top: 1px solid white; padding: 1em; background-color: #$c5;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "border-right: 3px solid Black; border-top: 1px solid white; padding: 1em; background-color: #$c1;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c1;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c4;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c1;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c7;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $table->appendChild($tr);


#       <tr>
#       <td style="padding: 1em; background-color: #$c6;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2;" colspan="1">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2; border-left: 3px solid white;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2;" colspan="3">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c1;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2; border-right: 3px solid Black; ">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2;" colspan="1">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c4;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2;" colspan="1">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c7;">&nbsp;</td>
#       </tr>

  $tr = $this->DOM()->createElement("tr");

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c6;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2;");
  $td->setAttribute("colspan", "1");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2; border-left: 3px solid white;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2;");
  $td->setAttribute("colspan", "3");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c1;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2; border-right: 3px solid Black;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2;");
  $td->setAttribute("colspan", "1");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c4;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c7;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $table->appendChild($tr);


#       <tr>
#       <td style="padding: 1em; background-color: #$c6;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2;" colspan="1">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2; border-left: 3px solid white;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2;" colspan="3">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c1;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2; border-right: 3px solid Black; ">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2;" colspan="1">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c4;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2;" colspan="1">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c7;">&nbsp;</td>
#       </tr>

  $tr = $this->DOM()->createElement("tr");

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c6;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2; border-left: 3px solid white;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2;");
  $td->setAttribute("colspan", "3");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c1;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2; border-right: 3px solid Black; ");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c4;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c7;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $table->appendChild($tr);


#       <tr>
#       <td style="padding: 1em; background-color: #$c6;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3;" colspan="1">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3; border-left: 3px solid white;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c1;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3;" colspan="5">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3; border-right: 3px solid Black;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3;" colspan="1">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c4;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3;" colspan="1">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c7;">&nbsp;</td>
#       </tr>

  $tr = $this->DOM()->createElement("tr");

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c6;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color:  #$c3;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color:  #$c3; border-left: 3px solid white;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c1;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3;");
  $td->setAttribute("colspan", "5");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3; border-right: 3px solid Black;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c4;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c7;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $table->appendChild($tr);


#       <tr>
#       <td style="padding: 1em; background-color: #$c6;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3; border-left: 3px solid white;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c1;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3;" colspan="5">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3; border-right: 3px solid Black;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c4;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c7;">&nbsp;</td>
#       </tr>

  $tr = $this->DOM()->createElement("tr");

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c6;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3; border-left: 3px solid white;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c1;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3;");
  $td->setAttribute("colspan", "5");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3; border-right: 3px solid Black;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c4;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c7;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $table->appendChild($tr);


#       <tr>
#       <td style="padding: 1em; background-color: #$c6;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5; border-left: 3px solid white;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c1;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5;" colspan="3">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5; border-right: 3px solid Black;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c4;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c7;">&nbsp;</td>
#       </tr>

  $tr = $this->DOM()->createElement("tr");

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c6;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5; border-left: 3px solid white;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c1;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5;");
  $td->setAttribute("colspan", "3");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5; border-right: 3px solid Black;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c4;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c7;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $table->appendChild($tr);



#       <tr>
#       <td style="padding: 1em; background-color: #$c6;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5; border-top: 1px solid black;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c2; border-top: 1px solid black;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5; border-top: 1px solid black;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c1; border-top: 1px solid black;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5; border-top: 1px solid black;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c3; border-top: 1px solid black;" colspan="2">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5; border-top: 1px solid black;" colspan="4">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c4;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c7;">&nbsp;</td>
#       </tr>

  $tr = $this->DOM()->createElement("tr");

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c6;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5; border-top: 1px solid black;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c2; border-top: 1px solid black;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5; border-top: 1px solid black;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c1; border-top: 1px solid black;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5; border-top: 1px solid black;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c3; border-top: 1px solid black;");
  $td->setAttribute("colspan", "2");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5; border-top: 1px solid black;");
  $td->setAttribute("colspan", "4");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c4;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c7;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $table->appendChild($tr);


#       <tr>
#       <td style="padding: 1em; background-color: #$c6;">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c5;" colspan="18">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c7;">&nbsp;</td>
#       </tr>

  $tr = $this->DOM()->createElement("tr");

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c6;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c5;");
  $td->setAttribute("colspan", "18");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c7;");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $table->appendChild($tr);


#       <tr>
#       <td style="padding: 1em; background-color: #$c6;" colspan="10">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c7;" colspan="10">&nbsp;</td>
#       </tr>

  $tr = $this->DOM()->createElement("tr");

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c6;");
  $td->setAttribute("colspan", "10");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c7;");
  $td->setAttribute("colspan", "10");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $table->appendChild($tr);


#       <tr>
#       <td style="padding: 1em; background-color: #$c6;" colspan="10">&nbsp;</td>
#       <td style="padding: 1em; background-color: #$c7;" colspan="10">&nbsp;</td>
#       </tr>

  $tr = $this->DOM()->createElement("tr");

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c6;");
  $td->setAttribute("colspan", "10");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $td = $this->DOM()->createElement("td");
  $td->setAttribute("style", "padding: 1em; background-color: #$c7;");
  $td->setAttribute("colspan", "10");
  $td->appendTextNode(' ');
  $tr->appendChild($td);

  $table->appendChild($tr);
  $div->appendChild($table);

  return $div;
}

sub index_table {
  my $this  = shift;
  my ($c1, $c2, $c3, $c4, $c5, $c6, $c7) = @_;

  my $div = $this->DOM()->createElement("div");
  $div->setAttribute("class", "TableIndex");

  my $table = $this->DOM()->createElement("table");
  $table->setAttribute("style",  "font-size : small;  cellspacing: 2em;");

  my $tr = $this->DOM()->createElement("tr");
  my $th = $this->DOM()->createElement("th");
  my $tmp = Graphics::ColorObject->new_RGBhex("$c1", white_point => 'E');
  my ($red, $green, $blue) = @{ $tmp->as_RGB255() };
  my $color = (($red * 0.5 + $green + $blue * 0.3) > 220)? 'black' : 'white';
  $th->setAttribute("style", "padding: 1em; color: $color; background-color: #$c1;");
  $th->appendTextNode("#$c1");
  $tr->appendChild($th);

  $tmp = Graphics::ColorObject->new_RGBhex("$c2", white_point => 'E');
  ($red, $green, $blue) = @{ $tmp->as_RGB255() };
  $color = (($red * 0.5 + $green + $blue * 0.3) > 220)? 'black' : 'white';
  $th = $this->DOM()->createElement("th");
  $th->setAttribute("style", "padding: 1em; color: $color; background-color: #$c2;");
  $th->appendTextNode("#$c2");
  $tr->appendChild($th);

  $tmp = Graphics::ColorObject->new_RGBhex("$c3", white_point => 'E');
  ($red, $green, $blue) = @{ $tmp->as_RGB255() };
  $color = (($red * 0.5 + $green + $blue * 0.3) > 220)? 'black' : 'white';
  $th = $this->DOM()->createElement("th");
  $th->setAttribute("style", "padding: 1em; color: $color; background-color: #$c3;");
  $th->appendTextNode("#$c3");
  $tr->appendChild($th);

  $tmp = Graphics::ColorObject->new_RGBhex("$c4", white_point => 'E');
  ($red, $green, $blue) = @{ $tmp->as_RGB255() };
  $color = (($red * 0.5 + $green + $blue * 0.3) > 220)? 'black' : 'white';
  $th = $this->DOM()->createElement("th");
  $th->setAttribute("style", "padding: 1em; color: $color; background-color: #$c4;");
  $th->appendTextNode("#$c4");
  $tr->appendChild($th);

  $tmp = Graphics::ColorObject->new_RGBhex("$c5", white_point => 'E');
  ($red, $green, $blue) = @{ $tmp->as_RGB255() };
  $color = (($red * 0.5 + $green + $blue * 0.3) > 220)? 'black' : 'white';
  $th = $this->DOM()->createElement("th");
  $th->setAttribute("style", "padding: 1em; color: $color; background-color: #$c5;");
  $th->appendTextNode("#$c5");
  $tr->appendChild($th);

  $tmp = Graphics::ColorObject->new_RGBhex("$c6", white_point => 'E');
  ($red, $green, $blue) = @{ $tmp->as_RGB255() };
  $color = (($red * 0.5 + $green + $blue * 0.3) > 220)? 'black' : 'white';
  $th = $this->DOM()->createElement("th");
  $th->setAttribute("style", "padding: 1em; color: $color; background-color: #$c6;");
  $th->appendTextNode("#$c6");
  $tr->appendChild($th);

  $tmp = Graphics::ColorObject->new_RGBhex("$c7", white_point => 'E');
  ($red, $green, $blue) = @{ $tmp->as_RGB255() };
  $color = (($red * 0.5 + $green + $blue * 0.3) > 220)? 'black' : 'white';
  $th = $this->DOM()->createElement("th");
  $th->setAttribute("style", "padding: 1em; color: $color; background-color: #$c7;");
  $th->appendTextNode("#$c7");
  $tr->appendChild($th);

  $table->appendChild($tr);
  $div->appendChild($table);

  return $div;
}

sub rotate {
  my $this = shift;
  my $color= shift;
  my $angle= shift;
  my ($H, $S, $V)   = @{ $color->as_HSV() };
  my ($L, $C, $Hab) = @{ $color->as_LCHab() };
  my $Hr = $H + $angle;
  $Hr   -= 360 if $Hr > 360;
  $Hr   += 360 if $Hr < 0;
  my $temp = Graphics::ColorObject->new_HSV([$Hr, $S, $V], white_point => 'E');
  my ($Ln, $Cn, $Hn) = @{ $temp->as_LCHab() };
  warn "orig = $H, angle = $angle, rotated=$Hr, $Hab - > $Hn ";
  return
    Graphics::ColorObject->new_LCHab([$L, $C, $Hn],  white_point => 'E');
}

sub analogic{
  my $this = shift;
  my $angle= shift;

  my $div = $this->DOM()->createElement("div");
  $div->setAttribute("class", "analogic");

  my $header = $this->DOM()->createElement("h2");
  $header->setAttribute("class", "section");
  $header->appendTextNode("Analogic Scheme");
  $div->appendChild($header);
  my $para = $this->DOM()->createElement("p");
  $para->appendTextNode(<<EOTXT);
        This scheme is made by base color and its adjacent colors -
        two colors identically on both sides. It always looks very
        elegantly and clear, the result has less tension and it's
        uniformly warm, or cold. If a color on the warm-cold border is
        chosen, the color with opposite
EOTXT
  my $em = $this->DOM()->createElement("em");
  $em->appendTextNode("temperature");
  $para->appendChild($em);
  $para->appendTextNode(<<EOTXT2);
        may be used for accenting the other two colors. The distance
        of the adjacent colors from the primary color is up for
        experimentation, but values between 15 to 30 degrees are
        optimal. You can also add the contrast color, the scheme is
        then supplemented with the complement of the base color. It
        must be treated only as a complement - it adds tension to the
        palette, and it's too aggressive when overused. However, used
        in details and as accent of main colors, it can be very
        effective and elegant. The following is made with the
        separation $angle.
EOTXT2
  $div->appendChild($para);


  my ($r, $g, $b) = @{ $this->{color}->as_RGB255() };
  my ($L, $C, $H) = @{ $this->{color}->as_LCHab() };
  my $col1 = $this->{color}->as_RGBhex();

  ###################################################################
  my $temp_color = 
    Graphics::ColorObject->new_LCHab([($L < 100 ? $L + 20 : 100),
				      ($C < 170 ? $C + 30: 200),
				      $H],
				     white_point => 'E');
  my $col2 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$L, ($C > 30 ? $C -30 : 0), $H],
				     white_point => 'E');

  my $col3 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $L)/3, $C / 3, $H],
				     white_point => 'E');
  my $col4 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($L > 30 ? $L - 30 : 30),
				      ($C < 180 ? $C + 20: 200),
				      $H],
				     white_point => 'E');
  my $col5 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$L *2 /3, $C *2 /3, $H],
				     white_point => 'E');
  my $col6 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $L, 200 - $C, $H],
				     white_point => 'E');
  my $col7 = $temp_color->as_RGBhex();


  my $complementary =  $this->rotate($this->{color}, -1 * $angle);
  
  my $col8 = $complementary->as_RGBhex();
  my ($Lcomp, $Ccomp, $Hcomp) = @{ $complementary->as_LCHab() };

  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp < 60 ? $Lcomp + 40 : 100),
				      ($Ccomp < 170 ? $Ccomp + 30: 200),
				      $Hcomp],
				     white_point => 'E');
  my $col9 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp, ($Ccomp + 70), $Hcomp],
				     white_point => 'E');

  my $col10 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $Lcomp)/6, 
				      200 - (200 - $Ccomp)/ 6, $Hcomp],
				     white_point => 'E');
  my $col11 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp > 30 ? $Lcomp - 30 : 30),
				      ($Ccomp < 180 ? $Ccomp + 20: 200),
				      $Hcomp],
				     white_point => 'E');
  my $col12 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp * 2/3, ($Ccomp * 2 / 3 ), $Hcomp],
				     white_point => 'E');
  my $col13 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $Lcomp, 200 - $Ccomp, $Hcomp],
				     white_point => 'E');
  my $col14 = $temp_color->as_RGBhex();


  $complementary =  $this->rotate($this->{color}, $angle);

  my $col15 = $complementary->as_RGBhex();
  ($Lcomp, $Ccomp, $Hcomp) = @{ $complementary->as_LCHab() };

  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp < 60 ? $Lcomp + 40 : 100),
				      ($Ccomp < 170 ? $Ccomp + 30: 200),
				      $Hcomp],
				     white_point => 'E');
  my $col16 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp, ($Ccomp + 70), $Hcomp],
				     white_point => 'E');

  my $col17 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $Lcomp)/6, 
				      200 - (200 - $Ccomp)/ 6, $Hcomp],
				     white_point => 'E');
  my $col18 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp > 30 ? $Lcomp - 30 : 30),
				      ($Ccomp < 180 ? $Ccomp + 20: 200),
				      $Hcomp],
				     white_point => 'E');
  my $col19 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp * 2/3, ($Ccomp * 2 / 3 ), $Hcomp],
				     white_point => 'E');
  my $col20 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $Lcomp, 200 - $Ccomp, $Hcomp],
				     white_point => 'E');
  my $col21 = $temp_color->as_RGBhex();

  my $example = $this->col_table("$col1", "$col2", "$col3", "$col8", "$col9",
				 "$col15", "$col16");
  $div->appendChild($example);

  my $index = $this->index_table("$col1", "$col2", "$col3", "$col4", "$col5",
				 "$col6", "$col7");
  $div->appendChild($index);

  $index = $this->index_table("$col8", "$col9", "$col10", "$col11", "$col12",
				 "$col13", "$col14");
  $div->appendChild($index);

  $index = $this->index_table("$col15", "$col6", "$col17", "$col18", "$col19",
				 "$col20", "$col21");
  $div->appendChild($index);


  return $div;
}

sub double_contrast{
  my $this = shift;
  my $angle= shift;

  my $div = $this->DOM()->createElement("div");
  $div->setAttribute("class", "quad_tone");

  my $header = $this->DOM()->createElement("h2");
  $header->setAttribute("class", "section");
  $header->appendTextNode("Double Contrast");
  $div->appendChild($header);
  my $para = $this->DOM()->createElement("p");
  $para->appendTextNode(<<EOTXT);
        This is the next progression in the color chemes -- previous
        schemes used one, two, and three hues, in this one we use four
        - a pair of colors and their complements. A smaller distance
         between the colors leads to less tension in the result, but
         this is a very aggressive color scheme, and a great deal of
         care is required not to have the end result be garish and
         displeasing. The following was made with an separation angle
         $angle.
EOTXT
  $div->appendChild($para);




  my ($r, $g, $b) = @{ $this->{color}->as_RGB255() };
  my ($L, $C, $H) = @{ $this->{color}->as_LCHab() };
  my $col1 = $this->{color}->as_RGBhex();

  ###################################################################
  my $temp_color = 
    Graphics::ColorObject->new_LCHab([($L < 100 ? $L + 20 : 100),
				      ($C < 170 ? $C + 30: 200),
				      $H],
				     white_point => 'E');
  my $col2 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$L, ($C > 30 ? $C -30 : 0), $H],
				     white_point => 'E');

  my $col3 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $L)/3, $C / 3, $H],
				     white_point => 'E');
  my $col4 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($L > 30 ? $L - 30 : 30),
				      ($C < 180 ? $C + 20: 200),
				      $H],
				     white_point => 'E');
  my $col5 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$L *2 /3, $C *2 /3, $H],
				     white_point => 'E');
  my $col6 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $L, 200 - $C, $H],
				     white_point => 'E');
  my $col7 = $temp_color->as_RGBhex();


  my $complementary =  $this->rotate($this->{color}, $angle);
  my $col8 = $complementary->as_RGBhex();
  my ($Lcomp, $Ccomp, $Hcomp) = @{ $complementary->as_LCHab() };

  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp < 60 ? $Lcomp + 40 : 100),
				      ($Ccomp < 170 ? $Ccomp + 30: 200),
				      $Hcomp],
				     white_point => 'E');
  my $col9 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp, ($Ccomp + 70), $Hcomp],
				     white_point => 'E');

  my $col10 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $Lcomp)/6, 
				      200 - (200 - $Ccomp)/ 6, $Hcomp],
				     white_point => 'E');
  my $col11 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp > 30 ? $Lcomp - 30 : 30),
				      ($Ccomp < 180 ? $Ccomp + 20: 200),
				      $Hcomp],
				     white_point => 'E');
  my $col12 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp * 2/3, ($Ccomp * 2 / 3 ), $Hcomp],
				     white_point => 'E');
  my $col13 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $Lcomp, 200 - $Ccomp, $Hcomp],
				     white_point => 'E');
  my $col14 = $temp_color->as_RGBhex();


  $complementary =  $this->rotate($this->{color}, 180);

  my $col15 = $complementary->as_RGBhex();
  ($Lcomp, $Ccomp, $Hcomp) = @{ $complementary->as_LCHab() };

  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp < 60 ? $Lcomp + 40 : 100),
				      ($Ccomp < 170 ? $Ccomp + 30: 200),
				      $Hcomp],
				     white_point => 'E');
  my $col16 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp, ($Ccomp + 70), $Hcomp],
				     white_point => 'E');

  my $col17 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $Lcomp)/6, 
				      200 - (200 - $Ccomp)/ 6, $Hcomp],
				     white_point => 'E');
  my $col18 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp > 30 ? $Lcomp - 30 : 30),
				      ($Ccomp < 180 ? $Ccomp + 20: 200),
				      $Hcomp],
				     white_point => 'E');
  my $col19 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp * 2/3, ($Ccomp * 2 / 3 ), $Hcomp],
				     white_point => 'E');
  my $col20 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $Lcomp, 200 - $Ccomp, $Hcomp],
				     white_point => 'E');
  my $col21 = $temp_color->as_RGBhex();

  $complementary =  $this->rotate($this->{color}, 180 + $angle);
  my $col22 = $complementary->as_RGBhex();
  ($Lcomp, $Ccomp, $Hcomp) = @{ $complementary->as_LCHab() };

  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp < 60 ? $Lcomp + 40 : 100),
				      ($Ccomp < 170 ? $Ccomp + 30: 200),
				      $Hcomp],
				     white_point => 'E');
  my $col23 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp, ($Ccomp + 70), $Hcomp],
				     white_point => 'E');

  my $col24 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $Lcomp)/6, 
				      200 - (200 - $Ccomp)/ 6, $Hcomp],
				     white_point => 'E');
  my $col25 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp > 30 ? $Lcomp - 30 : 30),
				      ($Ccomp < 180 ? $Ccomp + 20: 200),
				      $Hcomp],
				     white_point => 'E');
  my $col26 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp * 2/3, ($Ccomp * 2 / 3 ), $Hcomp],
				     white_point => 'E');
  my $col27 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $Lcomp, 200 - $Ccomp, $Hcomp],
				     white_point => 'E');
  my $col28 = $temp_color->as_RGBhex();

  my $example = $this->col_table("$col1", "$col2", "$col8", "$col9",
				 "$col15", "$col16", "$col22");
  $div->appendChild($example);

  my $index = $this->index_table("$col1", "$col2", "$col3", "$col4", "$col5",
				 "$col6", "$col7");
  $div->appendChild($index);

  $index = $this->index_table("$col8", "$col9", "$col10", "$col11", "$col12",
				 "$col13", "$col14");
  $div->appendChild($index);

  $index = $this->index_table("$col15", "$col6", "$col17", "$col18", "$col19",
				 "$col20", "$col21");
  $div->appendChild($index);

  $index = $this->index_table("$col22", "$col23", "$col24", "$col25", "$col26",
				 "$col27", "$col28");
  $div->appendChild($index);




  $header = $this->DOM()->createElement("h3");
  $header->setAttribute("class", "section");
  $header->appendTextNode("The Tetrade");
  $div->appendChild($header);
  $para = $this->DOM()->createElement("p");
  $para->appendTextNode(<<EOTXT2);
        This color scheme, like the triade, is a set of colors
        equidistant from each other on the color wheel. Since this
        scheme uses four colors, they are 90 degrees apart. The
        tetrade is very aggressive color scheme, requiring very good
        planning and very sensitive approach to relations of these
        colors.
EOTXT2
  $div->appendChild($para);

  $angle = 90;

  $complementary =  $this->rotate($this->{color}, $angle);

  $col8 = $complementary->as_RGBhex();
  ($Lcomp, $Ccomp, $Hcomp) = @{ $complementary->as_LCHab() };

  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp < 60 ? $Lcomp + 40 : 100),
				      ($Ccomp < 170 ? $Ccomp + 30: 200),
				      $Hcomp],
				     white_point => 'E');
  $col9 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp, ($Ccomp + 70), $Hcomp],
				     white_point => 'E');

  $col10 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $Lcomp)/6, 
				      200 - (200 - $Ccomp)/ 6, $Hcomp],
				     white_point => 'E');
  $col11 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp > 30 ? $Lcomp - 30 : 30),
				      ($Ccomp < 180 ? $Ccomp + 20: 200),
				      $Hcomp],
				     white_point => 'E');
  $col12 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp * 2/3, ($Ccomp * 2 / 3 ), $Hcomp],
				     white_point => 'E');
  $col13 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $Lcomp, 200 - $Ccomp, $Hcomp],
				     white_point => 'E');
  $col14 = $temp_color->as_RGBhex();


  $complementary =  $this->rotate($this->{color}, 180);
  $col15 = $complementary->as_RGBhex();
  ($Lcomp, $Ccomp, $Hcomp) = @{ $complementary->as_LCHab() };

  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp < 60 ? $Lcomp + 40 : 100),
				      ($Ccomp < 170 ? $Ccomp + 30: 200),
				      $Hcomp],
				     white_point => 'E');
  $col16 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp, ($Ccomp + 70), $Hcomp],
				     white_point => 'E');

  $col17 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $Lcomp)/6, 
				      200 - (200 - $Ccomp)/ 6, $Hcomp],
				     white_point => 'E');
  $col18 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp > 30 ? $Lcomp - 30 : 30),
				      ($Ccomp < 180 ? $Ccomp + 20: 200),
				      $Hcomp],
				     white_point => 'E');
  $col19 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp * 2/3, ($Ccomp * 2 / 3 ), $Hcomp],
				     white_point => 'E');
  $col20 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $Lcomp, 200 - $Ccomp, $Hcomp],
				     white_point => 'E');
  $col21 = $temp_color->as_RGBhex();

  $complementary =  $this->rotate($this->{color}, 180 + $angle);
  $col22 = $complementary->as_RGBhex();
  ($Lcomp, $Ccomp, $Hcomp) = @{ $complementary->as_LCHab() };

  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp < 60 ? $Lcomp + 40 : 100),
				      ($Ccomp < 170 ? $Ccomp + 30: 200),
				      $Hcomp],
				     white_point => 'E');
  $col23 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp, ($Ccomp + 70), $Hcomp],
				     white_point => 'E');

  $col24 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $Lcomp)/6, 
				      200 - (200 - $Ccomp)/ 6, $Hcomp],
				     white_point => 'E');
  $col25 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp > 30 ? $Lcomp - 30 : 30),
				      ($Ccomp < 180 ? $Ccomp + 20: 200),
				      $Hcomp],
				     white_point => 'E');
  $col26 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp * 2/3, ($Ccomp * 2 / 3 ), $Hcomp],
				     white_point => 'E');
  $col27 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $Lcomp, 200 - $Ccomp, $Hcomp],
				     white_point => 'E');
  $col28 = $temp_color->as_RGBhex();

  $example = $this->col_table("$col1", "$col2", "$col8", "$col9",
				 "$col15", "$col16", "$col22");
  $div->appendChild($example);

  $index = $this->index_table("$col1", "$col2", "$col3", "$col4", "$col5",
				 "$col6", "$col7");
  $div->appendChild($index);

  $index = $this->index_table("$col8", "$col9", "$col10", "$col11", "$col12",
				 "$col13", "$col14");
  $div->appendChild($index);

  $index = $this->index_table("$col15", "$col6", "$col17", "$col18", "$col19",
				 "$col20", "$col21");
  $div->appendChild($index);

  $index = $this->index_table("$col22", "$col23", "$col24", "$col25", "$col26",
				 "$col27", "$col28");
  $div->appendChild($index);



  return $div;
}


sub split_complementary{
  my $this = shift;
  my $angle= shift;

  my $div = $this->DOM()->createElement("div");
  $div->setAttribute("class", "duotone");

  my $header = $this->DOM()->createElement("h2");
  $header->setAttribute("class", "section");
  $header->appendTextNode("Split Complementary");
  $div->appendChild($header);
  my $para = $this->DOM()->createElement("p");
  $para->appendTextNode(<<EOTXT);
        This scheme is based on using the base color, supplemented by
        two colors, placed equidistantly on either side of the
        complementary color.  Unlike the sharp cpntrasts of the
        complementrary scheme, this schemeis often more comfortable
        for the eyes, it's softer, and has more space for balancing
        warm and cold colors.
EOTXT
  $div->appendChild($para);
  $para = $this->DOM()->createElement("p");
  $para->appendTextNode(<<EOTXT1);
        One variation one can experiment with is how far apart from
        the complementary color are the colors selected. A separatrion
        of 0 degrees degenerates to the complementary scheme, the best
        results are usually 15 to 30 degrees from the complementary
        color. The table below has a separation of $angle.
EOTXT1
  $div->appendChild($para);

  my ($r, $g, $b) = @{ $this->{color}->as_RGB255() };
  my ($L, $C, $H) = @{ $this->{color}->as_LCHab() };
  my $col1 = $this->{color}->as_RGBhex();

  ###################################################################
  my $temp_color = 
    Graphics::ColorObject->new_LCHab([($L < 100 ? $L + 20 : 100),
				      ($C < 170 ? $C + 30: 200),
				      $H],
				     white_point => 'E');
  my $col2 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$L, ($C > 30 ? $C -30 : 0), $H],
				     white_point => 'E');

  my $col3 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $L)/3, $C / 3, $H],
				     white_point => 'E');
  my $col4 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($L > 30 ? $L - 30 : 30),
				      ($C < 180 ? $C + 20: 200),
				      $H],
				     white_point => 'E');
  my $col5 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$L *2 /3, $C *2 /3, $H],
				     white_point => 'E');
  my $col6 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $L, 200 - $C, $H],
				     white_point => 'E');
  my $col7 = $temp_color->as_RGBhex();


  my $complementary =  $this->rotate($this->{color}, 180 - $angle);

  my $col8 = $complementary->as_RGBhex();
  my ($Lcomp, $Ccomp, $Hcomp) = @{ $complementary->as_LCHab() };

  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp < 60 ? $Lcomp + 40 : 100),
				      ($Ccomp < 170 ? $Ccomp + 30: 200),
				      $Hcomp],
				     white_point => 'E');
  my $col9 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp, ($Ccomp + 70), $Hcomp],
				     white_point => 'E');

  my $col10 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $Lcomp)/6, 
				      200 - (200 - $Ccomp)/ 6, $Hcomp],
				     white_point => 'E');
  my $col11 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp > 30 ? $Lcomp - 30 : 30),
				      ($Ccomp < 180 ? $Ccomp + 20: 200),
				      $Hcomp],
				     white_point => 'E');
  my $col12 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp * 2/3, ($Ccomp * 2 / 3 ), $Hcomp],
				     white_point => 'E');
  my $col13 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $Lcomp, 200 - $Ccomp, $Hcomp],
				     white_point => 'E');
  my $col14 = $temp_color->as_RGBhex();


  $complementary =  $this->rotate($this->{color}, 180 + $angle);
  my $col15 = $complementary->as_RGBhex();
  ($Lcomp, $Ccomp, $Hcomp) = @{ $complementary->as_LCHab() };

  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp < 60 ? $Lcomp + 40 : 100),
				      ($Ccomp < 170 ? $Ccomp + 30: 200),
				      $Hcomp],
				     white_point => 'E');
  my $col16 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp, ($Ccomp + 70), $Hcomp],
				     white_point => 'E');

  my $col17 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $Lcomp)/6, 
				      200 - (200 - $Ccomp)/ 6, $Hcomp],
				     white_point => 'E');
  my $col18 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp > 30 ? $Lcomp - 30 : 30),
				      ($Ccomp < 180 ? $Ccomp + 20: 200),
				      $Hcomp],
				     white_point => 'E');
  my $col19 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp * 2/3, ($Ccomp * 2 / 3 ), $Hcomp],
				     white_point => 'E');
  my $col20 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $Lcomp, 200 - $Ccomp, $Hcomp],
				     white_point => 'E');
  my $col21 = $temp_color->as_RGBhex();

  my $example = $this->col_table("$col1", "$col2", "$col3", "$col8", "$col9",
				 "$col15", "$col16");
  $div->appendChild($example);

  my $index = $this->index_table("$col1", "$col2", "$col3", "$col4", "$col5",
				 "$col6", "$col7");
  $div->appendChild($index);

  $index = $this->index_table("$col8", "$col9", "$col10", "$col11", "$col12",
				 "$col13", "$col14");
  $div->appendChild($index);

  $index = $this->index_table("$col15", "$col6", "$col17", "$col18", "$col19",
				 "$col20", "$col21");
  $div->appendChild($index);


  $header = $this->DOM()->createElement("h3");
  $header->setAttribute("class", "section");
  $header->appendTextNode("The Triade");
  $div->appendChild($header);
  $para = $this->DOM()->createElement("p");
  $para->appendTextNode(<<EOTXT2);
        This color scheme is just the split complementary scheme with
        the separation equal to 60 degrees.  As you can see, this
        reults in three colors equidistant from each other on the
        color wheel (120 degrees apart), and is very pleasing to the
        eye. The triade-schemes are vibrant, full of energy, and have
        large amount of leeway to find contrasts, accents and to
        balance warm and cold colors.  Again, monochromatic variations
        of these colors can be used.
EOTXT2
  $div->appendChild($para);

  $angle = 60;
  $complementary =  $this->rotate($this->{color}, 180 - $angle);
  $col8 = $complementary->as_RGBhex();
  ($Lcomp, $Ccomp, $Hcomp) = @{ $complementary->as_LCHab() };

  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp < 60 ? $Lcomp + 40 : 100),
				      ($Ccomp < 170 ? $Ccomp + 30: 200),
				      $Hcomp],
				     white_point => 'E');
  $col9 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp, ($Ccomp + 70), $Hcomp],
				     white_point => 'E');

  $col10 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $Lcomp)/6, 
				      200 - (200 - $Ccomp)/ 6, $Hcomp],
				     white_point => 'E');
  $col11 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp > 30 ? $Lcomp - 30 : 30),
				      ($Ccomp < 180 ? $Ccomp + 20: 200),
				      $Hcomp],
				     white_point => 'E');
  $col12 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp * 2/3, ($Ccomp * 2 / 3 ), $Hcomp],
				     white_point => 'E');
  $col13 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $Lcomp, 200 - $Ccomp, $Hcomp],
				     white_point => 'E');
  $col14 = $temp_color->as_RGBhex();


  $complementary =  $this->rotate($this->{color}, 180 + $angle);
  $col15 = $complementary->as_RGBhex();
  ($Lcomp, $Ccomp, $Hcomp) = @{ $complementary->as_LCHab() };

  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp < 60 ? $Lcomp + 40 : 100),
				      ($Ccomp < 170 ? $Ccomp + 30: 200),
				      $Hcomp],
				     white_point => 'E');
  $col16 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp, ($Ccomp + 70), $Hcomp],
				     white_point => 'E');

  $col17 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $Lcomp)/6, 
				      200 - (200 - $Ccomp)/ 6, $Hcomp],
				     white_point => 'E');
  $col18 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp > 30 ? $Lcomp - 30 : 30),
				      ($Ccomp < 180 ? $Ccomp + 20: 200),
				      $Hcomp],
				     white_point => 'E');
  $col19 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp * 2/3, ($Ccomp * 2 / 3 ), $Hcomp],
				     white_point => 'E');
  $col20 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $Lcomp, 200 - $Ccomp, $Hcomp],
				     white_point => 'E');
  $col21 = $temp_color->as_RGBhex();

  $example = $this->col_table("$col1", "$col2", "$col3", "$col8", "$col9",
				 "$col15", "$col16");
  $div->appendChild($example);

  $index = $this->index_table("$col1", "$col2", "$col3", "$col4", "$col5",
				 "$col6", "$col7");
  $div->appendChild($index);

  $index = $this->index_table("$col8", "$col9", "$col10", "$col11", "$col12",
				 "$col13", "$col14");
  $div->appendChild($index);

  $index = $this->index_table("$col15", "$col6", "$col17", "$col18", "$col19",
				 "$col20", "$col21");
  $div->appendChild($index);

  return $div;
}

sub complementary{
  my $this = shift;

  my $div = $this->DOM()->createElement("div");
  $div->setAttribute("class", "complementary");

  my $header = $this->DOM()->createElement("h2");
  $header->setAttribute("class", "section");
  $header->appendTextNode("Complementary");

  $div->appendChild($header);
  my $para = $this->DOM()->createElement("p");
  $para->appendTextNode(<<EOTXT);
        In this scheme, the base color is used in conjunction with the
        color from the opposite side of the color wheel -- its
        complementary color. So one warm and one cold color is always
        created. Suitable monochromatic variations of the base color
        and the complementary color can be added to the
        scheme. Judicious use of saturation and value variations allow
        us to chose whether the warm or the cold color shall be
        dominant.  
EOTXT
  $div->appendChild($para);


  my ($r, $g, $b) = @{ $this->{color}->as_RGB255() };
  my ($L, $C, $H) = @{ $this->{color}->as_LCHab() };
  my $col1 = $this->{color}->as_RGBhex();

  ###################################################################
  my $temp_color = 
    Graphics::ColorObject->new_LCHab([($L < 80 ? $L + 20 : 100),
				      ($C < 170 ? $C + 30: 200),
				      $H],
				     white_point => 'E');
  my $col2 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$L, ($C > 30 ? $C -30 : 0), $H],
				     white_point => 'E');

  my $col3 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $L)/3, $C / 3, $H],
				     white_point => 'E');
  my $col4 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($L > 30 ? $L - 30 : 30),
				      ($C < 180 ? $C + 20: 200),
				      $H],
				     white_point => 'E');
  my $col5 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$L *2 /3, $C *2 /3, $H],
				     white_point => 'E');
  my $col6 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $L, 200 - $C, $H],
				     white_point => 'E');
  my $col7 = $temp_color->as_RGBhex();


  my $complementary =  $this->rotate($this->{color}, 180);

  my $col8 = $complementary->as_RGBhex();
  my ($Lcomp, $Ccomp, $Hcomp) = @{ $complementary->as_LCHab() };

  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp < 60 ? $Lcomp + 40 : 100),
				      ($Ccomp < 170 ? $Ccomp + 30: 200),
				      $Hcomp],
				     white_point => 'E');
  my $col9 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp, ($Ccomp + 70), $Hcomp],
				     white_point => 'E');

  my $col10 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $Lcomp)/6, 
				      200 - (200 - $Ccomp)/ 6, $Hcomp],
				     white_point => 'E');
  my $col11 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($Lcomp > 30 ? $Lcomp - 30 : 30),
				      ($Ccomp < 180 ? $Ccomp + 20: 200),
				      $Hcomp],
				     white_point => 'E');
  my $col12 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$Lcomp * 2/3, ($Ccomp * 2 / 3 ), $Hcomp],
				     white_point => 'E');
  my $col13 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $Lcomp, 200 - $Ccomp, $Hcomp],
				     white_point => 'E');
  my $col14 = $temp_color->as_RGBhex();

  my $example = $this->col_table("$col1", "$col2", "$col3", "$col4", "$col8",
				 "$col9", "$col10");
  $div->appendChild($example);

  my $index = $this->index_table("$col1", "$col2", "$col3", "$col4", "$col5",
				 "$col6", "$col7");
  $div->appendChild($index);

  $index = $this->index_table("$col8", "$col9", "$col10", "$col11", "$col12",
				 "$col13", "$col14");
  $div->appendChild($index);
  return $div;
}



sub monotone{
  my $this = shift;


  my $div = $this->DOM()->createElement("div");
  $div->setAttribute("class", "monotone");
  my $header = $this->DOM()->createElement("h2");
  $header->setAttribute("class", "section");
  $header->appendTextNode("Monotone");
  $div->appendChild($header);
  my $para = $this->DOM()->createElement("p");
  $para->appendTextNode(<<EOTXT);
        The Monochromatic scheme is based on only a single color tint
        (hue), and uses only variations made by changing its
        saturation and brightness. The result is comfortable for eyes,
        even when using aggressive variations in saturation and
        brightness. However, it is harder to find accents and
        highlights.
EOTXT
  $div->appendChild($para);

  my ($r, $g, $b) = @{ $this->{color}->as_RGB255() };
  my ($L, $C, $H) = @{ $this->{color}->as_LCHab() };
  my $col1 = $this->{color}->as_RGBhex();

  ###################################################################
  my $temp_color = 
    Graphics::ColorObject->new_LCHab([($L < 100 ? $L + 20 : 100),
				      ($C < 170 ? $C + 30: 200),
				      $H],
				     white_point => 'E');
  my $col2 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$L, ($C > 30 ? $C -30 : 0), $H],
				     white_point => 'E');

  my $col3 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - (100 - $L)/3, $C / 3, $H],
				     white_point => 'E');
  my $col4 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([($L > 30 ? $L - 30 : 30),
				      ($C < 180 ? $C + 20: 200),
				      $H],
				     white_point => 'E');
  my $col5 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([$L *2 /3, $C *2 /3, $H],
				     white_point => 'E');
  my $col6 = $temp_color->as_RGBhex();
  ###################################################################
  $temp_color = 
    Graphics::ColorObject->new_LCHab([100 - $L, 200 - $C, $H],
				     white_point => 'E');
  my $col7 = $temp_color->as_RGBhex();


#  my $example = $this->col_table("c1d6ff", "e0ebff", "eff5ff", "d1d6df",
#				 "8e98aa", "474c55", "a8b0bf");
  my $example = $this->col_table("$col1", "$col2", "$col3", "$col4", "$col5",
				 "$col6", "$col7");
  $div->appendChild($example);

  my $index = $this->index_table("$col1", "$col2", "$col3", "$col4", "$col5",
				 "$col6", "$col7");
  $div->appendChild($index);
  return $div;
}

sub color_schemes {
  my $this  = shift;
  my $div   = $this->DOM()->createElement("div");
  $div->setAttribute("class", "introduction");
  my $header = $this->DOM()->createElement("h1");
  $header->setAttribute("class", "section");
  $header->appendTextNode("Color Schemes");
  $div->appendChild($header);
  my $monotone  = $this->monotone();
  my $duotone   = $this->complementary();
  my $tri_tone  = $this->split_complementary(20);
  my $quad_tone = $this->double_contrast(20);
  my $analogic  = $this->analogic(25);
  $div->appendChild($monotone);
  $div->appendChild($duotone);
  $div->appendChild($tri_tone);
  $div->appendChild($quad_tone);
  $div->appendChild($analogic);
  return $div;
}

sub text_color {
  my $this = shift;
  my %params = @_;

  my ($r, $g, $b) = @{ $this->{color}->as_RGB255() };
  my $text_col = $r * 0.5 + $g + $b * 0.3;
  return $text_col > 220 ? 'black' : 'white';
}

sub non_chromatic_variation {
  my $this  = shift;
  my ($r, $g, $b) = @{ $this->{color}->as_RGB255() };
  my ($L, $C, $H) = @{ $this->{color}->as_LCHab() };
  my $col =$this->{color}->as_RGBhex();
  my $div      = $this->DOM()->createElement("div");
  $div->setAttribute("class", "huesat");


  my $header = $this->DOM()->createElement("h3");
  $header->setAttribute("class", "section");
  $header->appendTextNode("Lightness and Chroma variation");
  $div->appendChild($header);
  my $para = $this->DOM()->createElement("p");
  $para->appendTextNode(<<EOTXT3);
        Let us look at this Hue in a little more detail. Playing with
        lightness and chroma, we get the following figure.  Each cell
        in that table is evenly separated, perceptually, from its
        neighbors. The X marks the color selected.
EOTXT3
  $div->appendChild($para);

  #my @numc = (1, 6, 11, 16, 21, 21, 16, 11, 6, 1);
  my @numc = (1, 4, 7, 10, 13, 16, 19, 22, 22, 19, 18, 17);

  my $chue = $H + 180;
  $chue -= 360 if $chue > 360;

  my $complementary =  Graphics::ColorObject->new_LCHab([100, 100, $chue],
					   white_point => 'E');
  my $chex = $complementary->as_RGBhex();

  my $Lupper = 100 - $L;
  my $Lunum = int ($Lupper / 10);
  my $Llnum = int ($L / 10 );
  
  my $Cupper = 200 - $C;
  my $Cunum = int ($Cupper / 10);
  my $Clnum = int ($C / 10 );

  my $table = $this->DOM()->createElement("table");
  $table->setAttribute
    ("style", 
     "width: 80%; font-size : x-small; border: 1em; padding: 4ex; cellspacing: 2em;");
  my $tr;
  my $td;
  my $th;
  $tr = $this->DOM()->createElement("tr");
  $th = $this->DOM()->createElement("th");
  $th->setAttribute("style", "padding: 1em; background-color: #D1D6DF;");
  $th->appendTextNode('L');
  $tr->appendChild($th);

  $th = $this->DOM()->createElement("th");
  $th->setAttribute("style", "padding: 1em;");
  $th->setAttribute("colspan", "20");
  $th->appendTextNode(' ');
  $tr->appendChild($th);

  $table->appendChild($tr);

  {
    $tr = $this->DOM()->createElement("tr");

    $th = $this->DOM()->createElement("th");
    $th->setAttribute("style", "padding: 1em; background-color: #D1D6DF;");
    $th->appendTextNode("100");
    $tr->appendChild($th);
    for (my $j = $Clnum; $j>0; $j--) {
      $td = $this->DOM()->createElement("td");
      if (int($C / 10) - $j < $numc[11]) {
	my $background = 
	  Graphics::ColorObject->new_LCHab([100, $C - 10 * $j, $H],
					   white_point => 'E');
	my $bgcol = $background->as_RGBhex();
	$td->setAttribute("style", "padding: 1em; background-color: #$bgcol;");
      }
      $td->appendTextNode(' ');
      $tr->appendChild($td);
    }
    {
      $td = $this->DOM()->createElement("td");
      if (int($C / 10) < $numc[11]) {
	my $background = 
	  Graphics::ColorObject->new_LCHab([100, $C, $H],
					   white_point => 'E');
	my $bgcol = $background->as_RGBhex();
	$td->setAttribute("style", "padding: 1em; border-left: 1px solid; border-right: 1px solid; border-color: #$chex; background-color: #$bgcol;");
      }
      $td->appendTextNode(' ');
      $tr->appendChild($td);
    }
    for my $j (1..$Cunum) {
      $td = $this->DOM()->createElement("td");
      if (int($C / 10) + $j < $numc[11]) {
	my $background = 
	  Graphics::ColorObject->new_LCHab([100, $C + 10 * $j, $H],
					   white_point => 'E');
	my $bgcol = $background->as_RGBhex();
	$td->setAttribute("style", "padding: 1em; background-color: #$bgcol;");
      }
      $td->appendTextNode(' ');
      $tr->appendChild($td);
    }
    $table->appendChild($tr);
  }

  for (my $i = $Lunum; $i>0; $i--) {
    $tr = $this->DOM()->createElement("tr");

    $th = $this->DOM()->createElement("th");
    $th->setAttribute("style", "padding: 1em; background-color: #D1D6DF;");
    $th->appendTextNode(sprintf ("%3.0f", $L + 10 * $i));
    $tr->appendChild($th);
    for (my $j = $Clnum; $j>0; $j--) {
      $td = $this->DOM()->createElement("td");
      if (int($C / 10) - $j < $numc[1 + int($L / 10) + $i]) {
	my $background = 
	  Graphics::ColorObject->new_LCHab([$L + 10 * $i, $C - 10 * $j, $H],
					   white_point => 'E');
	my $bgcol = $background->as_RGBhex();
	$td->setAttribute("style", "padding: 1em; background-color: #$bgcol;");
      }
      $td->appendTextNode(' ');
      $tr->appendChild($td);
    }
    {
      $td = $this->DOM()->createElement("td");
      if (int($C / 10) < $numc[1 + int($L / 10) + $i]) {
	my $background = 
	  Graphics::ColorObject->new_LCHab([$L + 10 * $i, $C, $H],
					   white_point => 'E');
	my $bgcol = $background->as_RGBhex();
	$td->setAttribute("style", "padding: 1em; border-left: 1px solid; border-right: 1px solid; border-color: #$chex; background-color: #$bgcol;");
      }
      $td->appendTextNode(' ');
      $tr->appendChild($td);
    }
    for my $j (1..$Cunum) {
      $td = $this->DOM()->createElement("td");
      if (int($C / 10) + $j < $numc[1 + int($L / 10) + $i]) {
	my $background = 
	  Graphics::ColorObject->new_LCHab([$L + 10 * $i, $C + 10 * $j, $H],
					   white_point => 'E');
	my $bgcol = $background->as_RGBhex();
	$td->setAttribute("style", "padding: 1em; background-color: #$bgcol;");
      }
      $td->appendTextNode(' ');
      $tr->appendChild($td);
    }
    $table->appendChild($tr);
  }
  $tr = $this->DOM()->createElement("tr");
  $th = $this->DOM()->createElement("th");
  $th->setAttribute("style", "padding: 1em; background-color: #D1D6DF;");
  $th->appendTextNode(sprintf ("%3.0f", $L));
  $tr->appendChild($th);
  for (my $j = $Clnum; $j>0; $j--) {
    $td = $this->DOM()->createElement("td");
    if (int($C / 10) - $j < $numc[1 + int($L / 10)]) {
      my $background = 
	Graphics::ColorObject->new_LCHab([$L, $C - 10 * $j, $H],
					 white_point => 'E');
      my $bgcol = $background->as_RGBhex();
      $td->setAttribute("style", "padding: 1em; border-top: 1px solid; border-bottom: 1px solid; border-color: #$chex; background-color: #$bgcol;");
    }
    $td->appendTextNode(' ');
    $tr->appendChild($td);
  }
  {
    $td = $this->DOM()->createElement("td");
    if (int($C / 10) < $numc[1 + int($L / 10)]) {
      my $background = 
	Graphics::ColorObject->new_LCHab([$L, $C, $H],
					 white_point => 'E');
      my $bgcol = $background->as_RGBhex();
      my $text_color = $this->text_color();
      $td->setAttribute("style", "padding: 1em; border: 1px solid; border-color: #$chex; background-color: #$bgcol; color: $text_color; text-align: center;");
    }
    $td->appendTextNode('X');
    $tr->appendChild($td);
  }
  for my $j (1..$Cunum) {
    $td = $this->DOM()->createElement("td");
    if (int($C / 10) + $j < $numc[1 + int($L / 10)]) {
      my $background = 
	Graphics::ColorObject->new_LCHab([$L, $C + 10 * $j, $H],
					 white_point => 'E');
      my $bgcol = $background->as_RGBhex();
      $td->setAttribute("style", "padding: 1em; border-top: 1px solid; border-bottom: 1px solid; border-color: #$chex; background-color: #$bgcol;");
    }
    $td->appendTextNode(' ');
    $tr->appendChild($td);
  }
  $table->appendChild($tr);
  for my $i (1..$Llnum) {
    $tr = $this->DOM()->createElement("tr");
    $th = $this->DOM()->createElement("th");
    $th->setAttribute("style", "padding: 1em; background-color: #D1D6DF;");
    $th->appendTextNode(sprintf ("%3.0f", $L - 10 * $i));
    $tr->appendChild($th);
    for (my $j = $Clnum; $j>0; $j--) {
      $td = $this->DOM()->createElement("td");
      if (int($C / 10) - $j < $numc[1 + int($L / 10) - $i]) {
	my $background = 
	  Graphics::ColorObject->new_LCHab([$L - 10 * $i, $C - 10 * $j, $H],
					   white_point => 'E');
	my $bgcol = $background->as_RGBhex();
	$td->setAttribute("style", "padding: 1em; background-color: #$bgcol;");
      }
      $td->appendTextNode(' ');
      $tr->appendChild($td);
    }
    {
      $td = $this->DOM()->createElement("td");
      if (int($C / 10) < $numc[1 + int($L / 10) - $i]) {
	my $background = 
	  Graphics::ColorObject->new_LCHab([$L - 10 * $i, $C, $H],
					   white_point => 'E');
	my $bgcol = $background->as_RGBhex();
	$td->setAttribute("style", "padding: 1em; border-left: 1px solid; border-right: 1px solid; border-color: #$chex; background-color: #$bgcol;");
      }
      $td->appendTextNode(' ');
      $tr->appendChild($td);
    }
    for my $j (1..$Cunum) {
      $td = $this->DOM()->createElement("td");
      if (int($C / 10) + $j < $numc[1 + int($L / 10) - $i]) {
	my $background = 
	  Graphics::ColorObject->new_LCHab([$L - 10 * $i, $C + 10 * $j, $H],
					   white_point => 'E');
	my $bgcol = $background->as_RGBhex();
	$td->setAttribute("style", "padding: 1em; background-color: #$bgcol;");
      }
      $td->appendTextNode(' ');
      $tr->appendChild($td);
    }
    $table->appendChild($tr);
  }

  {
    $tr = $this->DOM()->createElement("tr");

    $th = $this->DOM()->createElement("th");
    $th->setAttribute("style", "padding: 1em; background-color: #D1D6DF;");
    $th->appendTextNode("0");
    $tr->appendChild($th);
    for (my $j = $Clnum; $j>0; $j--) {
      $td = $this->DOM()->createElement("td");
      if (int($C / 10) - $j < $numc[0]) {
	my $background = 
	  Graphics::ColorObject->new_LCHab([0, $C - 10 * $j, $H],
					   white_point => 'E');
	my $bgcol = $background->as_RGBhex();
	$td->setAttribute("style", "padding: 1em; background-color: #$bgcol;");
      }
      $td->appendTextNode(' ');
      $tr->appendChild($td);
    }
    {
      $td = $this->DOM()->createElement("td");
      if (int($C / 10) < $numc[0]) {
	my $background = 
	  Graphics::ColorObject->new_LCHab([0, $C, $H],
					   white_point => 'E');
	my $bgcol = $background->as_RGBhex();
	$td->setAttribute("style", "padding: 1em; border-left: 1px solid; border-right: 1px solid; border-color: #$chex; background-color: #$bgcol;");
      }
      $td->appendTextNode(' ');
      $tr->appendChild($td);
    }
    for my $j (1..$Cunum) {
      $td = $this->DOM()->createElement("td");
      if (int($C / 10) + $j < $numc[0]) {
	my $background = 
	  Graphics::ColorObject->new_LCHab([0, $C + 10 * $j, $H],
					   white_point => 'E');
	my $bgcol = $background->as_RGBhex();
	$td->setAttribute("style", "padding: 1em; background-color: #$bgcol;");
      }
      $td->appendTextNode(' ');
      $tr->appendChild($td);
    }
    $table->appendChild($tr);
  }



  $tr = $this->DOM()->createElement("tr");
  $th = $this->DOM()->createElement("th");
  $th->setAttribute("style", "padding: 1em; background-color: #D1D6DF;");
  $th->appendTextNode("C");
  $tr->appendChild($th);

  for (my $j = $Clnum; $j>0; $j--) {
    $th = $this->DOM()->createElement("th");
    $th->setAttribute("style", "padding: 1em; background-color: #D1D6DF;");
    $th->appendTextNode(sprintf ("%3.0f", $C - 10 * $j));
    $tr->appendChild($th);
  }
  {
    $th = $this->DOM()->createElement("th");
    $th->setAttribute("style", "padding: 1em; background-color: #D1D6DF;");
    $th->appendTextNode(sprintf ("%3.0f", $C));
    $tr->appendChild($th);
  }
  for my $j (1..$Cunum) {
    $th = $this->DOM()->createElement("th");
    $th->setAttribute("style", "padding: 1em; background-color: #D1D6DF;");
    $th->appendTextNode(sprintf ("%3.0f", $C + 10 * $j));
    $tr->appendChild($th);
  }


  $table->appendChild($tr);

  $div->appendChild($table);
  return $div;
}

sub introduction {
  my $this  = shift;
  my ($r, $g, $b) = @{ $this->{color}->as_RGB255() };
  my ($L, $C, $H) = @{ $this->{color}->as_LCHab() };
  my $col = sprintf "#%02x%02x%02x", $r, $g, $b;
  chomp($col);
  my $div      = $this->DOM()->createElement("div");
  $div->setAttribute("class", "introduction");

  my $intro = $this->DOM()->createElement("p");
  my $txt =<<EOF;
        You have selected the color $col (or, if you prefer, the
        familiar RGB triplet:
EOF
  $intro->appendTextNode("$txt");

  my $span = $this->DOM()->createElement("span");
  $span->setAttribute("style", "color: red;");
  $span->appendTextNode("           $r");
  $intro->appendChild($span);
  $intro->appendTextNode("           , ");

  $span = $this->DOM()->createElement("span");
  $span->setAttribute("style", "color: green;");
  $span->appendTextNode("           $g");
  $intro->appendChild($span);
  $intro->appendTextNode("           , ");

  $span = $this->DOM()->createElement("span");
  $span->setAttribute("style", "color: blue;");
  $span->appendTextNode("           $b");
  $intro->appendChild($span);
  $intro->appendTextNode("           ).");

  $div->appendChild($intro);

  $intro = $this->DOM()->createElement("p");
  my $strong = $this->DOM()->createElement("strong");
  $strong->appendTextNode("CIE LCh");
  my $sub = $this->DOM()->createElement("sub");
  $sub->appendTextNode("ab");
  $strong->appendChild($sub);
  $intro->appendChild($strong);
$txt =<<EOF;
        Alternately, you can represent this color in a color space 
 often referred to simply as LCH. The system is the same as the CIELab
 color space, except that it describes the location of a color in
 space by use of polar coordinates, rather than rectangular
 coordinates.
EOF
  $intro->appendTextNode("$txt");
  $div->appendChild($intro);

  $intro = $this->DOM()->createElement("p");
  $intro->appendTextNode("For the color you have selected, ");
  $intro->appendTextNode(sprintf("the Hue is: %.2f, ", $H));
  $intro->appendTextNode(sprintf("the Chroma is: %.3f, and ", $C));
  $intro->appendTextNode(sprintf("the Lightness Value  is: %.3f.", $L));
  $div->appendChild($intro);
  

  $intro = $this->DOM()->createElement("p");
  $span = $this->DOM()->createElement("span");
  my $text_color = $this->text_color();
  $span->setAttribute("style",
		      "color: $text_color; background: $col; padding: 1em; align: center;");
  $span->appendTextNode("This color looks best with $text_color text.");
  $intro->appendChild($span);

  $div->appendChild($intro);
  my $variation = $this->non_chromatic_variation();
  $div->appendChild($variation);
  return $div;
}


sub doc_title {
  my $this  = shift;
  my ($r, $g, $b) = @{ $this->{color}->as_RGB255() };
  my ($L, $C, $H) = @{ $this->{color}->as_LCHab() };
  my $col = sprintf "#%02x%02x%02x", $r, $g,$b;
  chomp($col);

  my $div      = $this->DOM()->createElement("div");
  my $doctitle = $this->DOM()->createElement("h1");
  my $toprule  = $this->DOM()->createElement("hr");

  $div->setAttribute("class", "doc_title");

  $doctitle->setAttribute("class", "title");
  $doctitle->appendTextNode("       Color Report for $col");
  $div->appendChild($doctitle);

  $toprule->setAttribute("style", "clear: both;");
  $div->appendChild($toprule);
  return $div;
}

sub  styles {
  my $this  = shift;
  my $link = $this->DOM()->createElement("link");
  $link->setAttribute("href", "styles/simple_screen.css");
  $link->setAttribute("type", "text/css");
  $link->setAttribute("rel", "stylesheet");
  $link->setAttribute("media", "screen");
  $this->{head}->appendChild($link);

  $link = $this->DOM()->createElement("link");
  $link->setAttribute("href", "styles/simple_print.css");
  $link->setAttribute("type", "text/css");
  $link->setAttribute("rel", "stylesheet");
  $link->setAttribute("media", "print");
  $this->{head}->appendChild($link);

  $link = $this->DOM()->createElement("link");
  $link->setAttribute("href", "styles/common.css");
  $link->setAttribute("type", "text/css");
  $link->setAttribute("rel", "stylesheet");
  $this->{head}->appendChild($link);
  return $this->{head};
}

sub  fill_header {
  my $this  = shift;
  my $meta = $this->DOM()->createElement("meta");
  my ($r, $g,$b) = @{ $this->{color}->as_RGB255() };
  my $col = sprintf "#%x%x%x", $r, $g,$b;
  chomp($col);

  my $title    = $this->DOM()->createElement("title");
  $title->appendTextNode("       Color Report for $col");
  $this->{head}->appendChild($title);

  my $attr = $this->DOM()->createAttribute("name", "Author");
  $meta->setAttributeNode($attr);
  $attr = $this->DOM()->createAttribute("content", "Manoj Srivastava");
  $meta->setAttributeNode($attr);
  $this->{head}->appendChild($meta);
  return $this->{head};
}

sub create_report {
  my $this  = shift;
  $this->DOM(XML::LibXML::Document->new( "1.0", "UTF8" ));
  $this->DTD($this->DOM()->createInternalSubset
	     ('html',
	      '-//W3C//DTD XHTML 1.0 Strict//EN',
	      'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'
	     ));
  $this->Root($this->DOM()->createElementNS
	      ("http://www.w3.org/1999/xhtml", "html")) ;
  $this->DOM()->setDocumentElement($this->Root());
  my $attr = $this->DOM()->createAttributeNS("http://www.w3.org/1999/xhtml",
					     "xml:lang", "en");
  $this->Root()->setAttributeNodeNS($attr);
  $this->{head} = $this->DOM()->createElement("head");
  $this->{body} = $this->DOM()->createElement("body");
  $this->Root()->appendChild($this->{head});
  $this->Root()->appendChild($this->{body});
}

sub header {
  my $this  = shift;
  $this->fill_header();
  $this->styles();  
}

sub body {
  my $this  = shift;
  my $doctitle = $this->doc_title();
  my $intro    = $this->introduction();
  my $schemes  = $this->color_schemes();
  my $glossary = $this->glossary();

  $this->{body}->appendChild($doctitle);
  $this->{content} = $this->DOM()->createElement("div");
  $this->{content}->setAttribute("id", "content");

  $this->{content}->appendChild($intro);
  $this->{content}->appendChild($schemes);
  $this->{content}->appendChild($glossary);

  $this->{body}->appendChild($this->{content});

  $this->footer();
}

sub  new_report {
  my $this  = shift;
  $this->create_report();
  $this->header();
  $this->body();
}

sub primary_color {
  my $this  = shift;
  $this->{color} = shift;
  $this->new_report();
}

package main;
use Graphics::ColorObject;


sub main {
  my ($red, $green, $blue) = map { hex $_ } 
    ( substr($ARGV[0],0,2), substr($ARGV[0],2,2), substr($ARGV[0],4,2) );
  my $main_color = Graphics::ColorObject->new_RGB255([$red, $green, $blue],
						    white_point => 'E');
  my ($h, $s, $v) = @{ $main_color->as_HSL() };
  my ($L, $C, $H) = @{ $main_color->as_LCHab() };
  printf STDERR "Red=[% 7d] Green      = [% 7d] Blue =[% 7d]\n", $red, $green, $blue;
  printf STDERR "Hue=[%7.3f] Saturation = [%7.3f] Value=[%7.3f]\n", $h, $s, $v;
  printf STDERR "Hue=[%7.3f] Chroma     = [%7.3f] Light=[%7.3f]\n", $H, $C, $L;
  ($L, $C, $H) = @{ $main_color->as_LCHuv() };
  printf STDERR "Hue=[%7.3f] Chroma     = [%7.3f] Light=[%7.3f]\n", $H, $C, $L;
  my $report = Report->new();
  $report->primary_color($main_color);
  $report->DOM()->is_valid();
  print $report->DOM()->toString(2);
}

&main();

__END__

1;
