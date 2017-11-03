class AddAttachmentFileToArtifacts < ActiveRecord::Migration[5.1]
  def self.up
    change_table :artifacts do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :artifacts, :file
  end
end
