require_relative '../localdb.rb'

describe RecordDB do

  it 'RecordDB initialize' do
    File.delete("mytest.db") if File.exist?("mytest.db")
    db = RecordDB.new("mytest.db")
    expect( File.exist?("mytest.db") ).to eq true
  end
end