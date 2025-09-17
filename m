Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010000.outbound.protection.outlook.com [52.101.69.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EC8224AFB
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 13:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.0
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116177; cv=fail; b=U3cf0MKX8CFMdwXmOr+kpbeyXtJwath0JiMZNqaE6ADDt43Bd61NlpO1n0JGtgVtWGOvdf1UruTWcc5K1C+6EynCNq9REc3E84CZlz9bQuoyZsDdRj+LqrPHOw8l7YEMU/SczhcjMhkTedrh1NpnDsx6fGaLvgwplvxX5U/TnM4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116177; c=relaxed/simple;
	bh=zZ9DQXvbM/LAeCNSwOGpxuiDXlMFMqcj7/hfkpVr98w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Z2X0qlIEKJGp8Y89pntkc/rjRLmltz/CXBpNeu5Nnv2xHb01EGBCTKQ0ie9BpcSsgT0xtFZmh9+kCEh2uxYofOq2nCqL/VpoygkSFaycX8PopJo5GTa0MYirIo2lt+Tp6BXn4ETRcRMBRysZY4ZNLUuOsRp6czSMlQ4meMDaWNk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XyyMxdyu; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XyyMxdyu; arc=fail smtp.client-ip=52.101.69.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XyyMxdyu";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XyyMxdyu"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OdGUQjIKHMoWyjOySG4ZowQMH2JGYkZTn2INPg0UE0DLezlznr6m/MmQsVkqFHaUQ2YdB+MUUBmoRMl6PxiGpCV61zUUrXBBLDSifQ0Fv72mC4/mg8IroTWnCBCwmFHj0nBPsOW1SqXgv71g+wWfQbe0Ln2t5pxwidni+Zo9dPOxH8XYZLwH2yC/j6Y+bp3JNB9Fcc1obnPdfxVRf052i6GoUJSwqzmC5aFNJtXpmcJtfzvog75Cvvo9zaFImL1hmXBO+8K6U6oCnbneIkbWFXs9XdpUgANoz5ghXWJP2OZGNfy1rLrzA4kPhWW7zvVauJ9mxEKeoKAY+rossSuPrQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPGznFBdYI7QtRqvHV7zqAZ+mNHnVPQK+jmAA4TMAQM=;
 b=X0SW/GRK7hgQETAOuT8j+DvZKJzmaEtCkb3rN39T6F8sl4UKBWZv7zuIj/HjeF//zART7koOsNpnpXVf6bYGdk/ArGv6XSX0rKucf1bqZTPIBUal4vukGU5bk88o5OUcT1gf6jwME6jztZgTNGl5/gKnkcM09SgqY8UCPrT12B4kIGz4/C5ZBUBRJb8heMgSVUTaOGHOp5HsopZjoiMaIh5O5ZmyY7yvLKolhsZW3WgAVE4UE7+y5lfkXwKiZSOStHr/Ie9nzxBD2yf7nMiji3vBIOAUUc/6w7bvHg49Vd1rutdE7oA29pXpwN6fQqc+AtxJp4e1t7XrxK6KBKRypw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPGznFBdYI7QtRqvHV7zqAZ+mNHnVPQK+jmAA4TMAQM=;
 b=XyyMxdyuWIdCWOjed0ATw4QluAwJMaOVqBr3De7irUJbj47ZvKbBZ+ux2pdpFKnIMbccptDPpb6DOdWyVNwdvBHgRsmoKPwTmUnSkgM81xFp59wH4KUKZdcoJZ4ZTkGR8na22pUOXDK5JzLfF8uLVDlsy0OVKogeBS9vXO95JbA=
Received: from DU6P191CA0036.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::23)
 by AS2PR08MB10265.eurprd08.prod.outlook.com (2603:10a6:20b:62c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Wed, 17 Sep
 2025 13:36:07 +0000
Received: from DB1PEPF000509F5.eurprd02.prod.outlook.com
 (2603:10a6:10:53f:cafe::7f) by DU6P191CA0036.outlook.office365.com
 (2603:10a6:10:53f::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.13 via Frontend Transport; Wed,
 17 Sep 2025 13:36:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F5.mail.protection.outlook.com (10.167.242.151) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Wed, 17 Sep 2025 13:36:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hZbEXTStz7A1cP2vBTy/+0Gn0aMsPOdSlhN598yPotHOhcr8SgsDpqLDXCR8VxAsXAAuewhkuqmH9fKVadeOSI0lqzEn/kNfJ4QfU2vD1AsRfIUjkz9AYeqN/luKzqlK7Dl8jTPBHt7+wkeOU/y8whUFl17tfrphb18pYK+YIXhjrpoSoZBH+RBVANChwmqICYKOTu9zhNfj6vE20d6mlAc4qiQ9GjIITrArrGTqvTfw9WNmQK+6OI7QSSqpBF9D2lMQBNkI2vd+ka5hHJW6dBeTU0m66mPd2leAxSxzsxmrgxVw6cB35SQ22ZrA0c0BJSrabEbuQUbhTu2oSr+7Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPGznFBdYI7QtRqvHV7zqAZ+mNHnVPQK+jmAA4TMAQM=;
 b=HYCPoplG6ddWDwjnb5E8DpnDOlt8oR7uMy6QWMFdaXlm0K2SI4F9+i6Tj7/A2Y8Kz55w5B8WTYnf6MClGJWk3XXCJRKiKUlf0rtRZu5UlazgItyjgz3lP7RWHdYP9fM1a1m/JZw7VPvNE5MI68OaqSHimBnGAxPg2N4U4DtPqjF+AQKLYR5OjRD7MR9i5kkJb/qujZjROiz8DQrq2OvBQzWHczkIHkprEsFAOp6T8KgBnQAaL3g/qzM54tnyK7oEhje07QIas9EU+BYvODl4GTwcpUYdrnBg6K/zPjk40fgudFh9Gem2M+EzldiKyRuMLHzmvz7ztvz7XtIgEU4wWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPGznFBdYI7QtRqvHV7zqAZ+mNHnVPQK+jmAA4TMAQM=;
 b=XyyMxdyuWIdCWOjed0ATw4QluAwJMaOVqBr3De7irUJbj47ZvKbBZ+ux2pdpFKnIMbccptDPpb6DOdWyVNwdvBHgRsmoKPwTmUnSkgM81xFp59wH4KUKZdcoJZ4ZTkGR8na22pUOXDK5JzLfF8uLVDlsy0OVKogeBS9vXO95JbA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB9PR08MB6377.eurprd08.prod.outlook.com
 (2603:10a6:10:259::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 17 Sep
 2025 13:35:12 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 13:35:12 +0000
Date: Wed, 17 Sep 2025 14:35:09 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, broonie@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	james.morse@arm.com, ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 5/5] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aMq5DbqsXj6vP7Xe@e129823.arm.com>
References: <20250917110838.917281-1-yeoreum.yun@arm.com>
 <20250917110838.917281-6-yeoreum.yun@arm.com>
 <aMqx67lZZEgYW-x5@J2N7QTR9R3>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMqx67lZZEgYW-x5@J2N7QTR9R3>
X-ClientProxiedBy: LO4P123CA0216.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::23) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB9PR08MB6377:EE_|DB1PEPF000509F5:EE_|AS2PR08MB10265:EE_
X-MS-Office365-Filtering-Correlation-Id: a1ed192a-cbd7-49f6-a828-08ddf5ef273e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?EApF18ADiPtJMHbyIiflvySNtjoXKq9VOHudgkhb6cx57S7RpGKi/hl4+dRI?=
 =?us-ascii?Q?HtePERE1fGPbX+EztdblVOUOz99ql+j6133lyds+2wiMfqrkgmZAxwW6NiVc?=
 =?us-ascii?Q?898TITFEA+YlfSqpMkDlobgLMU2uziJePzKJok/Rcx9jKpU8BnMdBZl9bJPY?=
 =?us-ascii?Q?Zjvi67Koro6vqNBbe8RsBtFjEw6s5htiquaRijXXyBuGatx8GjMI0jxzUtTN?=
 =?us-ascii?Q?jvx+wcveVdF5XCugJcUSDUkHLQfZSbmU9eeKhxqKJclfOUfeqSkhydw+7wss?=
 =?us-ascii?Q?JIUKnOB3fl44txpniQpQsoV1pusqWqLXRhsUo/FxvSw1z30hwsqUUeQLFfh1?=
 =?us-ascii?Q?2NIjBR/oNzyr2GQsOQPdWDtK/0fN2fHto8YCYuE2Pwmo+oVNV/W9ryJSs1CG?=
 =?us-ascii?Q?cHdOG12DSdhOmyAFsTtcAMNSj0bjBmsRv/i/SdJWxTj0k1OQRQv+HOHnvEKP?=
 =?us-ascii?Q?pFIZmUaZV3lxBi5tFGP1he92kRIdPhudDuQQGYJ8JBvrQbd2D7ei8qJbCIDN?=
 =?us-ascii?Q?Dg66EHkXgKNpuuHFKsO/Pp6nTZ5s7eJZbJdqRNFv/duxxjl21+mkD9Kuyyq3?=
 =?us-ascii?Q?uNc3pfZhEIJM7nA/fodP8LwAQkeWU2C6l531hKhpb4dagNhbd/fi1wIB0t4g?=
 =?us-ascii?Q?xXKUixDrjx1Fxdw+vS4svcE5CIxBwvnfxbST0TCj9C/WaQ7Pyb34QzWSKrG4?=
 =?us-ascii?Q?MnhpT0LudrGVev5HoDhwJyJvyfOVr1mHDwMDBpSgqIebuKKDSdYRfUsoAYgN?=
 =?us-ascii?Q?jKygVdDfITlZId2/IHLx4UH4glpk+u1VkSaSSrDTctWaVC4IG7Sxl0rNTKPJ?=
 =?us-ascii?Q?zEodxi0Ehh9p8TosbWmb7H7qzuxrILDe0TFIec6QIoBjrwxAoPL++eaShnUd?=
 =?us-ascii?Q?RkzXRdspG9HsEG5ylI/WhPxOBnD3Pzg8ZUH5UmCwCO1ImZgV5XT/iSKIcSm6?=
 =?us-ascii?Q?f29u4qByhh34vE2hc0pkfSufnzk5JCANOHsZOOBv4k9SF/EJkoYWTH1nhAQ+?=
 =?us-ascii?Q?yF5UhoxXqOhw4LUAUckInus9LCtJ631yx6YsAkA8P4CWOGZGN3hM8MXifA3a?=
 =?us-ascii?Q?uBDo76AJEjvDUG2E1Ph9b8Em2EwVdHmf8P1zB/e8rMEaGSlJVjHiYDZxb8DY?=
 =?us-ascii?Q?Y4EgiBJ08R71eQhicHlj1CD/a+tkVOGYKM4Eb4OJdr8Uhklny/Xmc1ngPG3i?=
 =?us-ascii?Q?ua5lbOIrSy/Y1pFUkzlsov3/YNu+SrWystdN83XhB0o2gyvBkWqdiBBC/R6N?=
 =?us-ascii?Q?S/0MN2NQoJVvDKi2iX+xff2C8Hq5Zbw1yxK+dh9bS2VyYkO2jTAoiOE1vlA1?=
 =?us-ascii?Q?+wyjbrEO5AFwn+kAxwrsHcG9dx/t+5ArPREjQS/VE7ScfQOh5xuUfhL1w/Zx?=
 =?us-ascii?Q?9e/SrPjeqbBZ2Memb4rMv4xFnyETaWFDf5BEsiFnAcU8KzfYA7gWB91Wpx82?=
 =?us-ascii?Q?p5i2hcP063M=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6377
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F5.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	41f83791-78d8-4374-ff93-08ddf5ef06f0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|14060799003|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5v3n4CuEFQVp1c7mm3wpGrLobLE20P3U2J83QmPEoCvXbaRRRW14gf9Ch+IA?=
 =?us-ascii?Q?Alx7h+hoctj+CaZRC0FFiinz8ZaydCnnAEuO7Idua9w0WWD3f7BCweJpcgCf?=
 =?us-ascii?Q?qS1Cl2ZLtAJwjGwku/JY2sqf3aS0cfn/aw8NVntqIIFzGesri7egQM6t/XwR?=
 =?us-ascii?Q?O6hOXGHvIeba+7whPoSfs5zCJroX6EU+ZlLzAM/S9ADSYvRrDd89e3p4WD2d?=
 =?us-ascii?Q?1qt7D7Vp5D0PyWPYO7U9PvQlOteBfmtsX0xKSrPHwWNSD8LotrM+47+Y/9S9?=
 =?us-ascii?Q?tw7LbDORq4rL7JdWiX6dvcyH7Vn98iq8pcJBmKklrEtLFbhAJqruwC9pfVr+?=
 =?us-ascii?Q?9JdPvXbQxtaobwBPCkxOVHU5ufSy01wSrRCnWxUwt7csOBYKyq9obRY6FX2S?=
 =?us-ascii?Q?0aQFLRmtONVSafpOJb1orlhHda6Apxh2F0Uj7fFLMtWSYg2FSRZGdl4a52Dh?=
 =?us-ascii?Q?OzGpBY1wK9way7vm1tyG2Y6YY4Cp4nSQwExcR0wzhxxclBqsF4xozsubHTiH?=
 =?us-ascii?Q?T/4a6Gcg6Yr2KSULKTzSF6NaeFMahzz54TIMyw+ZyWVYx4L21dUYZhWSdy6S?=
 =?us-ascii?Q?HUsy6L/gXk96p++Zi4nSbnK9eeC/+hniFPU+fO20HaWUbEYwEhHP/XuMg1yo?=
 =?us-ascii?Q?lJ6N3fLu4iEcjwc5kPbGlQOBRPDA2wOCe4duKnfvRPyX01L5lEueNIJaUElj?=
 =?us-ascii?Q?Bl8x8AaD8fsptvfltjv3lVHd1vFawG5xkNqaNbtTiXg/fyEPNQjM6/Ujraft?=
 =?us-ascii?Q?99QTudKsVcV71Er6/gu5kL01UNWnQ10tJrVEOEJNek/M41CrazPY6KZ0znFh?=
 =?us-ascii?Q?RjZpI+7NsmnqTdDBbgVUYHx8kyNmuE2CAYyXG5/Kt010ZrzgoCqMXFEtb+jF?=
 =?us-ascii?Q?acduE6F/w4QrdSLnFTutKFlH49jl5kHyyBiyZxwGBCPW1DQAGs0rhGhBi/4c?=
 =?us-ascii?Q?mOVRyvttVA7qRwdqRnNC0q4tpbikskgTrvJiqy8jugNq1PN3lR0RV3IvKST/?=
 =?us-ascii?Q?hvsFK9pH71hJYtyKU79iFR9oM/eA5QCc7/PP0qmmsqSVWg8AF4b6ysczs75V?=
 =?us-ascii?Q?uqJMi6hQwe6S/7vpthWrpxODT+u3ObrUESmQub9CwHtKBI9HfoZgG7tkbz1m?=
 =?us-ascii?Q?DkUBN1D3OquGjYk0xcxreOkyuLdp7Xqqvc6L3YEdzUMvLRDKeaInT7YKB2y+?=
 =?us-ascii?Q?3JwAyvmcGwKI+n8yMxDQfI8Vzs5NFKWSJV7Gs8nGeN9d7zq3jNXxjggT3DlG?=
 =?us-ascii?Q?Xwb+L1X4vkimLbdHCuXjvzc6+TIAK0lFVfCY5Zr9BkaUDEaN6ImxAqpRUtVu?=
 =?us-ascii?Q?vVPiQsQsLFriB04CZwSY5CzsrvzYv3KZvp/tqgN0fjtfDs+ciCRlGrEWBh67?=
 =?us-ascii?Q?GjT/fp7rQOOqAnLDbX0EySJOO35am13saUr/Gyl8KQvXb7gqIbuZ6y2ML0Ay?=
 =?us-ascii?Q?xdBI2NLj6hyO7XAm0PSt2CbXWqy/v+H0g0s1Mep8+GOWVe4quW4oNHWEQbCM?=
 =?us-ascii?Q?H5FdZojTGW2lA1tZEJpehKAdlk2cU4j54hcI?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(14060799003)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 13:36:05.9921
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ed192a-cbd7-49f6-a828-08ddf5ef273e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F5.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10265

Hi Mark,

> On Wed, Sep 17, 2025 at 12:08:38PM +0100, Yeoreum Yun wrote:
> > +static __always_inline int
> > +__lsui_cmpxchg64(u64 __user *uaddr, u64 *oldval, u64 newval)
> > +{
> > +	int ret = 0;
> > +
> > +	asm volatile("// __lsui_cmpxchg64\n"
> > +	__LSUI_PREAMBLE
> > +"1:	casalt	%x2, %x3, %1\n"
> > +"2:\n"
> > +	_ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w0)
> > +	: "+r" (ret), "+Q" (*uaddr), "+r" (*oldval)
> > +	: "r" (newval)
> > +	: "memory");
> > +
> > +	return ret;
> > +}
> > +
> > +static __always_inline int
> > +__lsui_cmpxchg32(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> > +{
> > +	u64 __user *uaddr_al;
>
> Please use 'uaddr64' to match the other 64-bit variables.
>
> I assume that the '_al' suffix is meant to be short for 'aligned', but I
> think using '64' is more consistent and clearer.
>
> > +	u64 oval64, nval64, tmp;
>
> Likewise, 'orig64' would be clearer than 'tmp' here.

Thanks for your suggestion.
>
> > +	static const u64 hi_mask = IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN) ?
> > +		GENMASK_U64(63, 32): GENMASK_U64(31, 0);
> > +	static const u8 hi_shift = IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN) ? 32 : 0;
> > +	static const u8 lo_shift = IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN) ? 0 : 32;
> > +
> > +	uaddr_al = (u64 __user *) PTR_ALIGN_DOWN(uaddr, sizeof(u64));
> > +	if (get_user(oval64, uaddr_al))
> > +		return -EFAULT;
> > +
> > +	if ((u32 __user *)uaddr_al != uaddr) {
> > +		nval64 = ((oval64 & ~hi_mask) | ((u64)newval << hi_shift));
> > +		oval64 = ((oval64 & ~hi_mask) | ((u64)oldval << hi_shift));
> > +	} else {
> > +		nval64 = ((oval64 & hi_mask) | ((u64)newval << lo_shift));
> > +		oval64 = ((oval64 & hi_mask) | ((u64)oldval << lo_shift));
> > +	}
> > +
> > +	tmp = oval64;
> > +
> > +	if (__lsui_cmpxchg64(uaddr_al, &oval64, nval64))
> > +		return -EFAULT;
> > +
> > +	if (tmp != oval64)
> > +		return -EAGAIN;
>
> This means that we'll immediately return -EAGAIN upon a spurious failure
> (where the adjacent 4 bytes have changed), whereas the LL/SC ops would
> retry FUTEX_MAX_LOOPS before returning -EGAIN.
>
> I suspect we want to retry here (or in the immediate caller).

Right. I've thought about it but at the time of writing,
I return -EAGAIN immediately. Let's wait for other people's comments.

>
> > +
> > +	*oval = oldval;
> > +
> > +	return 0;
> > +}
>
> Aside from the retry issue, I *think* you can simplify this to something
> like:
>
> static __always_inline int
> __lsui_cmpxchg32(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> {
> 	uaddr64 = (u64 __user *)PTR_ALIGN_DOWN(uaddr, sizeof(u64));
> 	u64 oval64, nval64, orig64;
>
> 	if (get_user(oval64, uaddr64)
> 		return -EFAULT;
>
> 	if (IS_ALIGNED(addr, sizeof(u64)) == IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))  {
> 		FIELD_MODIFY(GENMASK_U64(31, 0), &oval64, oldval);
> 		FIELD_MODIFY(GENMASK_U64(31, 0), &nval64, newval);
> 	} else {
> 		FIELD_MODIFY(GENMASK_U64(63, 32), &oval64, oldval);
> 		FIELD_MODIFY(GENMASK_U64(63, 32), &nval64, newval);
> 	}
> 	orig64 = oval64;
>
> 	if (__lsui_cmpxchg64(uaddr_al, &oval64, nval64))
> 		return -EFAULT;
>
> 	if (oval64 != orig64)
> 		return -EAGAIN;
>
> 	*oval = oldval;
> 	return 0;
> }

Hmm I think this wouldn'b cover the case below when big-endianess used.

struct {
  u32 others 0x55667788;
  u32 futex = 0x11223344;
};

In this case, memory layout would be:

  55 66 77 88 11 22 33 44

So, the value of fetched oval64 is 0x5566778811223344;

So, it should modify the GENMASK_U64(31, 0) fields.
But, it tries to modify GENMASK_U64(63, 32) fields.

Thanks!

[...]
--
Sincerely,
Yeoreum Yun
