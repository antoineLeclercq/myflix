shared_examples 'requires sign in' do
  it 'redirects to the sign in page' do
    clear_current_user
    action
    expect(response).to redirect_to(sign_in_path)
  end
end

shared_examples 'requires admin' do
  it 'sets error message' do
    set_current_user
    action
    expect(flash[:error]).to be_present
  end

  it 'redirects singed in user to the home page' do
    set_current_user
    action
    expect(response).to redirect_to(home_path)
  end
end

shared_examples 'tokenable' do
  it 'generates a random token when new record is created' do
    expect(object.token).to be_present
  end
end
