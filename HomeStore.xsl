<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="html" doctype-public="XSLT-compat" omit-xml-declaration="yes" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>Furniture HomeStore</title>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
				<style>
				body{font-family:'Gill Sans', 'Gill Sans MT', Calibri, 'Trebuchet MS', sans-serif;background-color:#fff;margin:5px;text-align:left;color:#523819; background-image: url(img/background.webp); position: absolute;}
				h2{font-size:140%;color:#0d3427;margin-top:10px}
				p{font-size:80%;color:black}
				table{border-color:#000;border-width:thin;border-collapse:collapse;width:75%; ;}
				th{border-color:#000;font-size:120%;color:black}
				td{border-color:#000;font-size:100%;color:black;padding:5px}
				img{float:left;margin-left:10px;margin-right:10px;border:0}
				.indent{margin-left:78px}
				</style>
				<script><![CDATA[
				var gEntreeCount = 0;
				// returns a number that represents the sum of all the selected menu
				// item prices.
				function calculateBasket(idFurnitureTable) {
					var fBasketTotal = 0.0;
					var i = 0;
					// find the table tag
					var oTable = document.getElementById(idFurnitureTable);
					// go through the table and add up the prices of all
					// the selected items. The code takes advantage of the 
					// fact that each checkbox has a corresponding row in
					// the table, and the only INPUT tags are the checkboxes.
					var aCBTags = oTable.getElementsByTagName('INPUT');
					for (i = 0; i < aCBTags.length; i++) {
						// is this menu item selected? it is if the checkbox is checked
						if (aCBTags[i].checked) {
							// get the checkbox' parent table row
							var oTR = getParentTag(aCBTags[i], 'TR');
							// retrieve the price from the price column, which is the third column in the table
							var oTDPrice = oTR.getElementsByTagName('TD')[2];
							// the first child text node of the column contains the price
							fBasketTotal += parseFloat(oTDPrice.firstChild.data);
						};
					};
					// return the price as a decimal number with 2 decimal places
					return Math.round(fBasketTotal * 100.0) / 100.0;
				};

				// This function either turns on or off the row highlighting for sustainable
				// items (depending on the value of bShowSustainable)
				function highlightSustainable(idTable, bShowSustainable) {
					// if bShowSustainable is true, then we're highlighting sustainable
					var i = 0;
					var oTable = document.getElementById(idTable);
					var oTBODY = oTable.getElementsByTagName('TBODY')[0];
					var aTRs = oTBODY.getElementsByTagName('TR');
					// walk through each of the table rows and see if it has a 
					// "sustainable" attribute on it.
					for (i = 0; i < aTRs.length; i++) {
						if (aTRs[i].getAttribute('sustainable') && aTRs[i].getAttribute('sustainable') == "true") {
							if (bShowSustainable) {
								aTRs[i].style.backgroundColor = "lightGreen";
							} else {
								aTRs[i].style.backgroundColor = "";
							};
						};
					};
				};

				// Utility function for getting the parent tag of a given tag
				// but only of a certain type (i.e. a TR, a TABLE, etc.)
				function getParentTag(oNode, sParentType) {
					var oParent = oNode.parentNode;
					while (oParent) {
						if (oParent.nodeName == sParentType)
							return oParent;
						oParent = oParent.parentNode;
					};
					return oParent;
				};
				window.addEventListener("load", function() {
					document.forms[0].txtBasketAmt.value = calculateBasket('furnitureTable');
					document.querySelector("#calcBasket").addEventListener("click", function() {
						document.forms[0].txtBasketAmt.value = calculateBasket('furnitureTable');
					});
					document.querySelector("#showSustainable").addEventListener("click", function() {
						highlightSustainable('furnitureTable', this.checked);
					});
				});  ]]>
				</script>
			</head>
			<body>
				<table id="funitureTable" border="1" class="indent">
					<thead>
						<tr>
							<th colspan="3">Furniture HomeStore</th>
						</tr>
						<tr>
							<th>Select</th>
							<th>Item</th>
							<th>Price</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="//section">
							<tr>
								<td colspan="3">
									<xsl:value-of select="@name"/>
								</td>
							</tr>
							<xsl:for-each select="entry">
								<tr id="{position()}">
									<xsl:attribute name="sustainable">
										<xsl:value-of select="boolean(@sustainable)"/>
									</xsl:attribute>
									<td align="center">
										<input name="item0" type="checkbox"/>
									</td>
									<td>
										<xsl:value-of select="item"/>
									</td>
									<td align="right">
										<xsl:value-of select="price"/>
									</td>
								</tr>
							</xsl:for-each>
						</xsl:for-each>
					</tbody>
				</table>
				<form class="indent">
					<p><input type="button" name="btnCalcBasket" value="Calculate Basket" id="calcBasket"/>
                Total: €
                <input type="text" name="txtBasketAmt"/><input type="checkbox" name="cbOpts" value="isSustainable" id="showSustainable"/><label for="showSustainable">Highlight Sustainable products</label></p>
				</form>
			</body>
		</html>
	</xsl:template>
</xsl:transform>