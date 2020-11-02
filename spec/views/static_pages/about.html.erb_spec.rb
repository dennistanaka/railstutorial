require 'rails_helper'
require_relative '../views_helper'

RSpec.describe "static_pages/about.html.erb", type: :view do

  describe "renders the view" do
    it "has correct title" do
      render template: "static_pages/about", layout: "layouts/application"
      expect(rendered).to have_title("About | #{@base_title}", exact: true)
    end
  end

end
