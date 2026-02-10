require "rails_helper"

RSpec.describe "Items", type: :request do
  let(:user) { users(:one) }
  let(:item) { items(:one) }

  before do
    sign_in_as(user)
  end

  describe "GET /items" do
    it "returns success" do
      get items_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /items/new" do
    it "returns success" do
      get new_item_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /items" do
    it "creates a new item" do
      expect {
        post items_url, params: {
          item: {
            completed_at: item.completed_at,
            context_id: item.context_id,
            description: item.description,
            due_date: item.due_date,
            energy_level: item.energy_level,
            item_type: item.item_type,
            project_id: item.project_id,
            status: item.status,
            time_required: item.time_required,
            title: item.title
          }
        }
      }.to change(Item, :count).by(1)

      expect(response).to redirect_to(item_url(Item.last))
    end
  end

  describe "GET /items/:id" do
    it "returns success" do
      get item_url(item)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /items/:id/edit" do
    it "returns success" do
      get edit_item_url(item)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /items/:id" do
    it "updates the item and redirects" do
      patch item_url(item), params: {
        item: {
          completed_at: item.completed_at,
          context_id: item.context_id,
          description: item.description,
          due_date: item.due_date,
          energy_level: item.energy_level,
          item_type: item.item_type,
          project_id: item.project_id,
          status: item.status,
          time_required: item.time_required,
          title: item.title
        }
      }
      expect(response).to redirect_to(item_url(item))
    end
  end

  describe "DELETE /items/:id" do
    it "destroys the item" do
      item_to_delete = item # Force the item to be created
      expect {
        delete item_url(item_to_delete)
      }.to change(Item, :count).by(-1)

      expect(response).to redirect_to(items_url)
    end
  end
end
