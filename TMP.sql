SELECT  COUNT(time0) AS [Tutorial_Started] ,
		COUNT(time1) AS [Tutorial_First_Time_On_Island] ,
		COUNT(time2) AS [Tutorial_First_Time_In_Shop], 
		COUNT(time3) AS [Tutorial_Shop_Item_Bought] ,
		COUNT(time4) AS [Tutorial_Enter_Name], 
		COUNT(time5) AS [Tutorial_First_Time_Return_To_Wheel], 
		COUNT(time6) AS [Tutorial_Ended] 
FROM

			(SELECT sessionId0, time0,time1,time2, time3, time4, time5, time6
			   FROM
			 		(SELECT distinct_id AS sessionId0 ,MIN(time) as time0
					FROM [DEV.FACT_20140907] 
					WHERE event = 'Tutorial_Started'
					GROUP EACH BY sessionId0 ) AS s0
			   		LEFT JOIN EACH
			  		(SELECT sessionId1, time1,time2, time3, time4, time5, time6
			   		FROM
					    (SELECT distinct_id AS sessionId1 ,MIN(time) as time1
					  	FROM [DEV.FACT_20140907] 
					  	WHERE event = 'Tutorial_First_Time_On_Island'
					  	GROUP EACH BY sessionId1 ) AS s1
					    LEFT JOIN EACH
					    (SELECT sessionId2, time2, time3, time4, time5, time6
					     FROM
							(SELECT distinct_id AS sessionId2 ,MIN(time) as time2
							FROM [DEV.FACT_20140907] 
							WHERE event = 'Tutorial_First_Time_In_Shop'
							GROUP EACH BY sessionId2 ) AS s2
							LEFT JOIN EACH
							(SELECT sessionId3, time3, time4, time5, time6
							FROM
							    (SELECT distinct_id AS sessionId3 ,MIN(time) as time3
								FROM [DEV.FACT_20140907] 
								WHERE event = 'Tutorial_Shop_Item_Bought'
								GROUP EACH BY sessionId3 ) AS s3
							  	LEFT JOIN EACH
								(SELECT sessionId4, time4, time5, time6
								FROM
								/*s4*/  (SELECT distinct_id AS sessionId4 ,MIN(time) as time4
										FROM [DEV.FACT_20140907] 
										WHERE event = 'Tutorial_Enter_Name'
										GROUP EACH BY sessionId4 ) AS s4
									  	LEFT JOIN EACH 
									  	(SELECT sessionId5, time5, time6
										FROM
									/*s5*/  (SELECT distinct_id AS sessionId5 ,MIN(time) as time5
											FROM [DEV.FACT_20140907] 
											WHERE event = 'Tutorial_First_Time_Return_To_Wheel'
											GROUP EACH BY sessionId5 ) AS s5
									 		LEFT JOIN EACH 
									/*s6*/ 	(SELECT distinct_id AS sessionId6 ,MIN(time) as time6
											FROM [DEV.FACT_20140907] 
											WHERE event = 'Tutorial_Ended'
											GROUP EACH BY sessionId6 ) AS s6
										  ON s5.sessionId5 = s6.sessionId6
										)AS t5 
										  ON s4.sessionId4 = s5.sessionId5
										)AS t4
										  ON s3.sessionId3 = s4.sessionId4
										)AS t3
										  ON s2.sessionId2 = t3.sessionId3
										)AS t2
										  ON s1.sessionId1 = t2.sessionId2
										)AS t1
										  ON s0.sessionId0 = t1.sessionId1
										)AS t0


/*
funnel
table [DEV.FACT_201		7]
timestampColumn	  time
joinColumn UserID
nameColumn event
steps Tutorial_Started,Tutorial_Ended
*/;