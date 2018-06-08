require("bundler")
Bundler.require

get "/" do
  erb :index
end

def worksheet
  @session ||= GoogleDrive::Session.from_service_account_key("client_secret.json")
  @spreadsheet ||= @session.spreadsheet_by_title("Epc Landing Page")
  @worksheet ||= @spreadsheet.worksheets.first
end

post "/" do
  new_row = [params["name"], params["email"], params["id_number"],
             params["inlineCheckbox1"],params["textarea1"]]

  begin
    worksheet.insert_rows(worksheet.num_rows+1, [new_row])
    worksheet.save
    erb :index, locals: {
    error_message: "Your ID will be sent to email."
  }
  rescue   
  erb :index, locals: {
    error_message: "Something is wrong, try again."
  }
  end
end
