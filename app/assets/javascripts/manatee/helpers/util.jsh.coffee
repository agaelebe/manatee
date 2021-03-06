helper '_contentOrOptions', (content_or_options, options_or_content, default_content) ->
  if content_or_options != null && typeof content_or_options == 'object'
    [ options_or_content || default_content, @_clone(content_or_options) ]
  else
    [ content_or_options || default_content, @_clone( options_or_content || {} ) ]

htmlEscapeMap = { '&': '&amp;', '<': '&lt;', '>': '&gt;' }
escapeHTMLCallback = (key) ->
  htmlEscapeMap[key] || key;

helper '_clone', (object) ->
  return object if object == null || typeof object != "object"
  cloned_object = object.constructor()
  for attr of object
    cloned_object[attr] = object[attr] if object.hasOwnProperty(attr)
  cloned_object

helper 'htmlEscape', (string) ->
  string.replace(/[&<>]/g, escapeHTMLCallback);

helper 'htmlEscapeAttributes', (attributes) ->
  escaped_attributes = {}
  for index, value of attributes
    if typeof value == 'string'
      escaped_attributes[index] = @htmlEscape(value)
    else if typeof value == 'object'
      escaped_attributes[index] = @htmlEscapeAttributes(value)
    else
      escaped_attributes[index] = value
  escaped_attributes

helper 'underscore', (string) ->
  results     = []
  sub_strings = string.split '::'
  for index, sub_string of sub_strings
    replaced = sub_string.replace( /([A-Z0-9]+)/g, ( (str) -> '_' + str.toLowerCase() ) )
    if (/([A-Z0-9])/).test(sub_string[0])
      results.push replaced.slice(1)
    else
      results.push replaced
  results.join '/'
