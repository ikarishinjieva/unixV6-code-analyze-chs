require "rexml/document"
file = File.new( "UnixV6Wiki-20130712135459.xml" )
doc = REXML::Document.new file
selenium = ""
doc.elements.each("//mediawiki/page") do |e| 
	part = <<HERE
<tr>
	<td>open</td>
	<td>/ikarishinjieva/unixV6-code-analyze-chs/wiki/_pages</td>
	<td></td>
</tr>
<tr>
	<td>click</td>
	<td>link=New Page</td>
	<td></td>
</tr>
<tr>
	<td>type</td>
	<td>id=gollum-dialog-dialog-generated-field-name</td>
	<td>#{e.elements["title"].text}</td>
</tr>
<tr>
	<td>clickAndWait</td>
	<td>id=gollum-dialog-action-ok</td>
	<td></td>
</tr>
<tr>
	<td>type</td>
	<td>id=gollum-editor-body</td>
	<td>#{(e.elements["revision/text"].text || '').gsub(/</, "&lt;").gsub(/>/, "&gt;")}</td>
</tr>
<tr>
	<td>select</td>
	<td>id=wiki_format</td>
	<td>label=MediaWiki</td>
</tr>
<tr>
	<td>type</td>
	<td>id=gollum-editor-message-field</td>
	<td>import page #{e.elements["title"].text} by Tac</td>
</tr>
<tr>
	<td>clickAndWait</td>
	<td>id=gollum-editor-submit</td>
	<td></td>
</tr>

HERE

	part.gsub! '\n', '<br/>\n'

	part.gsub! /<div class=['"]wikiheadcode['"]>(.+?)<\/div>/m, '<code>\1</code>'

	part.gsub! /<div class=['"]wikinote['"]>(.+?)<\/div>/m, '<blockquote>\1</blockquote>'

	part.gsub! /<div class=['"]wikicode['"]>(.+?)<\/div>/m, '\1'

	part.gsub!(/\|([a-z]+)\=/) {
		"===#{$1.capitalize}==="
	}

	part.gsub! /<td>\{\{template:code/, '<td>'

	part.gsub! /<td>\{\{template:syscall/, '<td>'

	part.gsub! /\}\}<\/td>/, '</td>'
	
	part.gsub! /Code:/, 'code:'

	part.gsub!(/(\[\[code:\d+ +- +\d+\]\])/) {
		$1.sub(/-/, '~')
	}

	part.gsub!(/(<td>code:\d+ - \d+<\/td>)/) {
		$1.sub(/-/, '~')
	}

	part.gsub!(/\[\[[Ii]mage:([^\]]+)\]\]/) {
		"<p><img src=\"http://ikarishinjieva.github.io/unixV6-code-analyze-chs/images/#{$1.gsub(" ", "_")}\"/></p>"
	}

	selenium += part
end

selenium = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head profile="http://selenium-ide.openqa.org/profiles/test-case">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="selenium.base" href="https://github.com/" />
<title>selenium</title>
</head>
<body>
<table cellpadding="1" cellspacing="1" border="1">
<thead>
<tr><td rowspan="1" colspan="3">selenium</td></tr>
</thead><tbody>
#{selenium}
</tbody></table>
</body>
</html>
HERE
puts selenium