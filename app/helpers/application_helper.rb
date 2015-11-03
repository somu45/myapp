module ApplicationHelper

  def pager_params
    keys = ['limit', 'page', 'sort_column', 'order']
    pager = params.reject { |param,_| !keys.include? param }
    pager['page'] = pager['page'] || 1
    pager["limit"] = pager['limit'] || 10
    pager['offset'] = ((pager['page'].to_i-1) * pager["limit"].to_i)
    pager
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = "sortable ajax"
    css_class += column == pager_params['sort_column'] ? "sort-#{pager_params['order']}" : ""
    direction = column == pager_params['sort_column'] && pager_params['order'] == "asc" ? "desc" : "asc"
    link_to title, params.merge({:sort_column => column, :order => direction, :page => nil}), {:class => css_class}
  end
end
