class Attachment < ApplicationRecord
	has_attached_file :file

	validates_attachment :file, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png",
															"application/pdf", "application/doc", "application/msword"] }

	belongs_to :artifact
end
