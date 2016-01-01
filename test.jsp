<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/firium-taglib.tld" prefix="firium"%>
<%@ taglib uri="/WEB-INF/wms-logic.tld" prefix="wms-logic"%>
<%@ page import="com.firium.iplan.custom.wmp.form.FinancialPositionPageForm"%>
<%@ page import="com.firium.iplan.custom.wmp.view.DraftHeaderView"%>
<%@ page import="com.firium.iplan.custom.common.ExtConstants"%>
<%@ page import="com.firium.common.util.EntityContext"%>
<%@ page import="com.firium.iplan.common.Constants"%>
<%@ page import="com.firium.common.util.CustomerExtContext" %>
<%@ page import="com.firium.iplan.common.view.QuestionView"%>
<%@ page import="com.firium.iplan.common.view.AnswerView"%>
<%@ page import="com.firium.iplan.custom.wmp.view.MWPQuestionView"%>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="com.firium.common.util.LoginContext" %>
<%@page import="com.firium.common.util.CustomerContext"%>
<%@ page language="java"
	import="java.util.*,java.text.*,, com.firium.iplan.custom.common.ExtConstants, com.firium.iplan.common.view.*,com.firium.iplan.common.*,com.firium.common.util.FormatUtils,com.firium.iplan.custom.common.manager.*,com.firium.iplan.custom.common.*,com.firium.iplan.common.manager.*"%>
<%@ page import="com.firium.common.util.EntityContext" %>	
<%@ page import="com.firium.common.util.CustomerExtContext" %>
<%@ page import="java.util.List" %>
<%@ page import="com.firium.iplan.custom.common.ExtConstants" %>
<%@ page import="com.firium.iplan.custom.wmp.form.*" %>
<%@ page import="com.firium.iplan.common.view.*" %>
<%
/*
* List of hidden input:
* 1. name=validationStatus; for PAGE_STATE_MATRIX purpose
* 2. name=customer_<customerId> value=<customerId>
* 3. name=others_<customerId> value=<customerId>; to track if this customerId has "Others" in his answer
* 4. name=answerDesc_<answerId> value=<answerDesc>; for validation purpose
* 5. name=answers_<questionId> value=<answerId>; for form binding purpose - no. of answers per question
* 6. name=questions value=<questionId;answerType>; for form binding purpose
* 
* Applicant answer: 
* 1. Check-box: name=answer_checkbox_<answerId>_<customerId> value=<Constants.FLAG_SELECTED>
* 2. Radio: name=answer_radio_<questionId>_<customerId> value=<answerId>
* 3. name=othersTxt_<customerId> 
*/
FinancialPositionPageForm financialPositionPageForm = (FinancialPositionPageForm) request
	.getAttribute("financialPositionPageForm");
DraftHeaderView draftHeaderView = (DraftHeaderView) session
	.getAttribute(ExtConstants.DRAFT_MWP_CONTEXT);
EntityContext entityContext = (EntityContext) request.getSession()
	.getAttribute(Constants.SESSION_ENTITY_CONTEXT);	
String othersCode = (String) session.getAttribute(
	ExtConstants.LT_FINAPOSIS_OTHERS);
%>

<%
	LoginContext loginContext = (LoginContext) session.getAttribute(Constants.SESSION_LOGIN_CONTEXT);
	String language=loginContext.getLangCode();
	int rowCount = 0;
    int count=0;
%>

<!-- Header -->
<div class="row">
	<div class="col-lg-12 page-header-with-sub customh7">
		<bean:write name="financialPositionPageForm"
			property="descLangMap(common.mywealthplanner.label)" />
	</div>
	<div class="col-lg-12 customh8">
		<bean:write name="financialPositionPageForm"
			property="descLangMap(financialposition.header.label)" />
	</div>
</div>
<!-- /.Header -->

<html:form action="/mwp/financialPositionPageProcessAction">
	<input type="hidden" id="validationStatus" name="validationStatus" />
	<input type="hidden" id="submitType" name="submitType" value="submit" />
	<div class="row" id="wholeForm">
		<div class="panel">
			<div class="col-lg-12 section-header customh8">
				<bean:write name="financialPositionPageForm"
			property="descLangMap(financialposition.header.sublabel.1)" /> <span class="medium"><bean:write name="financialPositionPageForm"
			property="descLangMap(financialposition.header.sublabel.2)" /></span>
			</div>
			<div class="panel-body">
				<!-- Disclosure & Reason -->
				<div class="col-lg-12">
					<% if (!language.equalsIgnoreCase(Constants.LANG_EN_MY)) { %>
						<div class="col-lg-3 checkbox" style="position: relative; bottom: 8px; left: -30px">
							<%
								String undiscloseCheck = "";
												if (financialPositionPageForm.getUndiscloseFinaPosi() != null
														&& financialPositionPageForm.getUndiscloseFinaPosi().equals(
																ExtConstants.FLAG_SELECTED)) {
													undiscloseCheck = ExtConstants.CHECKED;
												}
							%>
							<label class="checkbox-blue" style="width: 40px;"> <input type="checkbox"
								value="<%=ExtConstants.FLAG_SELECTED%>" id="undiscloseFinaPosi"
								name="undiscloseFinaPosi" <%=undiscloseCheck%>
								class="<%=undiscloseCheck%> nodisclose" onclick="toggleStatus()">
								<label class="checkbox-bluebox" for="undiscloseFinaPosi"></label>
							</label>
							<bean:write
									name="financialPositionPageForm"
									property="descLangMap(financialposition.disclose.label)" />
						</div>
						<!-- <div class="col-lg-1">
							<bean:write name="financialPositionPageForm"
								property="descLangMap(financialposition.reason.label)" />
						</div>
						<div class="col-lg-8">
							<input class="form-control otherreason" type="text" name="reasonFinaPosi" id="reasonFinaPosi"
								value="<%=financialPositionPageForm.getReasonFinaPosi() == null
								? ""
								: financialPositionPageForm.getReasonFinaPosi()%>">
						</div> -->
					<% } %>
				</div>
				<!-- /.Disclosure & Reason -->
				<!-- Iterate the applicants -->
				<%
				for (CustomerExtContext customerExtContext: entityContext.getListOfCustomer()) {
				%>
	                <input type="hidden" name="customer_<%=customerExtContext.getCustomerId()%>" value="<%=customerExtContext.getCustomerId()%>" />
                    <input type="hidden" name="customername_<%=customerExtContext.getCustomerId()%>" value="<%=customerExtContext.getCustomerName()%>" />
                    <input type="hidden" name="others_<%=customerExtContext.getCustomerId()%>" value="" />
				<%
				}
				%>
				<!-- /.Iterate the applicants -->		
				<!-- Iterate the questions -->
				<%
				for (QuestionView questionView: financialPositionPageForm.getListQuestionView()) {
				%>
					<!-- To Hide Source of Funds Section -->
					<% if (!language.equalsIgnoreCase(Constants.LANG_EN_MY)) { %>

					 <!-- There is no Source of Funds Section -->
					 <!-- There is no Source of Funds Section -->
					
					<% } else { %>
					
					<div class="col-lg-12 table-responsive">
						<table class="table qualification">
							<thead>
								<tr>
									<th class="col-lg-4" style="border-bottom: 1px solid #fff">
										<label><%=questionView.getDesc()%></label>
										<%
										if (((MWPQuestionView)questionView).getAnswerType().equalsIgnoreCase("radio")) {
										%>
											<input type="hidden" name="questions" value="<%=questionView.getPkQuestionId()%>;radio" />
										<%
										 } else if(((MWPQuestionView)questionView).getAnswerType().equalsIgnoreCase("checkbox")){
										%>
										 	<input type="hidden" name="questions" value="<%=questionView.getPkQuestionId()%>;checkbox" />
										<%  
										} else {
										%>	 
										<input type="hidden" name="questions" value="<%=questionView.getPkQuestionId()%>;hnwi" />
										<%	 
										}
										%> 
                                        <input type="hidden" name="questionname_<%=questionView.getPkQuestionId()%>" value="<%=questionView.getDesc()%>" />
									</th>										
									<!-- Iterate the applicants -->
									
									<% if(!((MWPQuestionView)questionView).getAnswerType().equalsIgnoreCase("hnwi")){ %>
										<% for (CustomerExtContext customerExtContext: entityContext.getListOfCustomer()) { %>
												<th class="col-lg-2 text-center" style="border-bottom: 1px solid #fff">
													<label><%=customerExtContext.getCustomerName()%></label>
												</th>
										<% } %>
									<% } else { %>
											<th class="col-lg-2 text-center" style="border-bottom: 1px solid #fff"></th>
									<% } %>
									
									<!-- /.Iterate the applicants -->		
								</tr>
							</thead>
							<tbody>
								<!-- Iterate the answers -->
								<%
								for (Object object: questionView.getAnswer()) {
									AnswerView answerView = (AnswerView) object;
								%>
										<tr>
											<td class="col-lg-4">
												<label><%=answerView.getDesc()%></label>
												<input type="hidden" name="answers_<%=questionView.getPkQuestionId()%>" 
													value="<%=answerView.getId()%>" />
												<input type="hidden" name="answerDesc_<%=answerView.getId()%>" 
													value="<%=answerView.getDesc()%>" />
											</td>
											<!-- Iterate applicants' answers -->
											<%
											String checked;
											for (CustomerExtContext customerExtContext: entityContext.getListOfCustomer()) {
												
												checked = "";
												
												if (financialPositionPageForm.getMapApplicantAnswer().get(answerView.getId())
														.get(customerExtContext.getCustomerId())) {
													
													checked = "checked";
												}
											%>
												<td class="col-lg-2 text-center checkArea" style="vertical-align: middle;">
	                                            	<%
	                                            	if (((MWPQuestionView)questionView).getAnswerType().equalsIgnoreCase("radio")) {
	                                            	%>
			                                            <div class="radio">
		                                                    <label class="radio-blue"> <input type="radio"
                                                                    name="answer_radio_<%=questionView.getPkQuestionId()%>_<%=customerExtContext.getCustomerId()%>"
                                                                    id="answer_radio_<%=answerView.getId()%>_<%=customerExtContext.getCustomerId()%>" 
                                                                    value="<%=answerView.getId()%>"
                                                                    class="<%=checked%>" <%=checked%>>
                                      								<label class="radio-bluebox" 
                                      									for="answer_radio_<%=answerView.getId()%>_<%=customerExtContext.getCustomerId()%>"><label></label></label>
                                  							</label>	
                                  						<!-- cek source of funds Questions -->		          
                                					<%                                  		
	                                            	} else if (((MWPQuestionView)questionView).getAnswerType().equalsIgnoreCase("checkbox")) {
	                                            	%>
			                                            <div class="checkbox">
			                                                <label class="checkbox-blue"> 
			                                                	<input type="checkbox" 
			                                                		name="answer_checkbox_<%=answerView.getId()%>_<%=customerExtContext.getCustomerId()%>" 
			                                                		id="answer_checkbox_<%=answerView.getId()%>_<%=customerExtContext.getCustomerId()%>" 
			                                                		value="<%=Constants.FLAG_SELECTED%>" 
			                                                		class="<%=checked%>" <%=checked%>
			                                                		onclick="checkIfTypeOthers('<%=answerView.getId()%>','<%=customerExtContext.getCustomerId()%>')"> 
			                                                	<label class="checkbox-bluebox" 
			                                                		for="answer_checkbox_<%=answerView.getId()%>_<%=customerExtContext.getCustomerId()%>"></label>
			                                                </label>
		                                            <%
		                                            }
	                                                if (answerView.getDesc().equalsIgnoreCase(othersCode)) {
	                                                %>
															<textarea class="form-control" rows="3" 
																name="othersTxt_<%=customerExtContext.getCustomerId()%>"><%=financialPositionPageForm.getMapApplicantOthers().get(customerExtContext.getCustomerId())%></textarea>
	                                                <%
	                                                }
	                                                %>
		                                            </div>
												</td>
											<%
											}
											%>
											<!-- /.Iterate applicants' answers -->
										</tr>
								<%
								}
								%>
								<!-- /.Iterate the answers -->
							</tbody>
						</table>								
					</div>
				<%
				}
				
				%>
				<!-- /.Iterate the questions -->
				
	            <% if (language.equalsIgnoreCase(Constants.LANG_EN_MY)) { %>
	            <%	if(financialPositionPageForm.getHnwiValue() != null && financialPositionPageForm.getHnwiValue().equalsIgnoreCase("Y")){ %>
	            	
	            	
                <div class="col-lg-12">
                    <div class="tabs" role="tabpanel">
                        <!-- Nav tabs -->
                        <div class="menuTabs" style="border: 1px solid #e1e1e1;">
                            <ul class="nav nav-tabs nav-justified" role="tablist">
                                <%
                                    count=0;
                                    for(CustomerExtContext context: entityContext.getListOfCustomer()){
                                        count++;
                                        if(count==1){
                                %>
                                    <li role="presentation" class="active">
                                <%}else{%>
                                    <li role="presentation">
                                <%}%>
                                    <a
                                        href="#hnwideclaration_<%=context.getCustomerId()%>" aria-controls="hnwideclaration_<%=context.getCustomerId()%>" role="tab"
                                        data-toggle="tab"><%=context.getCustomerName()%></a></li>
                                <%}%>

                            </ul>

                            <!-- Tab panes -->
                            <div class="tab-content" style="padding: 5px;">
                                <%
                                    count=0;
                                    for(CustomerExtContext context: entityContext.getListOfCustomer()){
                                        count++;
                                        if(count==1){
                                %>

                                    <div role="tabpanel" class="tab-pane active row" id="hnwideclaration_<%=context.getCustomerId()%>">
                                <%}else{%>
                                    <div role="tabpanel" class="tab-pane row" id="hnwideclaration_<%=context.getCustomerId()%>">
                                <%}%>
                                	<div class="col-lg-12 topPadding20">
	                                	<table class="table">
	                                    	<thead>
	                                        	<tr>
	                                            	<div class="col-lg-12 customh8">
	                                                	<bean:write filter="false" name="financialPositionPageForm" property="descLangMap(financialposition.hnwi.requirement.1)"/>
	                                                </div>
	                                            </tr>
	                                        </thead>
	                                        <tbody>
	                                        	<tr>
	                                            	<td>
	                                                	<div class="col-lg-1">
	                                                    	<label class="checkbox-blue"> <input type="checkbox" value="<%=ExtConstants.FLAG_SELECTED%>" class="required"
										                    		name="hnwiFlag_<%=context.getCustomerId()%>" 
										                    		id="hnwiFlag_<%=ExtConstants.FLAG_SELECTED%>_<%=context.getCustomerId()%>"
										                    		class="<%=financialPositionPageForm.getHnwiFlag()!=null && financialPositionPageForm.getHnwiFlag().equalsIgnoreCase("Y")?"checked":""%>"
										                    		<%=financialPositionPageForm.getHnwiFlag()!=null && financialPositionPageForm.getHnwiFlag().equalsIgnoreCase("Y")?"checked='checked'":"" %>> 
										                    		<label class="checkbox-bluebox" for="hnwiFlag_<%=ExtConstants.FLAG_SELECTED%>_<%=context.getCustomerId()%>"></label>
										                	</label>
										                </div>
	                                                   
	                                                    <div class="col-lg-11">
	                                                        <p><bean:write filter="false" name="financialPositionPageForm" property="descLangMap(financialposition.hnwi.requirement.2)"/></p>
								                    		<p><bean:write filter="false" name="financialPositionPageForm" property="descLangMap(financialposition.hnwi.requirement.3)"/></p>
								                    		<p><bean:write filter="false" name="financialPositionPageForm" property="descLangMap(financialposition.hnwi.requirement.4)"/></p>
					                                	</div>
	                                                </td>
	                                            </tr>
	                                        </tbody>
	                                    </table>
                                   </div>
                                   
                                   </div>
                                <%}%>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <%		}
                	}
                %>
	            <% } %> 
	            
			</div>
		</div>
	</div>
	<!-- END of Source of Fund Section -->
	
	<!-- Next button -->
	<div class="row">
		<div class="col-lg-6 col-lg-offset-3">
			<div class="col-lg-12">
				<div class="col-lg-12 text-center endForm">
					<button type="button" id="nextButton" class="btn btn-default">
						<bean:write name="financialPositionPageForm"
							property="descLangMap(common.next.button)" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- /.Next button -->
</html:form>

<script type="text/javascript">
	$(document).ready(function() {
		
		$('textarea').maxlength({
			max: 1000,
			showFeedback: false
		});
		
		// If not all applicants are present then disable the whole form exclude the next button
		<%
		if (draftHeaderView.getCustomerExtViews().size() < entityContext
			.getListOfCustomer().size()) {
		%>
			$('#undiscloseFinaPosi').prop('disabled', true);
			$('#undiscloseFinaPosi').addClass('disabled');
			$('#undiscloseFinaPosi').parent().addClass('disabled');
			
			$('#reasonFinaPosi').prop('disabled', true);
			
			$('input[name^="answer_"]').each(function(i) {
				$(this).prop('disabled', true);
				$(this).addClass('disabled');
				$(this).parent().addClass('disabled');
			});
			
			$('textarea[name^="othersTxt_"]').each(function(i) {
				$(this).prop('disabled', true);
				$(this).addClass('disabled');
			});
		<%
		} else {
		%>
		
			toggleStatus();
		<%
		}
		%>

		$('a[name="financialPositionMenu"]').parent().addClass('active');
		$('a[name="financialPositionMenu"]').attr('href', '#');
	});

	function toggleStatus() {

		if ($('#undiscloseFinaPosi').is(':checked')) {

			// Disable & initialize all elements below the "Disclosure" and "Reason" section except for the next button
			$('input[name^="answer_"]').each(function(i) {
				$(this).prop('disabled', true);
				$(this).addClass('disabled');
				$(this).parent().addClass('disabled');
				$(this).prop('checked', false);
				$(this).removeClass('checked');
				$(this).removeClass('selected');
			});
			
			// Enable "Reason"
			$('input[name="reasonFinaPosi"]').removeAttr('disabled');
			
			$('textarea[name^="othersTxt_"]').each(function(i) {
				$(this).prop('disabled', true);
				$(this).addClass('disabled');
				$(this).val("");
			});
		} else {

			// Enable the "Answers"
			$('input[name^="answer_"]').each(function(i) {
				$(this).prop('disabled', false);
				$(this).removeClass('disabled');
				$(this).parent().removeClass('disabled');
			});
			
			// Enable "Others text"
			//$('textarea[name^="othersTxt_"]').each(function(i) {
			//	$(this).prop('disabled', false);
			//	$(this).removeClass('disabled');
			//});
			// Enable "Others text" if based on the answer
			$('input[name^="customer_"]').each(function(i) {
				
				customerId = $(this).val();
				
				$('input[name^="answers_"]').each(function(i) {
					
					answerId = $(this).val();
					
					checkIfTypeOthers(answerId, customerId);
				});
			});
			
			// Empty and disable reason
			$('input[name="reasonFinaPosi"]').val("");
			$('input[name="reasonFinaPosi"]').attr('disabled', true);
		}
	}
	
	function checkIfTypeOthers(answerId, customerId) {

		//alert("Is this others? " + $('input[name="answerDesc_' + answerId + '"]').val());
		if ($('input[name="answerDesc_' + answerId + '"]').val() == "<%=othersCode%>") {

			toggleOthersText(answerId, customerId);
		}
	}
	
	function toggleOthersText(answerId, customerId) {
		
		//alert($('#answer_checkbox_' + answerId + '_'+ customerId).is(':checked'));
		if ($('#answer_checkbox_' + answerId + '_'+ customerId).is(':checked')) {	
			
			//alert("Others is checked!");
			$('textarea[name^="othersTxt_' + customerId + '"]').prop('disabled', false);
			$('textarea[name^="othersTxt_' + customerId + '"]').removeClass('disabled');
			
			$('input[name="others_' + customerId + '"]').val(customerId);
		} else {
			
			//alert("Others is unchecked!");
			$('textarea[name^="othersTxt_' + customerId + '"]').prop('disabled', true);
			$('textarea[name^="othersTxt_' + customerId + '"]').addClass('disabled');
			$('textarea[name^="othersTxt_' + customerId + '"]').val("");
			
			$('input[name="others_' + customerId + '"]').val("");
		}
	}
	
	isValid = function() {
		
        var message = "";
        var status = true;

        // If "do not wish to disclose" is checked then "reason" must not be empty
        // Updated: "reason" is no longer needed. This filed has been removed since 28 Mar 2015
		if ($('#undiscloseFinaPosi').is(':checked')) {
			
        //	if($.trim($('input[name="reasonFinaPosi"]').val())=="")
        //	{
        //		status = false;
        //		message = '<bean:write name="financialPositionPageForm" property="descLangMap(financialposition.validation.error.reason)"/>';
		//      return {'status':status, 'message':message};
        //	}			
		} else {
        
			// All applicants must have at least 1 answer in each sections
			$('input[name="questions"]').each(function(i) {
				
				var questionId = $(this).val().split(';')[0];
				var answerType = $(this).val().split(';')[1];
				var answerFound = false;
                $('input[name^="customer_"]').each(function(i) {

                    if (answerType == "radio") {

                        var customerId = $(this).val();

                        //answer_radio_<questionId>_<customerId>
                        var selectedVal = $('input[name="answer_radio_' + questionId + '_' + customerId + '"]:checked').val();
                        //alert(selectedVal);
                        if (selectedVal !== undefined) {

                            answerFound = true;
                        } else {

                            answerFound = false;
//                            return false;
                        }
                    }
                    else if (answerType == "checkbox") {


                            var customerId = $(this).val();
                            //alert('customerId: ' + customerId)

                            answerFound = false;

                            // answer_checkbox_<answerId>_<customerId>
                            $('input[name^="answer_checkbox_"][name$="' + customerId + '"]').each(function(i) {

                                if ($(this).is(':checked')) {

                                    //alert('found!');
                                    answerFound = true;
//                                    return false;
                                }
                            });

                            if (!answerFound) {

                                //alert('here?');
//                                return false;
                            }
                    }
                    else if (answerType == "hnwi") {
                    	answerFound = true;
                    }
                    
                    if (!answerFound) {

                        status = false;
                        messageLanguage =$('input[name^="customername"][name$="' + customerId + '"]').val()+' '+$('input[name^="questionname"][name$="' + questionId + '"]').val()+  ' <bean:write name="financialPositionPageForm" property="descLangMap(financialposition.validation.error.atleastoneanswer)"/>';
                        message = message==""?messageLanguage:message+", \n"+messageLanguage;
                    }
                });
										


			});
//			if (!status) {
//
//				return {'status':status, 'message':message};
//			}
					
			// If "Others" is checked then the textbox must be filled out
            $('input[name^="customer_"]').each(function(i) {

                var customerId = $(this).val();

                $('input[name^="others_'+customerId +'"]').each(function(i) {

				//alert("Others? " + $(this).val());
				//alert("Text area: " + $('textarea[name="othersTxt_' + $(this).val() + '"]').val());
				if ($(this).val() != "" && $.trim($('textarea[name="othersTxt_' + $(this).val() + '"]').val()) == "") {

					status = false;
                    messageLanguage = $('input[name^="customername"][name$="' + customerId + '"]').val()+ ' <bean:write name="financialPositionPageForm" property="descLangMap(financialposition.validation.error.others)"/>';
                    message = message==""?messageLanguage:message+", \n"+messageLanguage;
//					return false;
				}
			    });
            });
			if (!status) {
				
				return {'status':status, 'message':message};
			}
		}
		
        return {'status':status, 'message':message};
	};

	$('#nextButton').click(function() {
		
		validate = isValid();
		if (validate.status) {

			if ($('#undiscloseFinaPosi').is(':checked')) {
				
				$('#validationStatus').val("UNDISCLOSED");
			} else {
				
				$('#validationStatus').val("VALID");
			}
			
			$('form[name="financialPositionPageForm"]').submit();

			return true;
		} else {

			$('#validationStatus').val("INVALID");
			alert(validate.message);

			return false;
		}
	});

	$('#side-menu a').click(function() {

		if ($(this).attr('href') == "#") {

			return true;
		}

		validate = isValid();
		if (validate.status) {

			if ($('#undiscloseFinaPosi').is(':checked')) {
				
				$('#validationStatus').val("UNDISCLOSED");
			} else {
				
				$('#validationStatus').val("VALID");
			}
		} else {

			$('#validationStatus').val("INVALID");
		}

		$('#submitType').val($(this).attr('name'));
		$('form[name="financialPositionPageForm"]').submit();

		return false;
	});
</script>	