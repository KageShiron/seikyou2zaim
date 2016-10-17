require_relative '../localdb.rb'

describe RecordDB do
  it 'RecordDB initialize' do
    File.delete("mytest.db") if File.exist?("mytest.db")
    db = RecordDB.new("mytest.db")
    expect( File.exist?("mytest.db") ).to eq true

    db.add_records( [{ :date => Time.parse("2016-10-5").to_i , :name => "パン1" , :amount => 100 , :place => "北部"  },
                     { :date => Time.parse("2016-10-6").to_i , :name => "パン2" , :amount => 100 , :place => "北部"  }] )

    #同様のものが削除される
    list = [{ :date => Time.parse("2016-10-5").to_i , :name => "パン1" , :amount => 100 , :place => "北部"  }]
    db.delete_existing( list)
    expect(list).to eq []

    ##DBになければ削除されない
    list = [ { :date => Time.parse("2016-10-6").to_i , :name => "パン3" , :amount => 100 , :place => "北部"  } ]
    db.delete_existing( list )
    expect(list).to eq [ { :date => Time.parse("2016-10-6").to_i , :name => "パン3" , :amount => 100 , :place => "北部"  } ]

    # 当てはまらないレコードは保持し、当てはまるレコードのみを削除
    list = [ { :date => Time.parse("2016-10-6").to_i , :name => "パン1" , :amount => 100 , :place => "北部"  } ,{ :date => Time.parse("2016-10-5").to_i , :name => "パン1" , :amount => 100 , :place => "北部"  } ]
    db.delete_existing( list )
    expect(list).to eq [{ :date => Time.parse("2016-10-6").to_i , :name => "パン1" , :amount => 100 , :place => "北部"  }]

    # 同じレコードが複数あっても消すのは一つ
    list = [ { :date => Time.parse("2016-10-5").to_i , :name => "パン1" , :amount => 100 , :place => "北部"  } ,{ :date => Time.parse("2016-10-5").to_i , :name => "パン1" , :amount => 100 , :place => "北部"  } ]
    db.delete_existing( list )
    expect(list).to eq [{ :date => Time.parse("2016-10-5").to_i , :name => "パン1" , :amount => 100 , :place => "北部"  } ]

    db.add_records( [{ :date => Time.parse("2016-10-5").to_i , :name => "パン1" , :amount => 100 , :place => "北部"  },
                     { :date => Time.parse("2016-10-6").to_i , :name => "パン2" , :amount => 100 , :place => "北部"  }] )


    # 2つあるので両方消える
    list = [ { :date => Time.parse("2016-10-5").to_i , :name => "パン1" , :amount => 100 , :place => "北部"  } ,{ :date => Time.parse("2016-10-5").to_i , :name => "パン1" , :amount => 100 , :place => "北部"  } ]
    db.delete_existing( list )
    expect(list).to eq []

    File.delete("mytest.db")

  end
end

