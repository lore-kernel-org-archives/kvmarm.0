Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013006.outbound.protection.outlook.com [52.101.72.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D34B3F23D5;
	Fri, 10 Jul 2026 09:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.6
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783677144; cv=fail; b=tZLX+Zq5BZqVRw3Bbdqd7+CUmdwAh9P7zNhwGzfYxBgXrnld/6nTceXXIfuO8fULwlOmRcWrezAZsVBPh5gqnhnlZY5qKmxUQw7uYeMKwJv+q9v204xfr+o3Com0Fi/M6lkCKBXhjBn0cGQXZUwFsIkbUGQJpIp/WF/uWYpGiS4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783677144; c=relaxed/simple;
	bh=Hsp/ZH64GOcpymNxvrDMdtwoozIKcVNL3JJZympsFVw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LjDl/32lMXjqrvnjonEdHJMTJkLfbkSPXwtPvzxnm8d5zCYqmHaunIK95BUUfV2VJNDMye+t+E4SoUchXsmU1IHzQtER0pc3MlIl8TSrM5YjOfRpSU0yo53dvrdQM0WGvAtRM0SQLrh5tLBVhFryxUtJUN6cQy41gPflhUy4Bgw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fAksSh5S; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fAksSh5S; arc=fail smtp.client-ip=52.101.72.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fAksSh5S";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fAksSh5S"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Fc/YRkJDGavpgf9pqXdEu/Q3rCSiU/tbtYom4w6dW39CXNM2gHVYaBMGcU6vlng4/6UEJWNwsTG/kPC1kAwHKnMTw01LxjO10ueTwz1Z/1o5RhTV2cCa9KsExJQrnnVKAsZ51f8g/ktzhMczKg8pdlS8sYV7kI7kqSyrpTmq/JSNQ5lKKVSez5GxZz34j3JxMMhscK5/cnAixrFX9txpsMxectz96LDdR5xPYsRyusOAj97ZD/elarvg9ElLv/KC7KELjzxEAeiKyMG9rAdN1kPAUjdDX95jcNvHuIZS+q/+NlAzsiL8aXuR4XsBWtXIuFQlA3reNl7PIXMMA5iPhw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hsp/ZH64GOcpymNxvrDMdtwoozIKcVNL3JJZympsFVw=;
 b=N2SIQOyQelqPyihpblrH42tU3PkZu+u+1SN0bJYjrt2MLPBm5KyGbrxkQ6zw3SX3LkvGb/NTBeKts6Clf8Tk9Y1502UhGWOenFLVf/EEDaPFjVeXao/MBQK/nXVYnLeJ30vvy6115Vl3zaBdz1Bu2ZpD3RgFFSU+amIiwvtr790rMqLdoXGU5LOwDxmdwkx+XtQ0bbFGy9kkS6Velj2IQWiI4YnTX/Dlp7UMjTQPsIv6/38dO31RjSP+jBYVA2AzhW7XAYJBS6sPV8ZJRSBDxVvG6RdnsDG3zgTS/mTc95x1GEXw8Xgs3Va0fo+L2X4HHzGkSgJsz9C+6y9v2PRlFg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hsp/ZH64GOcpymNxvrDMdtwoozIKcVNL3JJZympsFVw=;
 b=fAksSh5SplGlcizqzS9Ix0p2iGNZdE8UsId4W6z//sDjQswo9W1en7tao0xOmtFVRW9d8MOTzpiEoKFsP+ZsrmgyvK6Oa47gn/VPjAcfMok0Hos4L8v7V+Umj8O+F0Px5c8tdpdzSFYM432XlaoLVyvOMnqAd1YYkvYXC1+FW3M=
Received: from DUZP191CA0064.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4fa::17)
 by PA6PR08MB10471.eurprd08.prod.outlook.com (2603:10a6:102:3d0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Fri, 10 Jul
 2026 09:52:12 +0000
Received: from DU2PEPF0001E9C2.eurprd03.prod.outlook.com (2603:10a6:10:4fa::4)
 by DUZP191CA0064.outlook.office365.com (2603:10a6:10:4fa::17) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.13
 via Frontend Transport; Fri, 10 Jul 2026 09:52:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C2.mail.protection.outlook.com (10.167.8.71) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6 via
 Frontend Transport; Fri, 10 Jul 2026 09:52:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fKsA0WJsZuORsViZ7FYg5DX8dtc3qgCuYDjjcWltXvtlKk8OUX8VULObWz079+QsK6+BdLwt1baS1ct2KaHpnVK5+VkCeJzwMjEr5X5++oM5K+5m43IjZN+Eb4oR6+1bfAkC0Th4IeGlGGhp4A4sHWJ+9Iqt9OBetsc3DCuD49iB/zMutzR7spbcIK1LIvQ26f3BwAk5o1kyInT0e66DpgJFzywsJu1CfRzeTs16zLng6I3PaRgrLJ9ijikGMZ9SrAe6Wz1hit/Vy9QS/OVLjLxC0gJbQv72sFtGawvThLvdoOKjYn6/OyPgeg8GeCGbloPV+c+ij3QU8MqBkOIUhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hsp/ZH64GOcpymNxvrDMdtwoozIKcVNL3JJZympsFVw=;
 b=Y3onG5ykoF94E4fbXaxJa6eFrEINrmvNT3SVJLaWbY9TBTPfDY0/wflfJ4i9Q3oUejKd8TtH637djzQPsQE3zF/BELS+mRVpzM8xa81Purg487O0hvJOReiMfijopV6jVNNDlA4u9ynggTAPyzPZjq/wD4NlX2DJwcEwEynr15IpkbBj9SdXxTJAh1KqpxUGJ8cT2xWiwc+Gn5b83YE/MqZnQE4usoqOl8hZL2bdGIlSZLIMvn5ATTT7DH1nZ1HV30Vh2uwXp7kyeqrN+zWWXLqFj582RikwvwqxExWIqEWrOuN/9Ar8bdLmzg68XeVMpX/QUriCDNpcYWomOeHx/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hsp/ZH64GOcpymNxvrDMdtwoozIKcVNL3JJZympsFVw=;
 b=fAksSh5SplGlcizqzS9Ix0p2iGNZdE8UsId4W6z//sDjQswo9W1en7tao0xOmtFVRW9d8MOTzpiEoKFsP+ZsrmgyvK6Oa47gn/VPjAcfMok0Hos4L8v7V+Umj8O+F0Px5c8tdpdzSFYM432XlaoLVyvOMnqAd1YYkvYXC1+FW3M=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AS8PR08MB6629.eurprd08.prod.outlook.com (2603:10a6:20b:319::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.17; Fri, 10 Jul
 2026 09:51:08 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0181.016; Fri, 10 Jul 2026
 09:51:08 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 28/40] KVM: arm64: gic: Introduce set_pending_state()
 to irq_op
Thread-Topic: [PATCH v3 28/40] KVM: arm64: gic: Introduce set_pending_state()
 to irq_op
Thread-Index: AQHdCwWrudM9cYv8eE6kCJE/p9t1o7Zb/QkAgAqQLYA=
Date: Fri, 10 Jul 2026 09:51:08 +0000
Message-ID: <82464a84622b2baa5b48cbab5d4a4fdab22215b4.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-29-sascha.bischoff@arm.com>
	 <20260703163230.750BE1F000E9@smtp.kernel.org>
In-Reply-To: <20260703163230.750BE1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AS8PR08MB6629:EE_|DU2PEPF0001E9C2:EE_|PA6PR08MB10471:EE_
X-MS-Office365-Filtering-Correlation-Id: 336b4116-d8f8-41f6-8536-08dede68ea10
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|18002099003|22082099003|38070700021|11063799006|56012099006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 yDSf9LUD23MpJnEB0rdGOBSg8EYZt0ACgfWFunTrSOHnBCBqYwIzG1sxb2QT0XIDwAr92O0AIi2eSo9uQtimD1ApuJrOGV7JJ1WubcqNrjLfqx2+Y3Ucro275W8QJsXgRbtr7ahB7KR8vTK4dp9JGt/uUOEa/L4H12gr8EP4eIIvyBOObuGm78NWdZFQO1DcIjbbBYDZnE1uwlcdkYklbvq0Yh06HjT+Vcz4gxeIXCcx1O/f5dILiXFId3dvzABt/dktk21Aqz0Sv4IKwgl0X3G/CeIyODM8S9j01rETBtgmZidml5S7CNO2rytM+fJr0TXDs+LR4vsOG7epOfgkRr7giFxMaHdCT3i3WrV7wfRYoL2HdJUVZibEQPhfGVzlOl1YX5o0uifcLkl1+PuDAyvlDEAuscw+AT1aaJGKSVeR8CZzGoIPiPmsCSaLAE2LM4BF41r8KhoB0F//L75EGKOM//e9D876pzQVl2se7njxHms51UBFZjyvv6JL43a8mQkm+ol6q6oZW+hdLAiustu9LrJSdsrxiB6H8wQx+ZMCZUab6yx4vyo8/4TCsEfn2+t+GuSwWSluG2iZhoDDa0Ngcg9r3f2KUJYFDsa5Jzc9KqdeyIobs8qIfIJtBi4N+mdQvAT9EOoGpONJKLZoQu1BMLHVrqo8Dt7Wje8REivSp3DfUaCQVrGmRW5JebW9bsmPxOZ6raUERSyI/wwUHOZLUUb7cEXPlH2B+jIRSWQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(18002099003)(22082099003)(38070700021)(11063799006)(56012099006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E1EE45D6940844C84D500CC4DE3DADD@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 TY05FgOOvT1icXwqgY3wKTFdwYEtJhUHesDQTZnE4L7dr5qCn4HXROaqitB6sS6AXIBKbPlnlGoQDIpNohvYi/KAN7Fowu6SiWxVgQM3t0qWQLBjthKBrR/bEdWODXMESFDta6Cc936x2+DFrRRyCvXyGyqri4PzhIe+FmNBsAUQQVRv92iQdM14Qp123ym4tfO1btvlPgld4IkccYw32ojVcXGQsBtiuN6UsE0aJx5I54KUFLml1561mh2eu9JftFdw+7mpPLZRcorNvxCjH4TjFuhFKru7sJiVRs576Xpd0EVxq/WxXhMubQjwa2ct9xFB2VkYsx4ZuuDIgVAQyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6629
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C2.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2b81957c-63f5-47b4-5b1f-08dede68c459
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|376014|1800799024|35042699022|82310400026|14060799003|22082099003|18002099003|4143699003|11063799006|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	rtgnHo9KLdANFpOlevRVqHRsQQ/57o7YgBme3gvq4svx2xAHnUgy13clxLgORC10IXFtUJNlRc9+i7wlPjx5gxqTIwVb//BpXBGTOl0In7TUqMouoX8AUJdXoAQyz+6NMsq0UtAjvfT1tdwCe4KHs3EoF0kZP1btHjhOXOPn9IeF0ymUb56LXwet5Jcpo/v5/26ISdANqoFeOp6U8mCFyRC0DF2gHbgSwyPXgblxIPzDCYDiu/HPCcIR4RR6LavkpZTn9s6EX+MPgQJpb688suwijZNDL1j5qRKLHoo2TNtapJQTS3knyUzVBrDnFfeCLUH2KXkDNvxEgP2AFO2g93THP9/N8lKuYoXwjYVifPrKo3fChflY/bjf+JT5fcvGjfD38ibGkMtD73DX4o3Q2oQT2MPIZSBmPn4f6DVatuQR6n1TQvVjV6MNgUFO1n82GRgErrkyzxBB5giuXRl9fiPQ7oSslcs28fjDY+YU/0Voo9FmDhwfTsk1iHmeio0WQEs7M7ZqNv4IRJG31PlAWKM8buX5irwDfNhw4bR8i5h68vf045HCaoQH+qjwP9ABG7VsaN5xHeuWoUawXSeHrTUZXPAxBw13UuwUCjy9ir8Wv/W+fSVAo/UcbgYiHc3qS3Tfsmy5poiL3jRKxZGI5P3GQ3w9yASAlMwOhh8PdPFZcKrEEHDdg4r9o1D0Forx6pwhLp2qX9EMxwu0j6ZjIA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(376014)(1800799024)(35042699022)(82310400026)(14060799003)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OcHKYjaYcJahG1m7NelbgALSeN2943j/HXh0Q51JbnPMcXobqwRqdCA+8+enDF/utJCWjaEMhrawKZ29I3VPvgOWKLX84l8OntEG69RfQ65/Ygpaa1gn7E1QfxSZQUAX3wpHGx3iawgWuItmRzs/uNMsljt47MibPReIXpUJgQukbhgAWJ/Z7sa+PJNz7S2WYo535Da4yUFl7QvAyoyGvMUy0kIYd7bBr/zekm9yu57tmNOA4fwzyXoWic4nRDOPN2YUvqcXsqXGgWUvD89xt5geK5rgv4kIIunmViZWcbIyBUP4a/FkMhksMUwjcvzlVCa49qxzSYGUUbZxYYdTaB46mBEIV0alu0rnsnQW6z0rs7rjf6dDgXbiFYsTEIX5JTdE/wqgGp/j/hXY8jClmlv0VOz/2hrjrbopkbUL08pDkZMEtQBSNVwAb9tYiW7d
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 09:52:11.7023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 336b4116-d8f8-41f6-8536-08dede68ea10
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C2.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10471

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjMyICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gSGFyZHdhcmUgcGVuZGluZyBzdGF0ZSBkZXN5bmNocm9uaXphdGlvbiBmb3IgR0lDdjUgU1BJ
cyBhbmQNCj4gTFBJcyBkdWUgdG8gb21pdHRlZCBgc2V0X3BlbmRpbmdfc3RhdGVgIC8gYFZEUEVO
RGAgaW52b2NhdGlvbiBpbg0KPiBndWVzdCBNTUlPIGFuZCBNU0kgcGF0aHMuDQo+IC0tDQo+IA0K
PiBjb21taXQgZWUyZjJiNzc1NDdkYTE4ZjJmMWRhN2Q3OTkwNWI2N2E4Y2JjYTkyOQ0KPiBBdXRo
b3I6IFNhc2NoYSBCaXNjaG9mZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+DQo+IFN1YmplY3Q6
IEtWTTogYXJtNjQ6IGdpYzogSW50cm9kdWNlIHNldF9wZW5kaW5nX3N0YXRlKCkgdG8gaXJxX29w
DQo+IA0KPiBUaGlzIGNvbW1pdCBpbnRyb2R1Y2VzIGEgbmV3IHNldF9wZW5kaW5nX3N0YXRlKCkg
ZnVuY3Rpb24gcG9pbnRlciB0bw0KPiBpcnFfb3BzIGZvciB0aGUgQVJNNjQgS1ZNIFZHSUMuIEl0
IGNhbGxzIHRoaXMgZnVuY3Rpb24gaW4NCj4ga3ZtX3ZnaWNfaW5qZWN0X2lycSgpIHRvIGFsbG93
IHRoZSBiYWNrZW5kIHRvIG1pcnJvciB0aGUgdXBkYXRlZCBWR0lDDQo+IHNoYWRvdyBwZW5kaW5n
IHN0YXRlIGludG8gaGFyZHdhcmUgZm9yIGNhc2VzIHdoZXJlIGhhcmR3YXJlIG1hbmFnZXMNCj4g
dGhlDQo+IGxpZmVjeWNsZSwgc3VjaCBhcyBHSUN2NSBTUElzIGFuZCBMUElzLg0KPiANCj4gPiBk
aWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCj4gPiBiL2FyY2gvYXJtNjQv
a3ZtL3ZnaWMvdmdpYy5jDQo+ID4gaW5kZXggOGIxNTkzODQ2NGFiOS4uZWU3ZmMwYzcxMDRlNiAx
MDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuYw0KPiA+ICsrKyBiL2Fy
Y2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5jDQo+IFsgLi4uIF0NCj4gPiBAQCAtNTYzLDYgKzU2Myw5
IEBAIGludCBrdm1fdmdpY19pbmplY3RfaXJxKHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0DQo+ID4g
a3ZtX3ZjcHUgKnZjcHUsDQo+ID4gwqAJZWxzZQ0KPiA+IMKgCQlpcnEtPnBlbmRpbmdfbGF0Y2gg
PSB0cnVlOw0KPiA+IMKgDQo+ID4gKwlpZiAoaXJxLT5vcHMgJiYgaXJxLT5vcHMtPnNldF9wZW5k
aW5nX3N0YXRlKQ0KPiA+ICsJCVdBUk5fT05fT05DRSghaXJxLT5vcHMtPnNldF9wZW5kaW5nX3N0
YXRlKHZjcHUsDQo+ID4gaXJxKSk7DQo+ID4gKw0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBT
aW5jZSBzZXRfcGVuZGluZ19zdGF0ZSgpIGlzIG5lZWRlZCB0byBtaXJyb3IgdGhlIHNoYWRvdyBw
ZW5kaW5nDQo+IHN0YXRlIHRvDQo+IGhhcmR3YXJlIGZvciBHSUN2NSBTUElzIGFuZCBMUElzLCBk
b2VzIGl0IGFsc28gbmVlZCB0byBiZSBjYWxsZWQgaW4NCj4gb3RoZXINCj4gcGF0aHMgdGhhdCB1
cGRhdGUgaXJxLT5wZW5kaW5nX2xhdGNoPw0KDQpXaXRoIEdJQ3Y1LCBtb3N0IG9mIHRoZSBpbnRl
cnJ1cHQgbGlmZWN5Y2xlIGlzIGhhbmRsZWQgYnkgdGhlIGhhcmR3YXJlLg0KV2UgZG9uJ3QgbmVl
ZCB0byBkbyB0aGUgc2FtZSBsZXZlbCBvZiB0cmFja2luZyBpbiBzb2Z0d2FyZSBhcyBpcyBkb25l
DQpmb3IgR0lDdjMvNCwgYW5kIGluc3RlYWQgY2FuIGp1c3QgaW5qZWN0IHRoZSBpbnRlcnJ1cHQg
c3RhdGUgaW50byB0aGUNCmd1ZXN0IHRoZSBtYWpvcml0eSBvZiB0aGUgdGltZS4NCg0KPiANCj4g
Rm9yIGV4YW1wbGUsIHdoZW4gYSBndWVzdCB3cml0ZXMgdG8gSVNQRU5EUi9JQ1BFTkRSIHRvIG1h
bnVhbGx5IHBlbmQNCj4gb3INCj4gY2xlYXIgYW4gU1BJLCB0aGUgc2hhZG93IHN0YXRlIGlzIHVw
ZGF0ZWQgYnV0IHRoZSBoYXJkd2FyZSB1cGRhdGUNCj4gYXBwZWFycw0KPiB0byBiZSBieXBhc3Nl
ZDoNCg0KTm8gLSB0aGVzZSBkb24ndCBleGlzdCBmb3IgR0lDdjUuDQoNCj4gDQo+IGFyY2gvYXJt
NjQva3ZtL3ZnaWMvdmdpYy1tbWlvLmM6X19zZXRfcGVuZGluZygpIHsNCj4gwqDCoMKgIC4uLg0K
PiDCoMKgwqAgaXJxLT5wZW5kaW5nX2xhdGNoID0gdHJ1ZTsNCj4gwqDCoMKgIGlmIChpcnEtPmh3
ICYmICFpc191c2VyKQ0KPiDCoMKgwqDCoMKgwqDCoCB2Z2ljX2lycV9zZXRfcGh5c19hY3RpdmUo
aXJxLCB0cnVlKTsNCj4gwqDCoMKgIA0KPiDCoMKgwqAgdmdpY19xdWV1ZV9pcnFfdW5sb2NrKHZj
cHUtPmt2bSwgaXJxLCBmbGFncyk7DQo+IMKgwqDCoCAuLi4NCj4gfQ0KDQpJc24ndCB0aGlzIEdJ
Q3YyIGNvZGU/DQoNCj4gDQo+IFNpbWlsYXJseSwgZm9yIExQSXMgaW5qZWN0ZWQgdmlhIHRoZSBJ
VFMsIHRoZSBoYXJkd2FyZSB1cGRhdGUgc2VlbXMNCj4gdG8gYmUNCj4gb21pdHRlZDoNCj4gDQo+
IGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pdHMuYzp2Z2ljX2l0c190cmlnZ2VyX21zaSgpIHsN
Cj4gwqDCoMKgIC4uLg0KPiDCoMKgwqAgcmF3X3NwaW5fbG9ja19pcnFzYXZlKCZpcnEtPmlycV9s
b2NrLCBmbGFncyk7DQo+IMKgwqDCoCBpcnEtPnBlbmRpbmdfbGF0Y2ggPSB0cnVlOw0KPiDCoMKg
wqAgdmdpY19xdWV1ZV9pcnFfdW5sb2NrKGt2bSwgaXJxLCBmbGFncyk7DQo+IMKgwqDCoCAuLi4N
Cj4gfQ0KDQpUaGlzIGlzIHRoZSBHSUN2MyBJVFMuIFRoZSBHSUN2NSBvbmUgaGFzIG5vdCBiZWVu
IGFkZGVkIHRvIEtWTSBhdCB0aGlzDQpzdGFnZS4NCg0KPiANCj4gQ291bGQgdGhpcyBsZWFkIHRv
IGxvc3QgaW50ZXJydXB0cyBhbmQgcG90ZW50aWFsIHN5c3RlbSBoYW5ncyBpZiB0aGUNCj4gaGFy
ZHdhcmUgcmVtYWlucyB1bmF3YXJlIG9mIHRoZSBwZW5kaW5nIHN0YXRlIGluIHRoZXNlIHBhdGhz
Pw0KPiANCj4gQWRkaXRpb25hbGx5LCBkbyBHSUN2NSBMUElzIGdldCBhc3NpZ25lZCBhbiBpcnFf
b3BzIHN0cnVjdD8gSWYgbm90LA0KPiB0aGV5DQo+IG1pZ2h0IGxhY2sgYSBtZWNoYW5pc20gdG8g
aXNzdWUgdGhlIHJlcXVpcmVkIFZEUEVORCBjb21tYW5kIHdoZW4NCj4gdHJpZ2dlcmVkDQo+IHZp
YSB2Z2ljX2l0c190cmlnZ2VyX21zaSgpLg0KDQpBZ2Fpbiwgd2UgZG9uJ3Qgc3VwcG9ydCB0aGUg
R0lDdjUgSVRTIGF0IHRoaXMgc3RhZ2UuIFRoZXNlIHBhdGhzIHdpbGwNCmJlIHBvcHVsYXRlZCB3
aGVuIHRoZSBzdXBwb3J0IGZvciB0aGF0IGlzIGFkZGVkLg0KDQo+IA0KPiA+IMKgCXZnaWNfcXVl
dWVfaXJxX3VubG9jayhrdm0sIGlycSwgZmxhZ3MpOw0KPiA+IMKgCXZnaWNfcHV0X2lycShrdm0s
IGlycSk7DQo+ID4gDQo+IA0KDQpUaGFua3MsDQpTYXNjaGENCg==
