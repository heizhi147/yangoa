package com.yang.oa.commons;

import java.io.Serializable;
import java.util.List;

import javax.annotation.PostConstruct;

import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authc.credential.HashedCredentialsMatcher;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springside.modules.utils.Encodes;

import com.google.common.base.Objects;
import com.yang.oa.hr.entity.Employee;
import com.yang.oa.hr.service.CompyInfoService;
import com.yang.oa.hr.service.PowerInfoService;


public class ShiroDbRealm extends AuthorizingRealm{
	@Autowired
	private PowerInfoService powerservice;
	/**
	 * 授权查询回调函数, 进行鉴权但缓存中无用户的授权信息时调用.
	 */
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(
			PrincipalCollection principals) {
		ShiroUser shiroUser = (ShiroUser) principals.getPrimaryPrincipal();
		List<String> roles= powerservice.selectGroupRoles(shiroUser.getId());
		for(String s:roles){
		System.out.println("-----------------------------------"+s);
		}
		SimpleAuthorizationInfo ainfo = new SimpleAuthorizationInfo();
		ainfo.addRoles(roles);
		return ainfo;
				
	}
	/**
	 * 登陆时调用此函数
	 */
	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(
			AuthenticationToken token) throws AuthenticationException {
		UsernamePasswordToken tk=(UsernamePasswordToken) token;
		Employee emp=powerservice.selectEmpByCode(tk.getUsername());
		if(emp !=null){
			byte[] salt = Encodes.decodeHex(emp.getSalt());
			return new SimpleAuthenticationInfo(new ShiroUser(emp.getUuid(), emp.getEmpCode(), emp.getEmpName()),
					emp.getPwd(), ByteSource.Util.bytes(salt), getName());
		}else{	
			return null;
		}
	}
	
	/**
	 * 设定Password校验的Hash算法与迭代次数.
	 */
	@PostConstruct
	public void initCredentialsMatcher() {
		HashedCredentialsMatcher matcher = new HashedCredentialsMatcher(CompyInfoService.HASH_ALGORITHM);
		matcher.setHashIterations(CompyInfoService.HASH_INTERATIONS);

		setCredentialsMatcher(matcher);
	}
	/**
	 * 自定义Authentication对象，使得Subject除了携带用户的登录名外还可以携带更多信息.
	 */
	public static class ShiroUser implements Serializable {
		private static final long serialVersionUID = -1373760761780840081L;
		public String id;
		public String loginName;
		public String name;
		public ShiroUser(String id, String loginName, String name) {
			this.id = id;
			this.loginName = loginName;
			this.name = name;
		}

		public String getName() {
			return name;
		}
		public String getId() {
			return id;
		}
		/**
		 * 本函数输出将作为默认的<shiro:principal/>输出.
		 */
		@Override
		public String toString() {
			return loginName;
		}

		/**
		 * 重载hashCode,只计算loginName;
		 */
		@Override
		public int hashCode() {
			return Objects.hashCode(loginName);
		}

		/**
		 * 重载equals,只计算loginName;
		 */
		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (getClass() != obj.getClass())
				return false;
			ShiroUser other = (ShiroUser) obj;
			if (loginName == null) {
				if (other.loginName != null)
					return false;
			} else if (!loginName.equals(other.loginName))
				return false;
			return true;
		}
	}

}
