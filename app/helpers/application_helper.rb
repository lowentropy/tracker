# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	# are we in development mode?
	def dev_mode?
		ENV['RAILS_ENV'] == 'development'
	end

	# return select-options for the hours of the day, rendered as
	# 12am-11am, 12pm-11pm.
	def hours_of_day
		nums = [12, *(1..11).to_a]
		ams = nums.map {|i| "#{i}am"}
		pms = nums.map {|i| "#{i}pm"}
		ams + pms
	end

	# form builder component which renders members of a parent object.
	# as long as the member record class declares acts_as_list, the builder
	# will automate reordering of the elements.
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

	# given an activerecord object and an attribute, this function
	# constructs a unique name for the object-attribute pair and
	# prepares javascript code which appends that object's attribute
	# to any query. the name of the object and the action code is
	# returned to the provided block.
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

	# an edit-in-place boolean updater. [un]checking the box automatically
	# updates the object in the background.
	def boolean_update(object, attribute)
		fake_record(object, attribute, :value => 'checked') do |name,action|
			check_box name, attribute, :onchange => action
		end
	end

	# like collection_select, except that choosing any element from
	# the dropdown automatically updates an object in the background
	# through AJAX.
	def collection_update(object, attribute, choices, id_attr, text_attr)
		fake_record(object, attribute) do |name,action|
			collection_select name, attribute, choices, id_attr, text_attr,
												{}, :onchange => action
		end
	end

end
