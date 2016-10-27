/**
 *  Copyright 2012 Society for Health Information Systems Programmes, India (HISP India)
 *
 *  This file is part of Dms module.
 *
 *  Dms module is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  Dms module is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Dms module.  If not, see <http://www.gnu.org/licenses/>.
 *  
 *  author: ghanshyam
 *  date: 24-12-2012
 **/

package org.openmrs.module.hospitalcore.model;

import java.util.Date;
import org.openmrs.Concept;
import org.openmrs.User;

public class DmsOpdUnit {
	private Integer id;
	private Integer unitNo;
	private Concept opdConceptId;
	private String opdWorkingDay;
	private String startTime;
	private String endTime;
	private Date unitActiveDate;
	private Date unitDeactiveDate;
	private Integer creator;
	
	// setter and getter
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getUnitNo() {
		return unitNo;
	}
	public void setUnitNo(Integer unitNo) {
		this.unitNo = unitNo;
	}
	public Concept getOpdConceptId() {
		return opdConceptId;
	}
	public void setOpdConceptId(Concept opdConceptId) {
		this.opdConceptId = opdConceptId;
	}
	public String getOpdWorkingDay() {
		return opdWorkingDay;
	}
	public void setOpdWorkingDay(String opdWorkingDay) {
		this.opdWorkingDay = opdWorkingDay;
	}
	public String getStartTime() {
		return startTime;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	public Date getUnitActiveDate() {
		return unitActiveDate;
	}
	public void setUnitActiveDate(Date unitActiveDate) {
		this.unitActiveDate = unitActiveDate;
	}
	public Date getUnitDeactiveDate() {
		return unitDeactiveDate;
	}
	public void setUnitDeactiveDate(Date unitDeactiveDate) {
		this.unitDeactiveDate = unitDeactiveDate;
	}
	public Integer getCreator() {
		return creator;
	}
	public void setCreator(Integer creator) {
		this.creator = creator;
	}
	
}
