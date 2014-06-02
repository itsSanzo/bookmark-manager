require 'spec_helper'

feature "User sign up" do
	scenario "when being logged out" do
    lambda { sign_up }.should change(User, :count).by(1)
    expect(page).to have_content("Welcome, ciao@ciao.com")
    expect(User.first.email).to eq("ciao@ciao.com")
  end

  def sign_up(email = "ciao@ciao.com",
              password = "12345678")
    visit '/users/new'
    fill_in :email, :with => email
    fill_in :password, :with => password
    click_button "Sign up"
  end
end