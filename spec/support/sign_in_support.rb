module ValidUserRequestHelper
  # for use in request specs

  def sign_in_user
    Role.create(name: 'player')
    Role.create(name: 'admin')
    Role.create(name: 'developer')
    Role.create(name: 'researcher')

    @user = Fabricate :user, password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'player').first]

    visit root_url

    fill_in 'Login', with: @user.player_name
    fill_in 'Password', with: @user.password


    click_button 'Sign in'
  end

  def sign_in_admin
    Role.create(name: 'player')
    Role.create(name: 'researcher')
    Role.create(name: 'admin')
    Role.create(name: 'developer')

    @user = Fabricate :user, player_name: 'admin', password: 'pass1234', roles: [Role.where(name: 'admin').first, Role.where(name: 'player').first]

    visit root_url

    fill_in 'Login', with: @user.player_name
    fill_in 'Password', with: @user.password


    click_button 'Sign in'
  end


  def sign_in_player
    Role.create(name: 'player')
    Role.create(name: 'researcher')
    Role.create(name: 'admin')
    Role.create(name: 'developer')

    @user = Fabricate :user, player_name: 'Mock Man', email: 'mock@nomail.com', password: 'pass1234', roles: [Role.where(name: 'player').first]

    visit root_url

    fill_in 'Login', with: @user.player_name
    fill_in 'Password', with: @user.password


    click_button 'Sign in'
  end

  def sign_in_researcher_with_game
    Role.create(name: 'player')
    @researcher = Role.create(name: 'researcher')
    Role.create(name: 'admin')
    Role.create(name: 'developer')
    @game = Fabricate :game
    @user = Fabricate :user, player_name: 'researcher', password: 'pass1234', roles: [@game.researcher_role, @researcher]
    visit root_url

    fill_in 'Login', with: @user.player_name
    fill_in 'Password', with: @user.password


    click_button 'Sign in'
  end


  def sign_in_developer
    @player_role = Role.create(name: 'player')
    Role.create(name: 'admin')
    Role.create(name: 'researcher')
    @dev_role = Role.create(name: 'developer')
    @user = Fabricate :user, player_name: 'developer', password: 'pass1234', roles: [@dev_role ]
    visit root_url

    fill_in 'Login', with: @user.player_name
    fill_in 'Password', with: @user.password


    click_button 'Sign in'
  end

end

RSpec.configure do |config|
  config.include ValidUserRequestHelper, :type => :request
end
