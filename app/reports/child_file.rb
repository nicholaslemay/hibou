require 'prawn_child_file'

class ChildFile < Prawn::Document
  include ActionView::Helpers::DateHelper

  def initialize(child)
    super({ :margin => [0, 0, 0, 0],
            :page_layout => :landscape,
            :page_size => 'LETTER'
          })
    @child = child
  end

  def generate
    child_file do
      image scanned_child_form

      text_field :child_name, full_name_of(@child)
      text_field :birth_date, birth_date_of(@child)

      text_field :allergies, allergies_of_this(@child)

      check(@child.snack ? :snack : :no_snack)
      check(@child.bottle ? :bottle : :no_bottle)
      check(@child.nap ? :nap : :no_nap)
    end
    cutting_line

    render
  end

  def is_snack_checked
    
  end


  private
  def scanned_child_form
    File.dirname(__FILE__) +'/../../public/images/child_file/scanned_child_file.jpg'
  end

  #todo use child.full_name
  def full_name_of child
    child.first_name + " " + child.last_name
  end

  def birth_date_of child
    "#{I18n.l(child.birth_date, :format => :medium)} (#{distance_of_time_in_words(child.birth_date, Date.today)})"
  end

  def  allergies_of_this child
    child.allergic? ? child.allergies : I18n.translate(:none)
  end
end