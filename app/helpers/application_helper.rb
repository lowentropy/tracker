# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def sort_list(object, list_attr, list_options={}, item_options={}, &block)
		concat(
			content_tag(:ul, list_options.merge(:id => list_attr)) do
				object.send(list_attr).map do |item|
					content_tag(:li, capture(item, &block),
						item_options.merge(:id => "item_#{item.id}"))
				end.join("\n")
			end +
			sortable_element(list_attr, :url => {:action => "reorder_#{list_attr}"}),
		block.binding)
	end

	def fake_record(object, attribute, options={}, &block)
		value = options.delete(:value) || 'value'
		coll = object.class.name.underscore
		name = "#{coll}_#{object.id}"
		param = "#{coll}[#{attribute}]"
		dom_id = "#{name}_#{attribute}"
		with = "'#{param}=' + $('#{dom_id}').#{value}"
		options[:method] ||= :put
		options[:url] ||= object
		action = remote_function(options.merge(:with => with))
		eval "@#{name} = object"
		yield name, action
	end

	def boolean_update(object, attribute)
		fake_record(object, attribute, :value => 'checked') do |name,action|
			check_box name, attribute, :onchange => action
		end
	end

	def collection_update(object, attribute, choices, id_attr, text_attr)
		fake_record(object, attribute) do |name,action|
			collection_select name, attribute, choices, id_attr, text_attr,
												{}, :onchange => action
		end
	end

end
