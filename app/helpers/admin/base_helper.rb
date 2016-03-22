module Admin::BaseHelper
  BUTTON_OPTIONS = {
    show:   ['btn-success', 'fa-search-plus', 'View'],
    edit:   ['btn-info', 'fa-edit', 'Edit'],
    delete: ['btn-danger', 'fa-trash-o', 'Delete'],
  }
  private_constant :BUTTON_OPTIONS

  def admin_page_title(title)
    if controller.send(:_layout)
      content_for :title, "#{title} | Rentance Admin panel"
    else
      content_tag :title, "#{title} | Rentance Admin panel"
    end
  end

  def admin_nav_link(text, url, icon)
    # TODO:
    # Uncomment when this bug is fixed: https://github.com/rails/rails/issues/8679
    #
    # recognized = Rails.application.routes.recognize_path(url)
    # class_name = recognized[:controller] == params[:controller] ? 'active' : ''

    class_name = (url == request.original_url || url["/#{params[:controller].split('/')[1]}"]) ? 'active' : ''

    content_tag(:li, class: class_name) do
      link_to url do
        "<i class='fa #{icon}'></i>#{text}".html_safe
      end
    end
  end

  def admin_tooltip_hint(text)
    content_tag(:span, rel: 'tooltip', title: text) do
      content_tag(:i, '', class: 'fa fa-question-circle')
    end
  end

  def admin_button(type, url, html_options = {}, size = :medium)
    if BUTTON_OPTIONS[type]
      case size
        when :medium
          link_to(url, html_options.merge(class: "btn #{BUTTON_OPTIONS[type][0]}")) do
            content_tag(:i, '', class: "fa #{BUTTON_OPTIONS[type][1]}")
          end
        when :small
          link_to(url, html_options.merge(class: "btn btn-sm #{BUTTON_OPTIONS[type][0]}")) do
            content_tag(:i, '', class: "fa #{BUTTON_OPTIONS[type][1]}") + " #{BUTTON_OPTIONS[type][2]}"
          end
        when :extra_small
          link_to(url, html_options.merge(class: "btn btn-xs #{BUTTON_OPTIONS[type][0]}")) do
            content_tag(:i, '', class: "fa #{BUTTON_OPTIONS[type][1]}")
          end
      end
    end
  end

  def current_administrator
    @current_administrator ||= Administrator.find(session[:administrator_id]) if session[:administrator_id]
    @current_administrator
  end
end
