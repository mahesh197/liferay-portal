<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/init.jsp" %>

<clay:navigation-bar
	items="<%= assetBrowserDisplayContext.getNavigationItems() %>"
/>

<clay:management-toolbar
	clearResultsURL="<%= assetBrowserDisplayContext.getClearResultsURL() %>"
	componentId="assetBrowserManagementToolbar"
	creationMenu="<%= Validator.isNotNull(assetBrowserDisplayContext.getAddButtonURL()) ? assetBrowserDisplayContext.getCreationMenu() : null %>"
	disabled="<%= assetBrowserDisplayContext.isDisabledManagementBar() %>"
	filterItems="<%= assetBrowserDisplayContext.getFilterItemsDropdownItemList() %>"
	searchActionURL="<%= assetBrowserDisplayContext.getSearchActionURL() %>"
	searchFormName="searchFm"
	selectable="<%= false %>"
	sortingOrder="<%= assetBrowserDisplayContext.getOrderByType() %>"
	sortingURL="<%= assetBrowserDisplayContext.getSortingURL() %>"
	totalItems="<%= assetBrowserDisplayContext.getTotal() %>"
	viewTypes="<%= assetBrowserDisplayContext.getViewTypeItemList() %>"
/>

<aui:form action="<%= assetBrowserDisplayContext.getPortletURL() %>" cssClass="container-fluid-1280" method="post" name="selectAssetFm">
	<aui:input name="typeSelection" type="hidden" value="<%= assetBrowserDisplayContext.getTypeSelection() %>" />

	<liferay-ui:search-container
		searchContainer="<%= assetBrowserDisplayContext.getAssetBrowserSearch() %>"
	>
		<liferay-ui:search-container-row
			className="com.liferay.asset.kernel.model.AssetEntry"
			escapedModel="<%= true %>"
			modelVar="assetEntry"
		>

			<%
			AssetRenderer assetRenderer = assetEntry.getAssetRenderer();

			AssetRendererFactory assetRendererFactory = assetBrowserDisplayContext.getAssetRendererFactory();

			Group group = GroupLocalServiceUtil.getGroup(assetEntry.getGroupId());

			String cssClass = StringPool.BLANK;

			Map<String, Object> data = new HashMap<String, Object>();

			if (assetEntry.getEntryId() != assetBrowserDisplayContext.getRefererAssetEntryId()) {
				data.put("assetclassname", assetEntry.getClassName());
				data.put("assetclasspk", assetEntry.getClassPK());
				data.put("assettitle", assetRenderer.getTitle(locale));
				data.put("assettype", assetRendererFactory.getTypeName(locale, assetBrowserDisplayContext.getSubtypeSelectionId()));
				data.put("entityid", assetEntry.getEntryId());
				data.put("groupdescriptivename", group.getDescriptiveName(locale));

				cssClass = "selector-button";
			}
			%>

			<c:choose>
				<c:when test='<%= Objects.equals(assetBrowserDisplayContext.getDisplayStyle(), "descriptive") %>'>
					<liferay-ui:search-container-column-text>
						<liferay-ui:user-portrait
							userId="<%= assetEntry.getUserId() %>"
						/>
					</liferay-ui:search-container-column-text>

					<liferay-ui:search-container-column-text
						colspan="<%= 2 %>"
					>

						<%
						Date modifiedDate = assetEntry.getModifiedDate();

						String modifiedDateDescription = LanguageUtil.getTimeDescription(request, System.currentTimeMillis() - modifiedDate.getTime(), true);
						%>

						<h6 class="text-default">
							<span><liferay-ui:message arguments="<%= modifiedDateDescription %>" key="modified-x-ago" /></span>
						</h6>

						<h5>
							<c:choose>
								<c:when test="<%= assetEntry.getEntryId() != assetBrowserDisplayContext.getRefererAssetEntryId() %>">
									<aui:a cssClass="<%= cssClass %>" data="<%= data %>" href="javascript:;">
										<%= HtmlUtil.escape(assetRenderer.getTitle(locale)) %>
									</aui:a>
								</c:when>
								<c:otherwise>
									<%= HtmlUtil.escape(assetRenderer.getTitle(locale)) %>
								</c:otherwise>
							</c:choose>
						</h5>

						<h6 class="text-default">
							<%= HtmlUtil.escape(group.getDescriptiveName(locale)) %>
						</h6>
					</liferay-ui:search-container-column-text>
				</c:when>
				<c:when test='<%= Objects.equals(assetBrowserDisplayContext.getDisplayStyle(), "icon") %>'>

					<%
					row.setCssClass("entry-card lfr-asset-item");
					%>

					<liferay-ui:search-container-column-text>
						<c:choose>
							<c:when test="<%= Validator.isNotNull(assetRenderer.getThumbnailPath(renderRequest)) %>">
								<liferay-frontend:vertical-card
									cssClass="<%= cssClass %>"
									data="<%= data %>"
									imageUrl="<%= assetRenderer.getThumbnailPath(renderRequest) %>"
									subtitle="<%= HtmlUtil.escape(group.getDescriptiveName(locale)) %>"
									title="<%= assetRenderer.getTitle(locale) %>"
								/>
							</c:when>
							<c:otherwise>
								<liferay-frontend:icon-vertical-card
									cssClass="<%= cssClass %>"
									data="<%= data %>"
									icon="<%= assetRendererFactory.getIconCssClass() %>"
									subtitle="<%= HtmlUtil.escape(group.getDescriptiveName(locale)) %>"
									title="<%= assetRenderer.getTitle(locale) %>"
								/>
							</c:otherwise>
						</c:choose>
					</liferay-ui:search-container-column-text>
				</c:when>
				<c:when test='<%= Objects.equals(assetBrowserDisplayContext.getDisplayStyle(), "list") %>'>
					<liferay-ui:search-container-column-text
						name="title"
						truncate="<%= true %>"
					>
						<c:choose>
							<c:when test="<%= assetEntry.getEntryId() != assetBrowserDisplayContext.getRefererAssetEntryId() %>">
								<aui:a cssClass="<%= cssClass %>" data="<%= data %>" href="javascript:;">
									<%= HtmlUtil.escape(assetRenderer.getTitle(locale)) %>
								</aui:a>
							</c:when>
							<c:otherwise>
								<%= HtmlUtil.escape(assetRenderer.getTitle(locale)) %>
							</c:otherwise>
						</c:choose>
					</liferay-ui:search-container-column-text>

					<liferay-ui:search-container-column-text
						name="description"
						truncate="<%= true %>"
						value="<%= HtmlUtil.escape(assetRenderer.getSummary(renderRequest, renderResponse)) %>"
					/>

					<liferay-ui:search-container-column-text
						name="user-name"
						value="<%= PortalUtil.getUserName(assetEntry) %>"
					/>

					<liferay-ui:search-container-column-date
						name="modified-date"
						value="<%= assetEntry.getModifiedDate() %>"
					/>

					<liferay-ui:search-container-column-text
						name="site"
						value="<%= HtmlUtil.escape(group.getDescriptiveName(locale)) %>"
					/>
				</c:when>
			</c:choose>
		</liferay-ui:search-container-row>

		<liferay-ui:search-iterator
			displayStyle="<%= assetBrowserDisplayContext.getDisplayStyle() %>"
			markupView="lexicon"
		/>
	</liferay-ui:search-container>
</aui:form>

<aui:script>
	Liferay.Util.selectEntityHandler('#<portlet:namespace />selectAssetFm', '<%= HtmlUtil.escapeJS(assetBrowserDisplayContext.getEventName()) %>');
</aui:script>