Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2089.outbound.protection.outlook.com [40.107.7.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8411CF9B
	for <kvmarm@lists.linux.dev>; Fri, 31 May 2024 14:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.7.89
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717167483; cv=fail; b=pKRdxfkYeHfh7u/R5BLCSH336F+vTs6+oY5mbkz+lbvrJkpYFxTkSEphUtHOX4aTLkLcT0CPrL8hDuP57kW/2BtQt9ttmnRF6pczvtgGQtNtvqLmCnPMgEQqkZP9jJJdQSXc12RRQ//H1yK6DOo3x+0mtsWB3xpCSFjHv4kDP0Q=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717167483; c=relaxed/simple;
	bh=IQjs+9Vxu2E2sGL9dPcRcY2l7VdAYxrnrbb7oEgGGr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DADCnAYzTgXUju0Vt2Ay33DlTTtz3WCFOJclRRKolfxDUZm0kUD+MDeh90Y5vld2l3PKxz4Wzxb3XSs4UqUImJLcPmQsNmNucr5y+1/Qr6nTMuoe6UWAQe3vrOJw6/YNKxyCxwai6BX6bl+Ue8RRj+GbyiQp0vSx2qNO3MMTGnk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IiFRUDpc; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IiFRUDpc; arc=fail smtp.client-ip=40.107.7.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IiFRUDpc";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IiFRUDpc"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=BqJNk0x12Zb7hU3827IBgajotZ5afcfYeHdLIco/8wRcU4eknGFhh/HilYh53SQd65UqqNzu0GfgxdtQdjBffwCc4Rgte1XhVHfSAo83ICByOu+S9MaC6p74vBCLck/UBWfcgXBPepQOIhNHBgpgGWBXjOSHDfuU8GgoHMKs1LjfgFKEhMytmW5jSKswlP1WSH8HT7PPXUymn57/kMz/5Wiel5jDq73guPG3MY8jZ/CmMPbE/OXsVQTP3a4WzY1aFcRbNi+zM7mnDshCzlTH9QlgJUcKfImSpEqr2J9yzIf1Fc4ECfckfjBux8ztzTTCirci/He7Fz/7L/RPUVL+Qg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6fyDs3nrP7CF6zSQzwHD0RccZ+CrYXNXayMa/mBSk0g=;
 b=JCIuuD/NZceAOf5K7zathimnBSUl8qmg3Vpv+HJqtHi67r2ATSKTEhHv2oyX/BqlijeBuCnFC9P2crCr7l0fafcPsc0cc/ufsjrP7iRVH0MV3vyqcY6S6KRFKFJmZl5qp55Hp7xAR5mRmV/7i1i3+TnNFbBCiM6vto1hBXHqoUvGzd/6ZtuD5KfWmrttUkJYSCkJqnSFCIsgFaVkxYyX1+vn8TGXo4FAob1VcThfEZcELzWaEBSia2rZx7CM7UWrFpxgiCaM8E5D6T7qn8zrvopOdiExvIyiT2EwdYr0cl1ZZNLVOxRj7U0VYJaYBnGlqbeAGGfYoYN6Pm5lQ30SKA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6fyDs3nrP7CF6zSQzwHD0RccZ+CrYXNXayMa/mBSk0g=;
 b=IiFRUDpcAVoQiNqUAO6+YUVP28VgWDAgnBJk/bjpu7IrR41eM5mlIRVIDLFw4OSVdW7r1hZIcTeYKkcEvhubQYWV3S79pivfEMz9ecfqzP+igu06pGpQQ+t+tXCoBtDiMO4oYxZ6sZecUBrffbsvkHsvZwqrvHtpd6PtwZbRhQ4=
Received: from AM0PR10CA0005.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::15)
 by DU0PR08MB8018.eurprd08.prod.outlook.com (2603:10a6:10:3e5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.23; Fri, 31 May
 2024 14:57:38 +0000
Received: from AMS1EPF00000044.eurprd04.prod.outlook.com
 (2603:10a6:208:17c:cafe::fe) by AM0PR10CA0005.outlook.office365.com
 (2603:10a6:208:17c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.23 via Frontend
 Transport; Fri, 31 May 2024 14:57:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AMS1EPF00000044.mail.protection.outlook.com (10.167.16.41) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7633.15
 via Frontend Transport; Fri, 31 May 2024 14:57:37 +0000
Received: ("Tessian outbound c5e515ac9ee1:v327"); Fri, 31 May 2024 14:57:37 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 49ef7dee730dc2c4
X-CR-MTA-TID: 64aa7808
Received: from fc581970f3d6.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 1E6A01C6-4485-48B4-8D7B-C3E38CBB81D0.1;
	Fri, 31 May 2024 14:57:25 +0000
Received: from EUR03-DBA-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id fc581970f3d6.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 31 May 2024 14:57:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0zbFUfBg9hBCu5I7UuAQOt2hZgHE4XAaWcejDMciIRajACWh7VtW5IecIZqlKq0GxUkk9mN2Ll1YeGJZzcuYMxSZsBPuv5VdeXX2YVTcAnkrpWRasOApOeXG0t9mRYQnY8p9pa6TVgM1Y7+aud9GissT89mPEn61yAteACBFV03oMyPsHX1ZqypRdf99gm/xLhedX8ysDO/pdDU0/y/wpaiAp+vC8drYlWsjJ76yvbafwcYBDuV7fFwJFaMLbemu1GhZcN6z2Wx33pBxbYHiA5v5upOSGeXoYhJBq82shjGu8NlVHsuS2gvrIrxkw2XIhMQ5n0VpJ1tWIQnAW5h6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6fyDs3nrP7CF6zSQzwHD0RccZ+CrYXNXayMa/mBSk0g=;
 b=LwwPKJSPjI1C7cvCPSzgMNnVsT6Ee00ZCwhhjhxi3758/B90BaZYzPt41tfHYBhlmfirLF63LgNASUiL495LiGF2sXy+qLZWmrxN83UieX3EQkm888eUWoylwpLTcpsbZTGDu+/1CPKQlSZWzlK5Q8VEblHjIK6EYW5ErY911hAhH/x1U6KwLPNwaT5VU6hW5CRdEyI97o9KL0jZMO0HoD7lyCBSCrgjgSOYwPGv5R02tM5uJoEj5AZ0OF4dHA7IgVbSmNmo6vg7NU5LbpUbtdZvWrpQBHy71T9ggHZ34cXtz6VPdjZx4CkMVA1e1edq7d1PoFWKm7Caz6JG1qt8pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6fyDs3nrP7CF6zSQzwHD0RccZ+CrYXNXayMa/mBSk0g=;
 b=IiFRUDpcAVoQiNqUAO6+YUVP28VgWDAgnBJk/bjpu7IrR41eM5mlIRVIDLFw4OSVdW7r1hZIcTeYKkcEvhubQYWV3S79pivfEMz9ecfqzP+igu06pGpQQ+t+tXCoBtDiMO4oYxZ6sZecUBrffbsvkHsvZwqrvHtpd6PtwZbRhQ4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com (2603:10a6:10:2cc::19)
 by AS8PR08MB9147.eurprd08.prod.outlook.com (2603:10a6:20b:57e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Fri, 31 May
 2024 14:57:22 +0000
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::7d7e:3788:b094:b809]) by DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::7d7e:3788:b094:b809%5]) with mapi id 15.20.7587.035; Fri, 31 May 2024
 14:57:22 +0000
Date: Fri, 31 May 2024 15:57:07 +0100
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, aneesh.kumar@kernel.org,
	aneesh.kumar@linux.ibm.com, bp@alien8.de, broonie@kernel.org,
	catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
	dave.hansen@linux.intel.com, hpa@zytor.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, maz@kernel.org, mingo@redhat.com,
	mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com, npiggin@gmail.com,
	oliver.upton@linux.dev, shuah@kernel.org, tglx@linutronix.de,
	will@kernel.org, x86@kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 17/29] arm64: implement PKEYS support
Message-ID: <ZlnlQ/avUAuSum5R@arm.com>
References: <20240503130147.1154804-1-joey.gouly@arm.com>
 <20240503130147.1154804-18-joey.gouly@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240503130147.1154804-18-joey.gouly@arm.com>
X-ClientProxiedBy: LO4P123CA0165.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::8) To DB9PR08MB7179.eurprd08.prod.outlook.com
 (2603:10a6:10:2cc::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DB9PR08MB7179:EE_|AS8PR08MB9147:EE_|AMS1EPF00000044:EE_|DU0PR08MB8018:EE_
X-MS-Office365-Filtering-Correlation-Id: 3499f53e-f191-4630-fb10-08dc81820348
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230031|376005|366007|7416005|1800799015;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?U1psQmpTR1pkQ3FDekdlVXNGNFBrQ1FOTXpsT0hHZ1N5OEhpeUpGeVhXNXY2?=
 =?utf-8?B?WGFMWnZGT3Fza1B0b3V4Ulg2bWE4SHZocHM3UkJoS3BXVEdURVpyMW1VNThQ?=
 =?utf-8?B?d3RibEFrV0xVSUVUdHNCNUxjZitXQWlhSnBkV2dNTFNzZXAwTEFZbHh2QXB5?=
 =?utf-8?B?aXhyTEJ5a0hPWUpCUnJDYzhnNUptSnhwZ2tWSVVmdGhLZldJaE5sV2xrS0FN?=
 =?utf-8?B?MVRHVlJUUHV2NDBxcDRMaHNyWTlneTByZFVuZnhxbGNrTTNSSGJDY2p3ZHpU?=
 =?utf-8?B?eVVkejlrL1dPRzRra1FwbjRyMGRpWFVyZ2wrLzNQNS9ZZEtSQnl0Qy9kLy82?=
 =?utf-8?B?aEorR1dHSFZKSjRkYStJQXF5eUVqaWRvalQ1SnpKZFlHcU9JUTF3VHRCM2dq?=
 =?utf-8?B?YVdjVHU0bkFXV1R4VnFGa0FkL1dtMUJ4MXB2NU9Yc3VwM003WjQrRWo4L3E2?=
 =?utf-8?B?NEJLdUtVenROUFQ4V0VySWVRNVUrTldVdHBwUUd3MEg2blU1QmN3OVN4SDcx?=
 =?utf-8?B?ZmhucTR6ZUg0MmNlSG1ia05VVVpEU3ltMnhLbFdWT0h1b1BMWFhOMnMrYVFL?=
 =?utf-8?B?dzNPQVVjYWRBZlJacnlyeFpWejB1UzFZUCsvSTdkVnNqbHlLT0NzS054Z0c2?=
 =?utf-8?B?L1BEWjk2Zm1UVkVVZ0E5bFlDQy9HZG5HUmQ2Smc2UzBaK2VPcEwvaVkwV1Z4?=
 =?utf-8?B?ZFVYUHBxOUgyZ1NzVG1QSDRVbnF6TFVNVXN2aHdQcURGWmJ2dVprcTNkb3U0?=
 =?utf-8?B?WU1Mc21KNVRwT29zNmMyc3JPWlJtWCs2MzE4VzUwbVU1b0dqNU5CbWFlbDBX?=
 =?utf-8?B?a2pjRFVkTXNWWVlCcGFFeFBDWnh2ZjljT3NsRkRXcGk4WnhvVHkrckZFME9w?=
 =?utf-8?B?cTc4OGJnS2pTdHg1QnFxaXFJZ1Jua1RtbUZyaXZldjRrZ1Z0Z20zRTdWY0Jx?=
 =?utf-8?B?L28yeFlRVVBpREtXT3N2ZklTdUYveXRzbEJ2RUVWSHJLc1ZLczlma1NmZWVy?=
 =?utf-8?B?SDN4ZnIxYkd4VEE0bFBEZE9uMmhhOEVsRE1RNHdWSnErelRsRGJPV21PWk1m?=
 =?utf-8?B?WVVwdnAvME9hR3VEenBZV0JvM3hwTnFtMEd6Y2o5NHZVOXQzVTFpQVViVUhI?=
 =?utf-8?B?eHorVkNZR3MyU1l0L0RIdE1uUFl4QzhxTHh6VzVYSW5QMWt1am5MeEJpOHVk?=
 =?utf-8?B?TUJiMjRoazliNURpaCtVc3pCUmQ1OFdweThRUkk2M3FLemJjSDIzeFQ5ZERP?=
 =?utf-8?B?eFhUV2IxNEY1TWhaOXBJWEpnYU95bUUxdTVIc1JNbzJGZEx1MllrMXhUQ3Fi?=
 =?utf-8?B?UmRQSjhwcTNDYnVXQTRRcXE4N0EvaVRhaDFYL2hGTG1TanIxQ0pOelZ5N1lT?=
 =?utf-8?B?Sld5aEJUSzlmWVV6ZHdzL09OYnhGZHJGMzVaV3VnRDVPajUvYnVTM2lwaEM1?=
 =?utf-8?B?Y3ZoTUVZejgvUWdPdG5CWGZ0dXhXdGtITHlKQ2VMTDcrQmJ4ZnZ6VkNXUFl6?=
 =?utf-8?B?MExwRVdjRG84a2tRUFFWbVBvUndWNnB1NXhwRUVxZkNkY1I0dlluUkRKRFVF?=
 =?utf-8?B?V0NLa1B6cmpOa3oxQjBmRWVibTQ5b0dFa0RtdnBnMzE1c3IzTTlPbkR5SFNP?=
 =?utf-8?B?WkNnOStDM1k2VzZJL0xGcHMyWmpJMG9kQXVobkxxY0RmcEVtM1ovUGFIZUtj?=
 =?utf-8?B?K2x1a3JBbkxwVC9taXI5R2NyYkYycGx6bGlxV1RjRlpFMjRxc1IyR1N3PT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB7179.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9147
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000044.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1174fe25-a175-4ede-f27f-08dc8181f9f1
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|35042699013|82310400017|36860700004|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Zjltei9Kdm1DVEtLT1A1OGVyb1ZzOTF5bTRrVkg0UWdJV3RWVGpIdDFUbkRO?=
 =?utf-8?B?ZWdiR2tybytpbnkwZ0p5OWxpS2lxZlVUQVVuSm5MRXBlclVEaVBGNjZXUWNB?=
 =?utf-8?B?MW1iOGloZlRRV1ZmTVhrYVZhRTdtbE9TalF3c1lRY0ViUEd6ZUoxMzduM0k5?=
 =?utf-8?B?REpVVU1ZODN3RFpoOVZxRG15MzV6Qlh4cW1JQ2FaRmpPWlhzOHg5dmRKVWVX?=
 =?utf-8?B?aVJSV2k2TUVOUDVYdnk0SmhCYnV2UERwL1VPQjlEZ1NrcEZsdzg0TDVnbU0v?=
 =?utf-8?B?MFBpNFRCMVluNjQ3aVBlZmsyM2dqYUwva3JyWVMyYkkwS3dWTXpLa3dWU0VY?=
 =?utf-8?B?UVlIaDd0bGlVYjJHeFpydGptSk9ub0k0VnZZcWxWNDQ4QVlVU2VuTUdBMnRZ?=
 =?utf-8?B?YUx3Q0FYYk9tRGY0S0dDNE1ZVHVIRVdJM2RWV3lpWlVuaFVEZmJYd1BUMTd4?=
 =?utf-8?B?NTFpclk5RWxIL1c3VFlNU2lRRmphOTFuRDZXRld6d29DM2lLWGRmbWdYUlI5?=
 =?utf-8?B?Qk1PSjBnekpJNHV0SXZnbzNmTENKbUVEMzFLM1NOdE5GbWQyVW4wU1FZOEtp?=
 =?utf-8?B?UW1md0RGbXN4bDJ1K0dNd241NjgvNThWamZRNFo2N1FvK25oVXZ0OXpRMGhV?=
 =?utf-8?B?dEdLOURqUHYyNXJkL0RaOTIyMGF1NldSWEd5SENDN3hBOUkxczhtMXRPb2sr?=
 =?utf-8?B?cll1d25BVnJ3M0lPcnZvL0FwcE0wU0FZVElnbzZiSGx2aVpjUVhsRkhmSFBX?=
 =?utf-8?B?OElBaGFCZDNaRjVqNFJHaitYQ2lSRXVtOGk5MnVKb0wwTDlkR3dvRzYzUWtj?=
 =?utf-8?B?eDBWTCs1aWEvTFNHTG9nWWZNN2VpSmhqVVp0emJWdXE0WnNwZTFieUMraUdD?=
 =?utf-8?B?MTAwWEg2d1I1UW9RcUtBU3pRcjF1T05rOXNuWDgyNS9PZ3g2OUo5T3lrbkVE?=
 =?utf-8?B?ZzJjSjNqQmZ1ejNtVnJDZndLMTlUOWNGYVA0Z3RxbzRLRzd5NkRKbXJBKzZX?=
 =?utf-8?B?ME1acE9PSW5FVFdpd1hSdVFncTV0Q1lFejhqRUV2Q2NUeGZGYms5ZWYzaXAx?=
 =?utf-8?B?cS9RZnhoNGkwVVlmREJIMDZTeG1XZEdPazhWZWUwOUZZaE5JbW1LdkhMcUNT?=
 =?utf-8?B?VFJjZ0FBMVYrNWxocWlyTHFlL09sVjUyOXJyckRic2FLNWY4SHFOYzZWOG9P?=
 =?utf-8?B?WXhCUWZDNXJaZE1QendPaWZGb0lhRHArUUxoQjUzcEhnRXhjWkluOWxJOXpo?=
 =?utf-8?B?NWRodFZMckxJLzAxbjJqd2pkbkRJZ0RkSDk3cWFuQjZRamUyNGphS1NGY25V?=
 =?utf-8?B?aDd2VHFoV05kSzRSbGY2VzhTaUhFNFl1aTI0d0g4d1NZamVRRWxJQUt2NGxo?=
 =?utf-8?B?M0kra1IxTTFEMXZqYXk3Q0ticTdkTnVsOVZQTXpYdTF6eVh2dDQvTEhFNzh6?=
 =?utf-8?B?MmVtMEhMVlB5QmF6WXd1RVdyTE1vRVRYWi9paUhKbGo1UzlRbERwOEhON3lK?=
 =?utf-8?B?NEZmMTBIZG1tUkdaR3c4R3hBRTYvait3NHd5WU8yUzVjM0NadzBSWWVYOFZr?=
 =?utf-8?B?dGZiYkRjS3Frc0RKWDJUR2xlc2MwRi8wSlRWclFkTnFOYWtMQyt3cTFLWEly?=
 =?utf-8?B?NmZTMW52MlhMMHlpQWRBMlNSbkdITHlyQU9PdlpIem1IYjNXUFM0TDhIaEVx?=
 =?utf-8?B?K2k5a05iRks1Y1NPaWw2dG44WlA0NU8yNGFBQ1hPWll1dnJMOXBCeG5NSUJY?=
 =?utf-8?B?bng2MUNTNStkb2lTVXI5Nmw5U1ZRQXhyK0xLWVptUWNDbkwxVzJtN3d4V20y?=
 =?utf-8?Q?Eo3y/Hi9dgXFsmmIeVNLwz54t0ZymsDn6Dg/A=3D?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(35042699013)(82310400017)(36860700004)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 14:57:37.9988
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3499f53e-f191-4630-fb10-08dc81820348
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000044.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8018

The 05/03/2024 14:01, Joey Gouly wrote:
> Implement the PKEYS interface, using the Permission Overlay Extension.
...
> +#ifdef CONFIG_ARCH_HAS_PKEYS
> +int arch_set_user_pkey_access(struct task_struct *tsk, int pkey, unsigned long init_val)
> +{
> +	u64 new_por = POE_RXW;
> +	u64 old_por;
> +	u64 pkey_shift;
> +
> +	if (!arch_pkeys_enabled())
> +		return -ENOSPC;
> +
> +	/*
> +	 * This code should only be called with valid 'pkey'
> +	 * values originating from in-kernel users.  Complain
> +	 * if a bad value is observed.
> +	 */
> +	if (WARN_ON_ONCE(pkey >= arch_max_pkey()))
> +		return -EINVAL;
> +
> +	/* Set the bits we need in POR:  */
> +	if (init_val & PKEY_DISABLE_ACCESS)
> +		new_por = POE_X;
> +	else if (init_val & PKEY_DISABLE_WRITE)
> +		new_por = POE_RX;
> +

given that the architecture allows r,w,x permissions to be
set independently, should we have a 'PKEY_DISABLE_EXEC' or
similar api flag?

(on other targets it can be some invalid value that fails)

> +	/* Shift the bits in to the correct place in POR for pkey: */
> +	pkey_shift = pkey * POR_BITS_PER_PKEY;
> +	new_por <<= pkey_shift;
> +
> +	/* Get old POR and mask off any old bits in place: */
> +	old_por = read_sysreg_s(SYS_POR_EL0);
> +	old_por &= ~(POE_MASK << pkey_shift);
> +
> +	/* Write old part along with new part: */
> +	write_sysreg_s(old_por | new_por, SYS_POR_EL0);
> +
> +	return 0;
> +}
> +#endif
> -- 
> 2.25.1
> 
