Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012040.outbound.protection.outlook.com [52.101.66.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319AC44AB94
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.40
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522857; cv=fail; b=kW3W5N2GlCy0p6/WGoatOwixHTzUSjY8LagjeCiLLH5wM8tdXFFKk+qUJyvyklzyn46F50zCxSoY+UJ6SdqfwrpN2yS8UOrMWOpzo1ez3g9khV5HF4JnTJQBtLPep57x02nYi6zqelfLOAYHeB9IoIDiMDgwtz04RGp+kW6i/Ic=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522857; c=relaxed/simple;
	bh=tLs7D1HK03ua1TBIKO9zXZKrvWBrioj/A+RtHXna10Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uAp3w9mxSw9Sf89++TW0TgQfbnHpplAxu+b5W0JVymK7iDIX5+b9cwcT5eWZ6yekLUJCqnpYyO6KouCk6DjgSgAgHL68QuF7PW4zceRNUB8GiSJtCjdD6OrYttTGQl5fh/1gWfnM28TuiWdge0mjDjYK5tsHdD0D8x8R4LWI8M8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WL+MWAQX; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WL+MWAQX; arc=fail smtp.client-ip=52.101.66.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WL+MWAQX";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WL+MWAQX"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=O3aa9ULVLYReqClsE8DxGl/4cMJm5NGumnmKkX/PdwdVbHtPuNs6M39yRjFRaR3DE9OXddocyZZeiJyk/Fa156vF9U5OHxtzA9bWGJxMo5OXaREAbvPox17OGSIO5Dm1p75lXFlb/U52IZKH0Iu76LsW79tAFrlKwoy1+fJ5wGJo+TWgmkSOKoSMsbRR58DJDnmzyl2t1WBHy1jlJVdwpqzwFYGZh0+DkHCEUFBZB5q7u+FBrEZj0S/8Bv2Dvvf1kaHHWw2FN9xzxbURATkTLHN/6y934z9Qp9gFJpD6XuT4C0OYbI6FqIW/DSeCFhJaeUQnEdCOQ/InfIiW8L/g3w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3goHUnWgdGcm3Z7b2OE4GgH4Em0q4bquzhMK1Hfs0o=;
 b=rsFwhrLmCdxa+l1S9RKQCqbUdL/EvBAjBm2Bge1Wo6s5kcZ0lhALCHvgUJhjFcCFIIWo7rzArMh9TOHx4ljZu5SWInkeAd7MpxtqIRxmeUgISCkBJIhYCvl/OXDq4hoWsO7oF2Z/IE5qPU3UwROgs/JCbyOO+/U+gorr3EppD5ESOJmgWC04I7Y+5kgWIt3CeTvPb1I1F1uR0HM/9K9gDRcwKubz5+YSqxUdbuL0K4H3bL9/KTjLReQXhxXvjU/7C3fNlN4LR2lGHU2S0rqsSIBzpVs+khEqmVdW64aGs2VongG/9fsLpZjhbNexHAvqHIJLVjk6oz6lnfwTqcE3QQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3goHUnWgdGcm3Z7b2OE4GgH4Em0q4bquzhMK1Hfs0o=;
 b=WL+MWAQXKvgoKoYIaZOYE+WacbEn7fzIZ5OpdX4zu/+0u6SVGNsr5kf/rWAtAhetbsJQMPdag4xlqk/8GrwOSN7DkL1evuE4oLBjpNu+f/JwjpA+3PP/i2/HhYxxUgqz6pBCWx5thadD01mqbTmAWGB0VVV6BhQymHx2rdzXFMo=
Received: from AS9PR05CA0145.eurprd05.prod.outlook.com (2603:10a6:20b:497::24)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:54:08 +0000
Received: from AM4PEPF00027A63.eurprd04.prod.outlook.com
 (2603:10a6:20b:497:cafe::99) by AS9PR05CA0145.outlook.office365.com
 (2603:10a6:20b:497::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:54:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A63.mail.protection.outlook.com (10.167.16.73) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:54:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lAqzJaF6s96toTQSv0BBclyJhfxNPm29fXvAFxd0phB5UPKzXQWkNBG7YK/49o7cgvHL/q93WLtE9LOXmy3DKCePwjiHlyPec2Myz4s3J7RRPEXG9WI/pTr1sk9GPXUNKWead1D3dBFOtUR7ixYsGOQjkuvPLoh1wjCAEFGEzozDjyBSj0FEs48reHBUxlc6CvuDAkvCodkFlm09rwtgJ3ueADNxyAku5jStO8tRmm4FMDS2lQt4HXgG7lHkr4xbvlsbZJ/iyjwH4HzwzQ2eH7ue0IdBV0eNYsa2oy83mDJl04KdxEIRn9hmLJN8I0hdIdU76/HewpZF6kj9xm6fAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3goHUnWgdGcm3Z7b2OE4GgH4Em0q4bquzhMK1Hfs0o=;
 b=S8YQju+yceqGkNP8CpSI+YO64UtS8xRK5S103Wylkq8ru6LImtiSDmAD4qny8krHUVu6CKF0S24P3KqfuA0130nAO1S/NYtI/9Xjm2dtofnz+3W9kgZo7K6g3oB8knWrSYHxF0NHQbuxkt5/n5DW6T3/FN4lC4b1/byDu9+EdIJCcEzSxb8GjQiqXluD4JdoJp1ctfWU+w8lnXuUrZbMY+lB7AJRql1nRIvOPlZbzGM6u1cUH/MsAR1vf4drs/xNfDogciHWOz8mO1uHY46W0QwfUqHIS/44SrQF8hff/wOSt52dZMrZ7VYCiFbCZrLr73Jl4fqrp5hNuBzby2xbig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3goHUnWgdGcm3Z7b2OE4GgH4Em0q4bquzhMK1Hfs0o=;
 b=WL+MWAQXKvgoKoYIaZOYE+WacbEn7fzIZ5OpdX4zu/+0u6SVGNsr5kf/rWAtAhetbsJQMPdag4xlqk/8GrwOSN7DkL1evuE4oLBjpNu+f/JwjpA+3PP/i2/HhYxxUgqz6pBCWx5thadD01mqbTmAWGB0VVV6BhQymHx2rdzXFMo=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS2PR08MB10207.eurprd08.prod.outlook.com (2603:10a6:20b:647::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:53:35 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:53:35 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v6 38/49] Documentation: KVM: Add docs for
 KVM_DEV_ARM_VGIC_GRP_IST
Thread-Topic: [PATCH v6 38/49] Documentation: KVM: Add docs for
 KVM_DEV_ARM_VGIC_GRP_IST
Thread-Index: AQHdPGQDej//83OaJEaCJ3VkRQ1FVw==
Date: Fri, 4 Sep 2026 11:53:34 +0000
Message-ID: <20260904113404.4051341-39-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AS2PR08MB10207:EE_|AM4PEPF00027A63:EE_|PA4PR08MB7386:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a5d84c1-c7cd-4a0b-7b42-08df0a7b39ff
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|6133799003|22082099003|11063799006|56012099006|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 A6weK7s4H0zaloFDzc0Trr+U/DuhNKHOYV1z0HIAvDX+skdsn9P4BAxHRMYIp15FtVz4pZ5q7diuxYFa+aPvSu+yeFoffg0oTZBUIbUf/Ig8q0BYLk0dmKAdgVfD43eFTRvVc5bBE6BJN7SLw5bfRKqMGees30BlgWpZud9FJSiRMGK1MOjkuCeKkO9ozSpCYkILywzaQnT87qNph0OTWJXX7J9Bk1cNzjhK72y0wGw3zFXrHfRJDiD3sqDXsbDgaQmM0MJgFWi6L7lkqySvaSXaG+uzdG/jM19bNH1fc/lRY1w/pXh4dGOJ8mxAzHT3N64x7nSGPW0tGIdagGWZp4107EeDa1InrQi1L8skwU/V3Vu9kbQ1ojCmNS/uX70LgbyJzCuQ2OiQK75JwTcscGrUATHMbZeYd+bgG1r/0xDY9ysLaLiW9Ri0kHrDiRa0hVyLOTrohVrf1pnx7IQDCmG5kvGHolwfkhr/yC4Yr6uWh/l+iafxP5xGtMHBaaRLixGft406qZB3Uj3dRtzVy3RjnUQl9P/iX0KjI6KqBIf5w7WkITV+wM9PoddpHylfJDrEDCqhZ3aSGmbWDGPPb8s1Ug9a4Q3BUyNFp5uUHh46+JZgP/NIB0oLiiyoFukClUcK6qq2qxPLs6kA7HkbdRwHtp4sqNY5eFvxi7ZH/ozNsBSEB2VtUd06OricFW8VEKKLcbtl8fyvQf+Z39vkZfzKEMxhiDd4KGciEKyzMGA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(6133799003)(22082099003)(11063799006)(56012099006)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 pYUCSOBbUHtdR1Ld/zBOUaTxa5eV2l/A+CihYH7eVNPRGjom+6mK69zDL2ANhbc12v5N2j0vH+wdUyAsBf8K2bK6hthjhtH91KGJjSe35NjiF9V2rtsuN+bJP4tb0Rh8gRYHB4jFlEUYYu7VxHbu6J1A9BzkE4tEO90yGMZHnnwHa00NgmlF4DJ2D+rj/9+QUpWfTx0hqXFmBLEUy0nf3NhBlDaOerQrrnJAIFsQCkVGq1sWh5j8vW7dnWkjeoqjKfHNIN7wsDNWc8Ipaabh4/yVH5z7RSsV5RFjzPrFV8eIPBdOfJ4kFKm7YtTmKJOj94wzf+nlSojmaiFBIEpkhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10207
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A63.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8c909146-0265-4ee9-9c2c-08df0a7b2657
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|23010399003|82310400026|35042699022|36860700016|376014|56012099006|6133799003|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	HpvAmcDqkhbrlVAGD6xnCd+DWpAz8JfOMAdAdqhUKBB0dPlvCIgbFYu4mkJsvNQcReTYvl7fWMLk4HupF45AEOlTLWRqcoJO+sYcngEuobAHB2v48WzXE/CqQtwVttZyl/4LAPYop5wvUYpD0KxJxvxguNPhsieryZ+/ckrpc0+nDKrMkfOP4QfEHn42lhZMmQo10xEC75xqILjKoaVq2RVsaHuBP7w+vaGT6RVU7ZaXUojgCohASzz+qNq8+2kx/Wppq9OS7LKde0zvrXzQRU5E+vLNgt/Lqkx1VadasakZq/QP3oYzfNZYTi7RQJBtpxY4itrXDsnqxXz79OaJ0wmDanaSIefgHpJx+61s97fZY/GjCGevr4RkYA0cLA/wq3hKsBnZH89pX3UDJlYSlHrfIsY3yeCidy1dXBoYoafmiWHvRrYmyWvdQTA0b01nBI1auX1qFroZEyBqfp4KxrrwKE5O9T8ddgC7b4D6gGYCIC77MNpAIklLE0DWPRgocwPsKBDCpHJorh1WW2AKKOw96gqM8tOfCh9EAE7CHcm2sqgJFkrErIldPzKnG5PQ+UVagbJ1uYSh72m/CTwT61Ahg0X/29dMAJ/Pa24GFw7tKH3WyAZRvJeMwJMwLyRW4cMaDwKmAm9cS66H/jtsNyGplyxieXVDCK28TdAt+s4=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(23010399003)(82310400026)(35042699022)(36860700016)(376014)(56012099006)(6133799003)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IgWbX8X+CHJnva/eLz+YNrv8uEfmC4uREGYzORYIFa4T0XFagfRNCB4XNGZiwtSMkhXeFZyLL7oU4go3V6kISDhDsAvfpLS5fgNn7t1jhbV/105KvxkeSGWw0YGUG3y8HeZ4UCoe7OSpOf44fbgffDFmHZkHUCTEESrSiXLRk9XE1DZ9UQUCgRRDLCQmVFe2zxfH2lxAdWXW/G4Wxwhvyb5SfCLo2NW8JLjtUaC3kyLAM4/0gG0lB9VcoQYecWp3teZVUIaR+yJwvmAC3WaC04liCZmda2abYEQ9eBvri8dyDQNjkhiqc40PV6rvYAhdPeLp7dWxuv13zNV92cLwsVjzTpXIu+Enol4oH4oIYLq+gJalMFKcvA96fH3Jd5JKhdRFsk9vyhqAH7x7J4eZEkDvwYJrWcC1RNao0ERFoi55ZGAnYMCO/Jp7xWNwRDDf
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:54:07.9280
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a5d84c1-c7cd-4a0b-7b42-08df0a7b39ff
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A63.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7386

Document the IST save/restore userspace interface for the VGICv5
device, KVM_DEV_ARM_VGIC_GRP_IST.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 66 +++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 4f475d14f83dc..61db2f93373cb 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -196,3 +196,69 @@ Groups:
     -EBUSY   VGIC is not initialized, one or more VCPUs are running, or a
              write is attempted after a VCPU has run
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+  KVM_DEV_ARM_VGIC_GRP_IST
+    Attributes:
+      This interface is used to either save the state of the IRS's Interru=
pt
+      State Tables (ISTs), or to restore them. A get operation saves IST s=
tate,
+      and a set operation restores IST state. kvm_device_attr.attr is rese=
rved
+      and must be zero.
+
+      The VGIC must be initialized before using this interface. Restore mu=
st be
+      performed before the VM has run. For restore, userspace must have al=
ready
+      restored the IRS state needed to describe any guest LPI IST.
+
+      Saving first asks the IRS to save and quiesce the VM so that interru=
pt
+      state has been written back to the ISTs. KVM checks that the VM rema=
ins
+      quiesced while copying out the SPI and LPI IST state.
+
+      kvm_device_attr.addr points to a struct kvm_vgic_v5_ist::
+
+        struct kvm_vgic_v5_ist {
+                __u64   spi_ist_addr;
+                __u64   spi_ist_size;
+                __u64   lpi_ist_addr;
+                __u64   lpi_ist_size;
+        };
+
+      The SPI and LPI IST buffers contain one little-endian 32-bit IST ent=
ry per
+      interrupt, in interrupt number order. Only the architected 32-bit IS=
TE
+      state is exposed to userspace; host IST layout and metadata are priv=
ate to
+      KVM.
+
+      The SPI IST buffer is required and its size must be:
+
+        nr_spis * sizeof(__u32)
+
+      where nr_spis is the value returned by KVM_DEV_ARM_VGIC_GRP_NR_IRQS =
for
+      the VGICv5 device. For VGICv5 this value is the number of SPIs, not =
the
+      total number of interrupts.
+
+      The LPI IST buffer is required if the guest's IRS_IST_CFGR and
+      IRS_IST_BASER state describes a valid LPI IST, and its size must be:
+
+        BIT(lpi_id_bits) * sizeof(__u32)
+
+      where lpi_id_bits is the LPI ID width configured in IRS_IST_CFGR. If=
 no
+      LPI IST is configured, lpi_ist_addr and lpi_ist_size must both be ze=
ro.
+
+    Errors:
+
+      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+      -EBUSY       One or more VCPUs are running, the VGIC is not initiali=
zed,
+                   restore was requested after the VM has run, an LPI IST
+                   already exists, or the save operation completed but the=
 VM
+                   did not remain quiesced
+      -EINVAL      attr->addr is NULL, the userspace IST descriptor is mis=
sing
+                   a required buffer, supplies a non-zero LPI buffer when =
no
+                   LPI IST is configured, has a buffer size that does not =
match
+                   the configured VGICv5 IST state, or an internal VM tabl=
e
+                   operation rejected the VM state
+      -EFAULT      Invalid user pointer for attr->addr, spi_ist_addr, or
+                   lpi_ist_addr
+      -ENXIO       Required per-VM VGICv5/IST backing state is missing or
+                   inconsistent
+      -ENOMEM      Restoring IST state failed while allocating the host LP=
I IST
+                   or tracking pending interrupts
+      -ETIMEDOUT   An IRS save/VM operation timed out
+      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--=20
2.34.1
