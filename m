Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011023.outbound.protection.outlook.com [52.101.70.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE6D3F4DD2;
	Fri,  4 Sep 2026 06:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.23
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503840; cv=fail; b=WuSUYeUjc4UHozl9Hh6mi0b+4o7KLcTCvNEeW98TbRXdeDl3tvU5nU2h6q6DHGNwAEGmnjG8NVDgaju9vEntv9BlwLEapKAiLNu/GWyekmPPgTZ7e+RDFSiYlKcc+ew9mOtvL29sa+CSC5Oh0rDCmzHBFUV7lbpDbU1tR2ixnT4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503840; c=relaxed/simple;
	bh=hooFxl6rRGq59JQXiQ9rETvMfI18JIzGCN96OnM78xM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tJtDp4NTOya/4COaIfZNcJivy1J/zh3jGv9znkT87z8w6T7Mp7MYwmJDTMIQqc4oYcsWopygwYK+U+NY+8yE8pKMIL7h5Cs8IMCI/so6+873au93NkWroQ/OyljCrvQ6zYBkVDHzJpLb9hqJFDwph/OU2WOGFI8H+hHAHEQ1XO8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FKaIktBk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FKaIktBk; arc=fail smtp.client-ip=52.101.70.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FKaIktBk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FKaIktBk"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GPdoB3ALMFmrVknCe+ts5WDt+KJchyC/Fik+SD4cQrAB5HjzJksfgRio4a/bfCYXMm5u6wrVSyqrx388Mw/XTtD7zbrMt0j0HZyJveEchLCW7gFmEHPGfGvsYeVC6MF71pg08dO1sfqF+2Yx/Y0m5MrpKRGIGmgJk3i4n9koDC4ISk4ZIcSp/hH9t4NxswqxtKT4+UQ7HuiXY1XzuEgejXTSS8YscNWO9tS10bWAh0wiJKzejiD2jXpyUumLoVU8h0UCfhb1+h07shS6Az4m6HPloirlscf8YFxAuskNAPte7PUmqnoi1HzWyTaQABXJqhsvM8KDqHpq2n/rcNEVnw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hooFxl6rRGq59JQXiQ9rETvMfI18JIzGCN96OnM78xM=;
 b=oC/SW/fnxIbvGc0HMGxX56aBChHP8Awr3pu9/0vg6HfXP77tlCKJPdD8rV4T0m1MCTI87ws1H8Msj95O+fZ6bCDKYSGJ9JP7h94gppziXkNEKrMX/VEFT2j4OXAG7TgtVjtsdag3t/BHagBi9g3FOQjQW4n2iHPWqanJoJJRrnRfTEVrUpcFeGX95p6K0V71XANU/yLCVkcs6zBbUddMgTkeuCYJ/xM1nR4EHgMMknxUZRA6/aNV14zegLpNe80caYwUrPT7oANYUpmWrgsoxObXHjiKcUZUjzksnbhxkF0a+if8FDDcw1Hb01LVM9YPFoYBnDeHQtZOe2/bxK0q5A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hooFxl6rRGq59JQXiQ9rETvMfI18JIzGCN96OnM78xM=;
 b=FKaIktBkAUjdV/tjun2n6Swaj7DStA0rVxP3Ls9tiT8f5Da1FqS/eHDuPCG9P0haoXUJC7ulInvVD3tcBLIORINxbeBDvL8WNJD6eMRogZrkap/glVogyLijLiX3co3xwd2FTKvBEPPlo119g9lk5sPeANVcxLwB1095g1qQo50=
Received: from PA7P264CA0279.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:373::20)
 by GV2PR08MB11313.eurprd08.prod.outlook.com (2603:10a6:150:2ca::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 06:37:12 +0000
Received: from MI3PEPF0000848C.eurprd02.prod.outlook.com
 (2603:10a6:102:373:cafe::5b) by PA7P264CA0279.outlook.office365.com
 (2603:10a6:102:373::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 06:37:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF0000848C.mail.protection.outlook.com (10.167.240.139) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 06:37:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yOB2/TZnYJSn1C2ut6ay6yVrzQA9HhBaBshFsga4PXxgJMaeL8AowLTN/F+/fRLHGazngSU6lNG2r0KXfWl1ofy2W4vT7mZ7IKYv0Q84r/e1+1sOgP1ovat5JNE1UpzIzZjg61yKyYJQLuNwQGQAWPqOAFP/gLvVoXatL4mShKnmrKVjGVm1Wh0Nhpfr5GVpZUbIULS3th05qdSKwWe0pWBzvSstW8VWixr3Vskm1EnPRYVBRHt/M8mXpvUbmFX2MInxptIgid3vf1qCEVsaAov5vFBaokIVhxx+56mKCXWrfAS/AGhmWm8ynRQPkD4NhTWy0rAuJwbo0Jhz7rVu7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hooFxl6rRGq59JQXiQ9rETvMfI18JIzGCN96OnM78xM=;
 b=bauDZPuXEHTbqoDgR7poFO2IVH/9tVBtPuNwl54keRQD5kv3NuuBpiNRGIfRdNep7SPFvDv/5pxmCexdxmgwvXLriD4LC6Ey6C0yy/6CXDypBvcD1mYJswOH3TSs4LQ8GXy8WwvCRHGdzWBG3MjC5JSidNDKuhqtIv3Rego/02CoMLtqe/1rAlNaTZuf5DsAaMWkenq3Cjk4vz/0shEDBx+Mw4B8PNY3DNYaEQtB3dg+LTOo07t/PzF3I8gR3hH1sIg+lMCXSJ6XXDjtFVPJm9kNvQneibD7drrUZAavffP1rWqQNxwk216gG3vsf7vp+oCqoOULn5ZIB9NG9qnjsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hooFxl6rRGq59JQXiQ9rETvMfI18JIzGCN96OnM78xM=;
 b=FKaIktBkAUjdV/tjun2n6Swaj7DStA0rVxP3Ls9tiT8f5Da1FqS/eHDuPCG9P0haoXUJC7ulInvVD3tcBLIORINxbeBDvL8WNJD6eMRogZrkap/glVogyLijLiX3co3xwd2FTKvBEPPlo119g9lk5sPeANVcxLwB1095g1qQo50=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by DU0PR08MB9273.eurprd08.prod.outlook.com (2603:10a6:10:419::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 06:36:35 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 06:36:34 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 07/49] KVM: arm64: gic-v5: Cache host IRS ID registers
Thread-Topic: [PATCH v5 07/49] KVM: arm64: gic-v5: Cache host IRS ID registers
Thread-Index: AQHdJl4mE3ixBMiMxk6G5aqxys8umraSg3GAgCufRQA=
Date: Fri, 4 Sep 2026 06:36:34 +0000
Message-ID: <789e1ff8ce9ba5bca19742682e90b5b83719e64a.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-8-sascha.bischoff@arm.com>
	 <20260807122719.B87211F00AC4@smtp.kernel.org>
In-Reply-To: <20260807122719.B87211F00AC4@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|DU0PR08MB9273:EE_|MI3PEPF0000848C:EE_|GV2PR08MB11313:EE_
X-MS-Office365-Filtering-Correlation-Id: db458779-d62e-48d1-3961-08df0a4ef354
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|4143699003|11063799006|10067099003|6133799003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 0ZEzMY3IpeETEQBTLg5E/sxXRGktzz9Jc04gsWltw/r3q+l4tWMazG+Itnmm58L0C9KmGO3A1axJd1DbJaGo/tT+n5DJF7p1yjA++MzLy9MAEIM8cO4BuI0/s8EchPpiGd11UNre/fHwQFNwqNk7E/+ZovBJV+ulA21WqYfXq9dav2pTT/T2Xi4W4LMDeDZZSLbluNgCBDbu/JvphjoxgjlZJMNZToXzu/3vDfIW2lJNbCnJ3DZTDHx4ZT2H2JZEMJD92ut+bTBy43wQnkcc3TrdpZj48LxmYFTw8cQEW9LUnDFZdU1wlqPtIzbuDsJZO0BqdBD0xI3u5ShIkaF5V6V9lpTIHmbPN6gZr+CiRNhNmPvkGFd8iLnlX1y4Kn1I+cHdyhMjdRwvdkzJCXGulsWylxwmxZ85j41VNE7lUW5uE0Mxt2V1YNY2iNhawBDk2ULHkIIgAlKHrkZL2kWTLiBUy6RrtgJKXPjG/mSZ1Xu2BEfG8Un28mlUkgxSx65sasfH+Jta3bXE/Yi+2Xod+gZU7GCoHjCNLpe+o5gy9ipnv/r2d/Ess+cWQ8gh23+rh2kkg0bQOxnpZYCQtJqLIT/lW/1FqIkgbEZrCFyZodM8qflaLKWoCQhpdzwS6X4/VzHyAE8XccUn5MMF+XY+lWSiHmuRYNkpPMIla5kKqTsSBzNxdN50iBdSVVJqQlcZCMVRh3PW/8rAxdXGYTMrtwrxfoG2fVXoedXz47Gy7aE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(4143699003)(11063799006)(10067099003)(6133799003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D0EFE3F355C744E8ACDA4C501328C33@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 JE24Dg0qQDIEu+3WXPdXFv3d2M0pyEAlUf9+f8mmssL9IzPSNpe/m22TUQ0TW6tgxeYH/DAH8Am+hTM8sexLWcW7unn4WyjROl7131INQnV9Yq5fFWCPnymW1enJKGSZBVrxrJ/BbmOyPNI33AuBAmLZZBTRBznrdcJq4EMOfWAkZxdpMqEMbRYrNDimMx0OSNwcafp2ZP/aWPlWzKUguB6B3ew3fLVKl1v36ssf6Gm42iwfPLJHBOMUifpbw4eoXkMSEfUlCAz+nm4k6fcYt5SH11Gmm8yJunFT6i4Nb1JWiGPs3nRI2LMWNgVm8F9actrpC03F5XLpwX6yQMZamw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9273
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF0000848C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5fcd995f-9173-4241-fa41-08df0a4edd05
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|23010399003|14060799003|36860700016|82310400026|1800799024|10067099003|6133799003|4143699003|11063799006|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	1qv6YXcnsyh+FZWgmy8+XBnf7XaPE3aVjw+WhoWTL3UrpYw3HPHAll5drR+NbEUm20ZoBj+wuDar1ZAomKh4rYtFaNdsNFaPvUHXACzwliV/prjvF15+PaCXhQdmiahBrtUcjGTpwNLLt9mjJM1KgASqGlOn2nSCTEH2jzrH1oztOfLgLyb3COQyURAlQ+Jy4J5EusD2EcM1xM/7DrmgYse/GiDpMJ9FbK1wOUOC/SJBIq0o9AWQ//8WDRLwJ+87rpNIRrYuNcjf7dnxQ5tWHaPo5SJa8RWKYLC2Icavm4v8Im3Rc3G/CrGihiFIgVezrcXH72yqInL3c9hpgBfHfA+aocy6SIFFQxldEAvMRwYNBg9T6WFsuodXtdFYXYey48YptyVJubzFrVbQPChPPKbHE0OH3m19XL1WsYBZhreeYXBE0VM7SN0POrgo6YX2JtjjRC0dNkcTnoQ6Cr4jI13Hb1fcklETPfP8/64MTp4N8IbLZ4EU1RWLwrSHf9iEvaxQaYq5FE5k2adwIs4A6WzZx+Y5TCV5uYWcdboIX8EPK2UoP9Ny+vhDNPX+C0hKFT55R16dNbyP8OLHxb70FRMEpu8x71LV/ncXm/2SL2PQdF9jpoMg5iMhhlRcGbjEkbSH6rCphw9qHSgmBvDALgcsiz4aiT05f4ag7Iif8Ko=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(23010399003)(14060799003)(36860700016)(82310400026)(1800799024)(10067099003)(6133799003)(4143699003)(11063799006)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IfSylaMfvBXH7LIAoopFZX2RYqpsji8yhhzetBhhkYJtd/Y/08JaHS97/5iEMK+QR+VlDF/dQT5xy5V5m95ZhZ/iWXpfMOG6FxPFcMSYfgsZoaVfswepdhrmqkoNdBz/8wspXW7VgpZVg8OjH00Moa7bmJ249QT5N94e7sPTnI6QnKAwkecvdCFhWcbITdqZYDvKlMyHzeFzWYpoEVe3JnLA0n/bAvkcoFSsnoVzO4jvFUcpuuu72cza5pY6B+yF3+Ko3sYPAWySO64XEPFqDbkolu3MpljgB/5UirTC7joATDiX7jX1Bx9+h6tgQsOxunmGmJwnObfIZb2X0KAz5CsNSnV3nUUvNH8oR/7LgOBBvXgXLPU0/M1mW6vqt8u9tk3puWYA+EPY+YnNsdSUFcRT/qeMm9sdSrMxS+TzoGy/WxOETZOsX5ljJt7yU6MZ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 06:37:11.4044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db458779-d62e-48d1-3961-08df0a4ef354
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF0000848C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11313

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDEyOjI3ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gVGhlIGhhcmR3YXJlLWJhc2VkIGxpbWl0IGZvciBtYXhpbXVtIHZDUFVzIGlzIHNpbGVudGx5
DQo+IGNsb2JiZXJlZCBieSBhIGhhcmRjb2RlZCBtYXhpbXVtIGluIHRoZSBHSUN2MyBsZWdhY3kg
ZmFsbGJhY2sgcGF0aC4NCj4gLSBbTWVkaXVtXSBUaGUgcmV0dXJuIHR5cGUgb2YgYHZnaWNfdjVf
aXJzX3ZwZWRfc2l6ZSgpYCBpcyBgdTE2YCwNCj4gd2hpY2ggd2lsbCBzaWxlbnRseSB0cnVuY2F0
ZSBkZXNjcmlwdG9yIHNpemVzIG9mIDY0S0Igb3IgbGFyZ2VyIHRvIDAuDQo+IC0tDQo+IA0KPiAt
LS0gUGF0Y2ggWzddOiBbUEFUQ0ggdjUgMDcvNDldIEtWTTogYXJtNjQ6IGdpYy12NTogQ2FjaGUg
aG9zdCBJUlMgSUQNCj4gcmVnaXN0ZXJzIC0tLQ0KPiBjb21taXQgZDgxODAyZGQ1OWZhZjk2YzU3
MGJiNTA5ZTAwYWMzMzVkYWRhNzkwNA0KPiBBdXRob3I6IFNhc2NoYSBCaXNjaG9mZiA8U2FzY2hh
LkJpc2Nob2ZmQGFybS5jb20+DQo+IA0KPiBLVk06IGFybTY0OiBnaWMtdjU6IENhY2hlIGhvc3Qg
SVJTIElEIHJlZ2lzdGVycw0KPiDCoMKgwqAgDQo+IFRoaXMgY29tbWl0IGNhY2hlcyB0aGUgR0lD
djUgSVJTIElEIHJlZ2lzdGVycyB0byBjb25maWd1cmUgdmlydHVhbC0NCj4gbWFjaGluZQ0KPiBy
ZXNvdXJjZXMgYmFzZWQgb24gaGFyZHdhcmUgY2FwYWJpbGl0aWVzIHJhdGhlciB0aGFuIGV4dHJh
Y3RpbmcNCj4gaW5kaXZpZHVhbA0KPiBmaWVsZHMuIEl0IGxpbWl0cyB0aGUgbWF4aW11bSBudW1i
ZXIgb2YgdkNQVXMgdXNpbmcgdGhlIFZQRSBjYXBhY2l0eQ0KPiBmcm9tDQo+IHRoZSBjYWNoZWQg
SVJTX0lEUjQgcmVnaXN0ZXIgd2hpbGUgcmV0YWluaW5nIEtWTSdzIHVwcGVyIGJvdW5kLg0KPiAN
Cj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBiL2Fy
Y2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gaW5kZXggZDQ3ODlmZjNlNzQwMi4uNDFj
YTIwOThlY2I3MyAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUu
Yw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+IA0KPiBbIC4uLiBd
DQo+IA0KPiA+IEBAIC02MSwxMCArNzcsMTIgQEAgaW50IHZnaWNfdjVfcHJvYmUoY29uc3Qgc3Ry
dWN0IGdpY19rdm1faW5mbw0KPiA+ICppbmZvKQ0KPiA+IMKgCQlnb3RvIHNraXBfdjU7DQo+ID4g
wqAJfQ0KPiA+IMKgDQo+ID4gLQlrdm1fdmdpY19nbG9iYWxfc3RhdGUubWF4X2dpY192Y3B1cyA9
IFZHSUNfVjVfTUFYX0NQVVM7DQo+ID4gLQ0KPiA+ICsJdmdpY192NV9pcnNfY2FjaGVfaWRfcmVn
cyhpbmZvKTsNCj4gPiDCoAl2Z2ljX3Y1X2dldF9pbXBsZW1lbnRlZF9wcGlzKCk7DQo+ID4gwqAN
Cj4gPiArCWt2bV92Z2ljX2dsb2JhbF9zdGF0ZS5tYXhfZ2ljX3ZjcHVzID0NCj4gPiBtaW4odmdp
Y192NV9pcnNfbWF4X3ZwZXMoJmlyc19jYXBzKSwNCj4gPiArCQkJCQkJwqANCj4gPiBWR0lDX1Y1
X01BWF9DUFVTKTsNCj4gPiArDQo+IA0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IERvZXMgdGhlIEdJ
Q3YzIGxlZ2FjeSBmYWxsYmFjayBwYXRoIHVuZGVyIHRoZSBza2lwX3Y1IGxhYmVsIGluDQo+IHZn
aWNfdjVfcHJvYmUoKQ0KPiBvdmVyd3JpdGUgdGhpcyBkeW5hbWljYWxseSBjb21wdXRlZCBoYXJk
d2FyZSBsaW1pdD8NCg0KRmlyc3Qgb2YgYWxsLCB0aGlzIGlzbid0IGEgZmFsbGJhY2sgcGF0aC4g
U2Vjb25kbHksIHdlIHRyZWF0IHRoZSBsaW1pdHMNCmZvciBHSUN2MyBhbmQgR0lDdjUgZGlmZmVy
ZW50bHkuIFRoZSBHSUN2NSBsaW1pdCBjb21lcyBmcm9tIGEgcGh5c2ljYWwNCmxpbWl0IGluIHRo
ZSBoYXJkd2FyZSwgYnV0IHRoZSBHSUN2MyBsaW1pdCBkb2VzIG5vdC4NCg0KIktWTTogYXJtNjQ6
IGdpYy12NTogS2VlcCBHSUN2NSB2Q1BVIGxpbWl0IG1vZGVsLXNwZWNpZmljIiBleHBsaWNpdGx5
DQptYWtlcyBzdXJlIHRoYXQgdGhlIHR3byBsaW1pdHMgYXJlIHRyZWF0ZWQgZGlmZmVyZW50bHkg
Zm9yIHRoZQ0KZGlmZmVyZW50IEdJQyBtb2RlbHMuDQoNCj4gDQo+IElmIHRoZSBtYXhfZ2ljX3Zj
cHVzIGxpbWl0IGlzIGxhdGVyIGV4cGFuZGVkIGJ5IGEgc3RhdGljIHZhbHVlIChsaWtlDQo+IFZH
SUNfVjNfTUFYX0NQVVMgdmlhIGEgbWF4KCkgYXNzaWdubWVudCksIGNvdWxkIGl0IHBlcm1pdCB1
c2Vyc3BhY2UNCj4gdG8gY3JlYXRlDQo+IG1vcmUgdkNQVXMgZm9yIGEgR0lDdjUgVk0gdGhhbiB0
aGUgaGFyZHdhcmUgSVJTIGFjdHVhbGx5IHN1cHBvcnRzDQo+IChmb3IgZXhhbXBsZSwNCj4gYWxs
b3dpbmcgNTEyIHZDUFVzIGV2ZW4gaWYgdGhlIGhhcmR3YXJlIHJlc3RyaWN0cyBpdCB0byAxNiBW
UEVzKT8NCj4gDQo+ID4gwqAJcmV0ID0ga3ZtX3JlZ2lzdGVyX3ZnaWNfZGV2aWNlKEtWTV9ERVZf
VFlQRV9BUk1fVkdJQ19WNSk7DQo+ID4gwqAJaWYgKHJldCkgew0KPiA+IMKgCQlrdm1fZXJyKCJD
YW5ub3QgcmVnaXN0ZXIgR0lDdjUgS1ZNIGRldmljZS5cbiIpOw0KPiANCj4gPiBkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9rdm0vYXJtX3ZnaWMuaCBiL2luY2x1ZGUva3ZtL2FybV92Z2ljLmgNCj4gPiBp
bmRleCBmZTQ5ZmI1NmRjM2M5Li5jNmYwYWI2OWY3YTJlIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1
ZGUva3ZtL2FybV92Z2ljLmgNCj4gPiArKysgYi9pbmNsdWRlL2t2bS9hcm1fdmdpYy5oDQo+IA0K
PiBbIC4uLiBdDQo+IA0KPiA+IEBAIC02MzAsNiArNjQ2LDY1IEBAIGludCB2Z2ljX3Y0X2xvYWQo
c3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCj4gPiDCoHZvaWQgdmdpY192NF9jb21taXQoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1KTsNCj4gPiDCoGludCB2Z2ljX3Y0X3B1dChzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUpOw0KPiA+IMKgDQo+IA0KPiBbIC4uLiBdDQo+IA0KPiA+ICtzdGF0aWMgaW5saW5lIHUx
NiB2Z2ljX3Y1X2lyc192cGVkX3NpemUoY29uc3Qgc3RydWN0DQo+ID4gdmdpY192NV9pcnNfY2Fw
cyAqY2FwcykNCj4gPiArew0KPiA+ICsJcmV0dXJuIEJJVChGSUVMRF9HRVQoR0lDVjVfSVJTX0lE
UjRfVlBFRF9TWiwgY2Fwcy0+aWRyNCkpOw0KPiA+ICt9DQo+ID4gKw0KPiANCj4gW1NldmVyaXR5
OiBNZWRpdW1dDQo+IElmIGEgaGFyZHdhcmUgaW1wbGVtZW50YXRpb24gcmVwb3J0cyBhIHNpemUg
cGFyYW1ldGVyIG9mIDE2IG9yDQo+IGdyZWF0ZXINCj4gKGluZGljYXRpbmcgNjRLQiBvciBtb3Jl
KSwgd2lsbCB0aGUgQklUKCkgb3BlcmF0aW9uIGluDQo+IHZnaWNfdjVfaXJzX3ZwZWRfc2l6ZSgp
DQo+IHJlc3VsdCBpbiA2NTUzNiBhbmQgc2lsZW50bHkgdHJ1bmNhdGUgdG8gMCB3aGVuIGNhc3Qg
dG8gdGhlIHUxNg0KPiByZXR1cm4gdHlwZT8NCg0KVGhlIG1pbmltdW0gdmFsaWQgdmFsdWUgZm9y
IHRoaXMgZmllbGQgaXMgMyBhbmQgdGhlIG1heGltdW0gdmFsaWQgdmFsdWUNCmlzIDEyLiBUaGlz
IGlzIG5vdCBhbiBpc3N1ZS4NCg0KPiANCj4gQ291bGQgdGhpcyB6ZXJvLWJ5dGUgc2l6ZSBjYWxj
dWxhdGlvbiBsZWFkIHRvIDAtYnl0ZSBhbGxvY2F0aW9ucyBvcg0KPiBpbmZpbml0ZQ0KPiBsb29w
cyBpbiBkZXBlbmRlbnQgcmVzb3VyY2Ugc2l6aW5nPw0KPiANCk5vLg0KDQpUaGFua3MsDQpTYXNj
aGENCg==
