describe 'querying the bears table' do
  before do
    @db = SQLite3::Database.new(':memory:')
    @sql_runner = SQLRunner.new(@db)
    @sql_runner.execute_create_file
    @sql_runner.execute_data
  end
  after do
    File.open('lib/sql', 'w'){ |f| f.truncate(0) }
  end

  it 'selects all of the female bears and returns their name and age' do
    expect(@db.execute("select name, age from bears where gender='F';")).to eq([["Tabitha", 6],["Melissa", 13], ["Wendy", 6]])
  end

  it 'selects all of the bears names and orders them in alphabetical order' do
    expect(@db.execute("select name from bears order by name ASC;")).to eq([[nil],["Grinch"],["Melissa"],["Mr. Chocolate"],["Rowdy"],["Sargeant Brown"],["Tabitha"],["Wendy"]])
  end

  it 'selects all of the bears names and ages that are alive and order them from youngest to oldest' do
    expect(@db.execute("select name, age from bears where alive=1 order by age ASC;")).to eq([["Grinch", 2], ["Tabitha", 6], ["Wendy", 6], ["Rowdy", 10], ["Melissa", 13]])
  end

  it 'selects the oldest bear and returns their name and age' do
    expect(@db.execute("select name, max (age) from bears;")).to eq([["Mr. Chocolate", 20]])
  end

  it 'selects the youngest bear and returns their name and age' do
    expect(@db.execute("select name, min (age) from bears;")).to eq([["Grinch", 2]])
  end

  it 'selects the most prominent color and returns it with its count' do
    expect(@db.execute("select color, count (*) from bears group by color order by count (*) desc limit 1;")).to eq([["dark brown", 3]])
  end

  it 'counts the number of bears with goofy temperaments' do
    expect(@db.execute("select count (temperament) from bears where temperament = 'goofy';")).to eq([[1]])
  end

  it 'selects the bear that killed Tim' do
    #expect(@db.execute("select * from bears where id = 8;")).to eq([[8,, 20, "M", "black", "aggressive", 0]])
  end
end
