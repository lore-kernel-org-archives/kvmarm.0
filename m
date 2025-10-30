Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010067.outbound.protection.outlook.com [52.101.69.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550372475F7
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 13:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.67
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761831858; cv=fail; b=GN2rCHoR7pAyi8MgjhOyyin4A5dfeXO7ZKCYgThf3RsYSGrc+KTEC41ATR27SZkNOD1ZzOq6UuqtnonZJ3OKvaD8bnP7Mm7EmWJlAIIm+F2MZkksXtxnl05Nq033PklTSR4zqQgDpfUJQveaJoVlBpBCOg34mBNjaLk7tQWcKJ4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761831858; c=relaxed/simple;
	bh=8QC6+9e+AFHFbplyzFWljcItBUSDLMr7CqP35sF08zI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZyTP7UvK+6ps0bRs9GKGHdUBYk9kOjvCAu82Pa3CDYRIAWxSlVx5PdULUZQzzkxEsphGoNjqDUmRM6nwgGSBPKt9qfsJXGDK4DjzOtfgVDOp+0Rj/KsMvN4IAZje4THLkwZi8xNbkq7HNRNn+qYhfLIoSIFKiQhw0Dxu5+H9aGc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=B9T4uWCX; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=B9T4uWCX; arc=fail smtp.client-ip=52.101.69.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="B9T4uWCX";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="B9T4uWCX"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=DIFmUY+I4V0GqU39c17HaD4e2UHn1ZXouve/iOEDsICgO/56AaruyWeNCkCyIhqd8SBkmZx/U7QdHYLa5i+3sQuGMfysaiz1KVpXaJ37lvP1LQa+upzqfInobH43/Cn0LIdbMPx1IYTnICRzfyC2Wwc/daXQitmnL2ffhVKglzsk0FE2jpFV4A5MUNnIirHnjJq7dGTCopEAIpa84t8Rtrsmk6cy6/1q9FHCpk6SmoWJNGJbxi/itp2V4b6jPJwk3d4XOAl0G9Op4X4z7vWVUyhC9vTM9Qp1X9RwelzJbivIho79iW9++OyIcWhGHjJtaG6ik3UL1de2Juu719t+Mw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKpww5m50l9L4wzVwk9g/1WWpy5+tAeMIyQIQS+2KX4=;
 b=y8dcLNbwimrn0vsOMGCYlA2kmewdeHhbv9ysfusZqksGcXtSYhRSvaFZCd3GV8XaiVwf2T3JdCBLxcJgRDwPyq27sPqtj2d4iDOniG4TFvAHIzl3WJepi+gxUOCcCC3uKSZHTf5PB+zjy88hKTxkNp7sTjJtQmFy0LvBZdMjy5ZXNU9t0g/gljChATnfmHl2LJXBMO+yZPoVxTrkv8jT98NuKYshlgv3FBF0B9nLnw0Let96A9wcVpRe3/N8IIQVmyRZPQoka+OHQEX6UOrbbmtob4ZMw/JMaZCH6q7UU9oM9hnX9R/bNVreLvcYPcPOjMV4cehHywLauRVhWVoLZg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=immunant.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKpww5m50l9L4wzVwk9g/1WWpy5+tAeMIyQIQS+2KX4=;
 b=B9T4uWCXa11tMtPRYvxOn8ZVAhS9lNxwu/d1BBRg4ku4/TVjKCGVQuayWNyeKOlCMBw8w6OL8dqg5yHyYVvU9w4wiInPhQJq5xumBrACJ+shD7VF5TD+qumHIInsR1lb7B5F/wL8UyC74v2OgjRlNyYfYtiYzmk+IrtqR6mCNyw=
Received: from DUZPR01CA0174.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::23) by AM7PR08MB5303.eurprd08.prod.outlook.com
 (2603:10a6:20b:102::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 30 Oct
 2025 13:44:12 +0000
Received: from DU2PEPF00028D09.eurprd03.prod.outlook.com
 (2603:10a6:10:4b3:cafe::61) by DUZPR01CA0174.outlook.office365.com
 (2603:10a6:10:4b3::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.14 via Frontend Transport; Thu,
 30 Oct 2025 13:44:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D09.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.10
 via Frontend Transport; Thu, 30 Oct 2025 13:44:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jmDiDmjWy93ullmN/NoucrMl7aM6fcrFD1UGhZOW0WC8l76iRGL7xFH8zwhn2V3HEmHaayDHUFzozBmeuM39F1d39dhcAL5X2YrCgLX0ACTsiJKoeBXMB/71OVwJQQLcAIgNXQvkbkiq+IJc+RhoGRfgvmLNickgCh2+33J2KZAKIu2mG2d+7HMXcYdUGtKZ2ycJ7S9AGWPo5Lua5l3aR6G2W69adAfa5lmUvjNf6A5lv1ldY5RzC2PLd1AoJDSqNKjTARpWT20BuVbS8PTYXIx5X46eBSfFHrURvsKLqh9yQ6CybU3l1oPXy7CCAVIoI4WdmTFxzO78qo4Im915VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKpww5m50l9L4wzVwk9g/1WWpy5+tAeMIyQIQS+2KX4=;
 b=VaW0NrNhNUgC8hXOdjXH3Ehp0gaMkT1FtwACwxN9lyJ2sicRUamAsbWGyAvOKa1b8kvYQQcm7glD9lpg8QTD70+LFxwS/SlVGgDLefG64a62AkTPAj7s2qVf/kxlWHVlt0OP7S76JS9A/kS6/tSuT19RcuOJHCYW3Bfap0KXHDA5rGfJKQjjALAG5rkScZdYqbEHVVhf5BQVGmyxeR+9iJspi2p5deSY/6RZUk871jneJvVrV748CsD+LMZQS4kF4sZAzGW7UfhP+OMcSKMFON9NCmP9iv7ypqUHCWZ/WJBwoXigXZ7y2ZLoucYXC8Rp7bYLFAmF1gF8Ws0A0CluOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKpww5m50l9L4wzVwk9g/1WWpy5+tAeMIyQIQS+2KX4=;
 b=B9T4uWCXa11tMtPRYvxOn8ZVAhS9lNxwu/d1BBRg4ku4/TVjKCGVQuayWNyeKOlCMBw8w6OL8dqg5yHyYVvU9w4wiInPhQJq5xumBrACJ+shD7VF5TD+qumHIInsR1lb7B5F/wL8UyC74v2OgjRlNyYfYtiYzmk+IrtqR6mCNyw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB9PR08MB7651.eurprd08.prod.outlook.com
 (2603:10a6:10:30e::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Thu, 30 Oct
 2025 13:43:38 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9275.011; Thu, 30 Oct 2025
 13:43:38 +0000
Date: Thu, 30 Oct 2025 13:43:35 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Per Larsen <perl@immunant.com>
Cc: Ben Horgan <ben.horgan@arm.com>, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, perlarsen@google.com,
	ayrton@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: support optional calls of FF-A v1.2
Message-ID: <aQNrh1BG8KSkLOHg@e129823.arm.com>
References: <20251027191729.1704744-1-yeoreum.yun@arm.com>
 <20251027191729.1704744-3-yeoreum.yun@arm.com>
 <f5aa3c19-fdea-4f62-9541-530e59b20a87@arm.com>
 <aQEwVe8+okm/Nmso@e129823.arm.com>
 <61e923d6-388b-4cc6-8c26-5581a1e1cc10@arm.com>
 <aQIYZoP5iKcwtXwW@e129823.arm.com>
 <96171283-6f2a-45b5-b889-be1bee91678c@immunant.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96171283-6f2a-45b5-b889-be1bee91678c@immunant.com>
X-ClientProxiedBy: LO6P123CA0009.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::12) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB9PR08MB7651:EE_|DU2PEPF00028D09:EE_|AM7PR08MB5303:EE_
X-MS-Office365-Filtering-Correlation-Id: 2007a5c6-ae91-4e68-c18b-08de17ba689c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?+DAP9Rh4O4KjyMWp/Nza2Q5PqsIFsgc1TNr5XEd7+4A++xfb8yFSUtKQ50au?=
 =?us-ascii?Q?eljp4RKM0TnuQp68YQGgV57H1C6eM0D9qjV7OTaoyM2e3k+2jKzqZ4rFvrK0?=
 =?us-ascii?Q?xfHCZbPhsAm7PhDwbTIe7RZL/KEOGwwQP4aR5bW5pcvxn+5BGdTRw2dYpGY/?=
 =?us-ascii?Q?nBeQiSuf6TEf6BdiZOXF+VSsxxeITBNPUcfXB0aaXg6K0/hzllM2oTZrD1JI?=
 =?us-ascii?Q?1xCi4V+AAVUt6dFp/8KDmDasZ9MrLg3OqmCcSqst7tidqUbb+KK5sMO4obkI?=
 =?us-ascii?Q?hBJJFHO3izkwwYKmwSP8ZRSeNurcGplgiTMdxktMCM/ksoN9zSwMMCqAH0gV?=
 =?us-ascii?Q?0Z16TTlNqbCWdx9K9XcwC477jSXVjtPIoi9CPyYBJIu1meq2XgRW0Yek+F0z?=
 =?us-ascii?Q?dLOkxGMliAhxJNKAILVrrf2vX34lwPNFzU9eeE6MTWW3ns46F2DI8t8v9ALT?=
 =?us-ascii?Q?ahf/OjprIBA8U1tD3S65d1hu/dAjibyDMI8NXvv+iQ1kUjJHMhwOq7KQhsG6?=
 =?us-ascii?Q?RZ+/GXUqc4tZp+Gzm6Pn54Wb09dcBZly9jieTKTHuHD3LwFIKVGukEtG+2r3?=
 =?us-ascii?Q?OTZJ8pPDQec4Ug7vJgZsQe3YhCzGgE1fxNZUb23ARdh1+EKJktOlmf+3yZBC?=
 =?us-ascii?Q?gyi8fNMTrC7gnTC+MdtS8cWs7vaBBs2lrv6woP7mlnIR+WJ0ySou1WCEk9YI?=
 =?us-ascii?Q?+xgh+JqRYCJ/7xewzx7c1n+GKnG4UWRtVTiJRo9OmfzT57ccWc00BYhA+SEl?=
 =?us-ascii?Q?yMp1pns9TykLgO6bvAOiTL2rQGf0IQzn762gb09uXj2+C+1qyRjTxklPqFu8?=
 =?us-ascii?Q?miqngLGvoE2xsDnYlUHwlrHc6p6/ufQlKHjdUV3zI8LDwuvjARCjK+HVM0l9?=
 =?us-ascii?Q?QOszl9VufsMFIihOiMO5CoZRu8guPO/VRpDK+W3bh1nXwALloCNDOgYudLHN?=
 =?us-ascii?Q?X6oSYz6E8LtDOWJEjSA5w7GSEBlXmcWH5oVkD1VK+LAgjrxSv3aGjzKxJyMx?=
 =?us-ascii?Q?LL/17IcAdvCSla4c4V0kBkL6IWQSOlr+Bnt504M28iEnqMknAxQ6XINh14QE?=
 =?us-ascii?Q?avDV6XHo89rWdAzcO/j+r9cLa4l0V5KtsA8gMzGqBT+JUy4wH3GEHOuIsVfx?=
 =?us-ascii?Q?/DfDQIZS2HAggPKrtqzFMTicK3NJ8hNEo1v78BMI4G17wSk+ta3dJFE4LUh8?=
 =?us-ascii?Q?rWzBIEz4JgClHYpXwkRvkGi7+Y9wENDCizHMX9MjnGRvfwNgrMVSlLn+TxXH?=
 =?us-ascii?Q?EJz59Mbh1pIBPyhdFFeV9WPzImIyyh0IRBtGaePwUyI/P8O0THIrY7x3/Ky+?=
 =?us-ascii?Q?XFYBKfvAjTdjIywSgWa+NxYPTwtPYBsipghTu+zM3iQnbQGeLr27wuQt1pks?=
 =?us-ascii?Q?lG5yDfPQWMouZTSIj+MGRf1ur2bHZuXyZpeqjY6pbfrbBoQGItvJcFqKGY9H?=
 =?us-ascii?Q?VdhsziBi6cg=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7651
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D09.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9320798f-a986-4e89-9550-08de17ba5450
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X57wq+boYQsgyVYcbq7NuRgtpdk2MMuwv5bxXyvGrYUrSEUgptr3G+auf0tp?=
 =?us-ascii?Q?D+hDVeaKaMB4TBu/bB1Q6eLtlO4nEODJ80xqbbPfMatGNEGIdyQvgouq9NXP?=
 =?us-ascii?Q?phdENKFKF1+uKmIvuu6O794gVmHyA4OIp82tyGfUotfHTbnQJt9VIZpcel9T?=
 =?us-ascii?Q?RsvhXn3xlNxzCmJNqW8QFGLr9uDeEIAIUf/71GmT9t2h0ZL+XdIggy6lHErR?=
 =?us-ascii?Q?Zu3OpKYofiTSCWD5mQLejsjNT8OOxyZJjD5sq50N5UIJ0e3AN4Q/tAkfUIoh?=
 =?us-ascii?Q?RiXiSFSvVF6BsKht7CCiWCE+fWdIOTGyfiOsfVF+LK3kMxbPb1C9pzIRTfYp?=
 =?us-ascii?Q?BCl6cYnjeUP01V60KLQhRvKG6NlUn4tvXNDyr5APwxB+ODvyw4NPztEktHwU?=
 =?us-ascii?Q?enlFxb0m+4n5fEztfzPjyLaowjurMiAvF7pREQhUsx0uCT8Jr1f1NPcuXFv0?=
 =?us-ascii?Q?kBimDMtppKlb0XaAiEjd8S2B28+Gorrk2rKPj7GUuSuTi8STbvmADup64dwX?=
 =?us-ascii?Q?WrqCV2HSCsOjgWDhHRX2QSUfaP3nJeiSqRGCcNrXfjyGFXYMZWcwNGliJ3VV?=
 =?us-ascii?Q?VH5LD2hi8ZTnvp6M0AKl0ScMRMyblDUXnWyjOfi2f80KUNMsY5O265mdA4Eh?=
 =?us-ascii?Q?8djoxEsTX5AG07ELWXROAmcAWKFqia11Q1eMxGgKkq17P6zYqLN0NoJwUTlX?=
 =?us-ascii?Q?5sFz0Q7rSbFC74uj3vIgssHH/JrQIgu6DjXun6Y4w/pRj4eL/JJaKS2YC0KD?=
 =?us-ascii?Q?cCiDdPMCxlcNPX27Wr/meqcn2dLy5CkjCoX8UmccDLFiIRiDpsOyx2BIPmWV?=
 =?us-ascii?Q?evUA1g4wuywaaGUYmaUgKjOM7XZNf/Y1cXvCJOzq5eZ/FrJR7kg7V+r93J0m?=
 =?us-ascii?Q?81gAY5z4WALnr1QFFpiNBKaT/5t+MqC09uZYF0DbuLlt4c7pBLb7ae6fOulF?=
 =?us-ascii?Q?siiTeoI2qjp0hNoV6mEPN/Ui3lyuWFVs+R3C3ac6ROq0hVLOMp35PppRq5KV?=
 =?us-ascii?Q?RmXGYh3mPPkKy8AUWbZZ2tqwWLwXHt7paDFSIL2F6RlioI2qOWbmj96+ad6L?=
 =?us-ascii?Q?iZX4X6pmdsygdS/gfZ/M1by00JvQxMwaPUn0muqFr4b8rdPIAKY34jFKZazy?=
 =?us-ascii?Q?YXkyK84lQgNwuh46rBDZWYRLHJEYdceDZx0IVqUc+QOHKp3aPCZW8unLzigH?=
 =?us-ascii?Q?1ZsuBvBo63Qtho4R6lD8kRV1oYCli8B/Oh/GnQB/Aczcmk3GT2mmEPWkzbPf?=
 =?us-ascii?Q?KOC7mWHn64bnz2WHd0gjqPFZTHwFRF28lWz93+DOGszaV+JHG2IZypwWUjnj?=
 =?us-ascii?Q?ZbNZ59F0N3Oun992yWvx54zPHni3NThVFnsCCa+CaNJ5jBcb5LyPaRgBSP/a?=
 =?us-ascii?Q?97vznFQG7EJtRnnEvGAx2Iv/FAdwP5nyO4V1LzjfsW7S01zivTqT93N9GLNo?=
 =?us-ascii?Q?dXtIoYw90cP1U560EPcNoKyUxyJ86fHsKhwkr2Hvrv4cnJlkocof70jfTJKa?=
 =?us-ascii?Q?hkxAWFUYN6XWzPortQ3IBP1ytPq0HuNc3van?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 13:44:11.8381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2007a5c6-ae91-4e68-c18b-08de17ba689c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D09.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5303

Hi Per,

>
> On 10/29/25 2:36 PM, Yeoreum Yun wrote:
> > Hi Ben,
> >
> > >
> > > On 10/28/25 21:06, Yeoreum Yun wrote:
> > > > Hi Ben,
> > > >
> > > > > > To use TPM drvier which uses CRB over FF-A with FFA_DIRECT_REQ2,
> > > > > > support the FF-A v1.2's optinal calls by querying whether
> > > > > > SPMC supports those.
> > > > > >
> > > > > > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > > > > > ---
> > > > > >   arch/arm64/kvm/hyp/nvhe/ffa.c | 19 ++++++++++++++++++-
> > > > > >   1 file changed, 18 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > > > index 0ae87ff61758..9ded1c6369b9 100644
> > > > > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > > > @@ -646,6 +646,22 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
> > > > > >   		ffa_to_smccc_res(res, ret);
> > > > > >   }
> > > > > >
> > > > > > +static bool ffa_1_2_optional_calls_supported(u64 func_id)
> > > > > > +{
> > > > > > +	struct arm_smccc_1_2_regs res;
> > > > > > +
> > > > > > +	if (!smp_load_acquire(&has_version_negotiated) ||
> > > > > > +		(FFA_MINOR_VERSION(FFA_VERSION_1_2) < 2))
> > > > > > +		return false;
> > > > > > +
> > > > > > +	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
> > > > > > +		.a0 = FFA_FEATURES,
> > > > > > +		.a1 = func_id,
> > > > > > +	}, &res);
> > > > > > +
> > > > > > +	return res.a0 == FFA_SUCCESS;
> > > > > > +}
> > > > > > +
> > > > > >   /*
> > > > > >    * Is a given FFA function supported, either by forwarding on directly
> > > > > >    * or by handling at EL2?
> > > > > > @@ -678,12 +694,13 @@ static bool ffa_call_supported(u64 func_id)
> > > > > >   	case FFA_NOTIFICATION_SET:
> > > > > >   	case FFA_NOTIFICATION_GET:
> > > > > >   	case FFA_NOTIFICATION_INFO_GET:
> > > > > > +		return false;
> > > > > >   	/* Optional interfaces added in FF-A 1.2 */
> > > > > >   	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
> > > > > >   	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
> > > > > >   	case FFA_CONSOLE_LOG:			/* Optional per 13.1: not in Table 13.1 */
> > > > >
> > > > > Looking at table 13.54 in the FF-A 1.2 spec FFA_CONSOLE_LOG is only supported in secure FF-A
> > > > > instances and not from the normal world.
> > > >
> > > > Thanks. in that case, we can return false for FFA_CONSOLE_LOG
> > > > unconditionally.
> > > >
> > > > >
> > > > > >   	case FFA_PARTITION_INFO_GET_REGS:	/* Optional for virtual instances per 13.1 */
> > > > > > -		return false;
> > > > > > +		return ffa_1_2_optional_calls_supported(func_id);
> > > > > >   	}
> > > > >
> > > > > I don't think that an smc call here is the right thing to do. This changes this from a light
> > > > > weight deny list to an extra smc call for each ffa_msg_send_direct_req2 from the driver.
> > > > >
> > > > > Instead, I would expect this patch just to remove FFA_MSG_SEND_DIRECT_REQ2 from the deny list
> > > > > and rely on the TPM driver to use FFA_FEATURES to check whether it's supported.
> > > > >
> > > > > So, just this change:
> > > > >
> > > > > @@ -679,7 +679,6 @@ static bool ffa_call_supported(u64 func_id)
> > > > >          case FFA_NOTIFICATION_GET:
> > > > >          case FFA_NOTIFICATION_INFO_GET:
> > > > >          /* Optional interfaces added in FF-A 1.2 */
> > > > > -       case FFA_MSG_SEND_DIRECT_REQ2:          /* Optional per 7.5.1 */
> > > > >          case FFA_MSG_SEND_DIRECT_RESP2:         /* Optional per 7.5.1 */
> > > > >          case FFA_CONSOLE_LOG:                   /* Optional per 13.1: not in Table 13.1 */
> > > > >          case FFA_PARTITION_INFO_GET_REGS:       /* Optional for virtual instances per 13.1 */
> > > > >
> > > > > Am I missing something?
> > > >
> > > > Nope. I think you don't think you miss anything and
> > > > I also think about it.
> > > >
> > > > But, I'm not sure about "support" means in the pkvm about FF-A.
> > > > Anyway unless the SPMC doesn't support the specific FF-A ABI,
> > > > I don't know that's meaningful to return "TRUE" in here.
> > > > IOW, suppose pkvm returns supports of  FFA_MSG_SEND_DIRECT_REQ2
> > > > but user receive when it calls FFA_MSG_SEND_DIRECT_REQ2 with NOT SUPPORTED.
> > >
> > > As I understand it, the ffa_call_supported() is used in two places:
> > > 1. To return NOT SUPPORTED to an FFA_FEATURE call for ffa calls that are
> > > on the deny list.
> > > 2. To block ffa calls if they are on the deny list.
> > >
> > > For both your patch and just removing FFA_MSG_SEND_DIRECT_REQ2 from the
> > > denylist I think the behaviour is the same.
> > >
> > > If FFA_MSG_SEND_DIRECT_REQ2 is not supported at the spmc then:
> > > a) an FFA_FEATURE call will return not supported
> > > b) an FFA_MSG_SEND_DIRECT_REQ2 will return not supported
> > >
> >
> > Right! I've missed the FFA_FEATURE handles via default_host_smc_handler().
> > As you said, it just a deny list.
> >
> > Thanks. I'll change it.
> Sorry to jump into the discussion very late. I uploaded a patch set which
> adds support for the FFA_MSG_SEND_DIRECT_REQ2 interface which was originally
> developed for the Android common kernels:
>
> https://lore.kernel.org/all/20251030-host-direct-messages-v1-0-463e57871c8f@google.com/T/#t
>
>
> Since there appears to be an upstream use case for this functionality, it
> might be a good building block for the present patch set.

No worries and thanks for sharing.
I'll take a look and let me rebase this patch upon your one.

Thanks.

--
Sincerely,
Yeoreum Yun
