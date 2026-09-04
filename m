Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010041.outbound.protection.outlook.com [52.101.69.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFFF411A0E;
	Fri,  4 Sep 2026 10:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788517427; cv=fail; b=b8mpvvpsuphpT5pqaY8nnfR/2NOP9iQvdbMLwFF1Y5ZNN39++/B7Z6oNmnl5lLPzQiYK71RDtWNELHZhtzzEO4DN2aRMbfonicjjCJkhSBxjwmYqtdob3/Wz+Invu7VAkFt6so4r6OBZNesMbHBhvtMlzWFKn5KsMKq7RRHQ54A=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788517427; c=relaxed/simple;
	bh=dVUoAfDVH5oc+St9GR1pk3UqF2k6d1uHIerW7FGMEZE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nD4+uz4oylm7XlsykPYbErtnzQjxqDGUibcjqKywLRklt8Ie8zUSLJ96EugdG0xxMQQ+BDgaTovg2gr1OneFhkjBz0yVYbE6x0dbzaF42qFlf13QlcS/mTyEBtZSC5tBOU4xkn+BO40CE7KktiNVwewO7VtCm6cdYD1OaauUkCU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fMk1Du5Y; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fMk1Du5Y; arc=fail smtp.client-ip=52.101.69.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fMk1Du5Y";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fMk1Du5Y"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hWglZjbQrkk/agnsNi3ysx9N2ePZEest/4N4AzboNk9uaWysSoxE0ATmh/mUpa6SCOJX5wglRLjApFLRrwcW6F51Z/514EAgncJ3Sb+c4fLoe0pWtoE3cnBCJunuFl1U3dfshEr9YwSk98DlcD1yR4dMmZ6cx2VCcNQjNzDNEcUMSFmmhiP/ZYm6VSSAqyuMgQKdNJKsbX0PxY/bZ58CJtigtCHy2kU9aOC0aBcLZrcpt0pTnure4leG6Pb9fJmN1aSRYsNzR/m+4M/lq9o4WqoSvPTBow/sdFXfYEbxnbr7N20dBzI97eLXKZx/+awG3vJSjea/FbT0oybUfdKQGg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dVUoAfDVH5oc+St9GR1pk3UqF2k6d1uHIerW7FGMEZE=;
 b=UHtnploD/PYCUTByzGPeVL8LFR4SKXA3UdPBgNj/UA55cNlS3YwKAKMbX8Z+cMJMUR681v6L/A0zAZAYnAQ7bpnMfNJH0MtsM1TUkrUjzDkJbKXDWx0u1avj/coKjoCRE51OIbYE+JAIzPgE1OGB775n6MBf7ZAdqQozYAKFLQE7Zw/vayQiIaz6BNwCCuOGGMybt9TtS/KN/x8FNKURnbxAg5Z/6NCGySFdTzBlktwN3uOV454l6oyvMjsJNJQx+OvQypiScywoERCvKMSzJRFuIQyq3RsTaa1Q8KUJWWuC3MIwqe8FNWBLtx+MxwwEMCDszjiKWuoFx7an6djq4Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dVUoAfDVH5oc+St9GR1pk3UqF2k6d1uHIerW7FGMEZE=;
 b=fMk1Du5YWGeAOkuz6bWlQDcvX2wfqygo2oyddX9SCFCRzKayju73d1vxIkRZCV4zSDFQtmsla9BXHtdC45LauSPAbYQJmoJppJMNPwqvI2SxYK8ND90do+YI3ELhknsNHHyv54D7uBocRWdmnlJElN+TxwOv1bYRbOcq4qOOMuk=
Received: from BE1P281CA0046.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:23::11)
 by GV2PR08MB11343.eurprd08.prod.outlook.com (2603:10a6:150:2a6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:23:35 +0000
Received: from WA1PEPF00009B3C.eurprd05.prod.outlook.com
 (2603:10a6:b10:23:cafe::28) by BE1P281CA0046.outlook.office365.com
 (2603:10a6:b10:23::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.4 via Frontend Transport; Fri, 4
 Sep 2026 10:23:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 WA1PEPF00009B3C.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 10:23:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WEAsq8GjzoBxxkdYsZTvQ1CzEOn7JE0KZv+oIAWhfbpTYdDijFV0lQXaeveZIPG9V64Z7yUC6dh/2BVE94Gu97J8CCYGlSKMhZBb4EGQS15EwqWWmow7tn4+maC72lhCYoFEh+al6eleXpDr2PGTf0x6aHhXZlLO9bhUM1Vld2uuSBI7RFqTD7uu1D26eZ1zOG/XTFSwMaAFWvsgK4ygIAT2ujR+52+L8WEMe88vPMzriZnQwOxviOoNzs0hK9bR5m0ISLHMBCLB0sMOJTTw9c6zqM09RbVVUQqaRYj39+bPLdS/3cBJss6o3Wk27HS3Oh6MH8YgYJgWSLQdlYWFxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dVUoAfDVH5oc+St9GR1pk3UqF2k6d1uHIerW7FGMEZE=;
 b=lqD0PnfLS4y6EPHC9xAMMutQRxzzPkkpzr8lfukHvYZ9pnwiDZbHxqqcOu+Th8erYPZVZLVdOXxfKOMh06lnr5VXnlH/dcWIyWs/80+0v2duNpMs/lXVeyWEZQctWHJldfNKZc81t1J+WA7XtJX07KeciRBrVfI5NCjUZHMhz0TCwZgceu3bbvRqh4bnQCbpvJL2toq16e59BDuH4e7A010oFlmcn7cpjm4Xl2Fbh7CXzhSBamyLsBWTRQ03H33OasnGe+lFNHfZEw7qdpehWLD/I3Gy8TIITN/CNAvUO1n150KVz0GrTV3xISSrczdkLrEenX7ZAxBFdubWTZY4+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dVUoAfDVH5oc+St9GR1pk3UqF2k6d1uHIerW7FGMEZE=;
 b=fMk1Du5YWGeAOkuz6bWlQDcvX2wfqygo2oyddX9SCFCRzKayju73d1vxIkRZCV4zSDFQtmsla9BXHtdC45LauSPAbYQJmoJppJMNPwqvI2SxYK8ND90do+YI3ELhknsNHHyv54D7uBocRWdmnlJElN+TxwOv1bYRbOcq4qOOMuk=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by VI0PR08MB11383.eurprd08.prod.outlook.com (2603:10a6:800:303::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:23:02 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 10:23:01 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 35/49] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Topic: [PATCH v5 35/49] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Index: AQHdJmAkIVEQ06D3K06pVJap7VmeFbaSzFmAgCuVnwA=
Date: Fri, 4 Sep 2026 10:23:01 +0000
Message-ID: <559b79260a0e269f5c5ab3a2ae71f7c6a9e45271.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-36-sascha.bischoff@arm.com>
	 <20260807164820.DE59D1F000E9@smtp.kernel.org>
In-Reply-To: <20260807164820.DE59D1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|VI0PR08MB11383:EE_|WA1PEPF00009B3C:EE_|GV2PR08MB11343:EE_
X-MS-Office365-Filtering-Correlation-Id: 6618dbec-a95d-4fc0-f508-08df0a6e936f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|38070700021|6133799003|56012099006|10067099003|22082099003|4143699003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 tyuWlgtzoCkKb/BracesWYKiXPS/UTvAoPJR2/BZndCJSzBE498wPkl7L+6jrkmnIVReAtz0XDUfMbEZeqgB2tsoPtpf3V/MTdxifRLSEY1U6gEfjdtcYKruZaBeEm4RAMRfejB02kLu1+vx0jSByQYf4W/wauzYoI0UrmpvPpLLVmqpTbt979Kj8WpmA2SWkitpFc23ZMXN5T59utqhxkQ9l71oKjbPWSPkj0uJql7FmWqodVyJypsMBLTxWpvbIUOgwWXw7BnFyzo9aOh956M+99mOOyb6PrnBGYKwU5sCfkFd/mBUj3hNat2QMGQoHc+QTggHfNdM9CFzeki373acyd2be6AjUQglkHKE2z4RDPd15C+6XEPaZsqHI6XauWZGdQHCFmK/iXwgci4tCThihS3U+E1GNg2YfCenZHK/4vTccHvtka9/yoJA7eibGiNPDIelESMGKq2Dmd+YP5+1Y2UJHv3kY00l8g1o4NwnOseuMj3tcSCmeipk2pxPGERo0MnzmqcCrvjpTqGMeTPe9G3lni2YY31nSL8OzwcWYA85crxwBViSUteWjOfiSNIpxASUJjrHbtrUxP6J/SmlpvIw24rsr/q5PZGv3j3fj+pZr7NWwBuxKwp9qxzLm7eepxyUHfkWJ95Z7+akp1ujacwVtqvWX9F/ilFHH0N3MPG4FCODod/SYuO6RFkEFhUi9DUet004rxJKy5CLQX+x8jE2f8a82ItKLd+oEq4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(38070700021)(6133799003)(56012099006)(10067099003)(22082099003)(4143699003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A2B33AEF558DD41A34527DCD3E3C2C2@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 zlVsMbPqmPn3Bu+rl7eyQ4gJlLAc34TiyumqQafkYdYjv5hbcRVgXMHgnSvAO728jbTeJyKBnH11goCFwafX1c/jT5SRZKS9JbkfjFJwPrxsTChT0Engug6vp0DNVbJ3bSq9aJrfR+vp7oe00xqGC3yBb06URWGuw8d7A0POudDYjIwRQ/P5svYAzm56UJJoon5E02XiGsDIZxc42fuJB0EnHBSlWo4ElgQ/EnUGKGp2Axu092iorvJZeMdiLgA8DOpd7C7q/apSxsoOR6cK8euXBTczGFEIcythBeBCmKLFGPw9WrSOlr4UaFkbEQBIz23WVkwta8ay6ez38TMkGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11383
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 WA1PEPF00009B3C.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	df97eda0-923c-421d-c4d4-08df0a6e7fe8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|23010399003|14060799003|36860700016|82310400026|1800799024|11063799006|6133799003|10067099003|4143699003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	ny+4Ae/ctq+UV34dZGfhbLjCMtHHff0AjYhdN1UszTCbQpggl0JCaM7E76EE3Kr062DKHzCHJUYJA2PTVE4PTbCXEHgZYAmAa7/tPMByUBfun7Z7OgK8EvdahX72mjjqnbTxa3feXlYRmPEAnS1ESvjmHfmzoRtfx55KUYtBSMuB7kHIbKv/H3mtTfMWlVl5POqJNPqeOLjxhjFkurSBNdc3GUUNaGcfS2hjD6yJwth5EDLPm5CyqkfdMhXt/41ZJRuTR/MoxQZO32cLpFwBqkgD5ZGErRPwYBFSecrbdbJb/esU1pacIbVidncxEoFvv61TYvhRM85VCdEIf0s2uDnLB71dgwtvTQxG2nJO5l9jCbX7ve1G2U1II7HsqjIMDQbQjMGKxm2u3Zbveyjsjc0bdHah5COFqajJGV8yOXdhoJr4XKfXlnoh8INiimLAQRisz0VQLuUH3DzDfavW4ITlb8vwoDXEcGTp0p5X8IJY2nzusBa6WbtGwKOc5gtLGCPnsKgtmIrjTwCaj1uRA/IOEOjhuFlkPnXBoorYuo6Lwv25XXzwAxh/dVw9ZisJ4dXI98z6IyGozq7JBbAO43zcO6hPpXw/fh5oSm3kdg6uOoVXK/rU3OaxItQLUZLP9Oxo3gIA7qRp9Y8pChq3ke/DroakNIVpnMz0gLyrtxg=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(23010399003)(14060799003)(36860700016)(82310400026)(1800799024)(11063799006)(6133799003)(10067099003)(4143699003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Mlhxu/KqfzeM2KKDH1wDzB3A3/K1fwYKHfmOjFjdOdCpCNpvmSPi/MDqq0nyu72/GMrI1oFmCkLnPhQilyWXnfalryZKkYV60RIgeua6iqeTRjyVBJDCderbNksD7eu825kUyy/1eCUrIv0xrE1JLcth0TLHggde4s0wpwfLLiw/LfpkbmV5J5GBU51WNbLd1DaymnbGl0Y5U88pO68zGvpkD8uSlcttXPkmVN01td1JASTpuBCkutTqTyER1HosT4P+B8zkctEgx68wGRtUA0uDuzUJRTsIQ3Uh/HlyrTddSYXB7KeK3YtMQ3HiIAdqw9NC0+zVmAfwTp0xh921yTKH3Svj2kpwvV66ebVN47gAxMtfOGf3bJ8ae1dsJ1pECvQ21gEtft8OORThk9i+0aG08EX/xIT5frrkaW0TlBTE1lDqwGIa7dVgqz8RLebE
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 10:23:34.2862
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6618dbec-a95d-4fc0-f508-08df0a6e936f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	WA1PEPF00009B3C.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11343

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE2OjQ4ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAzIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gUmVzdG9yYXRpb24gb2YgR0lDdjUgSVJTIHJlZ2lzdGVycyBhbmQgSVNUIHN0YXRlDQo+IHVu
Y29uZGl0aW9uYWxseSBmYWlscyBiZWZvcmUgdGhlIFZNIHJ1bnMuDQo+IC0gW0hpZ2hdIE1pc3Np
bmcgbWVtb3J5IGJhcnJpZXIgYmV0d2VlbiBETUEgbWVtb3J5IHJlYWRzIGFuZCBNTUlPDQo+IHdy
aXRlcyBpbiBJU1Qgc2F2ZSBwYXRocyBhbGxvd3MgaGFyZHdhcmUgdG8gY29ycnVwdCBJU1Qgc3Rh
dGUuDQo+IC0gW01lZGl1bV0gRWFybHkgcmV0dXJucyBpbiBgdmdpY192NV92bXRlX3JlbGVhc2Vg
IGxlYWsgVk0gbWVtb3J5DQo+IHN0cnVjdHVyZXMgaWYgSVNUIGZyZWVpbmcgZmFpbHMuDQo+IC0t
DQo+IA0KPiAtLS0gUGF0Y2ggWzM1XTogW1BBVENIIHY1IDM1LzQ5XSBLVk06IGFybTY0OiBnaWMt
djU6IEltcGxlbWVudA0KPiBzYXZlL3Jlc3RvcmUgbWVjaGFuaXNtcyBmb3IgSVNUcyAtLS0NCj4g
Y29tbWl0IDMyMzc2YWIzZjNhNjcxNDYxNWUxOGVlZjcwYzYzMWFmYTNiNWNkMDUNCj4gQXV0aG9y
OiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gS1ZNOiBh
cm02NDogZ2ljLXY1OiBJbXBsZW1lbnQgc2F2ZS9yZXN0b3JlIG1lY2hhbmlzbXMgZm9yIElTVHMN
Cj4gDQo+IFRoaXMgcGF0Y2ggYWRkcyBzdXBwb3J0IGZvciBzYXZpbmcgYW5kIHJlc3RvcmluZyBH
SUN2NSBJbnRlcnJ1cHQNCj4gU3RhdGUgVGFibGVzDQo+IChJU1RzKSBkdXJpbmcgdmlydHVhbCBt
YWNoaW5lIG1pZ3JhdGlvbi4gSXQgaW50cm9kdWNlcyBpbnRlcmZhY2VzIHRvDQo+IGV4cG9ydA0K
PiB0aGUgaW50ZXJuYWwgU1BJIGFuZCBMUEkgSVNUIHN0YXRlcyB0byB1c2Vyc3BhY2UgYW5kIGlu
amVjdCBwZW5kaW5nDQo+IGludGVycnVwdHMgdXBvbiByZXN0b3JhdGlvbi4gVGhlIHN0YXRlIGlz
IGNoZWNrZWQgZm9yIGhhcmR3YXJlDQo+IHF1aWVzY2VuY2UNCj4gZHVyaW5nIHRoZSBzYXZlIG9w
ZXJhdGlvbi4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1p
cnMtdjUuYw0KPiA+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWlycy12NS5jDQo+ID4gLS0t
IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWlycy12NS5jDQo+ID4gKysrIGIvYXJjaC9hcm02
NC9rdm0vdmdpYy92Z2ljLWlycy12NS5jDQo+IFsgLi4uIF0NCj4gPiBAQCAtNjQ2LDEzICs2NjEs
MjMgQEAgc3RhdGljIGludA0KPiA+IHZnaWNfdjVfbW1pb191YWNjZXNzX3dyaXRlX2lycyhzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUsIGdwYV90IGFkZHIsDQo+ID4gwqAJCQlyZXR1cm4gLUVJTlZBTDsN
Cj4gPiDCoAkJYnJlYWs7DQo+ID4gwqAJY2FzZSBHSUNWNV9JUlNfSVNUX0JBU0VSOg0KPiA+IC0J
CWlmIChpcnNfZGF0YS0+aXN0X2Jhc2VyLnZhbGlkICYmDQo+ID4gLQkJwqDCoMKgICF2Z2ljX3Y1
X2lzdF9iYXNlcl9tYXRjaGVzKGlyc19kYXRhLCB2YWwpKQ0KPiA+ICsJCXJldCA9IHZnaWNfdjVf
bHBpX2lzdF9leGlzdHModmNwdS0+a3ZtKTsNCj4gPiArCQlpZiAocmV0IDwgMCkNCj4gPiArCQkJ
cmV0dXJuIHJldDsNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gSXMgdGhpcyBjaGVjayBnb2lu
ZyB0byB1bmNvbmRpdGlvbmFsbHkgZmFpbCBkdXJpbmcgbGl2ZSBtaWdyYXRpb24/DQo+IA0KPiBV
c2Vyc3BhY2UgdHlwaWNhbGx5IHJlc3RvcmVzIHJlZ2lzdGVycyBiZWZvcmUgdGhlIGZpcnN0IEtW
TV9SVU4uDQo+IEhvd2V2ZXIsDQo+IHZnaWNfdjVfbHBpX2lzdF9leGlzdHMoKSByZXF1aXJlcyB0
aGUgdm1pIHN0cnVjdHVyZSB0byBiZSBwcmVzZW50IGluDQo+IHRoZQ0KPiB2bV9pbmZvIFhBcnJh
eSwgd2hpY2ggaXMgb25seSBhbGxvY2F0ZWQgaW4gdmdpY192NV92bXRlX2luaXQoKQ0KPiAodHJp
Z2dlcmVkIGJ5DQo+IHRoZSBmaXJzdCBLVk1fUlVOKS4NCj4gDQo+IFdpbGwgdGhpcyBjYXVzZSAt
RU5YSU8gdG8gYmUgcmV0dXJuZWQgd2hlbiByZXN0b3JpbmcNCj4gR0lDVjVfSVJTX0lTVF9CQVNF
Uj8NCg0KVGhlcmUncyBubyB3YXkgdG8gcmVzdG9yZSB0aGUgR0lDdjUgcmVnaXN0ZXJzIHdpdGhv
dXQgZmlyc3QNCmluaXRpYWxpc2luZyBpdC4gRG9pbmcgdGhhdCBpbiB0aGUgb3Bwb3NpdGUgb3Jk
ZXIgd291bGQgcmVzdWx0IGluIHRoZQ0KcmVzdG9yZWQgcmVnaXN0ZXIgc3RhdGUgYmVpbmcgb2Js
aXRlcmF0ZWQgKGFuZCBhcyB5b3Ugc2F5LCB3ZSdkIG1pc3MNCnRoZSByZXF1aXJlZCBzdHJ1Y3R1
cmVzIHRvIGRvIHNvKS4gVGhpcyBpcyBub3QgYSByZWFsIGlzc3VlIElNTy4NCg0KPiANCj4gWyAu
Li4gXQ0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUtdGFibGVz
LmMNCj4gPiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS10YWJsZXMuYw0KPiA+IC0tLSBh
L2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS10YWJsZXMuYw0KPiA+ICsrKyBiL2FyY2gvYXJt
NjQva3ZtL3ZnaWMvdmdpYy12NS10YWJsZXMuYw0KPiBbIC4uLiBdDQo+ID4gQEAgLTYwNCw2ICs2
NjIsOSBAQCBpbnQgdmdpY192NV92bXRlX3JlbGVhc2Uoc3RydWN0IGt2bSAqa3ZtKQ0KPiA+IMKg
CWlmICghdm1pKQ0KPiA+IMKgCQlnb3RvIG5vX3ZtaTsNCj4gPiDCoA0KPiA+ICsJLyogVW5saWtl
bHksIGJ1dCBwb3NzaWJsZS4gQXZvaWQgbGVha2luZyB0aGUgbWVtb3J5LiAqLw0KPiA+ICsJdmdp
Y192NV9kcmFpbl9wZW5kaW5nX2lycXMoa3ZtLCB2bWksIGZhbHNlKTsNCj4gPiArDQo+ID4gwqAJ
LyogSWYgd2UgaGF2ZSBhbiBMUEkgSVNULCBmcmVlIGl0ICovDQo+ID4gwqAJaWYgKHZtaS0+aF9s
cGlfaXN0KSB7DQo+ID4gwqAJCXJldCA9IHZnaWNfdjVfbHBpX2lzdF9mcmVlKGt2bSk7DQo+IA0K
PiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4gRG9lcyByZXR1cm5pbmcgZWFybHkgZnJvbSB2Z2ljX3Y1
X3ZtdGVfcmVsZWFzZSgpIGNhdXNlIGEgbWVtb3J5IGxlYWs/DQo+IA0KPiBJZiB2Z2ljX3Y1X2xw
aV9pc3RfZnJlZSgpIG9yIHZnaWNfdjVfc3BpX2lzdF9mcmVlKCkgZmFpbHMsIHRoZQ0KPiBmdW5j
dGlvbg0KPiByZXR1cm5zIGltbWVkaWF0ZWx5IHdpdGhvdXQgZnJlZWluZyB2bWktPnZwZWRfYmFz
ZSwgdm1pLT52cGV0X2Jhc2UsDQo+IHZtaS0+dm1kX2Jhc2UsIGFuZCB0aGUgdm1pIHN0cnVjdHVy
ZSBpdHNlbGYuDQo+IA0KPiBTaG91bGQgdGhlc2UgdGVhcmRvd24gcGF0aHMgbWFrZSBhIGJlc3Qt
ZWZmb3J0IGF0dGVtcHQgdG8gZnJlZSB0aGUNCj4gcmVtYWluaW5nDQo+IHJlc291cmNlcyByYXRo
ZXIgdGhhbiBhYm9ydGluZz8NCg0KVGhleSBoYXZlIGZyZWVkIGFzIG11Y2ggYXMgdGhleSBjYW4u
IElmIHRoZSBoYXJkd2FyZSBtYXkgc3RpbGwgYWNjZXNzDQp0aGUgbWVtb3J5LCB0aGVuIGl0IGNh
bm5vdCBiZSBmcmVlZCBhcyBpdCBvdGhlcndpc2UgbWlnaHQgYmUgcmV1c2VkIGZvcg0Kc29tZXRo
aW5nIGVsc2UuIFRoaXMgaXMgYnkgZGVzaWduLCBhbmQgc2hvdWxkIG9ubHkgaGFwcGVuIGlmIHRo
aW5ncw0KaGF2ZSBhbHJlYWR5IGdvbmUgdmVyeSB3cm9uZy4NCg0KPiANCj4gWyAuLi4gXQ0KPiA+
IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGIvYXJjaC9h
cm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMtdjUuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+IFsgLi4u
IF0NCj4gPiBAQCAtMTI2NywzICsxMzAwLDI5MiBAQCB2b2lkIHZnaWNfdjVfc2F2ZV9zdGF0ZShz
dHJ1Y3Qga3ZtX3ZjcHUNCj4gPiAqdmNwdSkNCj4gWyAuLi4gXQ0KPiA+ICsJLyogU2F2ZSB0aGUg
U1BJIElTVCB0byB0aGUgdXNlcnNwYWNlIGJ1ZmZlci4gKi8NCj4gPiArCXJldCA9IHZnaWNfdjVf
c2F2ZV9zcGlfaXN0KGt2bSwgJmlzdF9hdHRyKTsNCj4gPiArCWlmIChyZXQpDQo+ID4gKwkJZ290
byBvdXRfdW5sb2NrOw0KPiA+ICsNCj4gPiArCXJldCA9IHZnaWNfdjVfaXJzX2lzX3F1aWVzY2Vk
KHZtX2lkKTsNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gQ2FuIHRoZSBoYXJkd2FyZSBjb3Jy
dXB0IHRoZSBJU1Qgc3RhdGUgZHVyaW5nIHRoZSByZWFkIGxvb3A/DQo+IA0KPiBUaGUgdmdpY192
NV9zYXZlX3NwaV9pc3QoKSBmdW5jdGlvbiByZWFkcyBmcm9tIERNQSBtZW1vcnkuIEl0IGlzDQo+
IGltbWVkaWF0ZWx5DQo+IGZvbGxvd2VkIGJ5IGEgY2FsbCB0byB2Z2ljX3Y1X2lyc19pc19xdWll
c2NlZCgpLCB3aGljaCB1c2VzDQo+IHdyaXRlcV9yZWxheGVkKCkNCj4gdG8gaXNzdWUgYW4gTU1J
TyB3cml0ZS4NCj4gDQo+IFNpbmNlIHJhd19zcGluX2xvY2tfaXJxc2F2ZSgpIG9ubHkgcHJvdmlk
ZXMgYW4gQUNRVUlSRSBiYXJyaWVyLCBpcw0KPiB0aGVyZQ0KPiBhbnl0aGluZyBwcmV2ZW50aW5n
IHRoZSBDUFUgZnJvbSByZW9yZGVyaW5nIHRoZSByZWxheGVkIE1NSU8gd3JpdGUNCj4gYmVmb3Jl
DQo+IHRoZSBETUEgcmVhZHMgY29tcGxldGU/IElmIHJlb3JkZXJlZCwgdGhlIGhhcmR3YXJlIGNv
dWxkIGJyZWFrDQo+IHF1aWVzY2VuY2UgYW5kDQo+IG1vZGlmeSB0aGUgSVNUcyBjb25jdXJyZW50
bHksIHdoaWxlIHRoZSBzb2Z0d2FyZSBtaXN0YWtlbmx5IGNvbmNsdWRlcw0KPiB0aGUgVk0NCj4g
cmVtYWluZWQgcXVpZXNjZWQuDQo+IA0KPiBXb3VsZCBhZGRpbmcgYSBkbWFfcm1iKCkgb3Igcm1i
KCkgZW5zdXJlIHRoZSBETUEgcmVhZHMgY29tcGxldGUNCj4gYmVmb3JlDQo+IGNoZWNraW5nIHRo
ZSBoYXJkd2FyZSBzdGF0dXM/DQoNCkkgdGhpbmsgeW91IGFyZSBjb3JyZWN0IGhlcmUsIGFsdGhv
dWdoIEkgdGhpbmsgeW91IG5lZWQgYW4gbWIoKSBub3QgYQ0Kcm1iKCkuIFdlIHdhbnQgcmVhZC10
by13cml0ZSBvcmRlcmluZywgbm90IHJlYWQtdG8tcmVhZC4gSSd2ZSBhZGRlZCBpbg0KdGhlIG1i
KCkgYmVmb3JlIGRvaW5nIHRoZSBxdWllc2NlbmNlIGNoZWNrLg0KDQo+IA0KPiBbIC4uLiBdDQo+
ID4gK2ludCB2Z2ljX3Y1X2lyc19yZXN0b3JlX2lzdHMoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3QN
Cj4gPiBrdm1fZGV2aWNlX2F0dHIgKmF0dHIpDQo+ID4gK3sNCj4gWyAuLi4gXQ0KPiA+ICsJcmV0
ID0gdmdpY192NV9scGlfaXN0X2V4aXN0cyhrdm0pOw0KPiA+ICsJaWYgKHJldCkgew0KPiA+ICsJ
CWlmIChyZXQgPiAwKQ0KPiA+ICsJCQlyZXQgPSAtRUJVU1k7DQo+ID4gKwkJZ290byBvdXRfdW5s
b2NrOw0KPiA+ICsJfQ0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBEb2VzIHRoaXMgaGF2ZSB0
aGUgc2FtZSBtaWdyYXRpb24gZmFpbHVyZSBhcw0KPiB2Z2ljX3Y1X21taW9fdWFjY2Vzc193cml0
ZV9pcnMoKT8NCj4gDQo+IFNpbmNlIHZtaSBoYXNuJ3QgYmVlbiBhbGxvY2F0ZWQgYnkgdGhlIGZp
cnN0IEtWTV9SVU4geWV0LA0KPiB2Z2ljX3Y1X2xwaV9pc3RfZXhpc3RzKCkgd2lsbCByZXR1cm4g
LUVOWElPLCBjYXVzaW5nIHRoZSByZXN0b3JhdGlvbg0KPiB0bw0KPiBmYWlsIHVuY29uZGl0aW9u
YWxseS4NCj4gDQoNClRoaXMgaXMgbm90IGEgcmVhbCBpc3N1ZS4gU2VlIGFib3ZlLg0KDQpUaGFu
a3MsDQpTYXNjaGENCg==
