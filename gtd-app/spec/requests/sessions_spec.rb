require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { User.take }

  describe "GET /session/new" do
    it "returns success" do
      get new_session_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /session" do
    context "with valid credentials" do
      it "creates a session and redirects to root" do
        post session_path, params: { email_address: user.email_address, password: "password" }

        expect(response).to redirect_to(root_path)
        expect(cookies[:session_id]).to be_present
      end
    end

    context "with invalid credentials" do
      it "redirects to new session path without creating session" do
        post session_path, params: { email_address: user.email_address, password: "wrong" }

        expect(response).to redirect_to(new_session_path)
        expect(cookies[:session_id]).to be_nil
      end
    end
  end

  describe "DELETE /session" do
    it "destroys the session and redirects to new session path" do
      sign_in_as(User.take)

      delete session_path

      expect(response).to redirect_to(new_session_path)
      expect(cookies[:session_id]).to be_empty
    end
  end
end
