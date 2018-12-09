class ChartDatum < ApplicationRecord
  belongs_to :artifact_status
  belongs_to :artifact
end
