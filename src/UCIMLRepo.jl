module UCIMLRepo

using HTTPClient.HTTPC
using DataArrays
using DataFrames
using PyCall

@pyimport lxml.html as lh

export ucirepodata,ucirepoinfo,ucirepolist 


function download_http(url::ASCIIString)
    println("fetching from the following url : ",url)
    request = HTTPC.get(url)
    if request.http_code != 200
        error("download failed")
    end	 
#converting received data into ASCII format and returning the value     
    rcvd_data = bytestring(request.body) 
end

#This function converts the input string into a dataframe
function parse_rcvd_data(rcvd_data::ASCIIString)
    rows = ASCIIString[]
    rows = split(rcvd_data,'\n',false)
    df = DataFrame()
    
    for i = 1:size(rows)[1]
        df[i] = split(rows[i],',',true)	
    end
    df		
end

#TODO: Use readtable("file.csv") instead of splitting the array.

function parse_rcvd_info(rcvd_info::ASCIIString)
    rows = ASCIIString[]
    rows = split(rcvd_info,'\n',false)
	
    for i = 1:size(rows)[1]
        println(rows[i])	
    end
end
#TODO: used the parsed info to create the header line for the dataframe

# Exported Function. Loads data into a dataframe from the repository as specified by the parameter
# usage: df = ucirepodata("iris")
# you can alternatively specify the exact url to *any* .data file that you want to load as so:
# df = ucirepodata("http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data",false)

function ucirepodata(DsetNameOrUrl::ASCIIString, DorU::Bool=true)
    if(DorU)
#creating the url to be used for download 
        url = string("http://archive.ics.uci.edu/ml/machine-learning-databases/", DsetNameOrUrl,"/",DsetNameOrUrl,".data")
	
    else
        url = DsetNameOrUrl
    end
	
#loading received data into a string type variable 
    rcvd_data = download_http(url)
	
    df = DataFrame()
#parsing received data and loading into an appropriate dataframe
    df = parse_rcvd_data(rcvd_data)
end


#Exported Function. Displays all relevant information about the dataset
#Usage: ucirepoinfo("iris")
# you can alternatively specify the exact url to *any* .data file that you want to load and view, as so:
# ucirepoinfo("http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.names",false)

function ucirepoinfo(DsetNameOrUrl::ASCIIString, DorU::Bool=true)
    if(DorU)
	#creating the url to be used for download	
        url = string("http://archive.ics.uci.edu/ml/machine-learning-databases/", DsetNameOrUrl,"/",DsetNameOrUrl,".names")
	
    else
        url = DsetNameOrUrl
    end
	
#loading received data into a string type variable 
    rcvd_info = download_http(url) 

#parsing recieved info and displaying on STDOUT
    parse_rcvd_info(rcvd_info)
end


#displays a list of all the available datasets.
#work in progress. Function not exported yet.
#need to work on parsing the html data rcvd to extract a list of available datasets

function ucirepolist()
    url = """http://archive.ics.uci.edu/ml/datasets.html"""
    doc = lh.parse(url)
    text = doc[:xpath]("/html//table[2]//table[2]")
    rows = text[2][:xpath]("/html//table[2]//table[2]//tr[1]")
    i =2;
    	
    	
    print("name|default task\n") 				
    while i<= 284                                                                       
	 
         name 			= rows[1][:xpath](string("""/html//table[2]//td[2]/table[2]//tr[""",i,"""]//td[2]/p//text()"""))[1]
         dtype 			= rows[1][:xpath](string("""/html//table[2]//td[2]/table[2]//tr[""",i,"""]//td[2]/p//text()"""))[2]
         #dtask[i-1] 		= rows[1][:xpath](string("""/html//table[2]//td[2]/table[2]//tr[""",i,"""]//td[3]/p//text()"""))
         #atypes[i-1] 		= rows[1][:xpath](string("""/html//table[2]//td[2]/table[2]//tr[""",i,"""]//td[4]/p//text()"""))
         #instances[i-1] 	= rows[1][:xpath](string("""/html//table[2]//td[2]/table[2]//tr[""",i,"""]//td[5]/p//text()"""))
         #attributes[i-1] 	= rows[1][:xpath](string("""/html//table[2]//td[2]/table[2]//tr[""",i,"""]//td[6]/p//text()"""))
         #year[i-1] 		= rows[1][:xpath](string("""/html//table[2]//td[2]/table[2]//tr[""",i,"""]//td[7]/p//text()"""))
	
	 print(name," | ", dtype,"\n")	
	 i += 1
    end

end

end # module
