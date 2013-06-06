package com.yang.oa.hr.dao;

import java.util.List;

import com.yang.oa.commons.MyBatisRepository;
import com.yang.oa.hr.entity.Role;
@MyBatisRepository
public interface RoleMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table role
     *
     * @mbggenerated Thu May 16 16:20:53 CST 2013
     */
    int deleteByPrimaryKey(String uuid);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table role
     *
     * @mbggenerated Thu May 16 16:20:53 CST 2013
     */
    int insert(Role record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table role
     *
     * @mbggenerated Thu May 16 16:20:53 CST 2013
     */
    int insertSelective(Role record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table role
     *
     * @mbggenerated Thu May 16 16:20:53 CST 2013
     */
    Role selectByPrimaryKey(String uuid);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table role
     *
     * @mbggenerated Thu May 16 16:20:53 CST 2013
     */
    int updateByPrimaryKeySelective(Role record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table role
     *
     * @mbggenerated Thu May 16 16:20:53 CST 2013
     */
    int updateByPrimaryKey(Role record);
    List<Role> selectRoles();
    int deleteRoleBatch(List<String> rolesId);
}