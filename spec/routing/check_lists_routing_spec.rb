require "rails_helper"

RSpec.describe CheckListsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/check_lists").to route_to("check_lists#index")
    end

    it "routes to #show" do
      expect(get: "/check_lists/1").to route_to("check_lists#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/check_lists").to route_to("check_lists#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/check_lists/1").to route_to("check_lists#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/check_lists/1").to route_to("check_lists#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/check_lists/1").to route_to("check_lists#destroy", id: "1")
    end
  end
end
