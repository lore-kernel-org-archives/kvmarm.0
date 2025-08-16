Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010046.outbound.protection.outlook.com [52.101.84.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA76C757EA
	for <kvmarm@lists.linux.dev>; Sat, 16 Aug 2025 13:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.46
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755349443; cv=fail; b=RBD0jVrknFAdBwfBlhocjx2NyR2VpR+Xv4ldHfMHUmy0k+Qj8aMxPLyq2TeIU/g9Ew4DXWlVgK2BXa+6H/SqPNRmny+zW9uxafVXL2kS0FVNquIds0Hj2FrhmzWk0U5Id7gzi8YebcKHqACH0K/1/wB1K5dckhb3lg/8jUefwos=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755349443; c=relaxed/simple;
	bh=Pt6U5HoCwnKZuaJ/01v43oCDhldofu436B1zk3krJMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uechOS2In4h05jAzedBq8ov07zWgIEaVQpjjkMtk4W8aej6Ok+F0qvOYyAY75mcJykHdGqeAWBcYFm02z9OUJl7iyhfJYodZB2ngts4cDFGuSJMcHMVyg9wiFZNipWvqzb3lee2EDnQemgVXY10IK0AjN/9++vZ+Jn5Hn83Q1fg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oBWY6y3m; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oBWY6y3m; arc=fail smtp.client-ip=52.101.84.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oBWY6y3m";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oBWY6y3m"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=QxPprm1eC6xngi8dHWNrhAESyiV+VFuDRbArPMunlP2AcR4bifwZ5hI08b48ZZgnIfCG8phfSPS9IApQnPXl0+M+HTaeBWo+Ds0ql/mslDQFCSJFM72iiQrjABxoo8hFhWb6YpQ6m3HYb0LTNPQ9wbKIqoM54X8HqoovwdVvx/OztTVj+evFQ/GamUbYGKMARg+BhCNlMnhgPK7rSkT2fF4aKFlobkHUbv6zO2eZBBs3SipShWlu6YsLfmxnEOri0+8BtCHlPatjL4qzJsuyLwhMAZD3G/DeuFaMdYXeAWoMycLzPAQK0PGGulKen5nw7TK+GQVkName8Au+kfPceQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OuftPGPRDv8S80CTwK6vPW8jlHCLfs/mEj/KGJvqrNo=;
 b=IEeK6SwKEfY/aeR21HMQf+7RQF6ST8WzfGdDgJJ8zsj73wfIvDiUxIox75RJaejVbBkp/0Vqdts5qqQjpIehFv4ejB/x+xaKXGdcd0zxNIHeLwwO84XqAbh1n9Hx2HE9v67AFC/n8B+x1lUUJ5m6BeVmZoUyay0MJJkImoOULiIY84TV02lF1xLu8tG7mtpYtN8hScg7cS1g4sYIW5Wo5fODW4Bds5KUYa2UGXS+U7y6R9nLiwOicxcl0D+wh99eD8GLOtAP17wpV4sK1Go04Zy7m0AqHdQQaJuTihuTT/4LAXQR2i7MewXnUQJ3HotbBCs640pZmQYl2Kx5jT9nyw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OuftPGPRDv8S80CTwK6vPW8jlHCLfs/mEj/KGJvqrNo=;
 b=oBWY6y3mMNbgANJ1WosSEB56Xo24VPa3q0LThE8dSgHTI6a/hCkTyvbtgv4qsOR0kKhywS4PFjj15YPjZSQiZB9RzI6EmT3fm/2ovxCaCw4GMM+yCN3oUxEe523jCtrcuEfLDckl/6Q2gMWifloYL5uWKRnLOyeKDHDm4PLY4RE=
Received: from PAZP264CA0115.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1ef::11)
 by AS8PR08MB6632.eurprd08.prod.outlook.com (2603:10a6:20b:31c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.21; Sat, 16 Aug
 2025 13:03:55 +0000
Received: from AMS1EPF00000043.eurprd04.prod.outlook.com
 (2603:10a6:102:1ef:cafe::5b) by PAZP264CA0115.outlook.office365.com
 (2603:10a6:102:1ef::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.20 via Frontend Transport; Sat,
 16 Aug 2025 13:03:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000043.mail.protection.outlook.com (10.167.16.40) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.8
 via Frontend Transport; Sat, 16 Aug 2025 13:03:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dY8EVZB3s0UqOkuhGExi9je+L2Z/qxQJncW6zVUqOU3GOUjNURVYj7rKPQbmrt3I2d0Fqn8dUCBlGlljUuvO5fxTMLi7B1Jzrw2Cpj1SJi63qjq++Xr/UJbTbwUjJQIj4MKKWfN1RY+E3ZD49m8U+N0NKZwac61ZGEMJYHHpIvLACgBhJ7htOrFhRpuQR2Z+98PaYxjznLlg1/7GtPFWSdZpGJCpMl2tSUjZ0g0fMPUNbu2EDtrBA0BAytyJLcFtJIHsq9iyxzHdegZ/VKUWVXuwTqv4hkUtbMWdAi4GwWQ6emu/rPHEzvm3aTA7mK8se7nRyYsWmVHUYcnm6GF3RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OuftPGPRDv8S80CTwK6vPW8jlHCLfs/mEj/KGJvqrNo=;
 b=sjBGPQnFZ1aA9VuGixDALrGa2Hbnro3xEaMR+N7nhoem37VRWQ5fZYZSLwQUCuw/dBIJIW2E72BJj/R7XwXwGEeznkMvQd/7S82/mFkpHIyhUDPT9haGwYL8lH7l7C9Gz+b8wDoivIhjX+dMgvDdZgO7jIbloeW5Jv/I0e+oe9SxlGE3tjpFU4sxGWENiSNcKPyA/4F9lUFNNTyxsoFFxWJfIXARJcKBvHoxP5R4rv6SfhW2fwHx5IXus18iI15Ov4CtmHJiuUKTJThggVyy843w46h9GJrist6q6Wy04RqrvDtLmmaB6GwPuG6irZXYL/xniojLEmMyAd/sxPtC8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OuftPGPRDv8S80CTwK6vPW8jlHCLfs/mEj/KGJvqrNo=;
 b=oBWY6y3mMNbgANJ1WosSEB56Xo24VPa3q0LThE8dSgHTI6a/hCkTyvbtgv4qsOR0kKhywS4PFjj15YPjZSQiZB9RzI6EmT3fm/2ovxCaCw4GMM+yCN3oUxEe523jCtrcuEfLDckl/6Q2gMWifloYL5uWKRnLOyeKDHDm4PLY4RE=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by PA4PR08MB7387.eurprd08.prod.outlook.com
 (2603:10a6:102:2a2::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Sat, 16 Aug
 2025 13:03:21 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.019; Sat, 16 Aug 2025
 13:03:21 +0000
Date: Sat, 16 Aug 2025 14:03:17 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com,
	joey.gouly@arm.com, james.morse@arm.com, ardb@kernel.org,
	scott@os.amperecomputing.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 4/5] arm64: futex: refactor futex atomic operation
Message-ID: <aKCBlVP084tZnfqH@e129823.arm.com>
References: <20250811163635.1562145-1-yeoreum.yun@arm.com>
 <20250811163635.1562145-5-yeoreum.yun@arm.com>
 <aJ9in0fUI01J3a4S@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJ9in0fUI01J3a4S@arm.com>
X-ClientProxiedBy: LO4P302CA0026.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::18) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|PA4PR08MB7387:EE_|AMS1EPF00000043:EE_|AS8PR08MB6632:EE_
X-MS-Office365-Filtering-Correlation-Id: 297e5150-8a8b-450a-ed47-08dddcc55adf
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?nc5ikcKdwGFxy7axXCpQH1F01YdMjMTuEWXWglMSUJImprJXPA6tLiSOb6pd?=
 =?us-ascii?Q?Kaocsf8le45uiuvevJ/rkeW1pUdxffWG3vZXJV39k/k2CWolCyw9ey/l2cxf?=
 =?us-ascii?Q?lqP+LcDshBkZDgu/3PKVxttctXKiER7zL+61erqI9WspI6sijH/ALf50Cbk0?=
 =?us-ascii?Q?L9JUdun8Lg7aJ/uJG90UsbdKR/tKTdyz2C3pDHZL5vFGzeCkPt1upNGEqftA?=
 =?us-ascii?Q?3CDN260aMJGp4N2VO0NQF5ikFrU5VJt3bPiPrCey0J1CpRoIpRcIJsdvr5eX?=
 =?us-ascii?Q?SwVpzkcu72fkbktGA4aTt66WwI8QbjXsuK8QeRKrw8EJmpn2Uew2oMi/sBqn?=
 =?us-ascii?Q?61/jP1yrJzNXeN3EqYZVW+L9OsPeXulnSPHdextS3b7vKZKeUI//CPN5RMZY?=
 =?us-ascii?Q?hjJzKX2sd64n/jxuj00xKKN5viltsm0DpJ/WHdWwG9XKjqYCZNw6oqYZE41H?=
 =?us-ascii?Q?MdYctUIRQSBSDAyhEqMDIN8UlDXj2g4YJsUqIluz3kWQRpzqMxx3Miy8Vrr3?=
 =?us-ascii?Q?B8QTOlwLuzT6g6l0JXDBeiquApMmcpoaWOHI53cc8KSnT9NIamxCxDDxVe4I?=
 =?us-ascii?Q?gmllHEdJ6mDDsBSt1pW/M4r5dbbzc/aQginxUvqAHSsQ5zQrjAHl/YlT3WWZ?=
 =?us-ascii?Q?ndstw01wfnyKSi8Aco7FxaznWWtufVP/2D2IH8jqQTlIszW9iPY4Fw+e+4vL?=
 =?us-ascii?Q?GmrTbjRB9kXr+xUBtWhPKhJQLYoM5LLSvwlI35Lo0y2bWOYDbJqIYZe3itWY?=
 =?us-ascii?Q?aftjA9BVLtKxG1HqNqY4ruVu47Af14OWvBHOzoB9/2N8GAu9bCIITTETFB/M?=
 =?us-ascii?Q?aPCpFugVTImXZmBGsvGPrCNdLGUTYjErK6QSdOIuJ9CjwgBl04G1/bLzpeYy?=
 =?us-ascii?Q?mcPwycTphDRcdDzCU0gk6SMuSt4KeGHM6y0bMCTYV4FjiKKrRndjllrYRCtH?=
 =?us-ascii?Q?tc1s9yvbCfJNFi6E/26H0z4A0q47e5A3WWl8kuseU3LCUyVPAFOWPc7sITja?=
 =?us-ascii?Q?FyDK6U43CT/+iMZTV66FHi1ARH2mOvl2mU0UyWG1hHnp9CV7C3oXb9au4sg4?=
 =?us-ascii?Q?El57tWjXKKrvKOEP7yO92EJ1Z7XHUtyhGDoDJq8OYznqHOx+QVXddzyOZEn9?=
 =?us-ascii?Q?mYl4QDWPTxRHYNTc7lo+pzMoBG4niiZyhB6dvh1pcQ7smiMf1uTw6EgHgBVF?=
 =?us-ascii?Q?PNID44JvOoS77doK1plmbyYNBZTWfBcxOVCgpvOYkHb9BzIiWJM/5jDA67Py?=
 =?us-ascii?Q?8TqcnIgYP00qZTdOOcEyXrsACv2PNyLgUD3PKWNHMhBcOElY2wZ7CMQQ92Tu?=
 =?us-ascii?Q?cR8a9pPscZ/qqXUuMOcH60UOf2xj478Ge806OQhrNamvUmkaIDNGtLLMoaN8?=
 =?us-ascii?Q?5AdZyJdVHltZdqenRylOlmUcAbK7Bc3qFosZCFDqN2gDGR9zlq4GMjBm+H4N?=
 =?us-ascii?Q?3GpiLHQ9DDM=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7387
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000043.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7603b125-a06c-44b1-a30a-08dddcc546bf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|14060799003|1800799024|82310400026|36860700013|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?phU558Y3YRdBGXU1ewBnFKv3YPv8aRzlVcH1sLpTxm6aNt9xe+TWC9bIHEI4?=
 =?us-ascii?Q?ROPG9cK20MOJRZvJUY/8lcIY5CHyjkHeH42M66WgboeOia5zkgisD9XcZuVU?=
 =?us-ascii?Q?x1ccxt6J7nM6VLSTGUB4uKLSkD1UUkc3DplxY7oqll9U1rDtE2U1Q/Nbk5Jl?=
 =?us-ascii?Q?s51ZENh7axFnT8tKDgKMD3a9LIEG359/LwcdVZ0d+yVZrTY0P1O+MXzVjbsg?=
 =?us-ascii?Q?Z019tMlwpUtGqwX6dGBt+E/NAz0Irb0rVBUmLRvQycZj1onBHjHofd3PAgZC?=
 =?us-ascii?Q?HmFZhzI4GbLo9igVvnnIbmbuD2XjNdeXGIIJqhIMYYAYKo3S/IqvHA7wQ54j?=
 =?us-ascii?Q?EyR/1IPS8Twf1FiuxXYgFu04GeWgjvwJfh9mM5qlur3kzd/jmiGXLvdmL1+x?=
 =?us-ascii?Q?aikBtKABA16G669tLidB2fbGik891ihQ7HESGdcA8R0g1MXfpDIIuPplqebA?=
 =?us-ascii?Q?+D1uwyvszQJ2ISQrNV3QSTDVvgbLGHaFqWp92o1zJ7OMHyk9cmwHMCs8Eovy?=
 =?us-ascii?Q?2DvuWfdINv2+Vtj09fHQZCJ/+tPfvknFJ/VbN84ZqWPyQ3/OlgE8u6tvR6YJ?=
 =?us-ascii?Q?SExpgus1C2CcQMvM2qf2noomliUsO7ToARqR5UhgGw91zzsj1TebPg+1Nzbq?=
 =?us-ascii?Q?xXxBZq4SNgTgXOfTFTDzV46icJ0iFV0mfaeDlYDo3G8B2FmWR1esg+xWllNa?=
 =?us-ascii?Q?ULVQ7AHRTZnS6jXPlCbC2/eRieaP8Nk37eyU8cQUMLw6lS1R74R6xKyXxEDC?=
 =?us-ascii?Q?x/X8Ep50iETLe7SSPqrHKl8Z40FtmjJ6nvxfUMruTzd5wq5H350Nr8GKSsZ5?=
 =?us-ascii?Q?eAEhMKk5vR92NL8W4wkzKIVLF4madWEe6L9nZ32LG1o2UtHFaT5IeoZjo2/X?=
 =?us-ascii?Q?/kovv92IJj3bbq73wmnjqhuyztmvCNP0Z1p0fGoK62G3yRPj5xNJNyICJ9aN?=
 =?us-ascii?Q?ckwdNbBw2oD2G//fw9lJW64uWqlZrzJn8WUwTRq3P8iHbmsRnX7o0/IEDzcV?=
 =?us-ascii?Q?9SgqCFicAnseUgAJmGzPK1dTBVitifVruuht1def8zbrEoE2CoJkDVSg7bTi?=
 =?us-ascii?Q?mMu55r97EQxU3E+IFtLjr/LNQvCrGP0OkVDP/3l5rX0u7wiftBiE68jIid20?=
 =?us-ascii?Q?lgtK1EcMJVneVCM/kbSXA8wMQ8t8XIEyDRA00Wd3cPjdfCYGQQfI0pLce2IQ?=
 =?us-ascii?Q?QEFza5XMR9blvJhJj63RT0vMfPMfF0Jdu4tonGdAzMGs12YLc0DBqcnqUZAd?=
 =?us-ascii?Q?BjVkaEW6NE4fowQ9tsIbqYrBTZlFX2l2dN9NaCUnwyKnsJVCH8P4h7EiSpTV?=
 =?us-ascii?Q?KNwu6y/Ic+CaL3BvrcaHh9F0Bn+BC2WY5I+MGsxrNAVujCrPqboAbUCPC+/I?=
 =?us-ascii?Q?i27Bp+Bz+p56K96Z7YSuFVcKfJDum7ZqOc1LcfrdpDgRSuCzYw03OOqfBwMz?=
 =?us-ascii?Q?ovPzlDHjz9PKN1YJAVAyGFX4rGRvqm2CCZAQasXvNzlXtqV6p1IqjlZDBnsD?=
 =?us-ascii?Q?Y9CJ+W4/fXtjP5VF8mZxoCMi8Mw51OT9meOO?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(14060799003)(1800799024)(82310400026)(36860700013)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2025 13:03:54.6921
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 297e5150-8a8b-450a-ed47-08dddcc55adf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000043.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6632

Hi Catalin,

[...]
> > diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> > index bc06691d2062..fdec4f3f2b15 100644
> > --- a/arch/arm64/include/asm/futex.h
> > +++ b/arch/arm64/include/asm/futex.h
> > @@ -7,73 +7,164 @@
> >
> >  #include <linux/futex.h>
> >  #include <linux/uaccess.h>
> > +#include <linux/stringify.h>
> >
> >  #include <asm/errno.h>
> >
> > -#define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
> > +#define LLSC_MAX_LOOPS	128 /* What's the largest number you can think of? */
> >
> > -#define __futex_atomic_op(insn, ret, oldval, uaddr, tmp, oparg)		\
> > -do {									\
> > -	unsigned int loops = FUTEX_MAX_LOOPS;				\
> > +#define LLSC_FUTEX_ATOMIC_OP(op, asm_op)				\
> > +static __always_inline int						\
> > +__llsc_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> > +{									\
> > +	unsigned int loops = LLSC_MAX_LOOPS;				\
> > +	int ret, val, tmp;						\
> >  									\
> >  	uaccess_enable_privileged();					\
> > -	asm volatile(							\
> > -"	prfm	pstl1strm, %2\n"					\
> > -"1:	ldxr	%w1, %2\n"						\
> > -	insn "\n"							\
> > -"2:	stlxr	%w0, %w3, %2\n"						\
> > -"	cbz	%w0, 3f\n"						\
> > -"	sub	%w4, %w4, %w0\n"					\
> > -"	cbnz	%w4, 1b\n"						\
> > -"	mov	%w0, %w6\n"						\
> > -"3:\n"									\
> > -"	dmb	ish\n"							\
> > +	asm volatile("// __llsc_futex_atomic_" #op "\n"		\
> > +	"	prfm	pstl1strm, %2\n"				\
> > +	"1:	ldxr	%w1, %2\n"					\
> > +	"	" #asm_op "	%w3, %w1, %w5\n"			\
> > +	"2:	stlxr	%w0, %w3, %2\n"					\
> > +	"	cbz	%w0, 3f\n"					\
> > +	"	sub	%w4, %w4, %w0\n"				\
> > +	"	cbnz	%w4, 1b\n"					\
> > +	"	mov	%w0, %w6\n"					\
> > +	"3:\n"								\
> > +	"	dmb	ish\n"						\
>
> Don't change indentation and code in the same patch, it makes it harder
> to follow what you actually changed. I guess the only difference is
> asm_op instead of insn.

Sorry for bothering you. I'll restore indentation to make it clear.
and yes. the only difference is to change you mention it.

>
> >  	_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)				\
> >  	_ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)				\
> > -	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp),	\
> > +	: "=&r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp),		\
>
> And here you changed oldval to val (was this necessary?)

Not really. I keep the "oldval" as it is.
Thanks.

>
> >  	  "+r" (loops)							\
> >  	: "r" (oparg), "Ir" (-EAGAIN)					\
> >  	: "memory");							\
> >  	uaccess_disable_privileged();					\
> > -} while (0)
> > +									\
> > +	if (!ret)							\
> > +		*oval = val;						\
> > +									\
> > +	return ret;							\
> > +}
> > +
> > +LLSC_FUTEX_ATOMIC_OP(add, add)
> > +LLSC_FUTEX_ATOMIC_OP(or, orr)
> > +LLSC_FUTEX_ATOMIC_OP(and, and)
> > +LLSC_FUTEX_ATOMIC_OP(eor, eor)
> > +
> > +static __always_inline int
> > +__llsc_futex_atomic_set(int oparg, u32 __user *uaddr, int *oval)
> > +{
> > +	unsigned int loops = LLSC_MAX_LOOPS;
> > +	int ret, val;
> > +
> > +	uaccess_enable_privileged();
> > +	asm volatile("//__llsc_futex_xchg\n"
> > +	"	prfm	pstl1strm, %2\n"
> > +	"1:	ldxr	%w1, %2\n"
> > +	"2:	stlxr	%w0, %w4, %2\n"
> > +	"	cbz	%w3, 3f\n"
> > +	"	sub	%w3, %w3, %w0\n"
> > +	"	cbnz	%w3, 1b\n"
> > +	"	mov	%w0, %w5\n"
> > +	"3:\n"
> > +	"	dmb	ish\n"
> > +	_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)
> > +	_ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)
> > +	: "=&r" (ret), "=&r" (val), "+Q" (*uaddr), "+r" (loops)
> > +	: "r" (oparg), "Ir" (-EAGAIN)
> > +	: "memory");
> > +	uaccess_disable_privileged();
>
> Was this separate function just to avoid the "mov" instruction for the
> "set" case? The patch description states that the reworking is necessary
> for the FEAT_LSUI use but it looks to me like it does more. Please split
> it in separate patches, though I'd leave any potential optimisation for
> a separate series and keep the current code as close as possible to the
> original one.
>

Yes. It's a small optimisation -- not use "mov" instruction.
I'll separate that part.

Thanks!

--
Sincerely,
Yeoreum Yun
