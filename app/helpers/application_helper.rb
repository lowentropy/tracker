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

	def collection_update(object, attribute, choices, id_attr, text_attr)
		coll = object.class.name.underscore
		name = "#{coll}_#{object.id}"
		eval "@#{name} = object"
		collection_select name, attribute, choices, id_attr, text_attr,
			{}, :onchange => remote_function(
				:with => "'#{coll}[#{attribute}]='+$('#{name}_#{attribute}').value",
				:url => object, :method => :put)
	end

end
