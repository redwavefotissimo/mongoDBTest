package com.models;

public class PersonalInfo {
	
	public org.bson.types.ObjectId _id;
	
	public BasicInfo basicInfo;
	public OtherInfo otherInfo;
	
	public PersonalInfo(){
		
	}
	
	public PersonalInfo(BasicInfo basicInfo, OtherInfo otherInfo){
		this.basicInfo = basicInfo;
		this.otherInfo = otherInfo;
	}
}
