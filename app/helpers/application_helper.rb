module ApplicationHelper
  def default_meta_tags
    {
      site: 'WildRecipe',
      title: "野食専門レシピサイトWildRecipe" ,
      reverse: true,
      charset: 'utf-8',
      description: "WildRecipeは野食専門のレシピサイトです。美味しく自然と触れ合おう",
      canocilal: request.original_url,
      image: image_url("wildrecipe_logo_character.png"),
      separator: '|',
      og:{
        site_name: :site,
        title: :title,
        descriptiotn: :description,
        image: image_url("wildrecipe_logo_character.png"),
        type: 'website',
        url: request.original_url,
        locale: 'ja_JP',
      },
      twitter:{
        site_name: :site,
        tiltle: :title,
        description: :description,
        image: image_url("wildrecipe_logo_character.png"),
        type: 'website',
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
