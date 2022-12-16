class PagesController < ApplicationController
  def home
    client = Client.new().create_client()
    token = client.generate_token()["access"]

    country = "NL"
    institution = Nordigen::InstitutionsApi.new(client=client)
    institution_list = institution.get_institutions(country)
    @list = institution_list.collect {|el| OpenStruct.new(el).marshal_dump }.to_json
  end

  def sync
    @calendar = Calendar.new
  end
end
