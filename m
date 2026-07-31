Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013030.outbound.protection.outlook.com [52.101.83.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CC83B83FE;
	Fri, 31 Jul 2026 09:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.30
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785490607; cv=fail; b=axUOCk/Uzi3qklDEsrCQDL9pPld3TstMtJtKK2kK+r/Skyn7114BfAADPU/Ik5A/N+tahLOVg7EJNV6rvl3tWJ60bYj785QfiQcX5DkpQDDsNnXLrZDFqfbZONGy/1aNMoixTDKB/paKU/GBH7DTW1S9SJjnSGU7XNU+g9Kgb7E=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785490607; c=relaxed/simple;
	bh=3f+bGByMCRzV3H70ppk92PDlbvg1HeobMnWQ8D7B9mw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KO0ruJ1TaOO6HwljWDA88kcQtyBmT9JGWxRSOJCaFsTwR6c4z4m/gm0BKSuVWtA4PwXIbimb2VKkLCYIPXLbRPi96wvyqv3IEFRiB3jSRpDaTUIWHrlZaFUBjKJ73D97Tbfe0A4PKLiVuX2M0NWXwDuzi4nPLiuC/TBJ58UETM8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EA73aZNl; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EA73aZNl; arc=fail smtp.client-ip=52.101.83.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EA73aZNl";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EA73aZNl"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=yBjG5q8HKxclFPG5KHcubdJe/SbaJLzYP0b4I5tae0/uH+fGtse9+qeBMEEl6BQmR7SQyDfck1KxQZMAcaUEgvaC4bdGKTYmrzOb3/D3y1KpG6yMrL9yLKv/+X/+/MAhZ+tiDUr92/xvhMErTax1Yp94ATjsI4iXxARyCdzuGCIALvUQcib4AO+KH+A8k2E6/o7TeLuqx6ep8EI0wKR/Z8o00wljvVDzACTlYWxNa1GwCncxG57TyvG0iwA28d1oJLUSnLyRytAbMsWl+AOYwYOSCvOL7jquA/c8opOT2WCjBcl9+APq+/+cdCWrlm4HtcPGDDj3T2mdpZjr1P2c2Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3f+bGByMCRzV3H70ppk92PDlbvg1HeobMnWQ8D7B9mw=;
 b=oDVqfHN5KVtrYBYhN364+OtBY7myN7uLw+IzDmkku4r5EHa/XmFLpMTs6LdJlh/fLQGu9HXtUMyVoGesUTHAV0onKLK1WZ5O3WrpPZegHumnFUE/e+V/AtIY8YE6+sZMdU0GzFdmwxiQbJwQpU98Z1BBauazlnGesdxURO8FYzif6p00UmJNSPBua6TiKEXne8uQKbEZCkMw8S13+OUrquH9JoENdfQQqicTYjj6eWNQlKd3JgkIwlGDJVHxHH3K6M0rox05x3thEqGaIxFSjhR3A13Aul4QJIc0oFREA3ZuY/sy80mtYftpSPC0X0NofsceuWwt/bDEuFRLF1hAFw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3f+bGByMCRzV3H70ppk92PDlbvg1HeobMnWQ8D7B9mw=;
 b=EA73aZNl531hhBUvNvWuafRneteswoaeKRd2nXgZihMvfxv9dm72PMAbYNkaV/e6KDdRaM7lWzBLdIoWCNsOkxDMa29Tkrl+il/sqsPRucTb+mAny2aBdBJycjYk8qLpLl8SDLTE3R3WbSmOKIQmuEpua24CHnxZtJ8vFgQTIYQ=
Received: from AS8PR07CA0038.eurprd07.prod.outlook.com (2603:10a6:20b:459::23)
 by AM9PR08MB6225.eurprd08.prod.outlook.com (2603:10a6:20b:2de::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 09:36:41 +0000
Received: from AMS1EPF00000046.eurprd04.prod.outlook.com
 (2603:10a6:20b:459:cafe::84) by AS8PR07CA0038.outlook.office365.com
 (2603:10a6:20b:459::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.10 via Frontend Transport; Fri,
 31 Jul 2026 09:36:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000046.mail.protection.outlook.com (10.167.16.43) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 09:36:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LRYmIENxvi2PN6zwo8uytTdUcgq+QQLJT8r8auRbhu4j35E5DHj3m1uLUCVvwVvBmA1dKIaBzZ9ALkAwwWbYg3R6WQ216vPAgZXboSxg7kRHE7hBd3nfiNx2/9P4STEa+dBgWGY+NZBmypA7Zcgb2kmwShakuIDuc9PGVss9NCXEk027BEr1n71FhHjNpeFKIYCdKpVhRliTJW6Rh2x8bwK6RUqLSA8vrZ1axTfavD2dR3KGnzZbOV6iTGb5mwZSpUdNnUKJ/f8YbldMpmzs8iR1dLkwWFBiwjxN2tkCQAn4I1qN/JDTqAmhnN5a1U3ZaaQ/uv0MuK6sUQWPUIcGrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3f+bGByMCRzV3H70ppk92PDlbvg1HeobMnWQ8D7B9mw=;
 b=n0Xcs6gMKKCHCBo3y9eSIkv1qupHBirZl49ZBzAEXYaJ4WJKXtuH79lPiuCCz+KO2ejWBUKgua018+8OLDOS3S/NgPE77EMo5tUTMYO5Ewp/xbXbOo1TKwxq6IKETN39O/KA5K9PaQIz3FbylTT+xpNFTWSkoULPGmW9qjOgY4XFiI+UHixUU/YHOAiKOKx5mZm2Hgk2z4v66WBRsMYXZE+TaHj60Gjd3v5IOC6VPGIXeMdB/njD/PH5fj9W1Ocj0yBN5GjY3xbYVee959xKxaZwjHv89wFJ+9vSuOEK4o04QRi0T3MsbZ+EpU10Cw9EOzL6GFkTzQCpz6ZTm8lvBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3f+bGByMCRzV3H70ppk92PDlbvg1HeobMnWQ8D7B9mw=;
 b=EA73aZNl531hhBUvNvWuafRneteswoaeKRd2nXgZihMvfxv9dm72PMAbYNkaV/e6KDdRaM7lWzBLdIoWCNsOkxDMa29Tkrl+il/sqsPRucTb+mAny2aBdBJycjYk8qLpLl8SDLTE3R3WbSmOKIQmuEpua24CHnxZtJ8vFgQTIYQ=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DBBPR08MB10722.eurprd08.prod.outlook.com (2603:10a6:10:530::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 09:35:35 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 09:35:35 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 07/48] KVM: arm64: gic-v5: Extract host IRS caps from
 IRS config frame
Thread-Topic: [PATCH v4 07/48] KVM: arm64: gic-v5: Extract host IRS caps from
 IRS config frame
Thread-Index: AQHdG1o0qOow5djU00KduraRpDffM7Z8hdWAgArjUwA=
Date: Fri, 31 Jul 2026 09:35:35 +0000
Message-ID: <837e507425c6a2f4f8d79b87cb5763cd3d482957.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-8-sascha.bischoff@arm.com>
	 <20260724111919.7EAB41F000E9@smtp.kernel.org>
In-Reply-To: <20260724111919.7EAB41F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DBBPR08MB10722:EE_|AMS1EPF00000046:EE_|AM9PR08MB6225:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d3c04ee-13b8-4f88-9774-08deeee73a21
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 /+f44d68wYwn8/ZKbiuR/Sz7tf8rssfq2MY580WyrrAkpbTEttHeDnTc0HzD/ZuHd4syIPOosb5FY2eIMvOS8Lhiyna+2Qi+QYT6+lPCUYPxgxsqrFQ5YKVuw/4wkbO7+nRVMCKsYmq+Y+fyB/L+CNSovY4qe8inOCeeJhu+frnYcEB36I/WaI1uiQOzznSW1nLAwq8qwVkBTFujHXsuK1ryg6fRJUH6pshGJijrXH4ctxJeFCxlXtw2omOGepjj8BwlufxxQW9xIuLy50/z7ZgrkvtfYlh7nQiT4VsYt8RSxGXzfVu0lICT5hSWd8abbcoOfMvaj65oSK+jXqZ1fl3c77YOO9ZknyIA+PmeeCeCMpudwTyceEu8b27Yqgmehn5/YXxLLxv8YeJKHgiReh7o6VmHk1E9xrCSmVfhN6CLLyQ6zt0i49ZS+hylLAmsHzDucC1yQhwfJanLamlV03eyKjfoeIU/TkplpXncN6fa5kuZFNmbrBbtuUbJbH/FMpl3liX8lvvsSeQGOu0Xsddk+lQxzcHdj+MAFrVl9GbCQX2Qo4xRY6ParhUQ67ujAAHchIKNi0koTGs1yGwbKgS0J4O2dXAdfto6itCloVlCjY1v6t4v31TdsD9p2BYkU29u+CHs1d7g6QSdWQSv+BPwewHXnsxEJz3HHZvAnnQ3dV3y2HYER5792xB+n0VUDH4J7Yi2Xb30z/TDfGXpyQ==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <44C2101DCCBE4B4083A9A09608F99E15@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 oQIP9iRHxwLoBTCqkpgLj3ujYWSw14hhNkRgPQDo3LvWWkdiPwFBjjhmfJYCBPaTc9tXnLCXuKzsn55LXqYt2LkFykvPkrG1WgRDqDpXsyTShoFQW/Vuh+NlUimNdZIvJ+vNvBfGZ0UOL4ZkiUtFdYA4CY50eeZLo9czAlBswoNKOdAmIajD+x5uoBrxd7MR6Sosn6DO7SKuZYFW14AuyiGGdLVaN2O3rqKO0xbxfbTtvu/+CdYDrUNjb+Z96lID+wVXtxpbUl9GUOd2rEnabef1UAH/VI2o8ttud2GWvX85usHzNTNmw8Wr0YsIJX1DTU0Oj5t0HA7lvyYuRpSceA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10722
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000046.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8ce3ac20-9a2b-439a-3ae4-08deeee712c4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|35042699022|1800799024|14060799003|23010399003|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qGYUxhn6R/8LVb0ODcFvJ6FSpAgsBcf2UJ6gjYnAO3nrcMzSU9Z7g+Ocsa2yvAxpIPawyEbLcKls35Oo4akTQVkONWomW+o1S+Z3ELoXOb8nanICndrzzaO7ImS3eoxjwNUg7IFC+e7MAo0MN9R/3aMWLZfFT3r6o6laaRSlqltYbcPWIUNwiUpqJ7ctOB8DUkI1qpQAtoNcKdaD6ZmwciHeRff2IHDefbZgeLwM5Y00ESNA7ZonM8E/aiNoxiJaoiZn1QpHNCkv0XHG9IUfXM+9q94rcXSDLFHsphtbHLLOsh4N43AFGVLxsGUNRk458aMxl+viJpGlyuBjma0TzON/z0imQ2ho+2zj15PBz2jqr9GX4aOTE+skI1sAAyk2VPeFyp/w64856ulDHSUmhejCMfhktB45Cqp+8oXTi17zR+me6zE0NT3uks7BlerWiLX8krGZoJHI9aRrPMlGG1QNdHrwJUggJdGhNm0V1fef13m6+flum06RyRgUjUBmS9R4W+a8H4TpdH3pzPBmftBIgP5JMbFE3Xa8RPlRuOiKwaVZMW+JNdSMvWopYBj3IZOsU9Sj5VtGnOynnQTQAhj4WSvtuDPNN4TLK0aRfCK1Osp2JNmEHtu+VM2XoVaudYtt3AUYLKqXyL/GbTbkMdgZabhwTrbuHSRA+yCBP5BUgv7pmDm+lLmCBQGje1bK
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(35042699022)(1800799024)(14060799003)(23010399003)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lqXkkuVf2YWOlWtPvByk5xjP5Hzw8Z75dVxmBrp6J1w1zBvq+UAh+kdjpQrAbQv8lRE2C6ZxKlN9sjd5ECqXOl2CcNcikNLCcfEFh1lLbguy6a/6LDWgJ0XSdPBbEqufnmWV5LR8qTVCh3M19GEKxjDwnB1Gufj31C/dCsecHMp3YB191Cv1/g3AqckhI2p+kSq+G9oWnULdvdIkRxixPUxyDvwE5zUupRhJjYw/QMPJ5A25j5RRCr2yE/MvMuKfMuwAGotBrff9KkeZMktwxZBMKlCqhSlTPqfoPrV6+JyHqNPX/dks2oEU/oA1RX83iyMlWRBA9SY0mOjRPROarhgyDBYiK5VaMBRhrJcL3IRhsFbi57OLLnIwPpJBcJi1nLzyKrq6jHFLfB7mn1DEkmj/mHU2VYNPMyU/bUF6NXMPbJoDQfTTASf1XVKFI5A3
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 09:36:41.2375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d3c04ee-13b8-4f88-9774-08deeee73a21
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6225

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDExOjE5ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiA+ICsJaWRyID0gaXJzX3JlYWRsX3JlbGF4ZWQoR0lDVjVfSVJTX0lEUjMpOw0K
PiA+ICsNCj4gPiArCWlyc19jYXBzLm1heF92bXMgPQ0KPiA+IEJJVChGSUVMRF9HRVQoR0lDVjVf
SVJTX0lEUjNfVk1fSURfQklUUywgaWRyKSk7DQo+IA0KPiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4g
U2hvdWxkIHRoaXMgaGF2ZSBhICsgMSBhcHBsaWVkIHRvIHRoZSBmaWVsZCB2YWx1ZSwgc2ltaWxh
ciB0byBob3cNCj4gVlBFX0lEX0JJVFMNCj4gaXMgaGFuZGxlZCBiZWxvdz8gDQo+IA0KPiBHSUMg
YXJjaGl0ZWN0dXJlIElEIGJpdCBmaWVsZHMgY2Fub25pY2FsbHkgc3RvcmUgdGhlIG51bWJlciBv
ZiBiaXRzDQo+IG1pbnVzIDEuDQo+IElmIFZNX0lEX0JJVFMgZm9sbG93cyB0aGUgc2FtZSBwYXR0
ZXJuLCBvbWl0dGluZyB0aGUgKyAxIHdpbGwgcmVzdWx0DQo+IGluIEtWTQ0KPiBjYWxjdWxhdGlu
ZyBleGFjdGx5IGhhbGYgb2YgdGhlIGFjdHVhbCBtYXhpbXVtIG51bWJlciBvZiBWTXMNCj4gc3Vw
cG9ydGVkIGJ5IHRoZQ0KPiBoYXJkd2FyZSwgbGVhZGluZyB0byBwcmVtYXR1cmUgcmVzb3VyY2Ug
ZXhoYXVzdGlvbi4NCg0KVGhlIGZpZWxkIGRvZXMgTk9UIGZvbGxvdyB0aGF0IHBhdHRlcm4uIFNv
bWUgZmllbGRzIGhhdmUgdGhhdCwgYW5kDQpvdGhlcnMgZG8gbm90LiBUaGlzIG9uZSBkb2VzIG5v
dCBhcyBhZGRpbmcgYW4gb2Zmc2V0IG9mICsxIHdvdWxkIGJyZWFrDQp0aGluZ3MuDQoNClRoYW5r
cywNClNhc2NoYQ0K
