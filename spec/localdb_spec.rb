require_relative '../localdb.rb'

describe RecordDB do
  before do
  end
  it 'Recorddb initialize' do
    #File.delete("mytest.db") if File.exist?("mytest.db")
    @db = RecordDB.new("test")
    @db.drop_database
    #expect( File.exist?("mytest.db") ).to eq true

    @db.add_records( [{ :date => Date.parse("2016-10-5") , :name => "パン1" , :amount => 100 , :place => "北部"  },
                     { :date => Date.parse("2016-10-6") , :name => "パン2" , :amount => 100 , :place => "北部"  }] )

    #同様のものが削除される
    list = [{ :date => Date.parse("2016-10-5") , :name => "パン1" , :amount => 100 , :place => "北部"  }]
    @db.delete_existing( list)
    expect(list).to eq []

    ##@dbになければ削除されない
    list = [ { :date => Date.parse("2016-10-6") , :name => "パン3" , :amount => 100 , :place => "北部"  } ]
    @db.delete_existing( list )
    expect(list).to eq [ { :date => Date.parse("2016-10-6") , :name => "パン3" , :amount => 100 , :place => "北部"  } ]

    # 当てはまらないレコードは保持し、当てはまるレコードのみを削除
    list = [ { :date => Date.parse("2016-10-6") , :name => "パン1" , :amount => 100 , :place => "北部"  } ,{ :date => Date.parse("2016-10-5") , :name => "パン1" , :amount => 100 , :place => "北部"  } ]
    @db.delete_existing( list )
    expect(list).to eq [{ :date => Date.parse("2016-10-6") , :name => "パン1" , :amount => 100 , :place => "北部"  }]

    # 同じレコードが複数あっても消すのは一つ
    list = [ { :date => Date.parse("2016-10-5") , :name => "パン1" , :amount => 100 , :place => "北部"  } ,{ :date => Date.parse("2016-10-5") , :name => "パン1" , :amount => 100 , :place => "北部"  } ]
    @db.delete_existing( list )
    expect(list).to eq [{ :date => Date.parse("2016-10-5") , :name => "パン1" , :amount => 100 , :place => "北部"  } ]

    @db.add_records( [{ :date => Date.parse("2016-10-5") , :name => "パン1" , :amount => 100 , :place => "北部"  },
                     { :date => Date.parse("2016-10-6") , :name => "パン2" , :amount => 100 , :place => "北部"  }] )


    # 2つあるので両方消える
    list = [ { :date => Date.parse("2016-10-5") , :name => "パン1" , :amount => 100 , :place => "北部"  } ,{ :date => Date.parse("2016-10-5") , :name => "パン1" , :amount => 100 , :place => "北部"  } ]
    @db.delete_existing( list )
    expect(list).to eq []

    @db.drop_database

  end

  it "Recorddb select test" do
    r = { :date => Date.parse("2016-10-6").to_i , :name => "パン2" , :amount => 100 , :place => "北部"  }
    r[:date] = Date.at(r[:date]).strftime("%Y-%m-%d")
    r[:mapping] = 1
    r[:category_id] = 101
    r[:genre_id] = 10104
    p r
    @db.add_records([r])
    @db.delete_existing([{ :date => Date.parse("2016-10-6").to_i , :name => "パン2" , :amount => 100 , :place => "北部"  }])
  end

end

