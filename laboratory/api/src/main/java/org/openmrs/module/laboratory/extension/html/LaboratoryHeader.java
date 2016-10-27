/**
 *  Copyright 2011 Society for Health Information Systems Programmes, India (HISP India)
 *
 *  This file is part of Laboratory module.
 *
 *  Laboratory module is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  Laboratory module is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Laboratory module.  If not, see <http://www.gnu.org/licenses/>.
 *
 **/

package org.openmrs.module.laboratory.extension.html;

import org.openmrs.module.Extension;

public class LaboratoryHeader extends Extension {

	public MEDIA_TYPE getMediaType() {
		return MEDIA_TYPE.html;
	}
	
	public String getRequiredPrivilege() {
		return "Access Laboratory";
	}

	public String getLabel() {
		return "laboratory.title";
	}

	public String getUrl() {
		return "module/laboratory/main.form";
	}
}
