package com.models;

public class BasicInfo {
	public String firstName;
	public String lastName;
	public int age;
	public AddressInfo addressInfo;
	
	public BasicInfo(){
		
	}
	
	public BasicInfo(String firstName, String lastName, int age, AddressInfo addressInfo){
		this.firstName = firstName;
		this.lastName = lastName;
		this.age = age;
		this.addressInfo = addressInfo;
	}
}
