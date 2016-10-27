/**
 * Copyright 2011 Society for Health Information Systems Programmes, India (HISP
 * India)
 *
 * This file is part of Laboratory module.
 *
 * Laboratory module is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * Laboratory module is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Laboratory module. If not, see <http://www.gnu.org/licenses/>.
 *
 *
 */
package org.openmrs.module.laboratory.web.util;

import java.util.List;
import org.openmrs.Concept;
import org.openmrs.ConceptSet;
import org.openmrs.module.hospitalcore.model.DiaConceptNumericRe;

public class TestResultModel implements Comparable<TestResultModel> {

    public static final String LEVEL_INVESTIGATION = "LEVEL_INVESTIGATION";
    public static final String LEVEL_SET = "LEVEL_SET";
    public static final String LEVEL_SET_SUB = "LEVEL_SET_SUB";
    public static final String LEVEL_TEST = "LEVEL_TEST";
    public static final String LEVEL_RESULT = "LEVEL_RESULT";
    public static final String LEVEL_TEST1 = "LEVEL_TEST1";

    public String investigation;
    public String set;
    public String test;
    public String value;
    public String hiNormal;
    public String lowNormal;
    public String unit;
    public String level = LEVEL_TEST;
    public Concept concept;
    public Integer encounterId;
    public Integer testId;
    public String set1;
    public String level1 = LEVEL_TEST1;
    public ConceptSet conceptSet;
    public String refRange;

    public String getRefRange() {
        return refRange;
    }

    public void setRefRange(String refRange) {
        this.refRange = refRange;
    }

    public ConceptSet getConceptSet() {
        return conceptSet;
    }

    public void setConceptSet(ConceptSet conceptSet) {
        this.conceptSet = conceptSet;
    }

    public String getLevel1() {
        return level1;
    }

    public void setLevel1(String level1) {
        this.level1 = level1;
    }

    public String getSet1() {
        return set1;
    }

    public void setSet1(String set1) {
        this.set1 = set1;
    }

    public String getInvestigation() {
        return investigation;
    }

    public void setInvestigation(String investigation) {
        this.investigation = investigation;
    }

    public String getTest() {
        return test;
    }

    public void setTest(String test) {
        this.test = test;
    }

    public String getHiNormal() {
        return hiNormal;
    }

    public void setHiNormal(String hiNormal) {
        this.hiNormal = hiNormal;
    }

    public String getLowNormal() {
        return lowNormal;
    }

    public void setLowNormal(String lowNormal) {
        this.lowNormal = lowNormal;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getSet() {
        return set;
    }

    public void setSet(String set) {
        this.set = set;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public Concept getConcept() {
        return concept;
    }

    public void setConcept(Concept concept) {
        this.concept = concept;
    }

    public Integer getEncounterId() {
        return encounterId;
    }

    public void setEncounterId(Integer encounterId) {
        this.encounterId = encounterId;
    }

    public Integer getTestId() {
        return testId;
    }

    public void setTestId(Integer testId) {
        this.testId = testId;
    }

    public int compareTo(TestResultModel o) {
        if (o == null) {
            return 1;
        }
        if (this == null) {
            return -1;
        }

        String tInvestigation = this.getInvestigation();
        String tSet = this.getSet();
        String tTest = this.getTest();
        String oInvestigation = o.getInvestigation();
        String oSet = o.getSet();
        String oTest = o.getTest();
        int investigationCompare = tInvestigation
                .compareToIgnoreCase(oInvestigation);
        int setCompare = tSet.compareToIgnoreCase(oSet);
        int testCompare = tTest.compareToIgnoreCase(oTest);
        if (investigationCompare != 0) {
            return investigationCompare;
        } else if (setCompare != 0) {
            return setCompare;
        } else {
            return testCompare;
        }
    }

}
