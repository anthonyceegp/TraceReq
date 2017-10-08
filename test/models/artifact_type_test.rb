require 'test_helper'

class ArtifactTypeTest < ActiveSupport::TestCase

  def setup
  	@artifact_type = ArtifactType.new(name: "Use Case")
  end

  test "should be valid" do
  	assert @artifact_type.valid?
  end

  test "name should be present" do
  	@artifact_type.name = "        "
  	assert_not @artifact_type.valid?
  end
end
