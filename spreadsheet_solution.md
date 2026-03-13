Spreadsheet Proficiency – Solution Explanation
1. Populate ticket_created_at column in feedbacks table
The objective is to populate the ticket_created_at column in the feedbacks worksheet using the created_at value from the ticket worksheet.
Both tables contain a common field called cms_id, which can be used as a key to match records between the two worksheets.
Steps to solve
1.	Ensure both tables are placed in separate worksheets in the same Excel workbook:
•	Sheet 1: ticket
•	Sheet 2: feedbacks
2.	In the feedbacks sheet, the column ticket_created_at needs to be populated.
3.	We can use XLOOKUP or VLOOKUP to match the cms_id in the feedbacks table with the cms_id in the ticket table.
4.	After matching the cms_id, we fetch the corresponding created_at value.
Example Formula (Using XLOOKUP)
=XLOOKUP(A2, ticket!E:E, ticket!B:B)
Explanation:
•	A2 → cms_id in feedbacks table
•	ticket!E:E → cms_id column in ticket table
•	ticket!B:B → created_at column in ticket table
This formula searches the cms_id in the ticket sheet and returns the corresponding created_at value, which populates the ticket_created_at column.
If XLOOKUP is not available, we can use VLOOKUP.
Example:
=VLOOKUP(A2, ticket!B:E, 2, FALSE)
2. Outlet-wise count of tickets created and closed
The objective is to calculate the number of tickets that were created and closed:
1.	On the same day
2.	Within the same hour of the same day
This can be done using helper columns and a pivot table.
A. Tickets created and closed on the same day
Step 1 – Create helper column
In the ticket worksheet, create a new column called:
Same_Day
Formula:
=IF(DATEVALUE(B2)=DATEVALUE(C2),"Yes","No")
Explanation:
•	B2 → created_at
•	C2 → closed_at
•	DATEVALUE() removes the time and compares only the date.
If both dates match, the formula returns Yes, otherwise No.
Step 2 – Create Pivot Table
Insert a Pivot Table using the ticket data.
Configure it as follows:
Rows:
outlet_id
Values:
Count of ticket_id
Filter:
Same_Day = Yes
This will show the outlet-wise count of tickets created and closed on the same day.
B. Tickets created and closed in the same hour of the same day
Step 1 – Create another helper column
Create a new column called:
Same_Hour
Formula:
=IF(TEXT(B2,"yyyy-mm-dd hh")=TEXT(C2,"yyyy-mm-dd hh"),"Yes","No")
Explanation:
This formula compares:
•	Year
•	Month
•	Day
•	Hour
If both timestamps fall within the same hour, the formula returns Yes.
Step 2 – Pivot Table
Create another pivot table with:
Rows:
outlet_id
Values:
Count of ticket_id
Filter:
Same_Hour = Yes
This will give the outlet-wise count of tickets created and closed within the same hour.
