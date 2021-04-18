require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "GET /new" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST invalid signup information" do
    let(:create_user) { post "/users", params: { user: { name: "",
                                                         email: "user@invalid",
                                                         password: "foo",
                                                         password_confirmation: "bar" } } }

    it "should not create change user count" do
      expect { create_user }.to_not change { User.count }
    end
  end

end
