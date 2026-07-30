# frozen_string_literal: true

require 'rails_helper'
require 'faker'
RSpec.describe ProductsController, type: :controller do
  describe 'POST #create' do
    context 'no image' do
      it 'renders the page with error' do
        post :create, product: { name: 'P 1' }
        expect(response).to render_template(:new)
        expect(flash[:notice]).to match(/^Email and password do not match/)
      end
    end

    context 'when password is valid' do
      it 'sets the user in the session and redirects them to their dashboard' do
        user = create(:user)

        post :create, session: { email: user.email, password: user.password }

        expect(response).to redirect_to '/dashboard'
        expect(controller.current_user).to eq user
      end
    end
  end
end
