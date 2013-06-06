package com.yang.oa.commons;

import java.util.List;
import java.util.Map;

import org.apache.shiro.config.Ini;
import org.apache.shiro.config.Ini.Section;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.beans.factory.annotation.Autowired;

import com.yang.oa.hr.bean.UrlRoleBean;
import com.yang.oa.hr.service.CompyInfoService;
import com.yang.oa.hr.service.PowerInfoService;


public class OaChainDefinitionSectionMetaSource implements
		FactoryBean<Ini.Section> {
	@Autowired
	private PowerInfoService powservice;
	 private String filterChainDefinitions;

	    /**
	     * 默认role字符串
	     */
	public static final String ROLE_STRING="roles[\"{0}\"]";
	@Override
	public Section getObject() throws Exception {
		List<UrlRoleBean> list=powservice.selectAllUrlRole();
		Ini ini =new Ini();
		ini.load(filterChainDefinitions);
	    Ini.Section section = ini.getSection(Ini.DEFAULT_SECTION_NAME);
	    for(UrlRoleBean urlRole:list){
	    	List<String> roles=urlRole.getRoles();
	    	String roleString=changeRoeListToString(roles);
	    	section.put(urlRole.getUrl(), roleString);
	    	System.out.println("--------------"+urlRole.getUrl()+":"+roleString);
	    }
		return section;
	}
	/**
     * 通过filterChainDefinitions对默认的url过滤定义
     * 
     * @param filterChainDefinitions 默认的url过滤定义
     */
    public void setFilterChainDefinitions(String filterChainDefinitions) {
        this.filterChainDefinitions = filterChainDefinitions;
    }
    private String changeRoeListToString(List<String> list){
    	StringBuffer sbf =new StringBuffer();
    	sbf.append("roles[");
    	sbf.append("\"");
    	int i=0;
    	for(String s: list){
    	
    		if(i !=list.size()-1){
    			sbf.append(s);
        		sbf.append(",");
    		}else{
    			sbf.append(s);
    		}
    			
    			i++;
    	}
    	sbf.append("\"");
    	sbf.append("]");
    	return sbf.toString();
    }
	@Override
	public Class<?> getObjectType() {
		// TODO Auto-generated method stub
		return this.getClass();
	}

	@Override
	public boolean isSingleton() {
		// TODO Auto-generated method stub
		return false;
	}

}
