Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011052.outbound.protection.outlook.com [52.101.65.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B723F12C0;
	Wed,  8 Jul 2026 15:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783525021; cv=fail; b=op/4H6RRvwp6OgL+PYknOgJH7SYAWo6RskfTy8y643XC+8vNsaQY1UcB2ARaw+ZI2+Ka7k4yZPjCKS/ya/DukW80bw5/318m7Evvdv6NWfR2cS8ypWYe8hbRp12wl8/YxU8RI8zI0gK+GvAVAv+VeKxQ4eRPggZRWweDTLUGQ9E=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783525021; c=relaxed/simple;
	bh=S74rvhIK3AjVXe/Z+N5vI8sTMqTz6XEBkH4508fK5jQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GdWR+vsgCvf+R9oiuK/ybwJu6OJBk/Ebvx9hYZvfTPl8z6CoNr9xo63X34+YDCZTqaZCytfrLJPRxkrZIRKKUi6lEEeFgqm12UN+4dMvvfcObK2oGtnyLflEA6ZHFjQVfZuc9ZnKNpYJ7oKZL7Y4nMnCOsqIIIkyjolU3chD+FU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gue3CY+w; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gue3CY+w; arc=fail smtp.client-ip=52.101.65.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gue3CY+w";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gue3CY+w"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=LmIx3YtmqdBQJP3FWkKzXnJiZSNzZ78/JbNofluu6sF7DuG4j9RDCeB9NjkLt8zDudk/XMMmXi6COkyxDl95VzVPKBXic7Hpox4cz26CufnkdTClHH1wCYMqJSgZW4cTgTsedjqrj76d8qNDrKiAPm71UgiZJn9BiuCx/mkmMn8NfrqzV9susjkLBjZIL0e57X+r6UWy/PrseWVJam/NFhGpbleqVKmh009nxgo7AElMIi2k1MK2ifqco3VUqCWqBP/kbZ+r5C4sGhSaK2TmhmRms7mIGbZjCQmktU5fV/hLVzHK6RO81ZsXndviKL6Gd5SvizLCCYWuBhLTsuQ6Tw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S74rvhIK3AjVXe/Z+N5vI8sTMqTz6XEBkH4508fK5jQ=;
 b=Us69PUQoDQdydZIigr+l8xMi5H8pOvewr5hX2NmirGJLyE+6AfDK4Hr6ep4cZqAsmRLyvDanFNr9p9uxKgpLo3ZtIl18MQfGedHV+JTwXKOg+SWuZcLC/owVmNo2XsHFvFk2PwKRzBaX6VRRbEAFq3HTh5x24qilq0kAvj9+rUZdi8O6i0F/LBz/zBrE1gEYmLbB1gdxRLE0SnCFlCtovoO493Sj9zsFRix4Y5QTWxEsEaO18/9kV2Il8OPdUt7hXd65GmxAGu6oAAwOWR1lW33EUkgNpTdmo1a867tGXpyrCkJ8QxxuVHKnvc7cJhbIwHqE2vamOgnjKFIIcXbsSA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S74rvhIK3AjVXe/Z+N5vI8sTMqTz6XEBkH4508fK5jQ=;
 b=gue3CY+wk/EkzPvgmcTL72N9ROjsAH9jVf6rOt19dqg6XQrOax09Bdmcz3EJ1n7YcSQyHAntfIBwvEFn3LJ26isIyGx+M6T3Vy1/HAE+3mCfXVCXVjMs6blJM3shu3OGPBd2gxeunrAW/aPXPEw2hzh1EcaI/2LWFsSzDglBUHc=
Received: from AS4P189CA0062.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:659::9)
 by DB3PR08MB9059.eurprd08.prod.outlook.com (2603:10a6:10:430::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Wed, 8 Jul
 2026 15:36:52 +0000
Received: from AMS0EPF000001B5.eurprd05.prod.outlook.com
 (2603:10a6:20b:659:cafe::84) by AS4P189CA0062.outlook.office365.com
 (2603:10a6:20b:659::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.10 via Frontend Transport; Wed, 8
 Jul 2026 15:36:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B5.mail.protection.outlook.com (10.167.16.169) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Wed, 8 Jul 2026 15:36:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DXjlDC6y4EFOr+rX80oZDHevkbaTod/KpR3ei1cEz41uzFtkES/QeqNtrClbFCnWgK9w/8qSCHrHTFRj4+naOuw4v5hCDycxpNchwFFcYkSpNjur5drIvU+PHauKrYht67PFbMgPOXtGpn6RkFhvjW+iJemv+57dTRjd6c3F630kDeWFwL5qtHKU9wXibbH3cgU1OevPydtGRZEZ7rMeNYJZXEmfrUeN01lZ2KiXRDK/DDS0h97UH5V5nfsB0AGokoyAoBez3B+32ZCoQ53kr8ojmc8MvTtlb1BMvtntZIY/je9HrSd85S+Wvo6E3ooXfr5N2QLgnbe+WhiPTrD5MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S74rvhIK3AjVXe/Z+N5vI8sTMqTz6XEBkH4508fK5jQ=;
 b=CrQz4OXN49p8/SW3GW9f6Zggn6W+eXoXbST4Cipur1BbprqCaJ8PSi7OqJLA0/j1NbLp9bC7jVKIIHRvmB7fZkeRWX03R2i3tqPFQQZwijDGgPa+FeZ+uJU6gLstpi0Wa94Y0XNKgab+fL+BZ1ACRqK3QTsCFYs/GiSxOcY8xqguLXaW9LEVvsMNlQ7Em6CKtOZXQQ3opnrI/C9+NqJYtqP0Of+4VF7S/7c3dTE34XJsi2obkTzqBwWHAo1OryBI0wYesubgQNAjaqRguEozbhLslVAt3ZzQCBMUF7hVGaxjf4JB6d8a8sy+jNx4qkATWBYrfiui42VFI+EJQOfFhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S74rvhIK3AjVXe/Z+N5vI8sTMqTz6XEBkH4508fK5jQ=;
 b=gue3CY+wk/EkzPvgmcTL72N9ROjsAH9jVf6rOt19dqg6XQrOax09Bdmcz3EJ1n7YcSQyHAntfIBwvEFn3LJ26isIyGx+M6T3Vy1/HAE+3mCfXVCXVjMs6blJM3shu3OGPBd2gxeunrAW/aPXPEw2hzh1EcaI/2LWFsSzDglBUHc=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by FRZPR08MB11047.eurprd08.prod.outlook.com (2603:10a6:d10:13b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 15:35:49 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0181.009; Wed, 8 Jul 2026
 15:35:49 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 16/40] KVM: arm64: gic-v5: Request doorbells when VPEs
 enter WFI
Thread-Topic: [PATCH v3 16/40] KVM: arm64: gic-v5: Request doorbells when VPEs
 enter WFI
Thread-Index: AQHdCwTRbiDaMUH2wEOmPJ4pBCPjFrZb/d6AgAfK/YA=
Date: Wed, 8 Jul 2026 15:35:48 +0000
Message-ID: <7d32adbf26454f5db1721bc28c716297c5e599ea.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-17-sascha.bischoff@arm.com>
	 <20260703163527.76C871F000E9@smtp.kernel.org>
In-Reply-To: <20260703163527.76C871F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|FRZPR08MB11047:EE_|AMS0EPF000001B5:EE_|DB3PR08MB9059:EE_
X-MS-Office365-Filtering-Correlation-Id: ddfa37d5-5bbb-4b09-260f-08dedd06bbc7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|18002099003|6133799003|4143699003|11063799006|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 nFoGRin5/bAS0oI0YvoT03H0+0kjlV3NDr9WAdpnIRmBUAcUipPqVEry13lusnZV/gUNGP+3a6LvaaQ4FWgc6cwIDaJ8MJ3mByLyKOc50vmUvQzx6O8Syw1qZafRqExYt3WY2c1EzqVtT0iTEbk0fk15IXJ/g60vixLIL+qt1HkPNfLrICqQjwyTQ7oNkbUz91GkCti3cbYvP8QzRwKJGWEOpCEJLeQdPqSoWVL3MhOIWWI62YMZshg5d7ljzoessIcV7Gxjgjc/vOkJUj41pboT3p0H25DtfahLlw45rGMQLFpzUTrPdDY7NSZw9mW3oMVz++OgWQVRSqC2K96dROxkfJLQjbm3SRXGEhmTDi6TDic+ORaoOOO5NrGO5IAuRuvCZKvpeO6xsEXyq1OobxBnmBTkN6Y5fR0gRuwkAt9J3995C7IPRxIjDnSvT8lXCz6FFRgcpCQ1ESt1Z4AfGVDzd1GpY5YWdG+WfCan1mo7HV50BwztF/W2MlB2YeAuhLAwG43OaPRdb9PN3Djh5u6rhvhI2IteYDXnsoJISuJTH6nxhwgBJKpcQQ+T/jiiC2raQp/dR/odQoJSYM/AXiF+LnbdennXpIPP6vUy0bimDa5sepbv0BlZlU0Y149xHrKGoUv9U4lWKhNP7vJsLKkmWIJtTvWUZ1Btm+w5pnB0tZ57OCWW+zhRZBNzEbPeosGUanO6kdkPUORTzPSOSMYhgaMfbq4IY5SjEhUqdzo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(18002099003)(6133799003)(4143699003)(11063799006)(56012099006)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD6960026F5642498CB19E5B7E87FAD6@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 W4OF8IqNR+E21P4M0vt6O1qk+Uj0oigHM+GFl5OUpI2Sobz/iaaeN4GS1XxZ2YISDkJu5PMOADOns5FSd0QKb2a7F2Hjw2MbvopMsJ2lyZZODpi5xx8VOy2lcf9HOAG38m5ZVh23ySdBBoJOEw6/MVU8TX53vcRxt5ZeGNwcKrWYcP15PlEBCfe2lMNc9ncq0CN2NlvoduqGCXls7nbiyZ88PQp3vPK2rLNcUX+7d5yCQlrvCJkE6O+YqBiSMEjxNsb9qgQxr632Q5mlSg1mzXwt3mfR+hAJHFwU5dZkUPNYxAM1ZT3GGN5iVGGqI9buJy/oRlvqZFOW2t4nke9TbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB11047
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B5.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7a261fa1-95d3-4dc9-941e-08dedd069607
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|36860700016|82310400026|376014|14060799003|23010399003|22082099003|18002099003|56012099006|4143699003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	CMbsqrGG6GrNuiqxbdaOKGw+JgwzTnPoVJEagHGw2/XwBw+aMNvGNaVQeBa9dXrCn2XvECQX9qo+/TLznnl7q+y7d4AooiX0OGq49Ul3yvbuSCUd1rx0atAAOWwso1VFkfvYvJ8fo0dN7y8VZ5H/qOrQ/W0aA5ddPh/tlgdLfapM9uDESryIgNwL7wxg4uVoDH9ZMAD4MD3zIPI8gclDKVKFYELuh66MNbHNuQAXRYmMNy+WztpKWEhVwsGq23U9B1nwGyYrkpxyL7628OKhEoceawfHqBaqrDPP8whk6MnL6CUrSHyt4YVB3hJqV0h3E0x21kgllD9nIW1RImq/j0Tw8OLQr209TxIu8CjQSJiFPrVejJwhfy5cpC5Dv4kYqOInBMCx6SsnQk48dLvWRtVXyn/uQ7ifxto+slhei6a8jw5ZuO0jlln6vTIl5oyNUXBoIAgjuonwl5LgXBF/kCGyQ0yJram/AQAGZzfWtgVgNS1a9CNrUDy9n+P1pijB0QRtpKRC96v0IV87ug77Guhob3OUrk5bgzUwk2AladKm5QMI32AmRLsGK2HZ0z/YKkwOKMtYRpagA3mPktJZ7kzBw9h0VR5JVuHeH/wrTyLR8Fq6Ih8hnkH0UF//ICfCpQ57+Np5DZEWE36DQquqxIJFpjyqWYlHiqj5xOu3oYlBrCN0Cbhx/aZ7naun29i1EBvzc+ktmL9mPGlKmIhtpw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(36860700016)(82310400026)(376014)(14060799003)(23010399003)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pBOYn+gRjIzpAcU7v3EvPTLDfhTA8EFY8XR3Mh/Oj1jljGJjoB39NTmqaPSIZj7Md8Uq5lH0QpYj8/pdyZAuTqEHF7pn7uwbKHqIbhNl7bnetZ+G+ugkwy8+vUYVYwR3Ikt+2NeyZNTfgolBM07HtPtxCh4xsMXbxf2kSdZuK+PWo43SytSTd5wmVqwxDOUeoC0y5GudqOR/i7PO/9z3GuXPg4RdASvyg595wZSre6JD30r6wmASWgGwHXyUA1h/hQGG2+Cu+evjrYn5T/HQTY9IZXqOqBxr8peEIAe6pNEczi5PO8zybTdBa/HtsYlkTB6U9mAYHoUbgdTAVM2PVrj53dCyZHiJtRaRriZ11rprBDnghpN/xfyLqMaqit4u4rWjiaPez2fQ+ue7BoiWdfgjpuP6SYa/VZsuyecXFCZo3gzLvA/TN+9e6k0Gbj/x
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 15:36:52.2094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ddfa37d5-5bbb-4b09-260f-08dedd06bbc7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B5.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB9059

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjM1ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gVXNlIG9mIGBXQVJOX09OKClgIHdyYXBwaW5nIHRoZSBmYWxsaWJsZQ0KPiBgaXJxX3NldF9h
ZmZpbml0eSgpYCBBUEkgb24gYSBndWVzdC1kcml2ZW4gV0ZJIHBhdGggYWxsb3dzIGENCj4gbWFs
aWNpb3VzIGd1ZXN0IHRvIHRyaWdnZXIgYSBob3N0IGRlbmlhbCBvZiBzZXJ2aWNlLg0KPiAtIFtI
aWdoXSBPZmYtYnktb25lIGVycm9yIHdoZW4gY29tcHV0aW5nIHRoZSBEb29yYmVsbCBQcmlvcml0
eSBNYXNrDQo+IChEQlBNKSBjYXVzZXMgdGhlIGhhcmR3YXJlIHRvIG1pc3MgZG9vcmJlbGwgc2ln
bmFscyBmb3IgdmFsaWQgcGVuZGluZw0KPiBpbnRlcnJ1cHRzLg0KPiAtLQ0KPiANCj4gY29tbWl0
IGE4MTBlMWNjNWY5NGMxZjI1YjEyN2IxODA0MTlmNjkxN2I5MmM4MDMNCj4gQXV0aG9yOiBTYXNj
aGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiBTdWJqZWN0OiBLVk06IGFy
bTY0OiBnaWMtdjU6IFJlcXVlc3QgZG9vcmJlbGxzIHdoZW4gVlBFcyBlbnRlciBXRkkNCj4gDQo+
IFRoaXMgY29tbWl0IGFkZHMgc3VwcG9ydCBmb3IgcmVxdWVzdGluZyBHSUN2NSBWUEUgZG9vcmJl
bGxzIHdoZW4gYQ0KPiB2Q1BVDQo+IGVudGVycyBXRkkgYW5kIHRoZSBWUEUgYmVjb21lcyBub24t
cmVzaWRlbnQuIEl0IHNldHMgdGhlIGRvb3JiZWxsDQo+IHByaW9yaXR5DQo+IG1hc2sgdG8gYXZv
aWQgdW5uZWNlc3Nhcnkgd2FrZXVwcy4gSXQgYWxzbyByb3V0ZXMgdGhlIGRvb3JiZWxsDQo+IGlu
dGVycnVwdCB0bw0KPiB0aGUgY3VycmVudCBDUFUgYW5kIHVwZGF0ZXMgdGhlIHBlbmRpbmcgY2hl
Y2sgdG8gb2JzZXJ2ZSB0aGUgZG9vcmJlbGwNCj4gZmlyZWQgc3RhdGUuDQo+IA0KPiA+IGRpZmYg
LS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGIvYXJjaC9hcm02NC9r
dm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBpbmRleCA5YzM4M2I2ODY0MjcwLi42ZTk3NjE2MmVjM2My
IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gKysr
IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBAQCAtMTA5NCw2ICsxMDk0LDQ2
IEBAIHZvaWQgdmdpY192NV9wdXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+IMKgCWt2bV9j
YWxsX2h5cChfX3ZnaWNfdjVfc2F2ZV9hcHIsIGNwdV9pZik7DQo+ID4gwqANCj4gPiDCoAljcHVf
aWYtPnZnaWNfY29udGV4dHIgPSAwOw0KPiA+ICsJaWYgKHZjcHVfZ2V0X2ZsYWcodmNwdSwgSU5f
V0ZJKSkgew0KPiA+ICsJCXUzMiBwcmlvcml0eV9tYXNrOw0KPiA+ICsJCWludCBkYnBtOw0KPiA+
ICsNCj4gPiArCQkvKg0KPiA+ICsJCSAqIEZpbmQgdGhlIHZpcnR1YWwgcnVubmluZyBwcmlvcml0
eSBhbmQgdXNlIHRoaXMNCj4gPiB0byBjYWxjdWxhdGUNCj4gPiArCQkgKiB0aGUgZG9vcmJlbGwg
cHJpb3JpdHkgbWFzay4gV2UgY29tYmluZSB0aGUNCj4gPiBoaWdoZXN0IGFjdGl2ZQ0KPiA+ICsJ
CSAqIHByaW9yaXR5IGFuZCB0aGUgQ1BVJ3MgcHJpb3JpdHkgbWFzay4gVGhlIGd1ZXN0DQo+ID4g
Y2FuJ3QgaGFuZGxlDQo+ID4gKwkJICogaW50ZXJydXB0cyB3aXRoIHByaW9yaXRpZXMgbGVzcyB0
aGFuIG9yIGVxdWFsDQo+ID4gdG8gdGhlIHZpcnR1YWwNCj4gPiArCQkgKiBydW5uaW5nIHByaW9y
aXR5LCBzbyB0aGVyZSdzIGxpdGVyYWxseSBubyBwb2ludA0KPiA+IGluIHdha2luZyB0aGUNCj4g
PiArCQkgKiBndWVzdCBmb3IgdGhlc2UuDQo+ID4gKwkJICoNCj4gPiArCQkgKiBUaGUgcHJpb3Jp
dHkgbmVlZHMgdG8gYmUgaGlnaGVyIHRoYW4gdGhlIG1hc2sNCj4gPiB0byBzaWduYWwsIHNvDQo+
ID4gKwkJICogcGljayB0aGUgbmV4dCBoaWdoZXIgcHJpb3JpdHkgKHN1YnRyYWN0IDEpLg0KPiA+
ICsJCSAqLw0KPiA+ICsJCXByaW9yaXR5X21hc2sgPQ0KPiA+IHZnaWNfdjVfZ2V0X2VmZmVjdGl2
ZV9wcmlvcml0eV9tYXNrKHZjcHUpOw0KPiA+ICsNCj4gPiArCQkvKg0KPiA+ICsJCSAqIFJlcXVl
c3QgYSBkb29yYmVsbCAqdW5sZXNzKiB0aGUgcHJpb3JpdHkgaXMgMCwNCj4gPiBpbmRpY2F0aW5n
DQo+ID4gKwkJICogdGhhdCBubyBpbnRlcnJ1cHQgY2FuIHdha2UgdGhlIENQVSB1cC4NCj4gPiAr
CQkgKi8NCj4gPiArCQlpZiAocHJpb3JpdHlfbWFzaykgew0KPiA+ICsJCQlpbnQgZGJfaXJxID0g
dmdpY192NV92cGVfZGIodmNwdSk7DQo+ID4gKwkJCXN0cnVjdCBpcnFfZGF0YSAqZCA9DQo+ID4g
aXJxX2dldF9pcnFfZGF0YShkYl9pcnEpOw0KPiA+ICsJCQljb25zdCBzdHJ1Y3QgY3B1bWFzayAq
YWZmID0NCj4gPiBpcnFfZGF0YV9nZXRfZWZmZWN0aXZlX2FmZmluaXR5X21hc2soZCk7DQo+ID4g
KwkJCWludCBjcHUgPSBzbXBfcHJvY2Vzc29yX2lkKCk7DQo+ID4gKw0KPiA+ICsJCQlkYnBtID0g
cHJpb3JpdHlfbWFzayAtIDE7DQo+ID4gKwkJCWNwdV9pZi0+dmdpY19jb250ZXh0ciA9DQo+ID4g
RklFTERfUFJFUChJQ0hfQ09OVEVYVFJfRUwyX0RCLCAxKSB8DQo+ID4gKwkJCQkJCUZJRUxEX1BS
RVAoSUNIX0NPTg0KPiA+IFRFWFRSX0VMMl9EQlBNLCBkYnBtKTsNCj4gDQo+IFtTZXZlcml0eTog
SGlnaF0NCj4gRG9lcyB0aGlzIHN1YnRyYWN0aW9uIGNvbmZpZ3VyZSB0aGUgbWFzayB0b28gc3Ry
aWN0bHk/IFNpbmNlIHRoZQ0KPiBoYXJkd2FyZQ0KPiBhbHJlYWR5IGV2YWx1YXRlcyB1c2luZyBh
IHN0cmljdGx5LWxlc3MtdGhhbiBjaGVjayAoUHJpb3JpdHkgPCBEQlBNKSwNCj4gd291bGQNCj4g
c2V0dGluZyBpdCB0byBwcmlvcml0eV9tYXNrIC0gMSBjYXVzZSB0aGUgaGFyZHdhcmUgdG8gbWlz
cyBkb29yYmVsbA0KPiBzaWduYWxzDQo+IGZvciBpbnRlcnJ1cHRzIGFycml2aW5nIGF0IHRoZSBs
b3dlc3QgdW5tYXNrZWQgcHJpb3JpdHkgbGV2ZWw/DQoNCk5vLiBXaGVuIHdlIGNhbGN1bGF0ZSB0
aGUgWy4uLl1lZmZlY3RpdmVfcHJpb3JpdHlfbWFzaygpIHdlJ3JlDQpyZXR1cm5pbmcgdGhlIGxv
d2VzdCBwcmlvcml0eSB0aGF0IGNhbm5vdCBiZSBzaWduYWxsZWQgdG8gdGhlIGd1ZXN0Lg0KVGhl
cmVmb3JlLCB0aGUgbG93ZXN0IHByaW9yaXR5IHRoYXQgY2FuIGJlIHNpZ25hbGxlZCBpcyB0aGUN
CnByaW9yaXR5X21hc2sgLSAxLg0KDQpJbiB0aGUgY2FzZSB3aGVyZSB0aGUgcHJpb3JpdHlfbWFz
ayBpcyBhbHJlYWR5IDAsIHdlIHNraXAgcmVxdWVzdGluZw0KZG9vcmJlbGxzIGFsdG9nZXRoZXIg
YXMgdGhlcmUncyBubyB3YXkgZm9yIHRoZSBhbiBpbnRlcnJ1cHQgdG8gYmUNCnNpZ25hbGxlZCB0
byB0aGUgZ3Vlc3QuDQoNCj4gDQo+ID4gKw0KPiA+ICsJCQkvKg0KPiA+ICsJCQkgKiBNYWtlIHRo
ZSBkb29yYmVsbCBhZmZpbmUgdG8gdGhpcyBDUFUsDQo+ID4gaWYgaXQgaXNuJ3QNCj4gPiArCQkJ
ICogYWxyZWFkeS4gQWN0aXZlbHkgY2hlY2sgdGhlIGNwdW1hc2sNCj4gPiBmaXJzdCBhcyBpdCBp
cw0KPiA+ICsJCQkgKiBjaGVhcGVyIHRoYW4gY2hhbmdpbmcgdGhlIGFmZmluaXR5DQo+ID4gZXZl
cnkgdGltZS4NCj4gPiArCQkJICovDQo+ID4gKwkJCWlmICghY3B1bWFza190ZXN0X2NwdShjcHUs
IGFmZikpDQo+ID4gKwkJCQlXQVJOX09OKGlycV9zZXRfYWZmaW5pdHkoZGJfaXJxLA0KPiA+IGNw
dW1hc2tfb2YoY3B1KSkpOw0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBTaG91bGQgd2UgaGFu
ZGxlIHRoZSBmYWlsdXJlIG9mIGlycV9zZXRfYWZmaW5pdHkoKSBoZXJlIHdpdGhvdXQgdXNpbmcN
Cj4gYQ0KPiBXQVJOX09OKCk/DQo+IA0KPiBCZWNhdXNlIHRoaXMgaXMgYSBmYWxsaWJsZSBBUEkg
YW5kIHRoZSBXRkkgcGF0aCBpcyBkcml2ZW4gZGlyZWN0bHkgYnkNCj4gdGhlDQo+IGd1ZXN0LCBh
IG1hbGljaW91cyBndWVzdCBjb3VsZCBleGVjdXRlIFdGSSBpbiBhIHRpZ2h0IGxvb3AgdG8gdHJp
Z2dlcg0KPiB0aGlzDQo+IHdhcm5pbmcgY29udGludW91c2x5LiBUaGlzIGNvdWxkIGxlYWQgdG8g
YSBob3N0IGRlbmlhbCBvZiBzZXJ2aWNlDQo+IGVpdGhlcg0KPiB0aHJvdWdoIHNldmVyZSBsb2cg
c3BhbSBvciBhIHBhbmljIGlmIHBhbmljX29uX3dhcm4gaXMgZW5hYmxlZC4NCg0KVGhpcyBjYWxs
IGlzIG5vdCByZWFsaXN0aWNhbGx5IGV4cGVjdGVkIHRvIGZhaWwgaW4gdGhlIGZpcnN0IHBsYWNl
LCBzbw0KdGhpbmdzIHdvdWxkIG5lZWQgdG8gYmUgc29tZXdoYXQgYnJva2VuIHRvIGJlZ2luIHdp
dGguIFBlcnNvbmFsbHksIEknZA0KcmF0aGVyIHNlZSBhIHdhcm5pbmcgaGVyZSB0aGFuIGhpZGUg
aXQgYWx0b2dldGhlci4NCg0KPiANCj4gPiArCQl9DQo+ID4gKwl9DQo+ID4gwqANCj4gPiDCoAlr
dm1fY2FsbF9oeXAoX192Z2ljX3Y1X21ha2Vfbm9uX3Jlc2lkZW50LCBjcHVfaWYpOw0KPiA+IA0K
PiANClRoYW5rcywNClNhc2NoYQ0K
