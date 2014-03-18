module UCIMLRepo

using HTTPClient.HTTPC
using DataArrays
using DataFrames

export UCIRepoData,UCIRepoInfo 


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

function parse_rcvd_info(rcvd_info::ASCIIString)
	
	rows = ASCIIString[]
	rows = split(rcvd_info,'\n',false)
	
	
	for i = 1:size(rows)[1]
	println(rows[i])	
	end
end

# Exported Function. Loads data into a dataframe from the repository as specified by the parameter
# usage: df = UCIRepoData("iris")

function UCIRepoData(DsetName::ASCIIString)
    
	#creating the url to be used for download 
	url = string("http://archive.ics.uci.edu/ml/machine-learning-databases/", DsetName,"/",DsetName,".data")
	 
	#loading received data into a string type variable 
	rcvd_data = download_http(url)
	
	df = DataFrame()
	#parsing received data and loading into an appropriate dataframe
	df = parse_rcvd_data(rcvd_data)
end


#Exported Function. Displays all relevant information about the dataset
#Usage: UCIRepoInfo("iris")

function UCIRepoInfo(DsetName::ASCIIString)
	url = string("http://archive.ics.uci.edu/ml/machine-learning-databases/", DsetName,"/",DsetName,".names")

	rcvd_info = download_http(url) 

	#parsing recieved info and displaying on STDOUT
	parse_rcvd_info(rcvd_info)
end

end # module
