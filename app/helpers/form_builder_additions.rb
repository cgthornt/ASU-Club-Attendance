# http://code.alexreisner.com/articles/form-builders-in-rails.html
class FormBuilderAdditions < ActionView::Helpers::FormBuilder
  
  def item(method, label = true, &block)
    @template.content_tag 'div', :class => 'control-group' do
      str = ""
      str += label(method, :class => 'control-label') if label
      str += @template.content_tag('div', :class => 'controls') do
        @template.capture(&block)
      end
      str.html_safe
    end
  end
  
  def submit_area(submit_text = nil, &block)
    @template.content_tag 'div', :class => 'form-actions' do
      str  = submit(submit_text, :class => 'btn btn-primary') + " "
      str += @template.capture(&block) if block_given?
      str.html_safe
    end
  end
  
  def check_box2(method, options = {}, checked_value = "1", unchecked_value = "0")
    label(method, :class => 'checkbox') do
      check_box(method, options, checked_value, unchecked_value) + " " + @object.class.human_attribute_name(method)
    end
  end
  
  def datetime_range(from_method, to_method)
    @template.render :partial => 'shared/forms/datetime_range', :locals => {
      :form => self,
      :from => from_method,
      :to   => to_method
    }
  end
  
end
