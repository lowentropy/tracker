# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def sort_list(object, list_attr, &block)
		concat(
			content_tag(:ul, :id => list_attr) do
				object.send(list_attr).map do |item|
					content_tag(:li, capture(item, &block), :id => "item_#{item.id}")
				end.join("\n")
			end +
			sortable_element(list_attr, :url => {:action => "reorder_#{list_attr}"}),
		block.binding)
	end

	def collection_update(object, attribute, choices, id_attr, text_attr)
		collection_select object.id.to_s, attribute, choices, id_attr, text_attr,
			{}, :onchange => remote_function(
				:with => "'#{attribute}='+$('#{object.id}_#{attribute}').value",
				:url => object, :method => :put)
	end

end
