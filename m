Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013068.outbound.protection.outlook.com [40.107.159.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250F62F60B3
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 10:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757932919; cv=fail; b=OWhzmaZrXdXWkeLt8/wKnT0pM7HYxDac657L7fxwcGscTIf4frZoQXdoax2ODFZBK4hybQr6G5VwbpOjqRLaIG0p/H9iw9sOXw9msABbHwcjBiKg+x5t69WcqaQR/C9hv1Aui7E6n9BLAg6ZKbNCxMKtBxOkzWt4viT81BycscY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757932919; c=relaxed/simple;
	bh=cdtBe2f0W7H75RvjpxoNNroWAIYZN/Vo01MGEbnKQoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Z12zITQK6PaFwWhuRmEgWdoyUbLW8RrljrK6Xckz+s1MC1T4DxfH8rXEWw4QqSyfJTUhtEZkc8g2UYg79yYP6yuFIHmUvXhiuz7SJWw5HLJrxlDXdS79MsPpFY4oXJthYNJWDEmn95VW9rS7VHg1+pIkjnTdkZKq4qb0VYxh83M=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mFY3Dh+B; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mFY3Dh+B; arc=fail smtp.client-ip=40.107.159.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mFY3Dh+B";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mFY3Dh+B"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rl9nAQ6eftBM1QOEcg3H377RBC2S8/HwPYsvDOH6Hoo+5fKcm+/71aQ6eQhm2hs6MBwHWkR+5Or+q03sV9osSBkBRadCjYowQL1cuSICeaPtSkg9zzbooyXn+QYIHEyj622EOMcoTECstsNyOKJbilrlxtrLic0K5ZV3YGLT+YVuvwFmjMWcVz1VlHJqtjwDVjv0k6W2D2BC5bE8msOMu2QpAMzQFqK+cBX/06Z8GA6EYxf9w+mJe/fbPvIFXe3djxkToxXhEc8mR3TbhG9wGgnt6NWCfl7dmNGFuaEDVAQABzqa/qc+DOwQiLH2kmi7XbpXA5tNway8+4msA3fhBg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cdtBe2f0W7H75RvjpxoNNroWAIYZN/Vo01MGEbnKQoQ=;
 b=DhNNJOZBLqpcR0dI6OYTYmBKVa9M5jUxkqG+GLEBUayfG19oqHnOcK2DtNN75oFV62tY7Ou5bsUPdPpciUWljR8tWw1q7BDUqEq8PwSqJjCA86IMsKipMA9CLhBSPo46Y9zJct46k6FvX/ZeDxl4F0ZcO4rEBXxXkM4Gxtx5+UWEqokExrbql1sdBUukcqgWRyfkJLUJNN2d4Njh5EIjNZ1mIXlqVM1x/B98Pbfvqttfifu8PdImz8wEHM4hvP96MCapiLrAxxbZT8YRIRAAJ/ww8azG8SU9gdLxI+V3TPI4jU5STv0PIdz5K1tP4I7Ksvb4r2mZnvamWqVYFLCVuA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdtBe2f0W7H75RvjpxoNNroWAIYZN/Vo01MGEbnKQoQ=;
 b=mFY3Dh+BjouxndjczhJfBLCb1X4y5SdlTPlQ2loj5LegswKkJmWl3MjnkI+MH83sKrF2DrV3vBNs8y1AelWJ4msl1ca+dGTC6Wp5vtD7A/doYhps/Wo+gitRQfP77EwBD6lTqYR4O0Jh/cTSlvGJAjHD4C7X5mQfaQ177DPEAzw=
Received: from AM0PR02CA0169.eurprd02.prod.outlook.com (2603:10a6:20b:28e::6)
 by AS4PR08MB8093.eurprd08.prod.outlook.com (2603:10a6:20b:588::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 10:41:52 +0000
Received: from AM3PEPF0000A791.eurprd04.prod.outlook.com
 (2603:10a6:20b:28e:cafe::3) by AM0PR02CA0169.outlook.office365.com
 (2603:10a6:20b:28e::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.19 via Frontend Transport; Mon,
 15 Sep 2025 10:41:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A791.mail.protection.outlook.com (10.167.16.120) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Mon, 15 Sep 2025 10:41:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CgN4guIa6yaW7N3j0MXFSSlwYPOOiZWAoo0M4ZIb20zTkNdgR+OEEd4KhOzlmlOtS3onXHvDw/eoPJwJ548XuyQXP3b/7XXMW/rwzVnggGW82C7a562bX0IRmVk+xsv8H+97ZUw36EW3IB2MiL4EleLPSWGQKDkIKIK9nMBMfxVjQOhsdTUhx+q+xW0wCUuAEqleJ0xURe6zgYsvtWKp+ZtsXsxGZD/TNfQrPbFaTP0J5YPtHfyuZbJnKkZInIdiUPLvV/8L850nN82QdBCJA/RNsnrEXX+oA4ulnNbPRs0gUiDOfGbZDDEaxAds/QiV+xs1a2zuXiSzHP4BReuNzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cdtBe2f0W7H75RvjpxoNNroWAIYZN/Vo01MGEbnKQoQ=;
 b=napNOMcl3S2IesqLjPbhNd0uakTId+7TQQSZ9n0TCT1m3EV1wPAW+1NHNgoQ2I6ksDEvGCvGVMAd/gMP+FwkEC6tutNFg6XR8G+MOoaWVTs9bubhRjcpwDNjHMpRmj0HJ6k/6luTLfju5f9lVqP/IBVzWuPpPfGonSfSR7JvuU0IzyHlpkJpk7Q1UsFiIOSPwpgwI1CQCsJmKYVbwSNCE3u4Q+MDLroNiQqmtYOqnZdoH70V0BRuZUjze1NmRiyBo1tQsRoZ3WjslOYbRRiTMggU9m3/ab7hsh6Y8SKeusZJIuwYOoUnVk538fAZWSAavRSuucgtbcr5zHbQ+Wzdyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdtBe2f0W7H75RvjpxoNNroWAIYZN/Vo01MGEbnKQoQ=;
 b=mFY3Dh+BjouxndjczhJfBLCb1X4y5SdlTPlQ2loj5LegswKkJmWl3MjnkI+MH83sKrF2DrV3vBNs8y1AelWJ4msl1ca+dGTC6Wp5vtD7A/doYhps/Wo+gitRQfP77EwBD6lTqYR4O0Jh/cTSlvGJAjHD4C7X5mQfaQ177DPEAzw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by GV1PR08MB10789.eurprd08.prod.outlook.com
 (2603:10a6:150:163::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 10:41:19 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 10:41:19 +0000
Date: Mon, 15 Sep 2025 11:41:16 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 RESEND 5/6] arm64: futex: small optimisation for
 __llsc_futex_atomic_set()
Message-ID: <aMftTNkHsbwAFdkt@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-6-yeoreum.yun@arm.com>
 <aMLqsez5y9R6FIdJ@willie-the-truck>
 <aML2fwGfeubY6HgA@e129823.arm.com>
 <aMRMBEdro1YJ5RLW@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMRMBEdro1YJ5RLW@arm.com>
X-ClientProxiedBy: LO4P123CA0150.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::11) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|GV1PR08MB10789:EE_|AM3PEPF0000A791:EE_|AS4PR08MB8093:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f1d94be-08b6-4101-f40c-08ddf4447b8a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?BY6N0Oo8D37moNbLyPHW/WSJxDiCmZd4kZBSHV4CE22WiGx8DZ/BFC1LFZnd?=
 =?us-ascii?Q?5cbwbYhsI8y/cw0xKjm7pJ4tQHn8IXOEdRwmrCRlMqc2ad/+om3kQEjgYdp3?=
 =?us-ascii?Q?XS0tW2/bF53lvbNv45lOK30nF7Hd4bGWjtmN5M/zO66V6KMGiewDB1qUDOrM?=
 =?us-ascii?Q?1hGXwo6mI4dXcgtNmEZR5jvv/nvk2bOpADIvTsw/VrKhuA9uwHch7O+4QinZ?=
 =?us-ascii?Q?vwaa9qA9aRjYqOFZddwQDROks88njhUDjVcg3VtgYNyUuksCp0HhA/9qKM8D?=
 =?us-ascii?Q?f67IvCTooNIOWJHmictnZdTzd9HLmOPnP9AQmTcbWhqEGoPztD4JEV01/6wO?=
 =?us-ascii?Q?0WdVqnDwhaoPINXYZSZ6aRibk0Ksomrb4zAOqR8Eu858h0izsLzk7huNdFze?=
 =?us-ascii?Q?/unNc5tolQTUyYaExTQzX/M3dv+d7RCGAGX53dVBCUA9iVnI8oXf4PWynFcD?=
 =?us-ascii?Q?dEMpEzuwUP24D1nttfCSIUH9vVVyrLEaVw3FTXzeGuy4LHROLjGTy6S0aFBN?=
 =?us-ascii?Q?KRsVuQLvZzBzSxdNoxstHgnduQp+5pjDEuOdrT5mVKrYPmtDTfO/525uSE/Y?=
 =?us-ascii?Q?/Q3PGwmTLvDCvbLpEeRqhZDSw8fQR4pGVdpkD6iHdHMCbTHPnEQB51PAVvep?=
 =?us-ascii?Q?9Z78N64ZPk6ZkxReOeBKyYTz2bZJ/oNNQt6CD7b+vzSIb/kRHz25MvQ01kKJ?=
 =?us-ascii?Q?BY1EJCPKMgErc+d4/gAozVvOxutM7Xs5wP2e2ZkRcUC0pe8Kyg0b2q0+c+qy?=
 =?us-ascii?Q?rIgNM0HLZ120RFru0v53XiNxzYiyvH3wCJWC2H4qGMD038yJjP4MVR7BpKho?=
 =?us-ascii?Q?31xpBL5CHraijjP/TPaZO3jTKQKwJ7CQQ6ngxgxCy4XGiH9xywog7H+GOxO4?=
 =?us-ascii?Q?knNA+qH9HKB89mFU3jbPLSKPT/B4FM0L1qwUkreoYJ3rVHmjn0mgzxvmT09H?=
 =?us-ascii?Q?iV8CWeHSihrXU2EeKqZHAi6Kwf30BFLHN8ktwLoeTEmyKvgSREmjkERuASbQ?=
 =?us-ascii?Q?p8qfFfPElPo+t8qHkvOY7LjJi3P92a2vtgYVQQppZh82yME9Gz7UcQUmzPQU?=
 =?us-ascii?Q?tDa/COzpn3YpuKqiBeJ9dFIYAYk6cMfPUoFq0iOzi6mKKKH1NVwtckDgf2qu?=
 =?us-ascii?Q?YSaYmeWrD16EJzYRSKQPSDDc7L2XolkOXtC1GESfjILeqtE7kQO6IzrmmeXz?=
 =?us-ascii?Q?Nq5C53qmz9sR6C/2yhenOcemKHRTL7O9rJhrVQF/kT/1iIGeAHZSkUBwfV4d?=
 =?us-ascii?Q?m642wliSsIJ4FVxPGBAFy+oDs3kNTcLO3R1HMKVH0wNMG7hlo/Ebq+cXtUk4?=
 =?us-ascii?Q?Sbx2lrwHhtTa6FaV/TaOssA/b2fiVf/hEbKODy20ckVz5MdNv2NUPiKIvUpt?=
 =?us-ascii?Q?j8hY8gwvciAxxHImRvk8kbwC5MoVqv8h5Y15QuMY1qPu7LbqTQ81ghTEcYsU?=
 =?us-ascii?Q?3N+jxWFNjjg=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10789
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5a8da7ac-7a16-45c4-ba45-08ddf44467b4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yAqgAXtQuozFhZ8183Vp5T1spC22PLL0ucbaCtlkyRs4NNYScepQ4tmlb3kC?=
 =?us-ascii?Q?+NCAJ/Vvbuxifh4q7Drlzm9PJd/Ub71iOMu5L+Q3/MCiKtjv0lFcnOvQ8vxu?=
 =?us-ascii?Q?d5ulPKVoIkv3UR9ZOYvlDeF+7gZpE1dTyTgg4LpXCm/h7TubGrm+junadMgc?=
 =?us-ascii?Q?Jr0/Q7yc0/9cS+U76JTS9Ft4EiUF8kIcl0CafRPFH4wVVMqOVoxJ/8onOein?=
 =?us-ascii?Q?gBIIwvASCMQWZh7nk7z2PgShQpKJaPS9z3jRg+IvI8mNebqBXXfGjxsxtRBm?=
 =?us-ascii?Q?VoPL3Djdn7mpCUTxeLtghIcbibV3bIzOUCsqpEru8vJRv+Hw9z44t8bsyZYR?=
 =?us-ascii?Q?Qy4OCPtQfiWyjzWhkCSCCUJHOA2hpdufr/6ISEMqinG/2mxWFhrPx3tSmeba?=
 =?us-ascii?Q?6ywzc4/7xmDIeQaPS0yhgx5XBsiuDYISoIHRztR0vQ/9Bgjac+NoSsPGCC/L?=
 =?us-ascii?Q?xMZ8FxL/XEwAkIrjkdlng7zEda6uyuGdSZlgsaodTP/emny2oVmYnVaDR1lk?=
 =?us-ascii?Q?jvKPOw+zt6IE78fAGsEKVylT3odlb692MWaSEXDOkBCHxlectDFCbCu4Magw?=
 =?us-ascii?Q?EK8+p3BglZC+0LwqTAhEjNHyc4DCvbTfqsRX4/LSc5ksmz1O1wBzSfLC6RTC?=
 =?us-ascii?Q?TRQM9EdNaHNc9bijgjK5/ze4CJrOKo+1VhPAyppuM1iUlWBBLSW4d6OLVMfi?=
 =?us-ascii?Q?yFo4dyO+ucxWnGWstxpfKvHIe46QkymjKikBpybqw1Tx4ctRvLKshVVUVU0a?=
 =?us-ascii?Q?ZCtVKAUUWKEE/NrSQHMik4j8tDskX2/uetuIWw1yru+u5J18PbafaKdYTjs6?=
 =?us-ascii?Q?S8Ddnm2nRsyRI+l9jt+B/K02AOs+PhIiVJ61ToX6IMeNWhhC9+dd95r0PWuL?=
 =?us-ascii?Q?MeQw7A6raCucznf0cOBJSf3z9E1Gu9h0gL3oLgXCa88oI5Hcv5aDI2vrqb+M?=
 =?us-ascii?Q?WqyLurqex0367VvrQlfuHY3C/XlS2tkIvMQfmnkpbC9mL1vFQhdPBjrZSK0L?=
 =?us-ascii?Q?5XJ3rMbRIE6IwlMUVDR/sa6V+oiK4ChALf6fWbOgbWyTsBNJOwYbj/6JbFxc?=
 =?us-ascii?Q?1cuBdQIrevtmfKOkWrvl/k1aboKsbymIwXssry+3vbNYpQxUdsQlE8UvqDpw?=
 =?us-ascii?Q?CwAKav97fvAnMIdQ1/U/c7QMnzWYl+OCM7OXI4DorjRwQvh7pCuKRzQ3G6mS?=
 =?us-ascii?Q?47YKoUtTtaJoDN6U79W3gUNZGw8z5TldOcHE/4WKLeUrRjGGEUHCUH9eds4x?=
 =?us-ascii?Q?b3ywVAXwI+jl/3rH/gXr7FihJb/sZgAKRXv3kulPahx+wL8z9s9pckf5ZJxJ?=
 =?us-ascii?Q?zL8d9BgUcxz5qvn1Vm7nb01aIlbfwtHmkEFgWGwmgqQz3yhDbMoqLRj4xqmN?=
 =?us-ascii?Q?OS7cHVOLClbH/8F566Cyh1J/QomEeiMhMutpc+YsU/lGF6hTeNe7fYIcatQ+?=
 =?us-ascii?Q?WZtVLVMheY1JpO3i8/3IOT8ksGx6Q+YJ5BgC5tpKtpfYjNNrFbP2qplrV+52?=
 =?us-ascii?Q?uSAJPKuHVAIoyWoITcLLS6rGqMuHqmc/taWV?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 10:41:52.3172
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f1d94be-08b6-4101-f40c-08ddf4447b8a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB8093

On Fri, Sep 12, 2025 at 05:36:20PM +0100, Catalin Marinas wrote:
> On Thu, Sep 11, 2025 at 05:19:11PM +0100, Yeoreum Yun wrote:
> > > > +static __always_inline int
> > > > +__llsc_futex_atomic_set(int oparg, u32 __user *uaddr, int *oval)
> [...]
> > > Hmm, I'm really not sure this is worthwhile. I doubt the "optimisation"
> > > actually does anything and adding a whole new block of asm just for the
> > > SET case isn't much of an improvement on the maintainability side, either.
> >
> > TBH, I had the same question, but I thought this code seems to modify
> > freqenetly, I decide even a small optimisation -- reduce one instruction
> > only.
> >
> > But I don't have strong opinion for this patch.
> > If it's not good for maintainability perspective,
> > This patch can be dropped.
>
> I'd drop it for now unless you can show some performance benefits
> (unlikely).

Yes. not much of improvement. So I'll drop this patch.
Thanks.

--
Sincerely,
Yeoreum Yun
