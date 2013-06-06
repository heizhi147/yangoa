package com.yang.oa.test.controler;

import java.util.List;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;

import com.yang.oa.hr.entity.Organization;
import com.yang.oa.hr.service.CompyInfoService;


@ContextConfiguration(locations = { "/root-context.xml"})
public class CompyInfoServiceTest extends AbstractJUnit4SpringContextTests{
	@Autowired
	private CompyInfoService cis; 
	@Test
	public void test(){
		List<Organization> o=cis.getOrgInfo();
		for(Organization s:o){
			System.out.println(s.getOrgName());
		}
		
	}

}
