require "rails_helper"

RSpec.describe "Tags", type: :request do
  let(:user) { users(:one) }
  let(:tag) { tags(:one) }

  before do
    sign_in_as(user)
  end

  describe "GET /tags" do
    it "returns success" do
      get tags_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /tags/new" do
    it "returns success" do
      get new_tag_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /tags" do
    it "creates a new tag" do
      expect {
        post tags_url, params: { tag: { name: tag.name } }
      }.to change(Tag, :count).by(1)

      expect(response).to redirect_to(tag_url(Tag.last))
    end
  end

  describe "GET /tags/:id" do
    it "returns success" do
      get tag_url(tag)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /tags/:id/edit" do
    it "returns success" do
      get edit_tag_url(tag)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /tags/:id" do
    it "updates the tag and redirects" do
      patch tag_url(tag), params: { tag: { name: tag.name } }
      expect(response).to redirect_to(tag_url(tag))
    end
  end

  describe "DELETE /tags/:id" do
    it "destroys the tag" do
      tag_to_delete = tag
      expect {
        delete tag_url(tag_to_delete)
      }.to change(Tag, :count).by(-1)

      expect(response).to redirect_to(tags_url)
    end
  end
end
