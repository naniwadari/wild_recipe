class Procedure < ApplicationRecord
  belongs_to :recipe
  
  #コンテンツを入れ替える
  def self.change_content(procedure, change_procedure)
      temp_content = procedure.content
      procedure.update_attributes(content: change_procedure.content)
      change_procedure.update_attributes(content: temp_content)
  end
end
