Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013004.outbound.protection.outlook.com [52.101.72.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDEE33B6D6;
	Fri,  9 Oct 2026 17:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791566609; cv=fail; b=KveRTvp1GsDL5vcB0XW3bYw7A98PTYL9WrnzvmzfRq4hZpil2YfeFSVg9C61leHtHuO3RcM6I6yZZ2wqacINfadvFRPV0ALQ0YW9/B2Om6KV7FO0PZ5VkSvjUOaF77u0VaYbAgWZglmqTV1vB+TK9b2sNrvjiGyn5ZaW2bunqjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791566609; c=relaxed/simple;
	bh=lbs5UwOlRoOUn7h+/Xy1CSZt/8DkzQda3Z0BhAWSKYk=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=n1VethC+c12JZ0wYLeX1FEOxaOIzSjY1bI1eJ/6JCzNPGR45KPpdzoIMzj+OZFwMZiOvxojPfsPDPeAJHafAYq6NTDkD1J2ZcnDsO1PjwzOYcfPdyTPJIE/l375aOPQ7Dg2CgZesiBtmsy7P5ee4qcDrNyA6XSE4Aj/GAejPM/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=mM6CVJRv; arc=fail smtp.client-ip=52.101.72.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="mM6CVJRv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XH9XpCl4KAzqyE1mnlGyn6/w808cvxWE/DDXKIoaxJkwwU0CX21frIfL+YpSmGZZGXG8pU5f5zyGNFXJlQ42pXX7K6PEj0kvhkMifGoSCf09E6RvfIUfJqGkFG4l+zXJ1Vryee4l+yGqwjK5wVAU504nB9VI//nx5QQIf6wggBNyhocTW6Rf/JMhPlRG4HoJYh0xKcBk942OGigQvrZ5hJ8QI+DKHq2JsPdSvo5yzxGQm5pTpE45ImMVJdsw6AS+sG7Rvgaa8kDCASaQ/YDUMqOjarXuh+Tras0LREuhmUcngZL1XaqEtG4guxcvvvf2p316FyybMjWflqXbQwLYVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zI2o2yXT75V8gnfGiuvZRoyF0i3p6LMPAUOG6clwjk=;
 b=bmQzS4POMbAdGc4Bvs3hOl5qNUc5bBWLIJSIXBT7anrAH4q38b/SJAVQYOFhfI+jqThvZm4Wp3JXxZme6D2mI7eDSeCPXhk+UUtjSkqJenOq3HqD2yunppx3hZtkdMKcYBky/Is0uByBpI7o6FIltaGW2/V98153JQvdq5UAIVxPKkEe/9a9X6yBKrt+0MbamuXnedrLu+k/8VnGOzYcjXGSNnkyRe6ex++BacAKtOwHdewsLtyh6KNpptzGVY8yTVph8ghX+1gS0hLXYO/7OZ/AGQNY3WzbmWNCmcSIFzGsZypKU5cYVlL/+3hznIda7EnYfRQzAyg+7raYjTzKrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zI2o2yXT75V8gnfGiuvZRoyF0i3p6LMPAUOG6clwjk=;
 b=mM6CVJRvBvti33Z5kMssukzfTi8G2xgPjGMS0trdYoUXUZcP5ilvb7mrAqT5oXQd7GcmfNPOk7IgZPGTlk5Ew2wvbHYX7c7lo1Om98Su+rX0ScqC2Y4jOqJILy7uwXInDKWdIrff+27mvbYBLf6KacZjDi632TOK1knOGBdpqdtWTv2FHwa4BmFjfJPYiUCQz2WazEPkbs2XBc5S2SadiOmvUZr6KnkMl1gPUPVIW6m9ywJ/bvfwjybuQH5GgkcORYaXatM62YapcVQpghRiLFav8/BcuVS8IiPiEDUO5c13k1rtbS+ewS2OPWLiceGMGaeHvCWIMUgBcszQ08TekQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by AS8PR04MB8343.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Fri, 9 Oct
 2026 17:23:24 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0496.010; Fri, 9 Oct 2026
 17:23:24 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Date: Sat, 10 Oct 2026 01:19:45 +0800
Subject: [PATCH v5 1/2] arm64: cpufeature: add ARM64_CPUCAP_SOC_ERRATUM for
 SoC-level errata
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261010-imx8qm-cache-coherency-v5-v5-1-c9d6cd60c0c2@nxp.com>
References: <20261010-imx8qm-cache-coherency-v5-v5-0-c9d6cd60c0c2@nxp.com>
In-Reply-To: <20261010-imx8qm-cache-coherency-v5-v5-0-c9d6cd60c0c2@nxp.com>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>
Cc: "Ivan T. Ivanov" <iivanov@suse.de>, 
 Francesco Dolcini <francesco@dolcini.it>, 
 Franz Schnyder <franz.schnyder@toradex.com>, Frank Li <frank.li@nxp.com>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, imx@lists.linux.dev, 
 Peng Fan <peng.fan@nxp.com>
X-Mailer: b4 0.15.2
X-ClientProxiedBy: MA5PR01CA0094.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1a8::17) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|AS8PR04MB8343:EE_
X-MS-Office365-Filtering-Correlation-Id: f3793e9c-0736-475c-25fe-08df262a0645
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|366016|1800799024|7416014|376014|921020|11063799006|10067099003|56012099006|18002099003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7FlsKFTykt/bLm/Fbt7uToPIiSoTXvv51Fhx4CTXSjdtwbiqNdSFvGlSkK7ZtKRmn/P9lwYTaXJaa/2fxI4mn8w1J1QVBWFBwRDXXRfRnEoJGJa3EoVo9SaGVxpWN8jepMmSRaxw8CyL0fce6CZYKonOq1D7p3LdpE1RFtEnjUn8AlGlil8K3U52ooUuoTn1qZOIwnbXaY9aRzdjRCehy77NZBMEnz9KHZePmUClFkSlxYfZtTb7mfErM6GVA62E/se86POY+yfhRWGGbCA+Mak3tT+ZIAFw8nVEYbQuUflASeXXlav+M6XqbGdh4INzOkyS0l7V7KC86VxlwZMFvxF7V8zOYa+FcLECV0lPHiEd8xcNKUmqSCIQIfjGMRf5Y/ys9tL1I5tAAlnuckoVmwo00BeJkvgftdhR3jACeeUA5uIXlcyl9uRNeU5jIYRnEUzGylhZv7YZWRouRYybqK/cO7OHixfdsfgTGzAE38T5Tj4XJNAiuzskdK9Lqwi5soUnRVum+HLkRqDuY5CcPLc5xrw83/vtxXdhNlm+wXgUcBYBoArKL0CmV/9Mv+Uj9UaUAQy+mGFd8NoCwGkcWY3eJg5Tlw9rOQcPxpaIN6A0dfb9RuYNxRpy2yem0/zQVGWMaEty9kAk7MHFya7Qw7UmcNoGiHUssxaZnU4gcQltUKn6EO9GDo9dvxgeGaLaOnwMGvCSS1hD95Nc/mzGQA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(366016)(1800799024)(7416014)(376014)(921020)(11063799006)(10067099003)(56012099006)(18002099003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NlZFdHBMbW9HZG94RDBXdlNETTZGUEczODJjdFBRVGF6SnZ1YWwzaEpoajQz?=
 =?utf-8?B?eGRjZG9iTU1OSktEYUFVWlAvSTBHYXpVVWhDQkVYMWJPRUhmV2xmVnM5VnJN?=
 =?utf-8?B?VFBGMk1JU21nQkpDQndraXJJclZKekxkbkVWS0NIRVlGRmdIV29ZN2Npd0xy?=
 =?utf-8?B?L0RuUmJHQWdMeXlockxZN3g3NGNPcTBIVVQvYmR2Kzg1NnFRSS9MRllZbjdC?=
 =?utf-8?B?Sk9pamRVVS9ZSlpJYjQzTytGK1R0dUR3aUtSRmtmcTZHM3UvZUVrODQyNlJT?=
 =?utf-8?B?K2NhUm10ZWZWRGN4SisybHVJVmk1UStzVjUxdnFrQm1zb2FuaWllZnNPeElP?=
 =?utf-8?B?YmNXaTl3TTBabWg0bmhQRVA2Tzh3YWI2cmFPZFhoaHMzaGRhZ3hQTzhIMWw2?=
 =?utf-8?B?aUNmNm45Z05HTjBVV1J3eVd4UnVPazgvUEI4VzZwd1hFWkRZMFBVRFdCSUJS?=
 =?utf-8?B?RGF0VDgrV2tCcDBBUkVwV2gvbW53bzVQSnNpZVp3MllTSGJIQ3Uzb09BbXda?=
 =?utf-8?B?YzExMlhFOUp3WG9seUh6QnpGUzJNS1lxL3VpUUVtZzlhYitOb2QvemlFS2dP?=
 =?utf-8?B?c0xUQ0s1OUJ2d0pFODhhV2lmSTBsWjFEWjRiaFc3b1Bla001S3p0dXlTUFdN?=
 =?utf-8?B?TFJsbkxKanRmcERJRlFqOUhjNHVVSzZNUnlpWnM0ZG55bzBVSDNzTjZVZ1Q4?=
 =?utf-8?B?RldiZnpNZjBPQnlFTmF6QnFnZG93VWxOWWlxNjZkb2pQTzZvN1h3L3FtUkta?=
 =?utf-8?B?Mm44R2lSYTRYc20rbnJVanNPcGFIWlJBV09vMmNmb1d3Nk8rVjM4Ny9PN2V6?=
 =?utf-8?B?UTlhc0ovSHhxQjk4WDdFQWhJN3Bac0FXMlBCYmpsSmYxcEVJN1N0NFhNTWRJ?=
 =?utf-8?B?VVBHWjRhU1VuMTYxRVlzOTlhYWdKS2pHcmhFZlRFMUFncWdaZHZLa2tUZ1h1?=
 =?utf-8?B?OXlLOHdLZzJMTnFtL3hmVUdnWFhLdk13enJOeS9tQ21jZFo1S1d6MlFxVUVo?=
 =?utf-8?B?c1RzYURhanRVYjNoOXU2ZFJXalF0WG5MK2YyWkt2eDQ4aWRKajQrdmJmK2dh?=
 =?utf-8?B?MS9mUGVHZG9sNDVnTFBFUGt2KzloVkcyQ1dmVWpJY3JycmNBMjlJaDNEQUND?=
 =?utf-8?B?RnhTbUs3eXhGV3Nmd01UTFpIRncwVHJrbUcrVlQ0aFZyTnZZbEtVeFdwUXpB?=
 =?utf-8?B?dWhSN29TMEk2QWFkVzJKQWw4S0lhOVBCNXFUTFNQQjY2eElycVF6LzF5RlNB?=
 =?utf-8?B?UHBLSVRVekU0MFFaTUhBNWFYTTF4MC9hWjJGdG1pT2c4TnlmY29vZkREYTRZ?=
 =?utf-8?B?VHhiR2JKVnJpTzA2QUN4b1JoYTk5UGJURmtDN3RmNldRK2NINEtoaVppY3F6?=
 =?utf-8?B?bXl4dWwwS0p0TC9NRFNSK0xMWlJPbFpoZThIdXE4WEI5NUtka0UzVjhwaXdL?=
 =?utf-8?B?a2JBNnJETktBdkFzNW5oYWk4bTRjOEdnT3JOclBzQXYycndlejNrRDhtQjdl?=
 =?utf-8?B?RldHOG0vVWw3RWxldGhjd0orK0FaSWF4L0xhSkpmRFNWckhNQkF3M2E1QXR4?=
 =?utf-8?B?OGlKWEVvcWNaSkN2Rzhvd0VPWTdKbXRQZ3hPeHNNNDgvNU1QblZpUGFDSlI1?=
 =?utf-8?B?NVkvbVpVc05za3N1a1czcTJyRytYb0UwYkdlcnpocEdEWmxCcFRRTmxJT1cv?=
 =?utf-8?B?LzlYZWJScVQvTWFjSnFQNDJaNHN0ciswcVhPL2pFOUZZeHV3bXczTVlTU1Bk?=
 =?utf-8?B?YjFya3NXVEI3R3dqZC9mYlFwTnFNZFRHczl0RDdNc0xwbURQczBiY0QxTVRI?=
 =?utf-8?B?WHRJMitJTlF6L2hWZ2M5NXV3citOUmM0U05XT0tJZTBGRkZ5eWcwT0t4c0RI?=
 =?utf-8?B?cDlpdmZjbE8xWXR6djRHazhjekw2NSsrbXJZMWg2Y1gxN2NlTzlCeERVcnBz?=
 =?utf-8?B?K2hZMHRaUFlab1p2SlN3T3lPSjJ6R3N0NzYzSmF2VGlhVy8zb2p3ajk3WmFu?=
 =?utf-8?B?STJHM3pRTFNFQkJ6RWNLRXB2MnQyMFhJTmpCQURqMnBwV3pRZ2RBK0JTN25U?=
 =?utf-8?B?UWZEMDRTY2hITE5aVFZxQ0ZBNlUybUFtZEJhNXViQWFOR0ZUK202am5jS0Ux?=
 =?utf-8?B?REM3TFNOUTd0QjZqOW9HYjdZS3QvRlpBZmlZZUpUaENXbldQWGszOEcya1RS?=
 =?utf-8?B?K0lLVVAxUjdvOE1JdmhSZ3ZqRUc2NFJ1Y3JFUFBIYUMxRnQycmVlR29pS3l5?=
 =?utf-8?B?TnhDTlkvZHRDTWFraHNzMTlhYlZOaDNuaUJCQnYyT1o3WnBWcEsyNkRGYjhp?=
 =?utf-8?B?V0xZN3krNkd5a0V3bnpncS9WRVFzNXRCMXBlV1Y5ckd6aE8xWjFJT2JHSHp0?=
 =?utf-8?Q?b0k9Wbt8OBrSMxZF8k6+6KzclGoNTQuK9RHXc?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3793e9c-0736-475c-25fe-08df262a0645
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2026 17:23:24.6667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n1/tuBLt0x38kNjQFoAhnU0G9B398LDwpXhZPuPqMzYOLYtJ5XJNp0yUxTMg7MUlUrhOuFwF34Lx8OyMz0Lztm5aoe/U5W1j3Ha/yKh5pxg80KOCx17pWwbCE1N3G21T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8343

From: Catalin Marinas <catalin.marinas@arm.com>

Add a new capability type for SoC-level (not CPU-level) errata. Unlike
CPU errata which need to be checked on every CPU, SoC errata are probed
once on the boot CPU and the result applies to all CPUs. Secondary
and late CPUs skip the matches() check but still get cpu_enable() called.

This avoids redundant probing on every secondary CPU for errata that
are SoC-wide properties, not per-CPU - such as ARM erratum 4311569
(which uses an early_param static key).

Convert ARM64_ERRATUM_4311569 from ARM64_CPUCAP_SYSTEM_FEATURE to
ARM64_CPUCAP_SOC_ERRATUM since it is a SoC-level property already
determined at boot.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Co-developed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 arch/arm64/include/asm/cpufeature.h | 20 ++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c      |  2 +-
 arch/arm64/kernel/cpufeature.c      |  5 ++++-
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 4f04ad82ea34..669f808e379e 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -266,6 +266,13 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
 #define SCOPE_BOOT_CPU				ARM64_CPUCAP_SCOPE_BOOT_CPU
 #define SCOPE_ALL				ARM64_CPUCAP_SCOPE_MASK
 
+/*
+ * matches() is called only once, when the capability is detected, and the
+ * result applies to all CPUs. Secondary and late CPUs are not checked for
+ * conflicts but cpu_enable() is still called on each of them. It has no
+ * effect on SCOPE_LOCAL_CPU capabilities.
+ */
+#define ARM64_CPUCAP_PROBE_ONCE			((u16)BIT(3))
 /*
  * Is it permitted for a late CPU to have this capability when system
  * hasn't already enabled it ?
@@ -293,6 +300,13 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
  */
 #define ARM64_CPUCAP_LOCAL_CPU_ERRATUM		\
 	(ARM64_CPUCAP_SCOPE_LOCAL_CPU | ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU)
+/*
+ * SoC (not CPU) errata workarounds. The erratum is probed once on the boot
+ * CPU, before the secondary CPUs are brought up, and no secondary or late CPU
+ * can conflict with it.
+ */
+#define ARM64_CPUCAP_SOC_ERRATUM			\
+	(ARM64_CPUCAP_SCOPE_BOOT_CPU | ARM64_CPUCAP_PROBE_ONCE)
 /*
  * CPU feature detected at boot time based on system-wide value of a
  * feature. It is safe for a late CPU to have this feature even though
@@ -414,6 +428,12 @@ static inline bool cpucap_match_all_early_cpus(const struct arm64_cpu_capabiliti
 	return cap->type & ARM64_CPUCAP_MATCH_ALL_EARLY_CPUS;
 }
 
+static inline bool cpucap_probe_once(const struct arm64_cpu_capabilities *cap)
+{
+	return (cap->type & ARM64_CPUCAP_PROBE_ONCE) &&
+	       !(cap->type & ARM64_CPUCAP_SCOPE_LOCAL_CPU);
+}
+
 /*
  * Generic helper for handling capabilities with multiple (match,enable) pairs
  * of call backs, sharing the same capability bit.
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index e0c09402540c..a418e240ccce 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -986,7 +986,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_ERRATUM_4311569
 	{
 		.capability = ARM64_WORKAROUND_4311569,
-		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.type = ARM64_CPUCAP_SOC_ERRATUM,
 		.matches = need_arm_si_l1_workaround_4311569,
 	},
 #endif
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 84053f0a8e01..0e4c3de78c1d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3695,8 +3695,11 @@ static void verify_local_cpu_caps(u16 scope_mask)
 		if (!caps || !(caps->type & scope_mask))
 			continue;
 
-		cpu_has_cap = caps->matches(caps, SCOPE_LOCAL_CPU);
 		system_has_cap = cpus_have_cap(caps->capability);
+		if (cpucap_probe_once(caps))
+			cpu_has_cap = system_has_cap;
+		else
+			cpu_has_cap = caps->matches(caps, SCOPE_LOCAL_CPU);
 
 		if (system_has_cap) {
 			/*

-- 
2.51.0

