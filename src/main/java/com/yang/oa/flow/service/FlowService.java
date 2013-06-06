package com.yang.oa.flow.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yang.oa.flow.dao.FlowTemMapper;
import com.yang.oa.flow.entity.FlowTem;
@Service
public class FlowService {
	@Autowired
	private FlowTemMapper flowTemDao;
	
	@Transactional(readOnly = false)
	public void inserFlowTem(FlowTem flowTem){
		flowTemDao.insertSelective(flowTem);
	}
	@Transactional(readOnly = false)
	public void updateFlowTem(FlowTem flowTem){
		flowTemDao.updateByPrimaryKeySelective(flowTem);
	}
	@Transactional(readOnly = false)
	public void delFlowTem(String id){
		flowTemDao.deleteByPrimaryKey(id);
	}
	
	public List<FlowTem> selectFlowTemByName(String flowTemName){
		List<FlowTem> flowTems=flowTemDao.selectFlowByName(flowTemName);
		return flowTems;
	}
}
