module ApplicationHelper
  def default_meta_tags
    {
      site: 'WildRecipe',
      title: "野食専門レシピサイト" ,
      reverse: true,
      charset: 'utf-8',
      description: "WildRecipeは野食専門のレシピサイトです",
      canocilal: request.original_url,
      separator: '|',
      og:{
        site_name: :site,
        title: :title,
        descriptiotn: :description,
        image: "",
        type: 'website',
        url: request.original_url,
        locale: 'ja_JP',
      },
      twitter:{
        card:'summary_large_image',
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
