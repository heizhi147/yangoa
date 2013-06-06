package com.yang.oa.hr.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springside.modules.security.utils.Digests;
import org.springside.modules.utils.Encodes;

import com.yang.oa.commons.PagingBean;
import com.yang.oa.commons.exception.JlException;
import com.yang.oa.hr.dao.EmployeeMapper;
import com.yang.oa.hr.dao.OrganizationMapper;
import com.yang.oa.hr.dao.PostMapper;
import com.yang.oa.hr.dao.RoleGroupMapper;
import com.yang.oa.hr.entity.Employee;
import com.yang.oa.hr.entity.Organization;
import com.yang.oa.hr.entity.Post;

@Service
@Transactional(readOnly = true)
public class CompyInfoService {
	
	public static final String HASH_ALGORITHM = "SHA-1";
	public static final int HASH_INTERATIONS = 1024;
	private static final int SALT_SIZE = 8;
	@Autowired
	private OrganizationMapper orgDao;
	@Autowired
	private PostMapper postDao;
	@Autowired
	private EmployeeMapper empDao;
	@Autowired
	private RoleGroupMapper roleGroupDao;
	/**
	 * 获取一级组织
	 * @return
	 */
	public  List<Organization> getOrgInfo(){	
		return orgDao.selectParentIsNull();
	}
	/**
	 * 保存组织
	 * @param org
	 */
	@Transactional(readOnly = false)
	public void saveOrgInfo(Organization org){
		orgDao.insert(org);
	}
	/**
	 * 根据ID删除组织
	 * @param ids
	 */
	@Transactional(readOnly = false)
	public void deleteOrgById(List<String> ids){
		for(String id:ids){
		orgDao.deleteByPrimaryKey(id);
		}
	}
	
	@Transactional(readOnly = false)
	public void deleteOrgs(List<Organization> lists) throws JlException{
		for(Organization org:lists){
			if(haveOrgChild(org.getUuid())){
				throw new JlException("请先删除子组织");
			}
			int num =empDao.selectEmpsNumByOrg(org.getUuid());
			if(num>0){
				throw new JlException(org.getOrgName()+"存在下属人员无法删除");
			}
		}
	
		orgDao.deleteBatch(lists);
	}
	/**
	 * 根据ID更新组织信息
	 * @param org
	 */
	@Transactional(readOnly = false)
	public void updateOrg(Organization org){
		orgDao.updateByPrimaryKey(org);
	}
	/**
	 * 根据父组织ID获取子组织
	 * @param parentid
	 * @return
	 */
	public List<Organization> getOrgInfoByParentid(String parentid){
		return orgDao.selectOrgByParentid(parentid);
	}
	/**
	 * 判定是否含有子组织
	 * @param parentid
	 * @return
	 */
	public boolean haveOrgChild(String parentid){
		int num=orgDao.getOrgChildNum(parentid);
		if(num>0){
			return true;
		}else{
			return false;
		}

	}
	/**
	 * 根据ID查询组织信息
	 * @param uuid
	 * @return
	 */
	public Organization getOrgByPk(String uuid){
		return orgDao.selectByPrimaryKey(uuid);
	}
	
	
	/**
	 * 新增岗位
	 * @param post
	 */
	@Transactional(readOnly = false)
	public void  insertPost(Post post){
		postDao.insert(post);
		
	}
	/**
	 * 根据父节点获取岗位
	 * @param parentid
	 * @return
	 */
	public List<Post> getPostByparent(String parentid){	
		return postDao.selectByParent(parentid);
		
	}
	/**
	 * 根据id获取岗位
	 * @param id
	 * @return
	 */
	public Post getPostById(String id){	
		return postDao.selectByPrimaryKey(id);
		
	}
	/**
	 * 删除岗位
	 * @param id
	 */
	@Transactional(readOnly = false)
	public void deletePostById(String id){	
		postDao.deleteByPrimaryKey(id);
		
	}
	@Transactional(readOnly = false)
	public void deletePostBatch(List<Post> posts) throws JlException{	
		for(Post post:posts){
			if(havePostChild(post.getUuid())){
				throw new JlException("请先删除子组织");
			}
		int num=empDao.selectEmpsNumByPost(post.getUuid());
		if(num>0){
			throw new JlException(post.getPostName()+"存在下属人员无法删除");
		}
		postDao.deletePostsBatch(posts);
		}
		
	}
	/**
	 * 更新岗位
	 * @param post
	 */
	@Transactional(readOnly = false)
	public void updatePost(Post post){
		postDao.updateByPrimaryKey(post);
	}
	/**
	 * 判断是否含有子岗位
	 * @param parentid
	 * @return
	 */
	public boolean havePostChild(String parentid){
		int num=postDao.getPostChildNum(parentid);
		if(num>0){
			return true;
		}else{
			return false;
		}

	}
	
	public List<Employee> getEmployeesByOrg(String orgId){
		return empDao.selectByOrg(orgId);
	}
	@Transactional(readOnly = false)
	public void insertEmployee(Employee emp){
		entryptPassword(emp);
		empDao.insert(emp);
	}
	@Transactional(readOnly = false)
	public void deleteEmployee(String id){
		empDao.deleteByPrimaryKey(id);
	}
	@Transactional(readOnly = false)
	public void deleteEmployeeBatch(List<String> empsId){
		roleGroupDao.deleteRoleEmpBatchByEmpsIds(empsId);
		empDao.deleteEmpBatch(empsId);
	}
	public Employee getEmpById(String id){
		return empDao.selectByPrimaryKey(id);
	}
	@Transactional(readOnly = false)
	public void updateEmp(Employee emp){
		empDao.updateByPrimaryKey(emp);
	}
	
	public List<Employee> selectEmpByByNameAndCode(String name,String code,PagingBean pageBean){
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("empCode", code);
		map.put("empName", name);
		map.put("currentRows", pageBean.getCurrentRows());
		map.put("onePageRows", pageBean.getOnePageRows());
		return empDao.selectByCodeAndName(map);
		
	}
	public int selectEmpNumByByNameAndCode(String name,String code){
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("empCode", code);
		map.put("empName", name);
		return empDao.selectRowNumByCodeAndName(map);
		
	}
	
	public List<Employee> selectAllEmp(){
		return empDao.selectAllEmp();
	}
	
	public List<Employee> selectEmployeesPaging(PagingBean pageBean){
		return empDao.selectEmpPageing(pageBean);
		
	}
	
	public int selectEmpNum(){
		return empDao.selectEmpNum();
	}
	
	/**
	 * 设定安全的密码，生成随机的salt并经过1024次 sha-1 hash
	 */
	private void entryptPassword(Employee user) {
		byte[] salt = Digests.generateSalt(SALT_SIZE);
		user.setSalt(Encodes.encodeHex(salt));

		byte[] hashPassword = Digests.sha1(user.getPwd().getBytes(), salt, HASH_INTERATIONS);
		user.setPwd(Encodes.encodeHex(hashPassword));
	}
}
