module ApplicationHelper
  def default_meta_tags
    {
      site: 'WildRecipe',
      title: "#{@recipe.name unless @recipe.nil?}" ,
      reverse: true,
      charset: 'utf-8',
      description: "#{@recipe.comment unless @recipe.nil?}",
      canocilal: request.original_url,
      separator: '|',
      icon:{
        href: "#{@recipe.image.url unless @recipe.nil?}" , sizes: '180x180', type: 'image/jpg' 
      },
      og:{
        site_name: :site,
        title: :title,
        descriptiotn: :description,
        type: 'website',
        url: request.original_url,
        locale: 'ja_JP',
      },
      twitter:{
        card:'summary',
      }
    }
  end
  #ページの完全なタイトルを返す
  def full_title(page_title = "")
    base_title = "野食専門レシピサイトWildRecipe!"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
