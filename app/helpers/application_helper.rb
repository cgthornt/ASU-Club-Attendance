module ApplicationHelper
  include WidgetHelper
  
  # Additional form_for methods, contained in app/helpers/form_builder_additions.
  # http://code.alexreisner.com/articles/form-builders-in-rails.html
  ActionView::Base.default_form_builder = FormBuilderAdditions
  
  def format_daterange(start, stop)
    today = Time.now
    str = "%a %b"
    str << " %d"
    str << " %Y" if start.year != today.year
    str << " at %I:%M %P to "
    start_str = start.strftime(str)
    str = ""
    if start.yday != stop.yday
      str << "%b %d at"
    end
    str << " %I:%M %P"
    return start_str + stop.strftime(str)
  end
  
  
  def page_title(title, subtext = nil)
    @page_title = title
    add_breadcrumb title, url_for(:action => params[:action], :controller => params[:controller])
    render :partial => 'shared/page_title', :locals => {:title => title, :subtext => subtext}
  end
  
  def global_javascript_file(*args)
    content_for :javascripts do
      javascript_include_tag(*args)
    end
  end
  
  def global_css_file(*args)
    content_for :javascripts do
      stylesheet_link_tag(*args)
    end
  end
  
  def global_css_js_file(*args)
    global_css_file(*args)
    global_javascript_file(*args)
  end
  
end
