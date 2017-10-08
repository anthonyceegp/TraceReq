require 'test_helper'

class ArtifactTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artifact_type = artifact_types(:one)
  end

  test "should get index" do
    get artifact_types_url
    assert_response :success
  end

  test "should get new" do
    get new_artifact_type_url
    assert_response :success
  end

  test "should create artifact_type" do
    assert_difference('ArtifactType.count') do
      post artifact_types_url, params: { artifact_type: { name: @artifact_type.name } }
    end

    assert_redirected_to artifact_type_url(ArtifactType.last)
  end

  test "should show artifact_type" do
    get artifact_type_url(@artifact_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_artifact_type_url(@artifact_type)
    assert_response :success
  end

  test "should update artifact_type" do
    patch artifact_type_url(@artifact_type), params: { artifact_type: { name: @artifact_type.name } }
    assert_redirected_to artifact_type_url(@artifact_type)
  end

  test "should destroy artifact_type" do
    assert_difference('ArtifactType.count', -1) do
      delete artifact_type_url(@artifact_type)
    end

    assert_redirected_to artifact_types_url
  end
end
