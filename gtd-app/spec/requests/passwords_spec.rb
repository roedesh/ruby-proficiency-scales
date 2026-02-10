require "rails_helper"

RSpec.describe "Passwords", type: :request do
  let(:user) { User.take }

  describe "GET /password/new" do
    it "returns success" do
      get new_password_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /passwords" do
    context "with a valid user" do
      it "enqueues password reset email and redirects" do
        expect {
          post passwords_path, params: { email_address: user.email_address }
        }.to have_enqueued_email(PasswordsMailer, :reset).with(user)

        expect(response).to redirect_to(new_session_path)

        follow_redirect!
        expect(response.body).to match(/reset instructions sent/)
      end
    end

    context "with an unknown user" do
      it "redirects but sends no mail" do
        expect {
          post passwords_path, params: { email_address: "missing-user@example.com" }
        }.not_to have_enqueued_email

        expect(response).to redirect_to(new_session_path)

        follow_redirect!
        expect(response.body).to match(/reset instructions sent/)
      end
    end
  end

  describe "GET /password/:token/edit" do
    context "with valid token" do
      it "returns success" do
        get edit_password_path(user.password_reset_token)
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid token" do
      it "redirects to new password path" do
        get edit_password_path("invalid token")
        expect(response).to redirect_to(new_password_path)

        follow_redirect!
        expect(response.body).to match(/reset link is invalid/)
      end
    end
  end

  describe "PUT /password/:token" do
    context "with matching passwords" do
      it "updates the password and redirects" do
        expect {
          put password_path(user.password_reset_token), params: { password: "new", password_confirmation: "new" }
        }.to change { user.reload.password_digest }

        expect(response).to redirect_to(new_session_path)

        follow_redirect!
        expect(response.body).to match(/Password has been reset/)
      end
    end

    context "with non-matching passwords" do
      it "does not update password and redirects to edit" do
        token = user.password_reset_token
        expect {
          put password_path(token), params: { password: "no", password_confirmation: "match" }
        }.not_to change { user.reload.password_digest }

        expect(response).to redirect_to(edit_password_path(token))

        follow_redirect!
        expect(response.body).to match(/Passwords did not match/)
      end
    end
  end
end
