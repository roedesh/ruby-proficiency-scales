module ApplicationHelper
  def active_link_to(text, path, options = {})
    classes = options[:class] || ""
    classes += " active" if current_page?(path)
    link_to text, path, options.merge(class: classes)
  end
end
