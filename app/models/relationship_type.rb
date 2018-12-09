class RelationshipType < ApplicationRecord
	validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :project_id }
	validates :color, presence: true, uniqueness: { case_sensitive: false, scope: :project_id }

	belongs_to :project

	has_many :relationships, dependent: :destroy

	def font_color
		r = Integer(color[1..2], 16)
		g = Integer(color[3..4], 16)
		b = Integer(color[5..6], 16)

  	a = 1 - (0.299 * r + 0.587 * g + 0.114 * b) / 255

  	a < 0.5 ? "black" : "white"
	end

	def LightenDarkenColor
		amt = -20  
    num = Integer(color[1..6],16)
 
    r = (num >> 16) + amt
    g = ((num >> 8) & 0x00FF) + amt
    b = (num & 0x0000FF) + amt
 
    r = 255 if (r > 255)
    r = 0 if (r < 0)

    g = 255 if (g > 255)
    g = 0 if (g < 0)

    b = 255 if (b > 255)
    b = 0 if (b < 0)

 		'#' + (r.to_s(16).length == 1 ? "0" + r.to_s(16) : r.to_s(16)) +
    (g.to_s(16).length == 1 ? "0" + g.to_s(16) : g.to_s(16)) +
    (b.to_s(16).length == 1 ? "0" + b.to_s(16) : b.to_s(16))
  end
end
