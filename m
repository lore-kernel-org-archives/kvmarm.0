Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2085.outbound.protection.outlook.com [40.107.20.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBEE152796
	for <kvmarm@lists.linux.dev>; Tue,  9 Jul 2024 08:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.85
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720513982; cv=fail; b=tDDqkccS9sGiN2Q9BoMoLbKCqT9RqodRCbphVc2EtuRwZ55LuSmEDx7lyPZoWid66Vs4GCBwYzg8yp8fpr4ACE6rtA3RFUrE9Y+dKcL2uFbgmb+UKGt8SI7tW/IQU2eyiLwgX7/BPZ55GKDVMV/k218V7mbtFPWhBXhyMnjraao=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720513982; c=relaxed/simple;
	bh=CNUFDFKp6nZweZgtR76wvckC64UE3kUSpXanFYCV+gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tWa+sOsqMupFv6u1dnkPE0KLYYhSyoSLKAhO/oW2UlWplsNWo7UijvPKcV3TeLqDyuV06GWdG1pFcSEoQs87/n4Ko/GrIZIBk4RwdViCVVw8g/s/XAoE72tznIpXGTCyFVs+OeD0nL2nxaQ8chQ3n93NahFaeJxH+VNQrNxgNQE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NLMuXB1o; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NLMuXB1o; arc=fail smtp.client-ip=40.107.20.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NLMuXB1o";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NLMuXB1o"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=GOdmybtmT8QQOK+MQdSfFuqQnfpw6D1x6BxaK0ySkdISn0dccrp9pJbvCjc06tMPtmKEdo17HMVJdhqeEc4kNovawO2kZUOk4QO/VGi489fHKPr7oSdin1sd7zhbAFQIduFG7F7C9wM/ZKV30JmMH+k2cNKd53Az/tV5BhSOsPyHc859YwULsMG46QHyR4JUM1FCn8u9UDrMfIyHffwHhijUUYSX8ZNnM5j6oij4lJmk0gUKA7untBpyUjM9zd0mIYDn8j0gzXn6hLv34ZEAZiXAaaLRoucRQhROs6qQd3fyqJ9hwrHvQREPSDJCtMyTe84OZMcBH00U8eNym9hNyg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fa+/cBsfraTPLWRjUaTedFIB+misiBywHLb6+XVNAvg=;
 b=C4Mj6A9JkotLTbHlO50ECMQF41FQ/SQvn4HbNqgD06wyi4ddkQB56sPMu71nJtcdtxTbdeMYeVLL3w8RgT4Kdx/FuqgMsxRmRasDtdErNnBNu/g14+VSw0TrB63GzOuEDWO/XuVcZ9JpM51rx9nLPHMuw83IAxTInloUwmrAI72PF4a99zwz5ZmB7xcvafpHyXxfJqiUopk0f344nVRuU42m5JL1G4QpRb3yWlvT6CD3x0IPR4xTWi4p5pnV8HIOrrWw/C2A7rxn2isEQwm/09dkziVVf4FG26KTSmU13qqTRxarh2FPB6fKRY9ANdhLEf5/VvrhPSalQwILQWXq4Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fa+/cBsfraTPLWRjUaTedFIB+misiBywHLb6+XVNAvg=;
 b=NLMuXB1oez5YyZVVgHKZVhT5FI3KaMF1SfGAmcPT+CwoAaw/Na85P2IFCTvcudr1mRG0gtAc1BaVBCfmOHUytNkaCfhHYR1XNHA3INGDLDb12FGcnqr9PLI/lJ2Dgl6b7wtSD9ZKDrn4JevkXWNbtIn3KnL3RQOGLixeA92m+Qc=
Received: from DU2PR04CA0329.eurprd04.prod.outlook.com (2603:10a6:10:2b5::34)
 by DBBPR08MB10841.eurprd08.prod.outlook.com (2603:10a6:10:533::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Tue, 9 Jul
 2024 08:32:54 +0000
Received: from DB1PEPF000509ED.eurprd03.prod.outlook.com
 (2603:10a6:10:2b5:cafe::87) by DU2PR04CA0329.outlook.office365.com
 (2603:10a6:10:2b5::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.19 via Frontend
 Transport; Tue, 9 Jul 2024 08:32:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB1PEPF000509ED.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7762.17
 via Frontend Transport; Tue, 9 Jul 2024 08:32:54 +0000
Received: ("Tessian outbound 7c3e8814239e:v359"); Tue, 09 Jul 2024 08:32:53 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: f64dcc8c5b7c941b
X-CR-MTA-TID: 64aa7808
Received: from 34990bff5547.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 635D81E7-D5B7-4838-9F51-AE528AEE27A6.1;
	Tue, 09 Jul 2024 08:32:42 +0000
Received: from EUR03-DBA-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 34990bff5547.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 09 Jul 2024 08:32:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lj66p5Bbg3qbGUNS4u7VmfhPrbvMf7D7KOXbohf10gDiP4fOm9P37SpcvH4semFb4ygHD5ElM5P84t6RmOkjdyA33jHnUIRnuMaXON9RzbOPVsLh+6edZx6m4HzJJQMG9JljZR0nYc3z4m2QRDH4PoFwEIwZUJAvaa3dZubjuQzm83mJDvQeZLCaOxgrWhjAHjU0hNo2KQODsUnGEeqMeeJbiYlEqtOYPf/1GTMKsKakvnwMV0Uz2oie6AJz2GGjRfmXdZDeP/Yd5V83mQHEZcHLquPFeMXEO0a1vrl36Pg58nGTd/QouojdPeY7RmVyzMbKRGcK7ecBz5pyYIZQ5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fa+/cBsfraTPLWRjUaTedFIB+misiBywHLb6+XVNAvg=;
 b=bxVubXjY7fTFxPhxKCCpV7/dIM9n0A/tXmEvmOV+JjTjUrSivam+bK4CF8lJtAu2LZF6n3u8Fr2u3G1G1gx3iTsbrI5SAa5l+xLfSDgHGlQp2jQ2pwDdkecM0nA6OeoXZm0CyX4A5puKQoUNFpFxb2XswCWLyocURnfuS3KPXHtT/FmmgevB/I8i2MjJIhdFgb2gwfX0hRftrYCf+XZGVffpjNrK0wla8xKee5LwMkmOCJ7GNyTEXbf1sg0Dj6kT6OmQz3VOg9xuhRxR4D/HBRz0/lFJvFqgCueEVX9JYTVaZbaPTRmZ7g+wXBAWmXLrgHYOCKAFg1K7S+j6bRBsuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fa+/cBsfraTPLWRjUaTedFIB+misiBywHLb6+XVNAvg=;
 b=NLMuXB1oez5YyZVVgHKZVhT5FI3KaMF1SfGAmcPT+CwoAaw/Na85P2IFCTvcudr1mRG0gtAc1BaVBCfmOHUytNkaCfhHYR1XNHA3INGDLDb12FGcnqr9PLI/lJ2Dgl6b7wtSD9ZKDrn4JevkXWNbtIn3KnL3RQOGLixeA92m+Qc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com (2603:10a6:10:2cc::19)
 by AS8PR08MB10361.eurprd08.prod.outlook.com (2603:10a6:20b:56d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Tue, 9 Jul
 2024 08:32:35 +0000
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::7d7e:3788:b094:b809]) by DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::7d7e:3788:b094:b809%6]) with mapi id 15.20.7741.033; Tue, 9 Jul 2024
 08:32:35 +0000
Date: Tue, 9 Jul 2024 09:32:21 +0100
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Florian Weimer <fweimer@redhat.com>, Joey Gouly <joey.gouly@arm.com>,
	dave.hansen@linux.intel.com, linux-arm-kernel@lists.infradead.org,
	akpm@linux-foundation.org, aneesh.kumar@kernel.org,
	aneesh.kumar@linux.ibm.com, bp@alien8.de, broonie@kernel.org,
	christophe.leroy@csgroup.eu, hpa@zytor.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, maz@kernel.org, mingo@redhat.com,
	mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com, npiggin@gmail.com,
	oliver.upton@linux.dev, shuah@kernel.org, tglx@linutronix.de,
	will@kernel.org, x86@kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 17/29] arm64: implement PKEYS support
Message-ID: <Zoz1lbjrp+y3HXff@arm.com>
References: <20240503130147.1154804-1-joey.gouly@arm.com>
 <20240503130147.1154804-18-joey.gouly@arm.com>
 <ZlnlQ/avUAuSum5R@arm.com>
 <20240531152138.GA1805682@e124191.cambridge.arm.com>
 <Zln6ckvyktar8r0n@arm.com>
 <87a5jj4rhw.fsf@oldenburg.str.redhat.com>
 <ZnBNd51hVlaPTvn8@arm.com>
 <ZownjvHbPI1anfpM@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZownjvHbPI1anfpM@arm.com>
X-ClientProxiedBy: LO4P265CA0078.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::7) To DB9PR08MB7179.eurprd08.prod.outlook.com
 (2603:10a6:10:2cc::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DB9PR08MB7179:EE_|AS8PR08MB10361:EE_|DB1PEPF000509ED:EE_|DBBPR08MB10841:EE_
X-MS-Office365-Filtering-Correlation-Id: 76da1559-5922-4326-f12e-08dc9ff1ba75
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?S0wrRXVOYldzS1lSZDU0QjZHTzZKTlM5RzkwSkF4cHpOVVMwTzVMN25qajln?=
 =?utf-8?B?bm9oazNnNlMreXBzWFQ0UmFUUmJHb2RUa2FtTUVWR0g4dnZNTWI5a2tRbE5p?=
 =?utf-8?B?blUyMk4xd1k5OTVNRSt2Z2VMRnFIbzBadTBjelNySW83NzkzSllrTjFIMFhn?=
 =?utf-8?B?UUszVnRUMmZ3WGVDMnJ3ZDkzMzN0M0pzNGcyZTZWd0I5cmxVTWZVYXZrdGhj?=
 =?utf-8?B?K3ZPTWxaL09kMTJhdE5DQ0g0ZUtnYjhHSEhoOGlFUFZYc2VuR21yRWw3Smcz?=
 =?utf-8?B?Z2N3Q3BKVlJVQ2Z6SkJxTUw1dkhFaG5BeEVuMyt4SmNYWnRUNlV3MGQ5K1kv?=
 =?utf-8?B?L2RTb2VYNFIyU09LRDBKbUU3dzBudG9YalM1dnBtMExYNmhTcDhWOEFHQzVF?=
 =?utf-8?B?ODkvRkNBdkNTMndiZnJTZnlmK2E0WWp3VEIySTJTQkVQM0htNW8wbVkvb2ZO?=
 =?utf-8?B?ZG1aeVBkSTFtL2pWT2RzS2dsSjc3amxaa2dUY0hUMkkwRzhyaFBhYXFrZXFB?=
 =?utf-8?B?L2dRRzcrMEcwUkdqNFljNHBUbXZxbGdXNVppYXNTaUlaWDBkVXJNQ0Z2akl6?=
 =?utf-8?B?azZvcjFKeTZRL1hsRDYrMVhlKytkVzFqdVlCbHBXYkVsUTFOQXBZc1dZSVlx?=
 =?utf-8?B?aDRGMGV4WlJKbFEzRzZjVVhHS3BzWHJsZ0UwS2s4T01YdWUxTTJEbWVKSTUw?=
 =?utf-8?B?T0JMVTE2eWg3Q0R0Ylh6TmNKV21jeE5JdzZueGZ3aTlYMXhnditQenFSRUxp?=
 =?utf-8?B?SFZwb0hZRDFqTDIzSHFpTUI0YncyUGQ2aWlSeGRJaVlHQWd6bGtmekRocHhq?=
 =?utf-8?B?SnVmV095aXI2K2dVaVhrRUhFeEl2ajNjU1RwTTZ4Vk1oSmpaV05LcFhTTW9p?=
 =?utf-8?B?R2V6TmJqZWFSY2ExWTlTVWhEM3ZMQ2k3d3FWRTJHRDRvMTluc2pKRk1xUlV4?=
 =?utf-8?B?eUxPZkZDc2drQ3JmeXZhTHNwWDlrZnVOb3JNUTYxV1pXY0I4ZTU1dDE2eUVh?=
 =?utf-8?B?YWhrZ2RwTzJEOFJiUEtCRWFKSlhlWFA3R2xHSW5xQmErelpsbzhIanA2N2lP?=
 =?utf-8?B?dU8vVkc1bVhmRzZzeWVacG96bEpvenF6WDBuSmRmWmlVelVKOUx1cmw4dFIv?=
 =?utf-8?B?Qk1XRFhmMG9CcUNhd1V2T3FzTW80dTF0Wm4xdWcvRnlZNC8rb3lFNS9KNlpN?=
 =?utf-8?B?RmpDMXJXVWZaUHdNd3FSeGpzNXVHYTYrdmp3dXFxRlJSQzVDazYzTG53S2lZ?=
 =?utf-8?B?d2xzTmpGQm53U3lISFh0V3BCSmFCanZFdksvQ0IzV2h3N2NhWGlJWTlOdlRJ?=
 =?utf-8?B?ejJHbjBkRkZkTCtRekJnSXM5MFQwMm0zQm4rV3AwaFk1dXhFSDZacTdsTmM2?=
 =?utf-8?B?TXhPaUlRZFJHVTFMQWtoZEtEcnk4bHZseHFYU1NvVWwwMXFYTHdTT3QwTjYx?=
 =?utf-8?B?eS9LNHBqTmVuSVcyMnpZUERQTHJDVVI4QzgwVkZNWWIxMGZEd08renVUdmlG?=
 =?utf-8?B?YjlpY1cwSmVNeFF5ZC9NVDBuYTU5WU9VcGtjdC9ncUtkcVpBSkdxcUtqVVdp?=
 =?utf-8?B?ZjRvMXByeXdNc2FPcHJETWlEZXpsOWFJV1pCM204bEl3aE13NkJnWDBBbzdP?=
 =?utf-8?B?QVM3eGdHZWRSQWJvMHQ4NDhTK2lSN1F2ZjV4MHFVZ0N6LzZRUjIwVDdWSjRs?=
 =?utf-8?B?QnVGajVVZGRFS2lzbkNmUzR3cmx3UmRRYmFBdFZ1UStMMERZelVLSU9Zd1Qv?=
 =?utf-8?B?TURSTmFFY3oyNElmOUNwMTJvME9SVnd1UnExdnNDMkt4RFBBYmtWOXQ5ZDRk?=
 =?utf-8?B?VCtpTFZWWXU1N0RZd2Y0dz09?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB7179.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10361
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b0ede9e4-ae99-4548-f34b-08dc9ff1aefa
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WElVWDBIeGI1VnhGYjlmNE9QVnZldVZNT3c0a240VUhIMUw4b1NNQm5KUUNN?=
 =?utf-8?B?eUpMb0xxbjdXVDB5d0ZrWVJ0b1lCdTV6L28zb2JsR0RQWXpLblNSRmdhV1Zl?=
 =?utf-8?B?bUJOTWJyRUtpb2F5K2FSdUpGVVlrWDVwdFVNaEJHQis0dkdOTWs2OTJSU1VM?=
 =?utf-8?B?QjZxYVNlb051dFpYQVdCa05UYUFMZzFRWkFyVE1HQ0s4TVRSa2lMcXd6cUVx?=
 =?utf-8?B?VFdmZTQ3OVNneVdXMTZwZTNTVDVPUHp3R1RraUZ5YUpacGdKd1BGOEVYb1lU?=
 =?utf-8?B?eHMwb2I5djhMek1SYWVPdXp6SXE5L2NTSjd3S2xxVFNaMngwRSt6aTBRVzg0?=
 =?utf-8?B?YVJHOVcraWNGamNVZGRsQksyZldEVUZ2eXlTdGNQbzVYbE9ZczRBMG84Z1JH?=
 =?utf-8?B?cnZmTDk1cUZFRlQvNHZ0NmUwd2YrbGU0anc2MGR6ZDZZTncyUEF3SXozbHhM?=
 =?utf-8?B?Sy9idCtBTlQ3NlVQb2RSVnNCS0pPTHVYV0djQlJxNzRXaDdhK1lhSlNHRmJ1?=
 =?utf-8?B?ZGJsenhBQ2FUWE1MemVkUCtIN2VHUk5NNHFkUmI0VTArMXZwSlZtUFNudVJm?=
 =?utf-8?B?U1l0cllQT1B0VkFyRmVpYnlVWVEwb1ZsRnFQVmo1VHV1Nm9BNkpsbXA2dzdH?=
 =?utf-8?B?bjhHVkpZZ3E5N21hZ21UWFBjdXFLWFgxZDdYVzJPa2srTlRuTFc5MnZjalZo?=
 =?utf-8?B?ZG9HZ0dZU2NDTFpJdy9MK1NYclVIVzE0ZmN4Z1hLV3ZvYmh0RGFYeTBqVW9E?=
 =?utf-8?B?MFVBWTZWRjF1SGZvb01PWjlZSHdxS0k1QlZHTkNjOUxhaDJMSlFkOVEydzdu?=
 =?utf-8?B?aWRaSU1RUU9DdjhvbDhtNTZ1OXJQV0hkL1BmK2xFV2VTUllFY2ZRcU91WHlC?=
 =?utf-8?B?NzdUUjVnbUVPRk5tY2k5ZzhuMkpaL09oSXlEQ1NuU2ROcnBvS1lvcDN3dVhn?=
 =?utf-8?B?MHMyZFlkSUh0Uzk4a2FkWXJNOU1zZjRNK1NOUDkya2YwaVArd1RwSWl2WHVo?=
 =?utf-8?B?U2NkNkFmTE5GcDVMYk9tU1F3RW9qamJRQjRXVmVqYktDUmJjT3gxT2ZQK3lq?=
 =?utf-8?B?ODVSNmJjMmN1Yzg4RDBrWmo3aGlLcU45amJnNDF6RE82NEgxWmcrcWxFNGg5?=
 =?utf-8?B?RlFvcHVxcmIrV2RMbkR4VStNMmQxM2FMMTBwd1pVQ1JraG9zSzBOLzJVbi92?=
 =?utf-8?B?ZlZycm45TnlSaWV4U3ZINDZ2SzdvSDRycEhBbzhnZFVjakhCdjFOOTBlR1Vm?=
 =?utf-8?B?czVmcnRXNWQyVkZ3VzhTNVhMeG5iOU5OYW9vWGdJaVh2MGdaakE0N056Smo3?=
 =?utf-8?B?VE1rOVo3Smw1OW1IbUxyV0VWYkZXS3dxdXp1MEU0UWdiSmhRRDJsQWgrdlpt?=
 =?utf-8?B?VGdHODI0djdlbjBIU0tNSGJaNWtaOEpNL21aUWZUOVFnVUFZS3prSnpUVHJk?=
 =?utf-8?B?a0lDdld6d1BJK2U5NDJNSFFCdXE5dmo2YmtVS1gzK1lCM2RKSGpMQ1NDUVhv?=
 =?utf-8?B?MkIzRWtaZGRUUXFnQm5WeTBiSDJ6Zjdaa2xFWFdPYXp1SjRydng4a092R0Jp?=
 =?utf-8?B?VWhZVU51SXk0VVFlVDBOREhEVkFMdGQ2RkJmR3hQRmNNTXNHckdTWisyVE9L?=
 =?utf-8?B?OENCWnpNc1Y4OEFUZFFrMS9vbE5raWd4Qll2UFNsNlVWZUo3SEYwQWFxY1No?=
 =?utf-8?B?NkdXbmxwMFg3NDRHZ3ZlUTBqQ1B0QlhTNk15RnBmZWttaU5vOHUrSGd2bytG?=
 =?utf-8?B?WFgrWUtra091ejVmdjQxeE8xblROVDRxMVg2Rm1DSTNlK3ZVQWJHSGF2M3V3?=
 =?utf-8?B?T211SUVJNUJPdlBHN3JINi81dlhZbFFPWlk0QXord0hkUG9jVFQ5c1NPMkZC?=
 =?utf-8?B?WmhYZmh1YzZIYWN3eEdOQmJWdDZ1c2M3empGQ3A2MU1KaC9uTUI5RXJrNEQ5?=
 =?utf-8?Q?/1kNxx2OgGRsZh0D0Hy8jlzscr9vTJ5D?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2024 08:32:54.3837
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76da1559-5922-4326-f12e-08dc9ff1ba75
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10841

The 07/08/2024 18:53, Catalin Marinas wrote:
> Hi Szabolcs,
> 
> On Mon, Jun 17, 2024 at 03:51:35PM +0100, Szabolcs Nagy wrote:
> > The 06/17/2024 15:40, Florian Weimer wrote:
> > > >> A user can still set it by interacting with the register directly, but I guess
> > > >> we want something for the glibc interface..
> > > >> 
> > > >> Dave, any thoughts here?
> > > >
> > > > adding Florian too, since i found an old thread of his that tried
> > > > to add separate PKEY_DISABLE_READ and PKEY_DISABLE_EXECUTE, but
> > > > it did not seem to end up upstream. (this makes more sense to me
> > > > as libc api than the weird disable access semantics)
> > > 
> > > I still think it makes sense to have a full complenent of PKEY_* flags
> > > complementing the PROT_* flags, in a somewhat abstract fashion for
> > > pkey_alloc only.  The internal protection mask register encoding will
> > > differ from architecture to architecture, but the abstract glibc
> > > functions pkey_set and pkey_get could use them (if we are a bit
> > > careful).
> > 
> > to me it makes sense to have abstract
> > 
> > PKEY_DISABLE_READ
> > PKEY_DISABLE_WRITE
> > PKEY_DISABLE_EXECUTE
> > PKEY_DISABLE_ACCESS
> > 
> > where access is handled like
> > 
> > if (flags&PKEY_DISABLE_ACCESS)
> > 	flags |= PKEY_DISABLE_READ|PKEY_DISABLE_WRITE;
> > disable_read = flags&PKEY_DISABLE_READ;
> > disable_write = flags&PKEY_DISABLE_WRITE;
> > disable_exec = flags&PKEY_DISABLE_EXECUTE;
> > 
> > if there are unsupported combinations like
> > disable_read&&!disable_write then those are rejected
> > by pkey_alloc and pkey_set.
> > 
> > this allows portable use of pkey apis.
> > (the flags could be target specific, but don't have to be)
> 
> On powerpc, PKEY_DISABLE_ACCESS also disables execution. AFAICT, the
> kernel doesn't define a PKEY_DISABLE_READ, only PKEY_DISABLE_ACCESS so
> for powerpc there's no way to to set an execute-only permission via this
> interface. I wouldn't like to diverge from powerpc.

the exec permission should be documented in the man.
and i think it should be consistent across targets
to allow portable use.

now ppc and x86 are inconsistent, i think it's not
ideal, but ok to say that targets without disable-exec
support do whatever x86 does with PKEY_DISABLE_ACCESS
otherwise it means whatever ppc does.

> 
> However, does it matter much? That's only for the initial setup, the
> user can then change the permissions directly via the sysreg. So maybe
> we don't need all those combinations upfront. A PKEY_DISABLE_EXECUTE
> together with the full PKEY_DISABLE_ACCESS would probably suffice.

this is ok.

a bit awkward in userspace when the register is directly
set to e.g write-only and pkey_get has to return something,
but we can handle settings outside of valid PKEY_* macros
as unspec, users who want that would use their own register
set/get code.

i would have designed the permission to use either existing
PROT_* flags or say that it is architectural and written to
the register directly and let the libc wrapper deal with
portable api, i guess it's too late now.

(the signal handling behaviour should have a control and it
is possible to fix e.g. via pkey_alloc flags, but that may
not be the best solution and this can be done later.)

> 
> Give that on x86 the PKEY_ACCESS_MASK will have to stay as
> PKEY_DISABLE_ACCESS|PKEY_DISABLE_WRITE, we'll probably do the same as
> powerpc and define an arm64 specific PKEY_DISABLE_EXECUTE with the
> corresponding PKEY_ACCESS_MASK including it. We can generalise the masks
> with some ARCH_HAS_PKEY_DISABLE_EXECUTE but it's probably more hassle
> than just defining the arm64 PKEY_DISABLE_EXECUTE.
> 
> I assume you'd like PKEY_DISABLE_EXECUTE to be part of this series,
> otherwise changing PKEY_ACCESS_MASK later will cause potential ABI
> issues.

yes i think we should figure this out in the initial support.
