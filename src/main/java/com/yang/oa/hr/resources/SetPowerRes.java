package com.yang.oa.hr.resources;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yang.oa.hr.bean.RoleEmpBean;
import com.yang.oa.hr.entity.RoleGroup;
import com.yang.oa.hr.entity.RoleRes;
import com.yang.oa.hr.service.PowerInfoService;
import com.yang.oa.commons.OaUtil;
import com.yang.oa.commons.ZtreeModel;

@Controller
@RequestMapping(value="/powers")
public class SetPowerRes {
	@Autowired
	private PowerInfoService pfs;
	@RequestMapping(value="/page",method=RequestMethod.GET)
	public String getSettingPowerPage(){
		return "/powerInfo/setPower";
	}
	@RequestMapping(value="/resTree",method=RequestMethod.POST)
	public @ResponseBody List<ZtreeModel> getResByRole(@RequestParam("parentid") String parentid,@RequestParam("roleId")String roleId){
		return pfs.getResTreeByRole(roleId, parentid);
	}
	@RequestMapping(value="/roleRes/{roleid}",method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> inserRoleRes(@PathVariable("roleid") String roleid,@RequestBody List<ZtreeModel> ztreeModels){
		List<RoleRes> insertlist=new ArrayList<RoleRes>();
		List<RoleRes> deletelist=new ArrayList<RoleRes>();
		for(ZtreeModel zt:ztreeModels){
			RoleRes roleRes=new RoleRes();
			roleRes.setUuid(OaUtil.getUUID());
			roleRes.setRoleid(roleid);
			roleRes.setResid(zt.getId());
			if(zt.isChecked()){
				insertlist.add(roleRes);
			}else{
				deletelist.add(roleRes);
			}
			
		}
		pfs.saveRoleReses(insertlist,deletelist);
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("message", "保存成功");
		return map;
	}
	
	@RequestMapping(value="/roleEmps",method=RequestMethod.GET)
	public @ResponseBody List<RoleEmpBean> getResByRole(@RequestParam("roleId") String roleId){
		return pfs.getEmpByRole(roleId);
	}
	@RequestMapping(value="/roleEmps/roleEmp/insert",method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> insertRoleEmp(@RequestBody RoleGroup roleGroup){
			roleGroup.setUuid(OaUtil.getUUID());
			pfs.insertRoleEmp(roleGroup);
			Map<String,Object> map=new HashMap<String,Object>();
			map.put("message", "保存成功");
			return map;
	}
	
	@RequestMapping(value="/roleEmps/{roleId}",method=RequestMethod.GET)
	public @ResponseBody List<RoleEmpBean> queryRoleEmpByRole(@PathVariable("roleId") String roleid){
			return pfs.getEmpByRole(roleid);
		
	}
	@RequestMapping(value="/roleEmps/delete",method=RequestMethod.POST)
	public @ResponseBody Map<String,String> deleteRoleEmpById(@RequestBody List<String> lists){

			 pfs.deleteRoleEmpBatchByIds(lists);
			Map<String,String> map=new HashMap<String,String>();
			map.put("message", "删除成功");
			return map;
	}
	
	
}
