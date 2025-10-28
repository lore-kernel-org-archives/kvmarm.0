Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013024.outbound.protection.outlook.com [52.101.72.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F1A2045B7
	for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 21:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761685637; cv=fail; b=ADmA6FStPK12HG+MICTKBnnnp+TnTfKcmCzRo15iyIN6tO2MJSzeJFn0ZhiY27tLooq194xz2loVF8nYinZnHCPOgTLRAwyFQ740j58TLvFfmeB+bqkZq2SfV2jbgG4FuF6Er08DYNMbdJ9xOngxaKRyTUL2gvNd2fH5KuAKEX0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761685637; c=relaxed/simple;
	bh=QFlHJqOT+KFIpdcUhPIJydPtMMiPeOph9bYPLIflQJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Wf2O/2jlq+wXXZRMo5mJoUKE2z6YqS1DQ53bd+Mr8BUDWfFFEXpvDUR+pKJrCflfUUqxywLJeMEEfEtlPLT+5+0weqjFI7FmssbUfDPEG96qbG2aWEbxNZ18ZwIkiYpJ/WGoY3UIxRSjuvQFfjhXs5pGc7Aymdcf16ELZ4iAGrE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Qg0JdxuX; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Qg0JdxuX; arc=fail smtp.client-ip=52.101.72.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Qg0JdxuX";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Qg0JdxuX"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=r6hxej0o1ELEBD+xTCvm3gho64FK5bYwlh/04FSB7dO7UEwg1PFeKlJb/QJpGK7MY6O0OxcbA0f1rXFFHLyx0QTDhiQnt36FPnJ8M2cvG1HfKobWx4VRrsOB4mP6hAhhw4Qa+lgyak1FCg6HqHFTBVs7dJxJSIsYSEQ/ia0q5YYqtcwrQ1m18xLlafkwTisb4Ddmg3FqSmilanVm6rQwRWMjysZS1457B9yQldnNxYdLQ+/xb4wPoqWTO6VDq4GHTsr6Kx4NKdjRjxwcy5p4dQozRoD57rxj/Ww7n76ONMLO8Tylh1+1ehUv1t35+EoO+s9XiEJMg5UqEmMs/Zw1dQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5vxH7XCTx/b/UD3e1BSyTYOs/DR5vW+vdklYIkA5zaM=;
 b=b79KDNK9f4ACDVupK7Nq+ZIQS7W0PKgb6l9QvFR9TX3vGOUYrTIV3nA17WFJGFq7iv2KX/e9tEwHp5Eouwb0navguWEGhXHMFC8DveA+AZTKESQENqvr0ow220KuPIk+AHkZ0FChhoZcsliIFNdf59lTN7T/1X35/+9U1DLAWoWMG6rrB0xsxR590VSZchtYVSn9KoJ6Wiagq2EFlXu+z+mL7KenYOpOeNXKrGMMoZe5MywBxz/6w/DE0kJTP4eNGcDo2xkUcUyL5a9AYuw50xOet8UZ9JR9HBeo2ZB0s37CZFBIwDdyfuSPGn3I19ajwG7Sr8oD1UHGGMA6f5BeAg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vxH7XCTx/b/UD3e1BSyTYOs/DR5vW+vdklYIkA5zaM=;
 b=Qg0JdxuX8rNPf5BM6jP0PcBPxwnEJ3a6CAfZzUeChZi6XYg9MHosuSAFKBLdr1id4y0ssIzGQ9mav9ysIUWwBZy8hDDs3jdlmvcwWsv/0QTyAxbyLHH1QdiFDo8Z6lBPXkNsVGJs6zma9hXCqtvfeA7FrXhOwJn3HqIS81rVSp0=
Received: from DU2PR04CA0277.eurprd04.prod.outlook.com (2603:10a6:10:28c::12)
 by AM9PR08MB6020.eurprd08.prod.outlook.com (2603:10a6:20b:2d6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 28 Oct
 2025 21:07:06 +0000
Received: from DB5PEPF00014B92.eurprd02.prod.outlook.com
 (2603:10a6:10:28c:cafe::3e) by DU2PR04CA0277.outlook.office365.com
 (2603:10a6:10:28c::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.16 via Frontend Transport; Tue,
 28 Oct 2025 21:07:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B92.mail.protection.outlook.com (10.167.8.230) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.10
 via Frontend Transport; Tue, 28 Oct 2025 21:07:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qKZhIc6czNhBuo61Qmvxix+CHE3ICLhtWpelXfV85nARfPThYtRCd0BIQxB5U82QPL3JIA76ahAPyKYPIv/WSFfrxId5x+zkzVwBnt+pU95wdTFOAHnPevYhZtwaIpyFTOk1Rr1cM2OKrj74N+02AsmMb1Fcl1CgVHFeTHcJrb9pQk8DwbG3EvXCQL85McxZ2t88PHVn90NLYEWf8efxu1yzhCyN3NxNmO1i5+b8+R7/4ePA97pBdHBqQa+uB7GrMv8WGZm77/+HydVb2ylKqeApyV+PkDz0qJc/VErRQJ/v2I9QKdzu4VT5vCU1nBVnShLfMagbVolHYjx55u+C6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5vxH7XCTx/b/UD3e1BSyTYOs/DR5vW+vdklYIkA5zaM=;
 b=sXpMmY8TeGfeDY1pONW+86MaHvM+d7V1kavSREO5imjQed/cFljySXCaJoVOyMe80Hpc2+UwxNTSo0moLaLk2iV6Ay9hK9GAXTAp4po5TXvgeArNPYO62MGduE+HaCstPyAhbIIDCMS/iV17jNscyfEIiI8J3JqB/R3iLsU8Mw/Ei/9TOmAMBbMrHfCiuTWvAAP2AV9puXE7AX4rbvsAFUMDxBCbChdmg2Gtwu+TknAf5TJ3ecHEVhraCtkLE002SeUUoSnrLxWpW1ZSYbShGsUEXOqUE3yuMbXpJbJx81GXGH1NzW6lrYDGQD/wmp2hByWHDFD+p01JOeABeAuVkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vxH7XCTx/b/UD3e1BSyTYOs/DR5vW+vdklYIkA5zaM=;
 b=Qg0JdxuX8rNPf5BM6jP0PcBPxwnEJ3a6CAfZzUeChZi6XYg9MHosuSAFKBLdr1id4y0ssIzGQ9mav9ysIUWwBZy8hDDs3jdlmvcwWsv/0QTyAxbyLHH1QdiFDo8Z6lBPXkNsVGJs6zma9hXCqtvfeA7FrXhOwJn3HqIS81rVSp0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by PAVPR08MB9651.eurprd08.prod.outlook.com
 (2603:10a6:102:31b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 21:06:33 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9275.011; Tue, 28 Oct 2025
 21:06:32 +0000
Date: Tue, 28 Oct 2025 21:06:29 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, perlarsen@google.com,
	ayrton@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: support optional calls of FF-A v1.2
Message-ID: <aQEwVe8+okm/Nmso@e129823.arm.com>
References: <20251027191729.1704744-1-yeoreum.yun@arm.com>
 <20251027191729.1704744-3-yeoreum.yun@arm.com>
 <f5aa3c19-fdea-4f62-9541-530e59b20a87@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5aa3c19-fdea-4f62-9541-530e59b20a87@arm.com>
X-ClientProxiedBy: LO2P265CA0421.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::25) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|PAVPR08MB9651:EE_|DB5PEPF00014B92:EE_|AM9PR08MB6020:EE_
X-MS-Office365-Filtering-Correlation-Id: a44cd3ac-375e-43c6-cf50-08de1665f306
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?m5iLyNIaJe8xVDdF0Xuba8LCRWAl8//vh4Oi9FeXZaHuOfRG1+9LERYw+IGw?=
 =?us-ascii?Q?THY4lE9S6gtkfWJJ7xYUGfi5sX2BZWEg+BgPFnV/rZ4smI3ifXQWo2crR2/1?=
 =?us-ascii?Q?EGp8gfMA2amRgX4FyfNIy1yaCIT+ycLsvGp9LP4QKb2L+g6fX7cy2uHv+uEK?=
 =?us-ascii?Q?EvieIyvFY4/n7MWHxRkUfCZr9PYjrunYWO4MZKzyjmpiwbaqx5jdjs4yMZpC?=
 =?us-ascii?Q?UoxSsDANsjXT4oQuVk777szd0LEVRYMT4K0lm+6Y4CZDIS1XSZGbG1v8z+oI?=
 =?us-ascii?Q?d9/9cfX6EQC9tj8R3NE4/LaE3Q1lsq1nW56k1HPs6J3rnBfT58CF3t1669f3?=
 =?us-ascii?Q?Aj2/kTFw/lqb4e9SfTqFZ7L4qWpRdYk2yBFddzLOswcSYRXrVLhwlbJ/qGbC?=
 =?us-ascii?Q?0cJdNCYHDMxC0sONuoojhV3ikz5+JN/2FZHJ3sD1sd4KBfVQPmuKZ4+tz+a3?=
 =?us-ascii?Q?EIpF3nfgLDHVhe+fNgHBeQAxjnrPJRhU7BB3NuRuC1xMvfIG/3AUiSQf251o?=
 =?us-ascii?Q?vAJWzCErE2UqRQTXOyBg2Gy1XaYyLlr+VeYLc57zNIwbzi76gz30UAywgIA2?=
 =?us-ascii?Q?FzErw0M9AeFNn4Kh7mJfKcDodWWF5PYwGDY2/yCdewx8ftBl5pXLTouH7sz+?=
 =?us-ascii?Q?lvW7xdmaxXpkhtjZr9lOqADieEDcagyGWfqXm6tS72+AFDv1QzP+NC5jB4DL?=
 =?us-ascii?Q?nimuD8XwQugFDMCoREY2Yjhi3BTE8eQZDBV27nBrkzTx2sAZNQIFzTOcKe2B?=
 =?us-ascii?Q?+FVZCP9Nl7/9KFubIRfb/PtuEfZFCXHGhaOo9xzdTaz+/+mWD22R6Qual13s?=
 =?us-ascii?Q?oiuNaCNYHwfJFGQGggAaBHWq1S4NELR+859wrixqb54eKvzXZK/fYoofQYaw?=
 =?us-ascii?Q?xzI8dg+St+z0mLqYrQcfjvLOrMTaPvJXDP08EgVCNPNgu+DqY7I0Uea5ZMJK?=
 =?us-ascii?Q?rWCGSbJ5gCFK6Aot5E+yf/Hpe4yCqEHCwryItwOFmjHOTHRTKA8cUT++uRaS?=
 =?us-ascii?Q?zYesVWhychiSzyffNMtm/2Z/iJ4po1HAQA2Uj3Ja2OB1JexPTkr5utfhMKO7?=
 =?us-ascii?Q?/EijiNGrIF7b++YZCFMjLeC81HcGJrRi7covD5gBAVSNLRlvsHMuTNuCEzta?=
 =?us-ascii?Q?FwbD9uR0TobqNNjZJ0RO2pFv0hwHJ5faxkD+648ynJjrQC4INfaXQpuMKpvd?=
 =?us-ascii?Q?d3licFLQ55c2n9bKsQvHU06TZzhYbBn5iS32vHs5voGpvp49y51Ygf3DphyX?=
 =?us-ascii?Q?2ykDSuWsaiOVLJAwCOKFvOcPmqCdDBMFh+kZJmL5GW2taqcee+sV14VJCDGc?=
 =?us-ascii?Q?m2UX+rxkJrduNeKQmychOVjXUJMOoUKQT1Nv58lmXnjtDvXBe6+AwA7vK8kD?=
 =?us-ascii?Q?Kjs4t47UpVnzZSEYvGPGadXZQ5XXOX+ZjMTHcTg6TDkYsGKByoGrVuz9kmrK?=
 =?us-ascii?Q?ThvSWXzRW2ZjG1VCFC2PX3qCVtpycWsP?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9651
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B92.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f1c5deaa-f691-45e0-411b-08de1665debf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|35042699022|1800799024|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O9jPadH6JTDLSoW7PHkcVIRAU9HGblaqYIR2pdP6Wa5ecxdMknZmNvWeq/h7?=
 =?us-ascii?Q?r0Ss4XVYDwnlmcnIXZhgk5FC778eSNED6eMIX7O28EXzjYdedfcJDGcwueag?=
 =?us-ascii?Q?MCepvjlW7c8Y1UiUMcARL+tbWcwbPTzRad+CsnScddNoiEMK44CIxtjgd8xL?=
 =?us-ascii?Q?pBzCPQih6pubP1fy8VwCsbdLyLWDyS1fFqra/uGDhS0mXJ0HnxxEeoLuTs9M?=
 =?us-ascii?Q?3VHbTwN0/K40vYWIn7k4gw0BKBQ5ey5ltWFaSYIeYcUUyBY8ZL/zCKQcL78D?=
 =?us-ascii?Q?RYSycDzJW/M5ed/wHuLwKobP5m+OGF9ASf9GYFMadIx8l3euAa6NhHeWUNg1?=
 =?us-ascii?Q?tRBVCfQMQ8p4OAW9l358FwNF0O1d1+VmCue4h4MzuusXPpWPtn1KNW++/m0C?=
 =?us-ascii?Q?2KoGkK0Odz5p7tGireG+wn7nna7HlLusOQ9Q3iprYKwQDo7h7Ds9SNRXmIBe?=
 =?us-ascii?Q?55Ls0AijT2erUAEXNYlXP89HGqj/xq3TZCNoohbmwyTFTvk6UpEnfP1aHreq?=
 =?us-ascii?Q?Nh0W5eMyEuka2rwSOMXoBLheSCLTdNmPJmrypMXGsjn4v9Z2VFUS75L0ElYJ?=
 =?us-ascii?Q?KUhIoV5SMRwk4JQNBwmU4WpQHvwvoPNx971OSdU14uTOjy8iuejmyVgVewvf?=
 =?us-ascii?Q?5xydbO06+Ga4DTsaNpULUl2nCpxSPX+IaP2iuh0Wcd0OAmmYWnQGUDRV9KDx?=
 =?us-ascii?Q?YZbsUi/dvj0xWOQuntvtqhTMHQHj0ISfcUdiTDYN8LvFmLCDX1HjkfyhjgRt?=
 =?us-ascii?Q?ogeSOMcLy/winRnlfvxqnLXV/dfEQsKnKdha2J7wDcXdig7W8JXDZhp8g4YB?=
 =?us-ascii?Q?UrCKun9b9RzZhu1GnGnBPiDljlHgzjwUDaMTo5uOhzvPsb9/eWslyOHeILn1?=
 =?us-ascii?Q?zAtN81gZpjHpBjJAZNPnDctqpCeJKtzvUr+HlTIDm0vRu6Y1G4rJgdAPc6oo?=
 =?us-ascii?Q?KFQMLulyxRcpTQivWMMyHR0N39T+HjwlUhFpE+N2J0/ef3b4CNbr7jfVFNEK?=
 =?us-ascii?Q?oIAbqzUau7olyZxMK7457UOKA/xOxJYFOA0NYx0wNJ2DehI0auLdkI8BL7P4?=
 =?us-ascii?Q?r9x7icZtt5XiH0txOqS3rW4NbjM/W8A0Eezrh/SRY6fHiEq7g915OW3aqBVS?=
 =?us-ascii?Q?fR95wyJlVnD7f094quQ77swn39yRsvJRxcHVrkdco/kFT18fOeTAqvVyw9JX?=
 =?us-ascii?Q?P8dnxpQVNaVil/0KUgm8DBNI7PqV7TisB81M17n37nKWeTdqi+FTNiG6ZWzR?=
 =?us-ascii?Q?CKS5/FMI+u9V07f8IEPZ/ByrdFxap8W9B5FBoKoR7CbdPtqmPmUDKU7QUYPn?=
 =?us-ascii?Q?SsNpxHYjristg9mmmFGNjc2wXDNI1klRzTPkcwWjJkqYkK5IOdwtOOm6j75J?=
 =?us-ascii?Q?yyo9NeanxHOSd06gS+AwigmYEIfdUWUzNahvR0DdgMyhuR36+8kJgUCAvT0t?=
 =?us-ascii?Q?eFzsCiiFCvMmuqz+OKojKWyQNTOyMo08n/6l3OCRrD00sm4KvrOWraOuBX19?=
 =?us-ascii?Q?7ub4XT5Ka/BfQ2TQoIQSrA20nlKKBfVruQyUhOvsg4FPUfZr3ynFvHK+OtZL?=
 =?us-ascii?Q?2ggd5BT5Awp1a+sLSsI=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(35042699022)(1800799024)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 21:07:05.7030
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a44cd3ac-375e-43c6-cf50-08de1665f306
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B92.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6020

Hi Ben,

> > To use TPM drvier which uses CRB over FF-A with FFA_DIRECT_REQ2,
> > support the FF-A v1.2's optinal calls by querying whether
> > SPMC supports those.
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 19 ++++++++++++++++++-
> >  1 file changed, 18 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 0ae87ff61758..9ded1c6369b9 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -646,6 +646,22 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
> >  		ffa_to_smccc_res(res, ret);
> >  }
> >
> > +static bool ffa_1_2_optional_calls_supported(u64 func_id)
> > +{
> > +	struct arm_smccc_1_2_regs res;
> > +
> > +	if (!smp_load_acquire(&has_version_negotiated) ||
> > +		(FFA_MINOR_VERSION(FFA_VERSION_1_2) < 2))
> > +		return false;
> > +
> > +	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
> > +		.a0 = FFA_FEATURES,
> > +		.a1 = func_id,
> > +	}, &res);
> > +
> > +	return res.a0 == FFA_SUCCESS;
> > +}
> > +
> >  /*
> >   * Is a given FFA function supported, either by forwarding on directly
> >   * or by handling at EL2?
> > @@ -678,12 +694,13 @@ static bool ffa_call_supported(u64 func_id)
> >  	case FFA_NOTIFICATION_SET:
> >  	case FFA_NOTIFICATION_GET:
> >  	case FFA_NOTIFICATION_INFO_GET:
> > +		return false;
> >  	/* Optional interfaces added in FF-A 1.2 */
> >  	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
> >  	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
> >  	case FFA_CONSOLE_LOG:			/* Optional per 13.1: not in Table 13.1 */
>
> Looking at table 13.54 in the FF-A 1.2 spec FFA_CONSOLE_LOG is only supported in secure FF-A
> instances and not from the normal world.

Thanks. in that case, we can return false for FFA_CONSOLE_LOG
unconditionally.

>
> >  	case FFA_PARTITION_INFO_GET_REGS:	/* Optional for virtual instances per 13.1 */
> > -		return false;
> > +		return ffa_1_2_optional_calls_supported(func_id);
> >  	}
>
> I don't think that an smc call here is the right thing to do. This changes this from a light
> weight deny list to an extra smc call for each ffa_msg_send_direct_req2 from the driver.
>
> Instead, I would expect this patch just to remove FFA_MSG_SEND_DIRECT_REQ2 from the deny list
> and rely on the TPM driver to use FFA_FEATURES to check whether it's supported.
>
> So, just this change:
>
> @@ -679,7 +679,6 @@ static bool ffa_call_supported(u64 func_id)
>         case FFA_NOTIFICATION_GET:
>         case FFA_NOTIFICATION_INFO_GET:
>         /* Optional interfaces added in FF-A 1.2 */
> -       case FFA_MSG_SEND_DIRECT_REQ2:          /* Optional per 7.5.1 */
>         case FFA_MSG_SEND_DIRECT_RESP2:         /* Optional per 7.5.1 */
>         case FFA_CONSOLE_LOG:                   /* Optional per 13.1: not in Table 13.1 */
>         case FFA_PARTITION_INFO_GET_REGS:       /* Optional for virtual instances per 13.1 */
>
> Am I missing something?

Nope. I think you don't think you miss anything and
I also think about it.

But, I'm not sure about "support" means in the pkvm about FF-A.
Anyway unless the SPMC doesn't support the specific FF-A ABI,
I don't know that's meaningful to return "TRUE" in here.
IOW, suppose pkvm returns supports of  FFA_MSG_SEND_DIRECT_REQ2
but user receive when it calls FFA_MSG_SEND_DIRECT_REQ2 with NOT SUPPORTED.

I'm not sure this inconsistency is allowed or not so as a defensive
perspective.

If that allows, I don't have a any special comment for this.

Thanks!

--
Sincerely,
Yeoreum Yun
