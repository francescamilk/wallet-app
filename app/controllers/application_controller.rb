class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :pin])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :pin])
  end

  ### NORDIGEN TEST ###
  require 'securerandom'
  require 'nordigen-ruby'

  # Get secret_id and secret_key from ob.nordigen.com portal and pass to NordigenClient or load from .env file
  client = Nordigen::NordigenClient.new(
    secret_id: "2b34d5cc-5623-4a3b-af52-8acedbeeb40b",
    secret_key: "2adf1aca09b5e21d37ba1a3e090b5a8e949f4cd893feb8b6de9d72984fea86733cd6fb69b853523084b66e914ddff5de12bb9e67cf687948f1fa0ce999f07c53"
  )

  # Generate new access token. Token is valid for 24 hours
  token_data = client.generate_token()

  # Use existing token
  client.set_token("YOUR_TOKEN")

  # Get access and refresh token
  # Note: access_token is automatically injected to other requests after you successfully obtain it
  access_token = token_data["access"]
  refresh_token = token_data["refresh"]

  # Exchange refresh token. Refresh token is valid for 30 days
  refresh_token = client.exchange_token(refresh_token)

  # Get all institution by providing country code in ISO 3166 format
  institutions = client.institution.get_institutions("LV")

  # Institution id can be gathered from get_institutions response.
  # Example Revolut ID
  id = "REVOLUT_REVOGB21"

  # Initialize bank authorization session
  # Returns requisition_id and link to initiate authorization with a bank
  init = client.init_session(
    # redirect url after successful authentication
    redirect_url: "https://nordigen.com",
    # institution id
    institution_id: id,
    # a unique user ID of someone who's using your services, usually it's a UUID
    reference_id: SecureRandom.uuid,
    # A two-letter country code (ISO 639-1)
    user_language: "en",
    # option to enable account selection view for the end user
    account_selection: true
  )

  link = init["link"] # bank authorization link
  requisition_id = init["id"] # requisition id that is needed to get an account_id

  # Get account id after you have completed authorization with a bank.
  requisition_data = client.requisition.get_requisition_by_id(requisition_id)
  # Get account id from list
  account_id =  accounts["accounts"][0]

  # Instantiate account object
  account = client.account_api(account_id)

  # Fetch account metadata
  meta_data = account.get_metadata()
  # Fetch details
  details = account.get_details()
  # Fetch balances
  balances = account.get_balances()
  # Fetch transactions
  transactions = account.get_transactions()
  # Fetch premium transactions
  transactions = account.get_premium_transactions(date_from: "2021-12-01", date_to: "2022-01-30", country: "LV")
  # Filter transactions by specific date range
  transactions = account.get_transactions(date_from: "2021-12-01", date_to: "2022-01-30")
end
