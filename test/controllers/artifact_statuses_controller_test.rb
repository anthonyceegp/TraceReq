require 'test_helper'

class ArtifactStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artifact_status = artifact_statuses(:one)
  end

  test "should get index" do
    get artifact_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_artifact_status_url
    assert_response :success
  end

  test "should create artifact_status" do
    assert_difference('ArtifactStatus.count') do
      post artifact_statuses_url, params: { artifact_status: { name: @artifact_status.name, project: @artifact_status.project } }
    end

    assert_redirected_to artifact_status_url(ArtifactStatus.last)
  end

  test "should show artifact_status" do
    get artifact_status_url(@artifact_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_artifact_status_url(@artifact_status)
    assert_response :success
  end

  test "should update artifact_status" do
    patch artifact_status_url(@artifact_status), params: { artifact_status: { name: @artifact_status.name, project: @artifact_status.project } }
    assert_redirected_to artifact_status_url(@artifact_status)
  end

  test "should destroy artifact_status" do
    assert_difference('ArtifactStatus.count', -1) do
      delete artifact_status_url(@artifact_status)
    end

    assert_redirected_to artifact_statuses_url
  end
end
