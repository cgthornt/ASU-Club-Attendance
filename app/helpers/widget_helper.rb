module WidgetHelper
  
  def pretty_form_for(record, options = {}, &proc)
    options[:html] = {} unless options.key?(:html)
    options[:html][:class] = 'form-horizontal pretty-form'
    render :partial => 'shared/pretty_form', :locals => {:record => record, :options => options, :proc => proc}
  end
  
end
