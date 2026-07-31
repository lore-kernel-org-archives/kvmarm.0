Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010010.outbound.protection.outlook.com [52.101.69.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7983A3909AE;
	Fri, 31 Jul 2026 09:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.10
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785490266; cv=fail; b=ejhA1q7xK1u/BkuiC+XboH+ddcBhPXBugGaKuV3Qo+0gDCYpZpzqJkY8zlvz+lATGO3+/q+lj4Z4U+BgFlx/o34DPY4rARy5RnbJ8o8ibF3R+ou/a9pZBottG74a2p4dKhDvocPhCORQisLKOv9/jXgsH4sYOWJxSmEjL4QsD1w=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785490266; c=relaxed/simple;
	bh=pPAjH04bY3qLQuMPRoY34L/eu8AEVIL9yNxe0kC6xgg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OkCoIYFmukzmqOHa3W4x7dqGB+oxwEXMgmnE+x9wN/YhfwpLd890NIyvz5A7oCOVZuyxnY+L+dGzNJeS9pnNB2Wehpp/Ry4zmkLVX+5oqix++qgb8GhsqDl4tMU11Cxvmm92eYNj4TMINvKLmA6pVzaohGTNnoTkCOEqzD7hmqo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WUgROTSx; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WUgROTSx; arc=fail smtp.client-ip=52.101.69.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WUgROTSx";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WUgROTSx"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=MH3KAUWQBlce0I7q+TnnPIEtrIPc6SEsNqX53tpqtd//tvh0QnlpNuoeSGPU2Sv7WQ/gtBhJEhw/IXVw2jB7Bm45J4jbTgkwDAb6lsAW4MdhNafI7q7UDsYf1pvSpJbJ5vnv8zbvZVvoO1eUt7j8doU3qI7uv9yCD9jGMd3ctc9OLZmogxixJzCuviZXTS2t6XMbk8TOTZN815qR65Ibwv4WC7j5FKs6jcqX2bwTuPa0AW2bMPzKzx6LfDmO8n1UJDyHmGJ/R9BdL8Wz56zJ/w4YFvCx1KIWZGznib4RssT2OcICyoIvvyx1LbFsJWdKCkuaW9haVBvEg+OG0qLShA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pPAjH04bY3qLQuMPRoY34L/eu8AEVIL9yNxe0kC6xgg=;
 b=lniiRPpR0CGm9GTXATRWGA7mbrmzjCHYL6lYMDKFdsqVuyfaewpAy+XYbF6T+8Yvkw5sEWbZbSXxGTC+knEimq/Jy0CL3FSna/Zpyi06YptCBlV7c3Wiw0sNqelr1l6+dc02RW2swU8b92AJ7EXTaBxafw4MGKD04H5iuC3poQSrDzl8bRE+41MHbTf25DY46WgXM4734F6Xhyv3n2jpmkzI2zvXcIXv0+XkKMdRLW4NaEj17AC3CxzmtxmqbDjgPFYPO4qg75N4FkZ7ch5JV9Rm6mv5Ak8uM9OXiWOqDrLBtWy5A9R/yUgFEi8l/UaL2bHLthDVslygg5atzwRuWw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPAjH04bY3qLQuMPRoY34L/eu8AEVIL9yNxe0kC6xgg=;
 b=WUgROTSx6kL1pkgce+qa7CqjfO6eeUdAwc31h40eAqPm7Bv7atEcTgi0dZv3a3OTUUMmn9PYUMyDr0B3fDAfR9iYcTZirOvl7TDUeJ0s8aUmMXdwSWRNztiLXXm3dI/i+8rL7t0lvs7jGbqohgDFKa34pQ3SBSkXunL3rPj2hVc=
Received: from DUZPR01CA0276.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b9::25) by AM9PR08MB6292.eurprd08.prod.outlook.com
 (2603:10a6:20b:2d8::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 09:30:59 +0000
Received: from DB1PEPF000509EA.eurprd03.prod.outlook.com
 (2603:10a6:10:4b9:cafe::98) by DUZPR01CA0276.outlook.office365.com
 (2603:10a6:10:4b9::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 09:30:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EA.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 09:30:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gc+9Dph1q7cvqGMrQnVQ933eSQY5v+W7qsqBXHaR8pxQihHTZYTcp77VgYL2QalYy9rKmAUmaiHEvY5uEH4Iit5rN1oxDs7xAtd6t0sxkYzyp5HxaGPcQSXOPaDUxV8o6+oIw/MlyJRqpeSQyD88a9XvRnM7ouw72STflsHEdMcJ1aX84cqEZqfxoIcRmEZGV9b6By0R3LqbRuHZW9jTbVrj9f5Tjr+WYpPKPbAMlfVQohCJXUuU96AFNsAZlq4Pzb/y+6pZ8lmuNx2LZ6B7/Sq4YuFSUDMtcbVHAPE8MYNxHeKgrtT50kCwNFKJ76/jNMFNAq2pXvHdM+8MgI+l+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pPAjH04bY3qLQuMPRoY34L/eu8AEVIL9yNxe0kC6xgg=;
 b=dYw692z5S4vbmW6FVVvJYsR4eT+msP3s+RUbnfZY+3YuoFkVzIkUyxuzmxh8MXurlcQ4zzJfmVJ7xjMD0nWRP7o03eCKAJLqNrHAeI7y/g2r5E4wt+F7qTuGv7A03D3kqq+IWaBFi6wNTcZHHduWCgAv9QQGdXEjCKRsN+BT1HYd0jYZYB21dkfG0uVopjqJbuGfZvV/l+13RyleEdPxhWAiG6YqlgtY3iB2SH+wF73OebmDQFNVGwQfIie/uMJmSN2x2ZWKUZ0YiELYeUWismwrnyMHJR5o859Ckcn8h8jggSlze5vZxmaG3tnbVzLhMUQ7usnmdtAfknFd9evBQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPAjH04bY3qLQuMPRoY34L/eu8AEVIL9yNxe0kC6xgg=;
 b=WUgROTSx6kL1pkgce+qa7CqjfO6eeUdAwc31h40eAqPm7Bv7atEcTgi0dZv3a3OTUUMmn9PYUMyDr0B3fDAfR9iYcTZirOvl7TDUeJ0s8aUmMXdwSWRNztiLXXm3dI/i+8rL7t0lvs7jGbqohgDFKa34pQ3SBSkXunL3rPj2hVc=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GVXPR08MB10861.eurprd08.prod.outlook.com (2603:10a6:150:154::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 09:29:53 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 09:29:53 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 02/48] irqchip/gic-v5: Provide OF IRS config frame
 attrs to KVM
Thread-Topic: [PATCH v4 02/48] irqchip/gic-v5: Provide OF IRS config frame
 attrs to KVM
Thread-Index: AQHdG1oGQAGyOIpVJU63p6OTUU3ny7Z8g3IAgArkHgA=
Date: Fri, 31 Jul 2026 09:29:53 +0000
Message-ID: <dadf1431ce6532ba4d066ba2368d30c5825d64f8.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-3-sascha.bischoff@arm.com>
	 <20260724111047.4D1D11F0429A@smtp.kernel.org>
In-Reply-To: <20260724111047.4D1D11F0429A@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|GVXPR08MB10861:EE_|DB1PEPF000509EA:EE_|AM9PR08MB6292:EE_
X-MS-Office365-Filtering-Correlation-Id: c517d383-4734-4ef1-b69a-08deeee66e3e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|4143699003|11063799006|6133799003|56012099006|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 4ZzTeT85xVTSn0bovJVBcw3Hx5lf20tBGKvW514Ra3l2AaZHbeCrwhUKQPCJNIa4Kx1HdFPqdClKI6/Oh615eVGGq/hY3ECSYSMO/psOMtZpgKoMh60a44PUifRGC3AHGiSzB9DS8fJYIb2DtMK9X9lu0yRiz70hE2VlwSe1UQjNqGV+/9A+0oj/sAdazxFeq6FsRDTpjT5oKYrx4aU5C2oIShBHB2SBVx8ff9G1K+DHoUIwukBG4t5VSsNzwUwpWgoT7Jwror6UOAlWMrkF2t+AX+zgeUxTpSeJU8tktIbopVH25ALvFMLRL/5j14h+/F41/3B+UNYI5WXC/+vYA1Ehj/QVRXCxH4WkTEWr7EoNmEQvkbshKBQh1MO7VBenOHOfW1lMYjtdaxyndZf8VIsnLRKZsma2PV7eLBRnOAjU0cLberaJocJRMFhgkwKLwvHlybJLSsak7mj3euZ27lytT3WX4q2Pu/AxFUdH0BDCxLYTAOMB0i7MSfYuWnztKhqq8alUur3YiD/uIMiTFpLuuFvwfvuP81I82VJAWOn8VvUCSYvK6KZCAE7d4PjCK0ne0mYvU4ufM9dnnMpN5/JbGHtav0jUIpjxJZ6JVrHSVuDTjB0v28BFeLoRehaPWlBCw48DRjW+/CLiXWO/2mPS0oL6mIY9E28ncV8qdBjxWNLjN3hk/zQnJBViFIjPnqxaj6hDAYPfTMru5H8CFul6W9qom7xJwFM2zU9dHBw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(4143699003)(11063799006)(6133799003)(56012099006)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <07FA8F60F65B254FB58B4A025BC5085C@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 cYGORfusmd1g7iCxlV0RGQzRSzJ/i/QwvyILMRH2skwyr+SqXDKXgQP4JApc3KAHg6euiLmK5axKgRliNI0l0SVck/dz+fELWTFCTScXTsnQqhjYR9pVkCXNWQQDl9MBAI9Si3Ajdgq4gq5cZCqBQMUUNhtgHahdCL2maNbCW+3CiQdKGfULMx+/SmFa9S8dDKCuzBjtT6slxu6xp9V02wFSq0j/jrV3R1NWNoZdk2BlgbPo+ybDtxtoLGxCC8gzGLxp2dxxRWpp4lYPl6NKACEsZ3E2WiheV5IdseF43iPmyuh/kP6fDJPEbvG/1+wxQOvXEHdtMRBUmMb55rUoEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10861
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EA.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	458b074b-0a70-4b8e-ecda-08deeee646d6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|82310400026|35042699022|14060799003|1800799024|23010399003|11063799006|4143699003|6133799003|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	sAmca8y38HA46kUhBlKD30oA1BNqhGlib4Ity2MaHeLA5m4Obi2Zxu0h5vbp4ogODgTlBI4qV4+NBZox3nX6hzobKc1Gk2RpfxY32umBkzmTv4hVu6mnX2SEj8z3SculbVwOs1ivGSmkyd422TB5zi/GZpSJygKLBeWC1dLsJoibZkgOGRqslhwjcSYkCVMndP/RloYbSb/WvOJLnY8Cgi/PGZkmnxZFfVOup6prgwyZ7AgCERNGlMM8MzaqjMLy1/XEwzSaT5xlaGU5U01fxH1AHHsX/m89Bk/UhrqRMbuYvPeE/x23l0o+NLF5NRmh+Ni25pjC/k9QQHeX6FLLMBavMWoW2HrwkAgC7s9AFSs0zvTunsII4BbD2aJ9aVP5srOlx2PFy3m9qFJuNX+mnQ2E6pG9nKhInY4DOz8Zg/NvuYMnLmD4AMJes3B4eCVMEDNn0DVMva4abtpXp4OxXLOtZrkSY33ZJJO8imM96uT/m/TBAfhnCQ4k0jVVXnvklto2FBAwWQmDMQzGFW3RSi2l1UdOitdLtR5M7GVhx+XlzuPe3xC1eh9veBty9ngLyBbW24dBzdSZ1EEHKp3rSmNno+MgnFwrvDO5IUGf4OR/FJH6NH49j48OCIeTS+mKLgkv+iEePUE/Nx/wwT7ZlOJLW99wi65+q1YxxBIhnpiFdJndkZSi7FvSk/pZnuCKnBI5gmfk7vPyle4R2vzATg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(82310400026)(35042699022)(14060799003)(1800799024)(23010399003)(11063799006)(4143699003)(6133799003)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	okdaulXJMNcwIH/GcphFJEvExj7Q8DbfCZ0fC3bsT1DPfjYYpzVX04eUZdWd5CFTN5RIadBQ7YvfJc8siR5+v8oY+n5wqM3ksJr7JwckrdthKsnZhpwUyRA+8Fkj78j8BhRV7KHlwacfHY9lUJjrIgjF/xQ34WnIZxZ7knn+4s6lprndkyWNPwuKwQwp2+8buViMYasp2AuDZBeWgfIF2MYxJ5WAeJ+k6borfLT5ZUw3+0ZFn9rok2DX0kIq4jOtT84Cac22+VW5F1wanV6PoqwT+YyNV8KmQSKZgweWs3w9VGtE7ABUuf6vyinFKqe/daLe6VU4/xGwYSOWKmGUrg/Wenf/Nup01jiUzJtY3de82CRSEpp5JidMm4gSCiVvCMxh69S68aULAE3rfzscPfZ4WBjUnQf9d1h9j5q1LeQxFj2C4peLy2x468mKhgAG
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 09:30:59.1537
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c517d383-4734-4ef1-b69a-08deeee66e3e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EA.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6292

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDExOjEwICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gDQo+IE5l
dyBpc3N1ZXM6DQo+IC0gW0hpZ2hdIFVuY2hlY2tlZCBkZXJlZmVyZW5jZSBvZiBgaXJzX2RhdGFg
IGluDQo+IGBnaWNfb2Zfc2V0dXBfa3ZtX2luZm8oKWAgY2F1c2VzIGEga2VybmVsIHBhbmljIGlm
IENQVSAwIGlzDQo+IHVuYXNzb2NpYXRlZCB3aXRoIGFuIElSUy4NCj4gDQo+IFByZS1leGlzdGlu
ZyBpc3N1ZXM6DQo+IC0gW0hpZ2hdIEZhaWx1cmUgdG8gY2xlYXIgYHBlcl9jcHVfaXJzX2RhdGFg
IG9uIElSUyBpbml0aWFsaXphdGlvbg0KPiBlcnJvciBsZWF2ZXMgZGFuZ2xpbmcgcG9pbnRlcnMs
IGNhdXNpbmcgYSBVc2UtQWZ0ZXItRnJlZS4NCj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbMl06IFtQ
QVRDSCB2NCAwMi80OF0gaXJxY2hpcC9naWMtdjU6IFByb3ZpZGUgT0YgSVJTIGNvbmZpZw0KPiBm
cmFtZSBhdHRycyB0byBLVk0gLS0tDQo+IGNvbW1pdCA2MDIyMzY3YTEyZGZlYTQwODdmYTExODVm
ZjEzMTAxNWQ0NDVhMWFhDQo+IEF1dGhvcjogU2FzY2hhIEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hv
ZmZAYXJtLmNvbT4NCj4gDQo+IGlycWNoaXAvZ2ljLXY1OiBQcm92aWRlIE9GIElSUyBjb25maWcg
ZnJhbWUgYXR0cnMgdG8gS1ZNDQo+IA0KPiBUaGlzIGNvbW1pdCBwYXNzZXMgYW4gSVJTIGNvbmZp
ZyBmcmFtZSBwb2ludGVyIGFuZCBjb2hlcmVuY3kgZmxhZyB0bw0KPiBLVk0NCj4gdmlhIHN0cnVj
dCBnaWNfa3ZtX2luZm8gZm9yIE9GIGNvbmZpZ3VyYXRpb25zLiBJdCBhZGRzIGEgaGVscGVyIHRv
DQo+IHJldHJpZXZlDQo+IHRoZSBJUlMgY2hpcCBkYXRhIGZvciBDUFUgMC4NCj4gDQo+ID4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXY1LWlycy5jDQo+ID4gYi9kcml2ZXJz
L2lycWNoaXAvaXJxLWdpYy12NS1pcnMuYw0KPiA+IGluZGV4IGYzZmNlMGIxZTI1ZDkuLjYwN2Uw
NjY4MjFiNTIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUtaXJz
LmMNCj4gPiArKysgYi9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS1pcnMuYw0KPiBbIC4uLiBd
DQo+ID4gQEAgLTUwLDYgKzQ4LDExIEBAIHN0YXRpYyB2b2lkIGlyc193cml0ZXFfcmVsYXhlZChz
dHJ1Y3QNCj4gPiBnaWN2NV9pcnNfY2hpcF9kYXRhICppcnNfZGF0YSwNCj4gPiDCoAl3cml0ZXFf
cmVsYXhlZCh2YWwsIGlyc19kYXRhLT5pcnNfYmFzZSArIHJlZ19vZmZzZXQpOw0KPiA+IMKgfQ0K
PiA+IMKgDQo+ID4gK3N0cnVjdCBnaWN2NV9pcnNfY2hpcF9kYXRhICpnaWN2NV9pcnNfZ2V0X2No
aXBfZGF0YSh2b2lkKQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4gcGVyX2NwdShwZXJfY3B1X2lyc19k
YXRhLCAwKTsNCj4gPiArfQ0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBUaGlzIGlzIGEgcHJl
LWV4aXN0aW5nIGlzc3VlLCBidXQgZG9lcyByZXR1cm5pbmcgdGhpcyBwZXItY3B1IHBvaW50ZXIN
Cj4gcmlzayBhDQo+IHVzZS1hZnRlci1mcmVlIGlmIHRoZSBJUlMgaW5pdGlhbGl6YXRpb24gZmFp
bGVkIGVhcmxpZXI/DQo+IA0KPiBJbiBnaWN2NV9pcnNfb2ZfaW5pdCgpLCBnaWN2NV9pcnNfb2Zf
aW5pdF9hZmZpbml0eSgpIHBvcHVsYXRlcw0KPiBwZXJfY3B1KHBlcl9jcHVfaXJzX2RhdGEsIGNw
dSkgd2l0aCBhIG5ld2x5IGFsbG9jYXRlZCBpcnNfZGF0YS4gSWYgYQ0KPiBzdWJzZXF1ZW50IHN0
ZXAgZmFpbHMsIHRoZSBlcnJvciBwYXRoIGZyZWVzIGlyc19kYXRhIGJ1dCBkb2VzIG5vdA0KPiBj
bGVhcg0KPiB0aGUgcGVyLWNwdSBwb2ludGVycyBmb3IgdGhlIGFzc29jaWF0ZWQgQ1BVcy4NCj4g
DQo+IElmIENQVSAwIGJlbG9uZ2VkIHRvIGEgZmFpbGVkIElSUywgd291bGQgdGhpcyBoZWxwZXIg
bm93IHJldHVybiBhDQo+IGRhbmdsaW5nDQo+IHBvaW50ZXIgdGhhdCBnZXRzIHVuY29uZGl0aW9u
YWxseSBkZXJlZmVyZW5jZWQgYnkNCj4gZ2ljX29mX3NldHVwX2t2bV9pbmZvKCkNCj4gZHVyaW5n
IGJvb3Q/DQo+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS5j
IGIvZHJpdmVycy9pcnFjaGlwL2lycS0NCj4gPiBnaWMtdjUuYw0KPiA+IGluZGV4IGMwNDUyM2E0
MzhjZWUuLmU3YTdhZWRjZmFmNzggMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9pcnFjaGlwL2ly
cS1naWMtdjUuYw0KPiA+ICsrKyBiL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXY1LmMNCj4gWyAu
Li4gXQ0KPiA+IEBAIC0xMTI4LDYgKzExMjgsOCBAQCBzdGF0aWMgc3RydWN0IGdpY19rdm1faW5m
byBnaWNfdjVfa3ZtX2luZm8NCj4gPiBfX2luaXRkYXRhOw0KPiA+IMKgDQo+ID4gwqBzdGF0aWMg
dm9pZCBfX2luaXQgZ2ljX29mX3NldHVwX2t2bV9pbmZvKHN0cnVjdCBkZXZpY2Vfbm9kZSAqbm9k
ZSkNCj4gPiDCoHsNCj4gPiArCXN0cnVjdCBnaWN2NV9pcnNfY2hpcF9kYXRhICppcnNfZGF0YSA9
DQo+ID4gZ2ljdjVfaXJzX2dldF9jaGlwX2RhdGEoKTsNCj4gPiArDQo+ID4gwqAJLyoNCj4gPiDC
oAkgKiBJZiB3ZSBkb24ndCBoYXZlIG5hdGl2ZSBHSUN2NSB2aXJ0dWFsaXNhdGlvbiBzdXBwb3J0
LA0KPiA+IHRoZW4NCj4gPiDCoAkgKiB3ZSBhbHNvIGRvbid0IGhhdmUgRkVBVF9HQ0lFX0xFR0FD
WSAtIHRoZSBhcmNoaXRlY3R1cmUNCj4gPiBAQCAtMTE0MCw2ICsxMTQyLDkgQEAgc3RhdGljIHZv
aWQgX19pbml0DQo+ID4gZ2ljX29mX3NldHVwX2t2bV9pbmZvKHN0cnVjdCBkZXZpY2Vfbm9kZSAq
bm9kZSkNCj4gPiDCoA0KPiA+IMKgCWdpY192NV9rdm1faW5mby50eXBlID0gR0lDX1Y1Ow0KPiA+
IMKgDQo+ID4gKwlnaWNfdjVfa3ZtX2luZm8uZ2ljdjVfaXJzLmJhc2UgPSBpcnNfZGF0YS0+aXJz
X2Jhc2U7DQo+ID4gKwlnaWNfdjVfa3ZtX2luZm8uZ2ljdjVfaXJzLm5vbl9jb2hlcmVudCA9ICEh
KGlyc19kYXRhLQ0KPiA+ID5mbGFncyAmIElSU19GTEFHU19OT05fQ09IRVJFTlQpOw0KPiANCj4g
W1NldmVyaXR5OiBIaWdoXQ0KPiBDYW4gaXJzX2RhdGEgYmUgTlVMTCBoZXJlLCBsZWFkaW5nIHRv
IGEga2VybmVsIHBhbmljIHdoZW4NCj4gZGVyZWZlcmVuY2luZw0KPiBpcnNfZGF0YS0+aXJzX2Jh
c2UgYW5kIGlyc19kYXRhLT5mbGFncz8NCj4gDQo+IElmIHRoZSBzeXN0ZW0ncyBEZXZpY2UgVHJl
ZSB0b3BvbG9neSBkb2VzIG5vdCBtYXAgbG9naWNhbCBDUFUgMCB0bw0KPiBhbnkgSVJTLA0KPiBn
aWN2NV9pcnNfZ2V0X2NoaXBfZGF0YSgpIHJldHVybnMgTlVMTC4gV291bGQgaXQgYmUgc2FmZXIg
dG8gY2hlY2sgaWYNCj4gaXJzX2RhdGEgaXMgdmFsaWQgYmVmb3JlIGFzc2lnbmluZyB0aGVzZSBm
aWVsZHM/DQo+IA0KDQpJIHdpbGwgYmUgcG9zdGluZyBhIGZpeHVwIGZvciB0aGlzIGFzIHBhcnQg
b2YgYSBzZXBhcmF0ZSBzZXJpZXMuIE9uIGENCm11bHRpLUlSUyBzeXN0ZW0gd2UgY29udGludWUg
aWYgb25lIG9mIHRoZSBJUlNlcyBmYWlscyB0byBpbml0LCBpbg0Kd2hpY2ggY2FzZSB3ZSBjb3Vs
ZCBoYXZlIHNvbWUgQ1BVcyB1bmJvdW5kIGZyb20gYW4gSVJTIGF0IHRoaXMgcG9pbnQNCmFsYmVp
dCB3aXRoIHN0YWxlIHBvaW50ZXJzLg0KDQpUaGFua3MsDQpTYXNjaGENCg==
