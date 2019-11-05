<%@ page import="com.mongodb.client.*,com.mongodb.ConnectionString, com.mongodb.MongoClientSettings, 
org.bson.*, java.util.*, org.bson.codecs.configuration.*,org.bson.codecs.pojo.*,com.models.*, com.google.gson.*
;" %>
<%
final String conStr = "mongodb+srv://mongouser:1234@freemongodbtest-seunn.azure.mongodb.net/test?retryWrites=true&w=majority";

try{
	
	Gson gson = new Gson();
	
	CodecRegistry pojoCodecRegistry = org.bson.codecs.configuration.CodecRegistries.fromRegistries(com.mongodb.MongoClient.getDefaultCodecRegistry(),
			org.bson.codecs.configuration.CodecRegistries.fromProviders(PojoCodecProvider.builder().register("com.models").build()));
	
	ConnectionString connString = new ConnectionString(conStr);
	MongoClientSettings settings = MongoClientSettings.builder()
		    .applyConnectionString(connString)
		    .codecRegistry(pojoCodecRegistry)
		    .retryWrites(true)
		    .build();
	MongoClient mongoClient = MongoClients.create(settings);
	MongoDatabase database = mongoClient.getDatabase("mongodbFirst");
	
	MongoCollection<Document> documents = database.getCollection("mongodbCollectionFirst");
	
	//for filter: new Document(); // lt, gt, eq
	Document condition = new Document("$gt", 16); 
	Document field = new Document("age", condition);
	
	documents.deleteMany(field);
	
	ArrayList<String> hobbies = new ArrayList<String>();
	hobbies.add("reading");
	hobbies.add("gaming");
	
	Document doc = new Document("first_name", "first")
			.append("last_name", "last")
			.append("age", 17)
			.append("hobby", hobbies);
	
	documents.insertOne(doc);
	
	doc = new Document("first_name2", "first 3")
			.append("last_name", "last 3")
			.append("age", 17);
	
	documents.insertOne(doc);
	
	out.write("complete");
	
	out.write("<br/>");
	
	FindIterable<Document> documentList = documents.find(new Document());
	
	for(Document docInserted : documentList){
		out.write(docInserted.toJson());
		out.write("<br/>");
	}
	
	out.write("<br/>");
	
	out.write("with filter");
	
	out.write("<br/>");
	
	Document conditionHobby = new Document("$eq", "reading"); 
	
	Document filterBoby = new Document("hobby", conditionHobby);
	
	FindIterable<Document> documentListFilterHobby = documents.find(filterBoby);
	
	for(Document docInserted : documentListFilterHobby){
		out.write(docInserted.toJson());
		out.write("<br/>");
	}
	
	out.write("<br/>");
	
	out.write("using class for delete, insert, retrieve");
	
	out.write("<br/>");
	
	MongoCollection<PersonalInfo> personalInfoDocuments = database.getCollection("mongodbCollectionClassTest", PersonalInfo.class);
	
	OtherInfo otherInfo = new OtherInfo();
	otherInfo.hobbies = new ArrayList<String>(Arrays.asList(new String[]{"reading", "gaming", "programming"}));
	otherInfo.skills = new ArrayList<String>(Arrays.asList(new String[]{"java", "c#", "html", "css", "android", "javascript"}));
	
	AddressInfo addressInfo = new AddressInfo();
	addressInfo.address1 = "address1";
	addressInfo.address2 = "address2";
	
	personalInfoDocuments.deleteMany(com.mongodb.client.model.Filters.eq("otherInfo.hobbies", "gaming"));
	
	personalInfoDocuments.insertOne(new PersonalInfo(new BasicInfo("first name 1",
			"last name 1", 17, addressInfo), otherInfo));
	
	personalInfoDocuments.insertOne(new PersonalInfo(new BasicInfo("first name 2",
			"last name 2", 17, addressInfo), otherInfo));
	
	out.write("<br/>");
	out.write("complete insert");
	out.write("<br/>");
	out.write("start Filter get");
	out.write("<br/>");
	
	FindIterable<PersonalInfo> documentListFilterBySkill = personalInfoDocuments.find(com.mongodb.client.model.Filters.in("otherInfo.skills", "c#"));
	
	PersonalInfo forUpdate = null;
	
	for(PersonalInfo docInserted : documentListFilterBySkill){
		out.write( docInserted._id.toHexString());
		out.write(gson.toJson(docInserted));
		out.write("<br/>");
		forUpdate = docInserted;
	}
	
	out.write("<br/>");
	out.write("update last record then start Filter get");
	out.write("<br/>");
	
	if(forUpdate != null){
		forUpdate.otherInfo.skills = new ArrayList<String>(Arrays.asList(new String[]{"java", "c++", "html", "css", "android", "javascript"}));
	}
	
	personalInfoDocuments.updateOne(new Document("_id", forUpdate._id), 
			new Document("$set", new Document("otherInfo.skills", forUpdate.otherInfo.skills)));
	
	documentListFilterBySkill = personalInfoDocuments.find(com.mongodb.client.model.Filters.in("otherInfo.skills", "c++"));
	
	for(PersonalInfo docInserted : documentListFilterBySkill){
		out.write( docInserted._id.toHexString());
		out.write(gson.toJson(docInserted));
		out.write("<br/>");
	}
}
catch(Exception ex){
	ex.printStackTrace();
}

%>
