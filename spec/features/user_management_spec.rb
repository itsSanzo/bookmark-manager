require 'spec_helper'

feature "User sign in" do

  before(:each) do
    User.create(:email => "ceppa@leppa.com",
                :password => "1234",
                :password_confirmation => "1234")
  end

  scenario "with correct credentials" do
    visit "/"
    expect(page).not_to have_content("Welcome, ceppa@leppa.com")
    sign_in('ceppa@leppa.com', '1234')
    expect(page).to have_content("Welcome, ceppa@leppa.com")
  end

  scenario "with incorrect credentials" do
    visit "/"
    expect(page).not_to have_content("Welcome, ceppa@leppa.com")
    sign_in('ceppa@leppa.com', 'wrongpsw')
    expect(page).not_to have_content("Welcome, ceppa@leppa.com")
  end

  def sign_in(email, password)
    visit "/sessions/new"
    fill_in "email", :with => email
    fill_in "password", :with => password
    click_button "Sign in"
  end

end


feature "User sign up" do
	scenario "when being logged out" do
    lambda { sign_up }.should change(User, :count).by(1)
    expect(page).to have_content("Welcome, ciao@ciao.com")
    expect(User.first.email).to eq("ciao@ciao.com")
  end

  scenario "with a password that doesn't match" do
    lambda { sign_up('no@no.com', 'psw', 'wrong') }.should change(User, :count).by(0)
    expect(current_path).to eq('/users')
    expect(page).to have_content("Sorry, your passwords don't match")
  end

  scenario "with an email that is already registered" do
    lambda { sign_up }.should change(User, :count).by(1)
    lambda { sign_up }.should change(User, :count).by(0)
    expect(page).to have_content("This email is already taken")
  end

  def sign_up(email = "ciao@ciao.com",
              password = "12345678",
              password_confirmation = "12345678")
    visit '/users/new'
    fill_in :email, :with => email
    fill_in :password, :with => password
    fill_in :password_confirmation, :with => password_confirmation
    click_button "Sign up"
  end
end