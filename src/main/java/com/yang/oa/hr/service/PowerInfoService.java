package com.yang.oa.hr.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yang.oa.commons.ZtreeModel;
import com.yang.oa.commons.exception.JlException;
import com.yang.oa.hr.bean.RoleEmpBean;
import com.yang.oa.hr.bean.UrlRoleBean;
import com.yang.oa.hr.dao.EmployeeMapper;
import com.yang.oa.hr.dao.RoleGroupMapper;
import com.yang.oa.hr.dao.RoleMapper;
import com.yang.oa.hr.dao.RoleResMapper;
import com.yang.oa.hr.dao.SysResourceMapper;
import com.yang.oa.hr.entity.Employee;
import com.yang.oa.hr.entity.Role;
import com.yang.oa.hr.entity.RoleGroup;
import com.yang.oa.hr.entity.RoleRes;
import com.yang.oa.hr.entity.SysResource;

@Service
@Transactional(readOnly = true)
public class PowerInfoService {
	@Autowired
	private SysResourceMapper resDao;
	@Autowired
	private RoleMapper roleDao;
	
	@Autowired
	private RoleResMapper roleresDao;
	@Autowired
	private RoleGroupMapper roelGroupDao;
	@Autowired
	private EmployeeMapper empDao;
	/**
	 * 获取子资源
	 * @param parentid
	 * @return
	 */
	public List<SysResource> getResByParent(String parentid){
		return resDao.selectByParentid(parentid);
	}
	/**
	 * 根据id获取系统资源
	 * @param id
	 * @return
	 */
	public SysResource getResById(String id){
		return resDao.selectByPrimaryKey(id);
	}
	/**
	 * 新增系统资源
	 * @param sysRes
	 */
	@Transactional(readOnly = false)
	public void insertRes(SysResource sysRes){
		resDao.insert(sysRes);
	}
	
	/**
	 * 更新系统资源
	 * @param sysRes
	 */
	@Transactional(readOnly = false)
	public void updateRes(SysResource sysRes){
		resDao.updateByPrimaryKey(sysRes);
	}
	/**
	 * 删除系统资源
	 * @param id
	 */
	@Transactional(readOnly = false)
	public void deleteRes(String id){
		resDao.deleteByPrimaryKey(id);
	}
	/**
	 * 批量删除系统资源
	 * @param id
	 * @throws JlException 
	 */
	@Transactional(readOnly = false)
	public void deleteResBatch(List<SysResource> sysRes) throws JlException{
		List<String> lists=new ArrayList<String>();
		for(SysResource res:sysRes){
			String resId=res.getUuid();
			if(hasChildRes(resId)){
				throw new JlException("请先删除子资源");
			}else{
				lists.add(resId);
			}
		}
		roleresDao.deleteRoleResBatchByResIds(lists);
		resDao.deleteResBatchByResId(lists);
	}
	/**
	 * 判断是否有子资源
	 * @param parentid
	 * @return
	 */
	public boolean hasChildRes(String parentid){
		int num=resDao.getResChildNum(parentid);
		if(num>0){
			return true;
		}else{
			return false;
		}
	}
	/**
	 * 根据角色id获取角色
	 * @param id
	 * @return
	 */
	public Role getRoleById(String id){
		return roleDao.selectByPrimaryKey(id);
	}
	/**
	 * 获取所有角色
	 * @return
	 */
	public List<Role> getRoles(){
		return roleDao.selectRoles();
	}
	/**
	 * 新增角色
	 * @param role
	 */
	@Transactional(readOnly = false)
	public void insertRole(Role role){
			roleDao.insert(role);
	}
	/**
	 * 更新角色
	 * @param role
	 */
	@Transactional(readOnly = false)
	public void updateRole(Role role){
		roleDao.updateByPrimaryKey(role);
	}
	/**
	 * 删除角色
	 * @param id
	 */
	@Transactional(readOnly = false)
	public void deleteRole(String id){
		roleDao.deleteByPrimaryKey(id);
	}
	
	/**
	 * 批量删除角色
	 * @param id
	 */
	@Transactional(readOnly = false)
	public void deleteRoleBatch(List<Role> roles){
		List<String> lits=new ArrayList<String>();
		for(Role role:roles){
			String roleId=role.getUuid();
			lits.add(roleId);
			
		}
		roelGroupDao.deleteRoleEmpBatchByRoleIds(lits);
		roleresDao.deleteRoleResBatchByRoleIds(lits);
		roleDao.deleteRoleBatch(lits);
	}
	

	/**
	 * 根据角色id获取资源id
	 * @param roleId
	 * @return
	 */
	public List<String> getResByRoleId(String roleId){
		return  roleresDao.selectByRoleId(roleId);
	}
	/**
	 * 新增角色资源
	 * @param roleRes
	 */
	@Transactional(readOnly = false)
	public void inserRoleRes(RoleRes roleRes){
		roleresDao.insert(roleRes);
	}
	/**
	 * 保存角色资源
	 * @param insertlist
	 * @param deletelist
	 */
	@Transactional(readOnly = false)
	public void saveRoleReses(List<RoleRes> insertlist,List<RoleRes> deletelist){
		for(RoleRes inroleRes:insertlist){
			SysResource res=resDao.selectByPrimaryKey(inroleRes.getResid());
			if("page".equals(res.getResType())){
			roleresDao.insert(inroleRes);
			}
		}
		for(RoleRes deroleRes: deletelist){
			SysResource deleteres=resDao.selectByPrimaryKey(deroleRes.getResid());
			if("page".equals(deleteres.getResType())){
			Map<String,String> map=new HashMap<String,String>();
			map.put("resid", deroleRes.getResid());
			map.put("roleid", deroleRes.getRoleid());
			roleresDao.deleteByRoleIdAndResId(map);
			}
		}
	}
	/**
	 * 
	 * @param roleId
	 * @param parentid
	 * @return
	 */
	public List<ZtreeModel> getResTreeByRole(String roleId,String parentid){
		List<String> lists=new ArrayList<String>();
		if(!"".equals(roleId)){
			List<String> resList=roleresDao.selectByRoleId(roleId);
			lists.addAll(resList);
		}
		
		List<SysResource> reses=resDao.selectByParentid(parentid);
		List<ZtreeModel> treeModels=new ArrayList<ZtreeModel>();
		for(SysResource res:reses){
			boolean ifCheck=false;
			for(String s:lists){
				if(s.equals(res.getUuid())){
					ifCheck=true;
				}
			}
			ZtreeModel tm=new ZtreeModel();
			tm.setId(res.getUuid());
			tm.setName(res.getResName());
			tm.setpId(res.getParentid());
			if(ifCheck){
			tm.setChecked(ifCheck);
			}
			boolean b=hasChildRes(res.getUuid());
			if(b){
				tm.setisParent(b);
			}
			treeModels.add(tm);
		}		
		return treeModels;
	}
	/**
	 * 根据角色id获取人员
	 * @param roleId
	 * @return
	 */
	public List<RoleEmpBean> getEmpByRole(String roleId){
		return roelGroupDao.selectByRoleId(roleId);
	}
	/**
	 * 新增角色对应人
	 * @param roleGroup
	 */
	@Transactional(readOnly = false)
	public void insertRoleEmp(RoleGroup roleGroup){
		roelGroupDao.insert(roleGroup);
	}
	/**
	 * 删除角色对应人
	 * @param id
	 */
	@Transactional(readOnly = false)
	public void deleteRoleEmp(String id){
		roelGroupDao.deleteByPrimaryKey(id);
	}
	/**
	 * 删除角色对应人
	 * @param id
	 */
	@Transactional(readOnly = false)
	public void deleteRoleEmpBatchByIds(List<String> ids){
		roelGroupDao.deleteRoleEmpBatchByIds(ids);
	};
	/**
	 * 获取所有角色url
	 * @return
	 */
	public Map<String,String> selectALlRoleUrl(){
		
		return roleresDao.selecAllRoleUrl();
	}
	/**
	 * 获取所有url对应角色用于shiro
	 * @return
	 */
	public List<UrlRoleBean> selectAllUrlRole(){
		List<SysResource> listRes=resDao.selectAllPage();
		List<UrlRoleBean> lists=new ArrayList<UrlRoleBean>();
		for(SysResource res:listRes){
			UrlRoleBean urlRole =new UrlRoleBean();	
			String uuid=res.getUuid();
			String url=res.getUrlCode();
			List<String> roleIds=roleresDao.selectByResId(uuid);
			urlRole.setUrl(url);
			urlRole.setRoles(roleIds);
			lists.add(urlRole);
		}
		return lists;
	}
	/**
	 * 查询人对应的所有角色
	 * @param groupId
	 * @return
	 */
	public List<String> selectGroupRoles(String groupId){
		return roelGroupDao.selectByGroupId(groupId);
	}
	/**
	 * 根据原编码获取人员信息
	 * @param empCode
	 * @return
	 */
	public Employee selectEmpByCode(String empCode){
		return empDao.selectByEmpCode(empCode);
	}
}
