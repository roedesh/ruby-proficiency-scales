require "rails_helper"

RSpec.describe "Projects", type: :request do
  let(:user) { users(:one) }
  let(:project) { projects(:one) }

  before do
    sign_in_as(user)
  end

  describe "GET /projects" do
    it "returns success" do
      get projects_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /projects/new" do
    it "returns success" do
      get new_project_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /projects" do
    it "creates a new project" do
      expect {
        post projects_url, params: {
          project: {
            completed_at: project.completed_at,
            description: project.description,
            name: project.name,
            status: project.status,
            user_id: project.user_id
          }
        }
      }.to change(Project, :count).by(1)

      expect(response).to redirect_to(project_url(Project.last))
    end
  end

  describe "GET /projects/:id" do
    it "returns success" do
      get project_url(project)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /projects/:id/edit" do
    it "returns success" do
      get edit_project_url(project)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /projects/:id" do
    it "updates the project and redirects" do
      patch project_url(project), params: {
        project: {
          completed_at: project.completed_at,
          description: project.description,
          name: project.name,
          status: project.status,
          user_id: project.user_id
        }
      }
      expect(response).to redirect_to(project_url(project))
    end
  end

  describe "DELETE /projects/:id" do
    it "destroys the project" do
      project_to_delete = project
      expect {
        delete project_url(project_to_delete)
      }.to change(Project, :count).by(-1)

      expect(response).to redirect_to(projects_url)
    end
  end
end
