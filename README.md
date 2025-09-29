## Step 1: Problem Definition
**Business Context:** PopStop is an online popcorn store that delivers quality popcorn to the people's doorsteps.
**Data Challenge:** PopStop faces challenges in indentifying the popcorn flavours that do well across different regions.
**Expected Outcome:** Gain insights on the top perfoming popcorn products, monitor the regional sales well and understand our customer's spending habits.	

## Step 2: Success Criteria

**Top 5 Products per Region/Quarter** 
Top 5 popcorn flavors per region/quarter → Use RANK() to rank sales by amount.

**Running Monthly Sales Totals**  
Running monthly sales totals for each flavor → Use SUM() OVER() for cumulative totals.

 **Month-over-Month Growth**  
 Month-over-month growth in sales for key regions → Use LAG()/LEAD() to calculate percentage changes.
 
 **Customer Quartiles**  
Customer quartiles based on purchase frequency → Use NTILE(4) to divide into loyalty tiers.

**3-Month Moving Average Sales**  
3-month moving averages for sales amounts per product → Use AVG() OVER() with a frame clause.


