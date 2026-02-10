require "rails_helper"

RSpec.describe "Contexts", type: :request do
  let(:user) { users(:one) }
  let(:context) { contexts(:one) }

  before do
    sign_in_as(user)
  end

  describe "GET /contexts" do
    it "returns success" do
      get contexts_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /contexts/new" do
    it "returns success" do
      get new_context_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /contexts" do
    it "creates a new context" do
      expect {
        post contexts_url, params: { context: { name: context.name } }
      }.to change(Context, :count).by(1)

      expect(response).to redirect_to(context_url(Context.last))
    end
  end

  describe "GET /contexts/:id" do
    it "returns success" do
      get context_url(context)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /contexts/:id/edit" do
    it "returns success" do
      get edit_context_url(context)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /contexts/:id" do
    it "updates the context and redirects" do
      patch context_url(context), params: { context: { name: context.name } }
      expect(response).to redirect_to(context_url(context))
    end
  end

  describe "DELETE /contexts/:id" do
    it "destroys the context" do
      context_to_delete = context
      expect {
        delete context_url(context_to_delete)
      }.to change(Context, :count).by(-1)

      expect(response).to redirect_to(contexts_url)
    end
  end
end
