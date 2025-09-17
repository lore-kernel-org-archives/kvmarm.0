Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010023.outbound.protection.outlook.com [52.101.84.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18A32EA721
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 09:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.23
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758101613; cv=fail; b=CGClT7v5vLTIRCBW1SL0CZIgyHX1a5TpJNdOPWjdLGBLAD5I9BTn1WL8Iy7fGQ2jlMlSCM/Cxq5FEBFcJ4AcUFBqPziohBjRQ/pqq/s8tA+4Ko3zBN8vOgUeC6ili+pLqiFbtTjFBqMJU/SlWWoNVI8frBdjq8pEkuEiCMXbjk0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758101613; c=relaxed/simple;
	bh=9ju0QmrULkhnrkABhKcwpV7mUwoaePbKJQ87EkvLqJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GoIrjR/1k8UhAVY5/uw+pWueXT55b3K9r9tJkBJK57684Lfuuc9snDp1yRl5ph11o6UxDln/7gqvGH7GVVnBGZ1bRMvYp/HVqB1p9Fer2rckWkjFLtXDUhgacb5N7YQwl8eKPYRf6qyM+9473f5iMvfwuTSuhh8lls+/ij6yRQQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H4BIKDRj; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H4BIKDRj; arc=fail smtp.client-ip=52.101.84.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H4BIKDRj";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H4BIKDRj"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JM2pZpzG0gZOouUZEGiytTxlAxU6jquc3dR3vZCYl2VORO5//Q7C1aXomBUXw2Q62siUAMlXXNEX/aPmBku5ByKjRcLPsOHIiAK3kbCarOCo9dDZrP2dZ6CMhodcX9tDZex0b46m/pxJ4EzUu3OBwI8Jc/fLbR54DkaWJwTAKobr7UhjikA5Haup4PMXTYJmZh0FG/lqiIIqveJ3YG+iwISItwGELStZ21SGzIJ1zHvdcm7g/FDJBK0taKOk5PeFPjwS1xqWLBh4Z9VTfZFByvTgTUNyUCshNihkicXj5dliIlR3QSu5Tvia6YXMJfS/5s5nJxZGnnLrMRl/jXOYwg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fpiN4/0jR/shcRWYsfG4s6zN08JkIKRpX0Fyej3/8aY=;
 b=jrzfgnaTWgqZZq4iRQmLN5RQIty73GYQtC61CN7s1/kcU67v5uAaT9dr/MIZ0v0svZVHuyy+PHB6MrNFHd+++P9MlMw+Cx76U6AoQ4XxJ6u6y3o6z75xqka5ddJgHCGFZiJgWqVY0Z9c94SURVi/v1iVzUilApNsqfL5lXCdSS2TdsLIBj3zQa4bIhLfNBuJEpoKMEoMAkS9Yi9qHVxx3vSfw+DZ3zbmqfUANNtuafMrBnmqnudxyKoNxNnpDyfkasd/APypaGvy+dLPAnZjqDO4OqLxwMQ9Hk1KvoqnsTQO/aKPAa7rSkkN8QUFaYP5hNdV0pMwF+kfq0AeR8aTJA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpiN4/0jR/shcRWYsfG4s6zN08JkIKRpX0Fyej3/8aY=;
 b=H4BIKDRj5bWjzXxSMW2fQ2f2UWLX247FfaGZH6hQhx0WgO1Us7peEnlNSv4Kulu4LoBhtCR4aWQoLHfllAvGbgvCt7QmJRB1sIF2O06XbAohjJ3/1+7O/gvcDRwHCWx0CYRJ1lwg3fyuxV1Os3Rtu2Dl93NKLTBBkAO1PYua1/0=
Received: from CWLP123CA0246.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19e::20)
 by DB4PR08MB8101.eurprd08.prod.outlook.com (2603:10a6:10:387::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Wed, 17 Sep
 2025 09:33:25 +0000
Received: from AM3PEPF0000A78F.eurprd04.prod.outlook.com
 (2603:10a6:400:19e:cafe::2f) by CWLP123CA0246.outlook.office365.com
 (2603:10a6:400:19e::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Wed,
 17 Sep 2025 09:33:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A78F.mail.protection.outlook.com (10.167.16.118) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Wed, 17 Sep 2025 09:33:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jzDwWmmnmIH2M9LoLlpI1C+lyAWnnDTaVU+KS8e7YTDs1HHh98ap14hJl0WPO43pbBmovDDSNJsL+GC2ORYbq1WZnfDEmQKs4hdiv41r19NkI3gc9ZX9Na9S0Csk0JQFOl6RmW4B260wjRSiiG56e7/GQQVV48iC3Uh23JbrRUvsbR6IkjF0305plb9rhqVE4W+JzOjyE9dBXY42d0uKvzxm9oatT+5XSmVsRK+i/zQ6dRfEET1jmz+Px4CpyPgkJS0u+SubsShjwce9BUu4zrDLO9F67sCClCw8puPkjUrblyX5lttq8BGId1kViDqrDJ7js9ANDq7hyw3N3pWiAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fpiN4/0jR/shcRWYsfG4s6zN08JkIKRpX0Fyej3/8aY=;
 b=MzeU/4hsH1TUgoJY2wJ1cnyGCiUOVoRQgvVcNn78ti07FWwxZaQ328ABTxj/SkHjmxXb9cf5ab/3kOzLGxIcPemWwKq+Ljds2oFx9MSLyHnDiZ2IXkpK79KMBiSlqBLD2vvKdhe87ZAIxQMcu9nPqm3Cvzgz0GRpqdS0w6YHIKr9NQ33TFbSNY9iVjfDMMjqHICWBZxXHA0F4Ont0lr2JeA1BXn8dGB4C/YPW1ZHW7zH8jIa9/X7hIpB10QYNI8GwpTDlCUGGSbQWcNlqSckyRD5nVs7MEd9wcMXTtE0uF5Vg5E/hKnYk/ZQBaNCHnsTfUzfCkox0U1eO6/H8dVvmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpiN4/0jR/shcRWYsfG4s6zN08JkIKRpX0Fyej3/8aY=;
 b=H4BIKDRj5bWjzXxSMW2fQ2f2UWLX247FfaGZH6hQhx0WgO1Us7peEnlNSv4Kulu4LoBhtCR4aWQoLHfllAvGbgvCt7QmJRB1sIF2O06XbAohjJ3/1+7O/gvcDRwHCWx0CYRJ1lwg3fyuxV1Os3Rtu2Dl93NKLTBBkAO1PYua1/0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by VI1PR08MB10123.eurprd08.prod.outlook.com
 (2603:10a6:800:1c7::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 09:32:51 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 09:32:50 +0000
Date: Wed, 17 Sep 2025 10:32:47 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, broonie@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	james.morse@arm.com, ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMqAPwNmD6HxqUFh@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
 <aMRQIeIdyiWVR8a0@arm.com>
 <aMfrR0vserl/hfZ3@e129823.arm.com>
 <aMhrscd1gz_syMtL@arm.com>
 <aMh4q4-xAPHnaOul@willie-the-truck>
 <aMkLb6jPiSbzeRWL@arm.com>
 <aMk1qxS3htyaTgEQ@e129823.arm.com>
 <aMk49UZ1EiUu3-Y2@willie-the-truck>
 <aMldMSCz+zHBguRK@e129823.arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMldMSCz+zHBguRK@e129823.arm.com>
X-ClientProxiedBy: LO4P265CA0300.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::10) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|VI1PR08MB10123:EE_|AM3PEPF0000A78F:EE_|DB4PR08MB8101:EE_
X-MS-Office365-Filtering-Correlation-Id: e9431877-1bd9-4907-fe58-08ddf5cd3fe6
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?dRoOFoytZLGXomoT37FuWOSqqkabtWgAKbSSgvt5hHLAgBCat88uKxmCRB/5?=
 =?us-ascii?Q?Pcecx6zOtYo/x73kONRaJpdJEsy6CBqxB6cBGLGyVRB219SUPE6yl+rG8NoY?=
 =?us-ascii?Q?HNUskYyWlkFBqPt6nL7qz1bCuH7VBDiWMLu/yuin6IbiTeASNxjEheAK0UeH?=
 =?us-ascii?Q?b6MZxTLhYwdIzXf6DyfA+5H+T+M43hB7zGAE2wtmypdX3RHrenbLYjDVuMtx?=
 =?us-ascii?Q?XmBRKSGXf1KZliKwvk12Ax9N2a7Lre5Bm5Q6iM1Mwf78+1P7hwWvs76j6lcf?=
 =?us-ascii?Q?NJdH8RqXJjDvV3yIQQDyVRySZbepkXg9ETjyzp/mI5BkJdCzeyZFZ6o1aQjj?=
 =?us-ascii?Q?BCrMaCbqQVFgZySCQMadWi3uUwDQao+Hv4h4IvHpwJIY15s7uj1D5gCAI5Vy?=
 =?us-ascii?Q?QFZcoJ8epk+26YkCFY/l82omkY+lj41Fb6PeIl+iz0Rp9AiBJ3bLyQnFQ/aV?=
 =?us-ascii?Q?83xMSj+eqIVOFyY8uaqU0CqoOyGRlAGHkdl2UtoypmrqTmJnehZAw6cVla67?=
 =?us-ascii?Q?sPYqw5uQ07iNE1FYL39RJLpRe54aqpDYznrjg06re1XChBAA3EBeJFYUExpi?=
 =?us-ascii?Q?6pP7+JKVT2fMhBTJkB54PNJEBjDo2nyZWeLC035eYsgCOk8AematUes3V4l2?=
 =?us-ascii?Q?RRlztNxFOy7/bT9IM077aoSX3uLL3u0i/AicL7rzxHWlKw3+3cZ4lLMXvvd5?=
 =?us-ascii?Q?pKCnU1dpnbG32OzM2BsH17Dcl/gpaixwxnnsqNbpMAJAFQwYIGML/g5o+4uY?=
 =?us-ascii?Q?6YGuwPPtLgDVoTxA60L9lIYlPPBGEG9SxPB5Xn7ZnNheWC2op24wK8FBqZ+p?=
 =?us-ascii?Q?J6zKM9BHEz8SsrsFBxCMcbrj979aoD6DUKJbzWs+B4BkoonTXoS958/Z9Ff9?=
 =?us-ascii?Q?w46+ZhcBVC4rYYyo5ywWzhr5KhfhnC8hNfxAb+bCxv3JP+Sr8U68IjrfqolA?=
 =?us-ascii?Q?Ev2gO2jdkczBPsUfjxZcqq/O0tDsM+73TpIOlv5E5NOV2yFEJbxWP17PcYSN?=
 =?us-ascii?Q?jU9Jr82yUnRPwvWwxzoPfYBlch0TWPZ8zrXYSPhTAWIygoEEooaQFdAbQRV9?=
 =?us-ascii?Q?ZvK4/4E81GRHP/r5W7POpt54GDbxJKOOj7ekOd5czss23MwZP4RritkOMd7l?=
 =?us-ascii?Q?YX0Z8nLhBT5hj1BXxZ+sqlCHmiMaU3mtLSiZ0xgRYKOatr6nnLQICIibjTkL?=
 =?us-ascii?Q?d0ibDKqjMfyQnIMZHIZknQG5NW1nG4kB7P5tXJNS8OFQWGonv7zdtsdCulNZ?=
 =?us-ascii?Q?9e3paHxkz5spqqo2ms1itQPQCcpyfQXBaxLVKnmSq8EvpGMpIADbsG4ir53e?=
 =?us-ascii?Q?HuHWATZVVhmdCMhxOkhTD0/MrYFvgduD0TSph0B0LXNR+yaR7JU2gME3MhKL?=
 =?us-ascii?Q?CQkDkJC2RHIBt1KbtzLKouOGtMuZYUheOdcVDpxmia+0wKPhJU7lW5NbEUCA?=
 =?us-ascii?Q?tLP5O3wl/Fk=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10123
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A78F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	be0b35e8-0119-498f-2a27-08ddf5cd2b81
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|82310400026|36860700013|7416014|376014|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?43HO/qZ2XiL2J6hxTamfnLyrK+RoxbROBVkLB2BA1+0le+TA0B7gxqrbiGdf?=
 =?us-ascii?Q?lz4/TuOlsgcWvqdqknTU6VH2OGZxwpEABgyf2+y0xIbOnD3gXP5YfkWl3L9x?=
 =?us-ascii?Q?HsoCElPSRDjB+/mStt/HSZL0ImK+LLN4SfHRCYa5ln4sxu8CTm5me+IdBkSb?=
 =?us-ascii?Q?iNz5wAsFgwnr++k/gvuxRQC58PX13SieMam+HPQIaCNEVJgpbMgja9umtlU8?=
 =?us-ascii?Q?5nvuhBTioOAnDbhBtGx9sHpi4IrEbTD6UgGD7Whxf23fVnKPj9dy1uLgrnvn?=
 =?us-ascii?Q?XH4T4AKGEFI3aW+ltcctLvL69/2H2xFC+HfOyF3BBw80odmfVAwvvjVtOLgo?=
 =?us-ascii?Q?YVDv3ClCqNetG8F4E+WOetPGz7buQb1cFYuM3V2RGm5SnyM6XOMbyot6vjTm?=
 =?us-ascii?Q?6/5FoWgYAq431/3z6xCGmhdx7z3aMfFi3/2Y0O8G+aq7WsBh8/hu/FiAS3N5?=
 =?us-ascii?Q?d73l3NdVHAMOWNzekpATmDDk91byLMlY1UIGkgKKgA1t5IIVY583xgE4CIV/?=
 =?us-ascii?Q?3AR+damN0fgcx6cVR1rPs06Nvp6XD/EjkGsCqDEqgPqVSeKoMpvPMeRZOXyA?=
 =?us-ascii?Q?KWmmRSK6Dl3SgKmexcnnQ0pJVKZUBjx/0xY9Rq+T3YhDA+lHoQ6/RtXdn/hw?=
 =?us-ascii?Q?U+kbM7L9Z2DwTZlpn9acoU1MJZGdijfDcG8WXdd/K0QwM70qO1jMHRHLtkUA?=
 =?us-ascii?Q?ZFVbw2Z9XG4sI78a4VugSFfe5ji+W9mKB9uOMuWNaPb5ue+k5hUMEZDL6CyS?=
 =?us-ascii?Q?UWRDsYiVyKlcniB2VvkSVjd5GoR79dKCTH0cGJc05279dCypEyW3jUdYxOXo?=
 =?us-ascii?Q?9iHQZlfgI5ZxnMuBjHx0uFPjJ/ndwyqqdbddo+sl0y/x+NX8EDccPrv3/Vf/?=
 =?us-ascii?Q?Lo5omiTwSLFrzioIV5Dw6wfmIzHqOAB6NfEmJ8KbEqnVnNKZ1Na9yfYsb5ia?=
 =?us-ascii?Q?Ru8mF9oWEaIjHZkccGHAbSfVfA8Wy5dPILnjHnveaqf7RZy5zP79XzJJt8eZ?=
 =?us-ascii?Q?9qe1l4g+pYLL/qlfAfYnxve7XgD+sJArnNeSpf1PgDlFn6jGLerNHegyPbbq?=
 =?us-ascii?Q?FMlxhAvKGgucDHuOhGNAXhBdvmxb+BvCUTjCz+yR92gt9nDqBCuM3e2iO1cx?=
 =?us-ascii?Q?TOzZQfRI5iW366jMloW8m3/BXjYuEbpJJjHFfKTHSZs8Fs157SpcTLA9OkeC?=
 =?us-ascii?Q?mAEipBee5QlD5vKDLEcs3XFi1l6vZlUMTMgYhKTUSJyQgO02Qyipu/meiu/s?=
 =?us-ascii?Q?s6/xabmxtLJ5JxYSiPNUJeRI1IUCWSpAKrRA8NCzOmKCtVbVMZBv5KoR+4l5?=
 =?us-ascii?Q?NJg5sBkJXgYJP55T235w5/YAP0vpsq3Uq0eyNSsAAO3ivvLTKsHELT3vutNK?=
 =?us-ascii?Q?vjckG7Qc0RS2t0gTVZssxolhus9KAM+cK2+4GR63GLV2ge1EGfJJnotDDLAd?=
 =?us-ascii?Q?H/aHXIF5GkiONfCoYzrgV6Tc20wySx4upasAQ58vM99ut2JE3PuOzpVD8U8y?=
 =?us-ascii?Q?fRKyDrjjZuwJV9iMrAIoI2jPgu3JLHwyfpwJ?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(82310400026)(36860700013)(7416014)(376014)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 09:33:24.4706
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9431877-1bd9-4907-fe58-08ddf5cd3fe6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A78F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8101

Hi all,

> Hi,
>
> [...]
> > > +#define LSUI_CMPXCHG_HELPER(suffix, start_bit)                                 \
> > > +static __always_inline int                                                     \
> > > +__lsui_cmpxchg_helper_##suffix(u64 __user *uaddr, u32 oldval, u32 newval)      \
> > > +{                                                                              \
> > > +       int ret = 0;                                                            \
> > > +       u64 oval, nval, tmp;                                                    \
> > > +                                                                               \
> > > +       asm volatile("//__lsui_cmpxchg_helper_" #suffix "\n"                    \
> > > +       __LSUI_PREAMBLE                                                         \
> > > +"      prfm    pstl1strm, %2\n"                                                \
> > > +"1:    ldtr    %x1, %2\n"                                                      \
> > > +"      mov     %x3, %x1\n"                                                     \
> > > +"      bfi     %x1, %x5, #" #start_bit ", #32\n"                               \
> > > +"      bfi     %x3, %x6, #" #start_bit ", #32\n"                               \
> > > +"      mov     %x4, %x1\n"                                                     \
> > > +"2:    caslt   %x1, %x3, %2\n"                                                 \
> > > +"      sub     %x1, %x1, %x4\n"                                                \
> > > +"      cbz     %x1, 3f\n"                                                      \
> > > +"      mov     %w0, %w7\n"                                                     \
> > > +"3:\n"                                                                         \
> > > +"      dmb     ish\n"                                                          \
> > > +"4:\n"                                                                         \
> > > +       _ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)                                   \
> > > +       _ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)                                   \
> > > +       : "+r" (ret), "=&r" (oval), "+Q" (*uaddr), "=&r" (nval), "=&r" (tmp)    \
> > > +       : "r" (oldval), "r" (newval), "Ir" (-EAGAIN)                            \
> > > +       : "memory");                                                            \
> >
> > The vast majority of this can be written in C.
>
> Here is the version with C base on patch 6:
>
> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> index 1d6d9f856ac5..68af15ba545a 100644
> --- a/arch/arm64/include/asm/futex.h
> +++ b/arch/arm64/include/asm/futex.h
> @@ -127,81 +127,77 @@ LSUI_FUTEX_ATOMIC_OP(andnot, ldtclr, al)
>  LSUI_FUTEX_ATOMIC_OP(set, swpt, al)
>
>  static __always_inline int
> -__lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
> +__lsui_cmpxchg_helper(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
>  {
> -       return __lsui_futex_atomic_andnot(~oparg, uaddr, oval);
> -}
> +       int ret = -EAGAIN;
> +       u64 __user *uaddr_al;
> +       u64 oval64, nval64, tmp;
> +       static const u64 lo32_mask = GENMASK_U64(31, 0);
> +
> +       uaddr_al = (u64 __user *) ALIGN_DOWN((unsigned long)uaddr, sizeof(u64));
> +       unsafe_get_user(oval64, uaddr_al, err_fault);
> +
> +       if ((u32 __user *)uaddr_al != uaddr) {
> +               nval64 = ((oval64 & lo32_mask) | ((u64)newval << 32));
> +               oval64 = ((oval64 & lo32_mask) | ((u64)oldval << 32));
> +       } else {
> +               nval64 = ((oval64 & ~lo32_mask) | newval);
> +               oval64 = ((oval64 & ~lo32_mask) | oldval);
> +       }
>
> -static __always_inline int
> -__lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
> -{
> -       unsigned int loops = FUTEX_MAX_LOOPS;
> -       int ret, oldval, tmp;
> +       tmp = oval64;
>
> -       /*
> -        * there are no ldteor/stteor instructions...
> -        */
> -       asm volatile("// __lsui_futex_atomic_eor\n"
> +       asm volatile("//__lsui_cmpxchg_helper\n"
>         __LSUI_PREAMBLE
> -"      prfm    pstl1strm, %2\n"
> -"1:    ldtxr   %w1, %2\n"
> -"      eor     %w3, %w1, %w5\n"
> -"2:    stltxr  %w0, %w3, %2\n"
> -"      cbz     %w0, 3f\n"
> -"      sub     %w4, %w4, %w0\n"
> -"      cbnz    %w4, 1b\n"
> -"      mov     %w0, %w6\n"
> -"3:\n"
> +"1:    caslt   %x1, %x3, %2\n"
> +"      sub     %x1, %x1, %x4\n"
> +"      cbnz    %x1, 2f\n"
> +"      mov     %w0, %w5\n"
> +"2:\n"
>  "      dmb     ish\n"
> +"3:\n"
>         _ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)
> -       _ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)
> -       : "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp),
> -         "+r" (loops)
> -       : "r" (oparg), "Ir" (-EAGAIN)
> +       : "+r" (ret), "=&r" (oval64), "+Q" (*uaddr_al)
> +       : "r" (nval64), "r" (tmp), "Ir" (0)
>         : "memory");
>
>         if (!ret)
>                 *oval = oldval;
>
> +err_fault:
>         return ret;
>  }
>
>  static __always_inline int
> -__lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> +__lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
>  {
> -       int ret = 0;
> -       unsigned int loops = FUTEX_MAX_LOOPS;
> -       u32 val, tmp;
> +       return __lsui_futex_atomic_andnot(~oparg, uaddr, oval);
> +}
> +
> +static __always_inline int
> +__lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
> +{
> +{
> +       int ret = -EAGAIN;
> +       u32 oldval, newval;
>
>         /*
> -        * cas{al}t doesn't support word size...
> +        * there are no ldteor/stteor instructions...
>          */
> -       asm volatile("//__lsui_futex_cmpxchg\n"
> -       __LSUI_PREAMBLE
> -"      prfm    pstl1strm, %2\n"
> -"1:    ldtxr   %w1, %2\n"
> -"      eor     %w3, %w1, %w5\n"
> -"      cbnz    %w3, 4f\n"
> -"2:    stltxr  %w3, %w6, %2\n"
> -"      cbz     %w3, 3f\n"
> -"      sub     %w4, %w4, %w3\n"
> -"      cbnz    %w4, 1b\n"
> -"      mov     %w0, %w7\n"
> -"3:\n"
> -"      dmb     ish\n"
> -"4:\n"
> -       _ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)
> -       _ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)
> -       : "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp), "+r" (loops)
> -       : "r" (oldval), "r" (newval), "Ir" (-EAGAIN)
> -       : "memory");
> +       unsafe_get_user(oldval, uaddr, err_fault);
> +       newval = oldval ^ oparg;
>
> -       if (!ret)
> -               *oval = oldval;
> +       ret = __lsui_cmpxchg_helper(uaddr, oldval, newval, oval);
>
> +err_fault:
>         return ret;
>  }
>
> +static __always_inline int
> +__lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> +{
> +       return __lsui_cmpxchg_helper(uaddr, oldval, newval, oval);
> +}
> +
>  #define __lsui_llsc_body(op, ...)                                      \
>  ({                                                                     \
>         alternative_has_cap_likely(ARM64_HAS_LSUI) ?                    \
> (END)
>
> I'm not sure this is good for you.
> But If you share your thought, That's would be greatful.
> (Note:
>   When I test with 256 threads for futex_atomic_eor op, there is not much
>   difference with former assembly version)
>

Might be all discussion seems to be going to made cmpxchg with C version.
I'll respin cmpxchg with C version with the missing endianess support.

Thanks.

--
Sincerely,
Yeoreum Yun
