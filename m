Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012024.outbound.protection.outlook.com [52.101.66.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B4821D3E2
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 09:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758014180; cv=fail; b=RFBYTvlqEW0rCT2+4WLdqkdTexeHZBgHqbqhfqA+uGQl7fkBeT6NHevxyN1NXGXGfhVp9QY7quAjSexAVmVxHbIm5sGwNxjVW9iQi86UF1Voc/rktNXWs7Wj3jumpA48PiCr6Qgf5g9f3CTE0//ZfNfGLdmKwe488ZrhhE30HeM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758014180; c=relaxed/simple;
	bh=9CwKYwfPKV1ul+FTO1XD/zUoIQH91ya01ybIM/nA2gA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nrlktgaqW/DtU8aO3xtgdy32HIkpmP2DQm2fs1l9qa17LR1w8APtXYzKVSxownK8ms9RWxAWJZzqFqD5fNK6aQZHebQzIkiFLfeRGis1eQ0o1TnQI1Kx3aAnlhTFZhQrx4IFMtQ8/H2ifWRzoQ/BM5skQL41Kge9FxJmzdMaptg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oh8inp4K; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oh8inp4K; arc=fail smtp.client-ip=52.101.66.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oh8inp4K";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oh8inp4K"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=C+mJKjboSqDEw6/N3O48GgR9BcVQWSfX1q2VA9M9xFVfkuaPQ52D/zUWNBI2In9h6sSRnKOo7dJYpKXSUDUHphJoiuGh+gt2P8geEX9Ws4qe/awbPf9Z1qYCN1wVM5C4i++KtV2VY2KPXbYDWHTlgrJlcOk+z51e6L9RfLeiqNP75tLpGlDNPh9J+8F44qJh99wjMCsq2HWI9ZWiuLitp7A8Xe4xmJPExfiC4pbM5EyRNPpnP9mLbB6v2yPTK/oeX8jm+6eh4B6pFyP+YH1CibE6GY7JVY8pkCpbUTZF13ym24aHSunqBwa7UUtVGZt50AngLEqh3QjJD+jNmo/y1w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n3RsAGF86XpaDtaf0JIvehLcpkivHn9FaOgOUOVJhlA=;
 b=CO3tgMO1Tw9Lhwq/EjYfRNLneCX+0pfc3/gpCC1eYNI7OcUMK2gwID/gwtvb8BboQxuU7z807f33dribLxlYYTBDke89efMpsm+H81D5vlU9EvwU1Ji5vyFNk0+N1bRmR1aLkas2+rt/A4H6nsgDyG0aUoJnmiBHfppo7BMs9RoWtr/XbgKpnZLh1m03WgKhleORjBG1hGxKUBxAk2NHWD0qGOhcWmGDE/BfXWFUAaA8AJHbnefo2hGNJvISRqqwJQteDVjsMiwBSVOnvUDhknEYwKa83haj2THxhprY0ZN304jwWQ05w/irYjIDHiIBWuc2zXoYwBaKopfTJJLiUw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3RsAGF86XpaDtaf0JIvehLcpkivHn9FaOgOUOVJhlA=;
 b=oh8inp4KXttay4J+Pr1iDF6oA/TC/ud6nGudygUhUXvh6mM3X0xCQxz9zIKuR+3ehjiBsyCXv9Do9Wi8RwpHf312EKSUau/eshoNbsiOcIQ6E5VFEr7cZMYxCUSBXvEj0TGAErHLCrgfAhmcF98mpQQo9eRJF9/V5BkrV8rCeKM=
Received: from DUZPR01CA0054.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:469::10) by AM7PR08MB5416.eurprd08.prod.outlook.com
 (2603:10a6:20b:10e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Tue, 16 Sep
 2025 09:16:11 +0000
Received: from DB1PEPF000509ED.eurprd03.prod.outlook.com
 (2603:10a6:10:469:cafe::98) by DUZPR01CA0054.outlook.office365.com
 (2603:10a6:10:469::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.22 via Frontend Transport; Tue,
 16 Sep 2025 09:16:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509ED.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Tue, 16 Sep 2025 09:16:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GvM9c4UowitpvVCKsRoswJ0p/YbGnIToBYgG/GTACgBsMhfTUqISty7/PltKrkrh1KwjwrfHGcac1rOwKe6F/WgAOA0LD45T4soF26fimwYq7/gnGAlnOIKvDWn3H//kHPVCnF7uGja2kj5AQDfgruDNpFAlr+0kmF81xmf+cnonSG5DCr30fLWACscraiYWRCBZk6ZghRtJJ7StzcCNa9e7zxjbi4xnUHZN+7j3H6Ciyf6BfzkgkjZN/7PUqsOZpzAmlFOEtyL25jXcV+hU8/31L6BbBBX3bFnKK8a2GhR8lsRO/py5YcqqiLntiuGt2XMTecjHKtIxg6oHVc7kxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n3RsAGF86XpaDtaf0JIvehLcpkivHn9FaOgOUOVJhlA=;
 b=KfSz/XziUuu3+UqRvQUPG+SjGwXb6jNc8H6x7W3vsJVyeswlmHsr2c5LGNGgRVFjM8hEw8su9BtMyVV4VITfC5v9nKWAAUn6myCE7B2EgeSa1dpkxNp0fyY+BXW64povQyX4s2EvEyWXpbwBVa42MNJgo+rnBQsCXtHNXoe0rcmk6qls08/YYiSfkaIm7SYQeD1DgxZirOmjf1RSaTGSgntGsos5TDxdDMaMUCECja7Va4zpNtQ7MOW0SzC2lasiUFfJe2HwJMe/ToYexDTwimj5lupuVJjjDJam23eBFbZA0Xt9kFNb6HGT1Og6cLVj7ebMYGSlbgaBZlXYC8NoAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3RsAGF86XpaDtaf0JIvehLcpkivHn9FaOgOUOVJhlA=;
 b=oh8inp4KXttay4J+Pr1iDF6oA/TC/ud6nGudygUhUXvh6mM3X0xCQxz9zIKuR+3ehjiBsyCXv9Do9Wi8RwpHf312EKSUau/eshoNbsiOcIQ6E5VFEr7cZMYxCUSBXvEj0TGAErHLCrgfAhmcF98mpQQo9eRJF9/V5BkrV8rCeKM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by GVXPR08MB11637.eurprd08.prod.outlook.com
 (2603:10a6:150:326::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 16 Sep
 2025 09:15:38 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 09:15:38 +0000
Date: Tue, 16 Sep 2025 10:15:35 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMkqt1LMUd5QPc3S@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
 <aMRQIeIdyiWVR8a0@arm.com>
 <aMfrR0vserl/hfZ3@e129823.arm.com>
 <aMhrscd1gz_syMtL@arm.com>
 <aMh4q4-xAPHnaOul@willie-the-truck>
 <aMkLb6jPiSbzeRWL@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMkLb6jPiSbzeRWL@arm.com>
X-ClientProxiedBy: LO4P123CA0205.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::12) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|GVXPR08MB11637:EE_|DB1PEPF000509ED:EE_|AM7PR08MB5416:EE_
X-MS-Office365-Filtering-Correlation-Id: c785a691-7e6b-41f1-c5dc-08ddf501ada8
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?6rbFTv14DSFkJ8TrWPr5rwFWpyfrhRHLscwZMI72vbg0vQjd2DYEDqyQm8Ne?=
 =?us-ascii?Q?aY+SB7Api7Uns9VvX3fer22LDa77Pg3/JgCJIW+En1tpGV7DTHBnBk5a/ymD?=
 =?us-ascii?Q?kocxsw+7yocyBi1n/JJCKFkPlNTiKhZK8P4UvlcWWONd3Nv8ndxyiew1pJ2m?=
 =?us-ascii?Q?hgk1pir+P7F/+Un4v8XWaFGPZRp63F5jries0Z9rKUOew8Hz2KaSJ9MKMU2v?=
 =?us-ascii?Q?IMDnPMdDry0HTKSQ4jdu+zoWocKMHWjbaOoehfoTkG306IUTMnlSAHzeCauK?=
 =?us-ascii?Q?aB0EQJjamqPh/XNzDVTD/55d5RJeHVq1ctfecamsF9HIO6oKnFsHEgpVaVH2?=
 =?us-ascii?Q?wCpaR7zw/Ffxtd8BPfM5RawtkOKVkUbL9W5UXP9+BWLtaw2Xl/TBeYp1LRsg?=
 =?us-ascii?Q?kBakC3KWs9+dKwo8gJ14UuCNmI6zgEHiqD5CylcV6ADGsLFLk+xUZxpfBbgu?=
 =?us-ascii?Q?6G+jhT9fm6ymEiqyPIVIc4Sya191G0Xaj6pVN7fO8TnpMuNb+Kb1+kFAAQAj?=
 =?us-ascii?Q?HuYnua6jhysIUjJjzrLzOKoqNgdK788eoSVREkql8Y7yJcPa4h3mbAluOyU1?=
 =?us-ascii?Q?f+AIC9atNR/fOWV/5Q0SkE5XubjC/zJLgbd+ffuERHQghu2rv8D42omu89mv?=
 =?us-ascii?Q?L8YMLyaYOu2QXhUe70tFb4pd0j5CcJzWNo08PGypiDktFSAFbpxqAzA55a3Q?=
 =?us-ascii?Q?J3EFeYJsn+wC2lWnVThpUfksaca/hSdmm87W6/ZI5DXi7JeWATdj1yZ6alEO?=
 =?us-ascii?Q?dT/+ibuqqa5++DtDSa9TeOkJ1cjJYxtO0phTjLWdh6B/7v+Nrjl4xJr+pXYS?=
 =?us-ascii?Q?zIvpq9CKp8S6nNPREGkWo+qfiSw0H5bmFImQr7POxjzlQH5qE0LmyAQUUeDp?=
 =?us-ascii?Q?vDdm/5BjFQrl3mSFVDWmvKarnA9xWrIVYgiIgY60SaawXTgaM1/leBEomRNA?=
 =?us-ascii?Q?bNYarphfAq6144esetPkxrsiE3259U379WN1VGUIv4dTc6mxwrDBg4lxOUTX?=
 =?us-ascii?Q?TUP8TgbjbhR2nGBKtv2h0ScXuZafwHHBRD+96MkPzjXUoe4dw5OB2ee3nR9G?=
 =?us-ascii?Q?Pqq3AOOEOn1I1kkjXCrg0bqy5KFM5T+QlQtc0l9OHraHXyA7PC8cRKSVb0nt?=
 =?us-ascii?Q?DJrOmaLXZ7wzJmE07DSZa/yH2sfI9XK46rtP++WppXwFeRs5Hi8FfKt281ds?=
 =?us-ascii?Q?pIUH+jzBySm39t6Ig7Z3MIKTGzszDgrUW7CgMfQS425afcsWfwv8TBtnJxf/?=
 =?us-ascii?Q?s/Pd29qtSHaIatZ0/HHVpLpApMNrlfaZOad/qTYznFQ5X/4d0wYXgmhQQgEz?=
 =?us-ascii?Q?lmvlId70vHSRD6z5We21cLTVU23Bt8vH2BSPY3+QQCWrJ8t8G6mkhcB4iuIQ?=
 =?us-ascii?Q?S+ex+8pXpAje4hkMqfNQw7LAFrliP7uzT2tZMk8agqd1LZJ3HlXZEvnO/fM5?=
 =?us-ascii?Q?nvqw8vwfwdQ=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11637
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c386bcf7-02e9-465e-d483-08ddf50199de
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|14060799003|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Aeggcdh5TKytrZXsxNHZVhDBspVSm/PnM7T3xFjVFxODJ4BXPFbHNqEMw2Hx?=
 =?us-ascii?Q?3WKGPH6SlOCh2hDPtwlydE9K6oy9VNQ29tMQTX3o9YEhFVtrIyxgOug5fQ/q?=
 =?us-ascii?Q?q1RQD3QXD1I7bEa22NkPFVllo+xycn5yPVe9CoEoEtwtjSwVZkU3ts28vgM0?=
 =?us-ascii?Q?CZmhE5qH9k/GUlzgvRtb4CGe2CjdmktlazSlB//azWdi8TM6c/Ou+OT3raJ1?=
 =?us-ascii?Q?S9HkGFFv8a1GFaCdcMJGJWPJCzkXsVXWRwdMhAyg1XEL6Rr59VxhXkJ+SUY4?=
 =?us-ascii?Q?znrpI+KV9+NksjNJY36oi8fX8DE0ahg1/6aclmz6Q98N61ES8xX00Pwhs8QM?=
 =?us-ascii?Q?s1JiE+wnokRcFEe7SEH1M5gZx73nmK34RdMcHK68uVnskD8v+DN4gs5m5cdx?=
 =?us-ascii?Q?v6+isgDVdbbOFj1ATmHaS1S2vXQvxcc7VdcQQwd2iYVkSfAJHeymBPH3HA1V?=
 =?us-ascii?Q?/Lu+2z3wznQZ52WgFnE56YQo3D9wL5QP31Tz6urwSC3gxubRZhdknontFIYm?=
 =?us-ascii?Q?G0bN8Nzo6mHanUu7QPDQQMuoMp2FaeG9PQndfacQuB00PKb4imKWWJqqKCuq?=
 =?us-ascii?Q?gVulLl7ZCgs9dwfkRU0sq8HEglTN5Pobnivt/SRkUJWuGRwViNOwS22nx4mT?=
 =?us-ascii?Q?L9hZJmP0EWb6zm3KNFeZ/+h5N5B24L9C8WvGdhuFjiocrMP5AcS1Jg3njKBj?=
 =?us-ascii?Q?qb+mpC8ALNmMQ+hq5tlcOpbNRzAOTMuc+dWoNVacWaouyTAmJfnDAiQvssfZ?=
 =?us-ascii?Q?vEZpoEG+4rPyZHGWPUgJrp71OQ0n7dQ7sM2Myq3UBjc6PzgmPX6fO63cApdJ?=
 =?us-ascii?Q?R3z4Or+d1BQWm+yyLrMFeiCKMAHU1dZhAfFggxK8f19XX/E+7lYIEQqy/kjU?=
 =?us-ascii?Q?ipLprGNb5WgzWlHTR/gYgz76XxDsyZPlW2w4QlawMXpEhmw8hvs8tOXzB1Cv?=
 =?us-ascii?Q?HWrEBXrx9dJkVVv2UpCbOy1P7EUbs7n/a/dLX+QDqVSGunuIMZLKgH2YT6bB?=
 =?us-ascii?Q?PQ80R5eDm2Ye2JJDeejGPosQjBJTInSRG2sHRbzIA3pDsfOwp5XRaLHHtUJQ?=
 =?us-ascii?Q?gIktdTAnm9ZSRqX4rW9xPPYh8vm7ZJEP7moH9lOjFHDowhd/reyFUPhmw9oq?=
 =?us-ascii?Q?yH826UsXAB52+Zu26AbqVQXj6H1U0eWq9O6KifCm9p7sMxKrEKT9/DjCrNzP?=
 =?us-ascii?Q?GWH8sxF3DMfYYR5/oMMR07jZPIUEPMFjEmT7XJ+TrK7wZW8ZRx2k4DRy1pzj?=
 =?us-ascii?Q?xjhliwRD/XmrD/OJRUyOzOf2Zqr0PUo80vCmUy3oZTX/aor4eL79MCMQmoEl?=
 =?us-ascii?Q?JIKMxdLnw3lyiwEGg32yHHIwMevHmv0dCBGVKir/LoU7w7pDdCRkYE3j0N4K?=
 =?us-ascii?Q?mLIWQQ4kJb/cfIDns1HfbB94sxMQzDnxSuEko/YHc+UXhf4ayZ+NT2G7ztdk?=
 =?us-ascii?Q?wIEy8UxUQWvGHErin5HUG6O14iBCwW36eisdY6JyYttespEEvt0+nMqDrbn+?=
 =?us-ascii?Q?nFHUFTm4qdW87wnXmFnFPu4tnOa1P4+QfVvS?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(14060799003)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 09:16:11.2687
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c785a691-7e6b-41f1-c5dc-08ddf501ada8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5416

Hi,

> On Mon, Sep 15, 2025 at 09:35:55PM +0100, Will Deacon wrote:
> > On Mon, Sep 15, 2025 at 08:40:33PM +0100, Catalin Marinas wrote:
> > > On Mon, Sep 15, 2025 at 11:32:39AM +0100, Yeoreum Yun wrote:
> > > > So I think it would be better to keep the current LLSC implementation
> > > > in LSUI.
> > >
> > > I think the code would look simpler with LL/SC but you can give it a try
> > > and post the code sample here (not in a new series).
> >
> > If you stick the cas*t instruction in its own helper say, cmpxchg_user(),
> > then you can do all the shifting/masking in C and I don't reckon it's
> > that bad. It means we (a) get rid of exclusives, which is the whole
> > point of this and (b) don't have to mess around with PAN.
>
> We get rid of PAN toggling already since FEAT_LSUI introduces
> LDTXR/STTXR. But, I'm all for CAS if it doesn't look too bad. Easier
> I think if we do a get_user() of a u64 and combine it with the futex u32
> while taking care of CPU endianness. All in a loop. Hopefully the
> compiler is smart enough to reduce masking/or'ing to fewer instructions.
>

Hmm, I think sure shifting/masking can be replace by single bfi
instruction like:

diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index 1d6d9f856ac5..30da0006c0c8 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -126,6 +126,59 @@ LSUI_FUTEX_ATOMIC_OP(or, ldtset, al)
 LSUI_FUTEX_ATOMIC_OP(andnot, ldtclr, al)
 LSUI_FUTEX_ATOMIC_OP(set, swpt, al)

+
+#define LSUI_CMPXCHG_HELPER(suffix, start_bit)                                 \
+static __always_inline int                                                     \
+__lsui_cmpxchg_helper_##suffix(u64 __user *uaddr, u32 oldval, u32 newval)      \
+{                                                                              \
+       int ret = 0;                                                            \
+       u64 oval, nval, tmp;                                                    \
+                                                                               \
+       asm volatile("//__lsui_cmpxchg_helper_" #suffix "\n"                    \
+       __LSUI_PREAMBLE                                                         \
+"      prfm    pstl1strm, %2\n"                                                \
+"1:    ldtr    %x1, %2\n"                                                      \
+"      bfi     %x1, %x5, #" #start_bit ", #32\n"                               \
+"      bfi     %x1, %x6, #" #start_bit ", #32\n"                               \
+"      mov     %x4, %x5\n"                                                     \
+"2:    caslt   %x5, %x6, %2\n"                                                 \
+"      sub     %x4, %x4, %x5\n"                                                \
+"      cbz     %x4, 3f\n"                                                      \
+"      mov     %w0, %w7\n"                                                     \
+"3:\n"                                                                         \
+"      dmb     ish\n"                                                          \
+"4:\n"                                                                         \
+       _ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)                                   \
+       _ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)                                   \
+       : "+r" (ret), "=&r" (oval), "+Q" (*uaddr), "=&r" (nval), "=&r" (tmp)    \
+       : "r" (oldval), "r" (newval), "Ir" (-EAGAIN)                            \
+       : "memory");                                                            \
+                                                                               \
+       return ret;                                                             \
+}
+
+LSUI_CMPXCHG_HELPER(lo, 0)
+LSUI_CMPXCHG_HELPER(hi, 32)
+
+static __always_inline int
+__lsui_cmpxchg_helper(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
+{
+       int ret;
+       unsigned long uaddr_al;
+
+       uaddr_al = ALIGN_DOWN((unsigned long)uaddr, sizeof(u64));
+
+       if (uaddr_al != (unsigned long)uaddr)
+               ret = __lsui_cmpxchg_helper_hi((u64 __user *)uaddr_al, oldval, newval);
+       else
+               ret = __lsui_cmpxchg_helper_lo((u64 __user *)uaddr_al, oldval, newval);
+
+       if (!ret)
+               *oval = oldval;
+
+       return ret;
+}
+
 static __always_inline int
 __lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
 {
@@ -135,71 +188,25 @@ __lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
 static __always_inline int
 __lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
 {
-       unsigned int loops = FUTEX_MAX_LOOPS;
-       int ret, oldval, tmp;
+       int ret = -EAGAIN;
+       u32 oldval, newval;

        /*
         * there are no ldteor/stteor instructions...
         */
-       asm volatile("// __lsui_futex_atomic_eor\n"
-       __LSUI_PREAMBLE
-"      prfm    pstl1strm, %2\n"
-"1:    ldtxr   %w1, %2\n"
-"      eor     %w3, %w1, %w5\n"
-"2:    stltxr  %w0, %w3, %2\n"
-"      cbz     %w0, 3f\n"
-"      sub     %w4, %w4, %w0\n"
-"      cbnz    %w4, 1b\n"
-"      mov     %w0, %w6\n"
-"3:\n"
-"      dmb     ish\n"
-       _ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)
-       _ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)
-       : "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp),
-         "+r" (loops)
-       : "r" (oparg), "Ir" (-EAGAIN)
-       : "memory");
+       unsafe_get_user(oldval, uaddr, err_fault);
+       newval = oldval ^ oparg;

-       if (!ret)
-               *oval = oldval;
+       ret = __lsui_cmpxchg_helper(uaddr, oldval, newval, oval);

+err_fault:
        return ret;
 }

 static __always_inline int
 __lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
 {
-       int ret = 0;
-       unsigned int loops = FUTEX_MAX_LOOPS;
-       u32 val, tmp;
-
-       /*
-        * cas{al}t doesn't support word size...
-        */
-       asm volatile("//__lsui_futex_cmpxchg\n"
-       __LSUI_PREAMBLE
-"      prfm    pstl1strm, %2\n"
-"1:    ldtxr   %w1, %2\n"
-"      eor     %w3, %w1, %w5\n"
-"      cbnz    %w3, 4f\n"
-"2:    stltxr  %w3, %w6, %2\n"
-"      cbz     %w3, 3f\n"
-"      sub     %w4, %w4, %w3\n"
-"      cbnz    %w4, 1b\n"
-"      mov     %w0, %w7\n"
-"3:\n"
-"      dmb     ish\n"
-"4:\n"
-       _ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)
-       _ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)
-       : "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp), "+r" (loops)
-       : "r" (oldval), "r" (newval), "Ir" (-EAGAIN)
-       : "memory");
-
-       if (!ret)
-               *oval = oldval;
-
-       return ret;
+       return __lsui_cmpxchg_helper(uaddr, oldval, newval, oval);
 }

 #define __lsui_llsc_body(op, ...)                                      \


This is based on the patch #6.

Am I missing something?

--
Sincerely,
Yeoreum Yun
