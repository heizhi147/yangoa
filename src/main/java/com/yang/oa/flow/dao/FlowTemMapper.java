package com.yang.oa.flow.dao;

import java.util.List;

import com.yang.oa.commons.MyBatisRepository;
import com.yang.oa.commons.PagingBean;
import com.yang.oa.flow.entity.FlowTem;
@MyBatisRepository
public interface FlowTemMapper {
	List<FlowTem> selectFlowByName(String flowTemName);
	List<FlowTem> selectFlowByNamePageing(PagingBean pageBean);
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table flow_tem
     *
     * @mbggenerated Thu Jun 06 13:23:55 CST 2013
     */
    int deleteByPrimaryKey(String uuid);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table flow_tem
     *
     * @mbggenerated Thu Jun 06 13:23:55 CST 2013
     */
    int insert(FlowTem record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table flow_tem
     *
     * @mbggenerated Thu Jun 06 13:23:55 CST 2013
     */
    int insertSelective(FlowTem record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table flow_tem
     *
     * @mbggenerated Thu Jun 06 13:23:55 CST 2013
     */
    FlowTem selectByPrimaryKey(String uuid);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table flow_tem
     *
     * @mbggenerated Thu Jun 06 13:23:55 CST 2013
     */
    int updateByPrimaryKeySelective(FlowTem record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table flow_tem
     *
     * @mbggenerated Thu Jun 06 13:23:55 CST 2013
     */
    int updateByPrimaryKey(FlowTem record);
}