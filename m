Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011036.outbound.protection.outlook.com [52.101.65.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB493AFAEA;
	Mon,  3 Aug 2026 08:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785747413; cv=fail; b=bQUa2dJceRZsF22QbiawImwNLPf0oK5lkMSju6uVGy+brhaHN2j+EhG28St6SXwooRLpkrKXf43f2QWe4v9LINUYMG5VPaobqeD2ziSKzv3H9jc/jB9L14BS8KllP7yPadwN7C+l8Aaj0ALjsdzk7zV4CDqNjBS+F5pW3ePqVxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785747413; c=relaxed/simple;
	bh=ej0Vwulsxbjge5uvTVTlH0huCKGqngeHqH9jEoZti18=;
	h=From:Date:Subject:Content-Type:Message-Id:To:Cc:MIME-Version; b=pH7JPZya4sX/yovSyuQqDH6lfjdKcYJJi1t+G2jB0YRB6KQnpjp0zqvRhpxRAWXnP8q27i1xqgmNPMpX3c7d/tMJ2Qgm5vVW70hTS13HT7GLH1Ot7jx5y+PMRxl6kv1/RkrGovZ9ERP6MempGl00X0qP7Mz+aSKfAhzrHw5eUuw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=CNSDThSS; arc=fail smtp.client-ip=52.101.65.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="CNSDThSS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vLQ75cFBDJfKxDxhpSArOJaUaxcupr6TGv9DOYavJ2pPK2UUaZRUhiDbw4tgZGtJOHZ8DRNseXHUh1HLdYcr+H0SHotAHe2pQaaggh2JSv/2CtU8tYU+Ed2zLlRV90w06yolp+w+yi2qeA3ILK8+wPnAZJ/2OghU19UbKYBMUlQ8usk0t8ElJ5TTS6FXVquPey1F8Xs3t2Ix8bzyu/0keqOoSIZIwTMzlD8YHmDSiFOJwctE7P9e3UoKPMxMgFDpxb17MbOva/nWjFEaMoc6Db+5jeRvmE0yZXP9lRP5FAEcJg3Rzn4FjwIsVqExM30PO/+n6cx95X/AgDK9DvZPpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xMrRgiMv2E5/JXcx2GlHYmzI/BrQbpiT1Ec3jkVhAjk=;
 b=yewhkzO7x2QQQLztMZ6Hfy35aEsy1n9Rhw/LLb1bk5+kYpUpi8N6WFaReQtw6DKQVzBdZEvdsiXsksTxFBwuivX1wbvg8oYeMTbvmtb8beina61M3g0wM38T+TflQ/OPO2TBcG9mxAqJDYngqDjUhf7PH9G2SW8RmEuqAkTsox9PIesc9XGCZFLx8i7YXjpU5f9gAcyrkOrFcQ5D8564z6Elqj26PDdU72FyM9MpkCNcuI2tZY/AShBXQ6ix+vSr8g+rjUsQXnFtkNM0tCYfXxYdxWLgdOI1ynEMjW9DTgR+Ukaj9XGYA6m34RAltG9/WrObpdNZbbyqQdx4IHwKLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMrRgiMv2E5/JXcx2GlHYmzI/BrQbpiT1Ec3jkVhAjk=;
 b=CNSDThSS42GFhqSM14U3D4f+4yDifKJwEqk6PvxvHDprLgrS/Ll3EpoHeFFfOQA74uN23SD8rJDHQSDpKoxpz0SvzxAF15UrFKjlmm9fFdGnGIQNHkysoIR5NOtwbIbaa2qh4JNh2bafvi4X4Al+zNx7WtHah8lhLBFaaRWIjCwKGqy9TzaFnsRXbteHWqe7Ct6qMZ+ykAYrOSFk01iiMqAJxZgJpRLMSX0K5gG9+L5223iDW6HwvFq2x07W1N8SouJI6h9hzIEHeeRpyF+iFfoXsQQehxN6XGST4KRVkswgvtBqDf8NsGmKsvFUzLFtojmYnU6gsEodPMsQPw11Yw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by DU4PR04MB10767.eurprd04.prod.outlook.com (2603:10a6:10:580::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 08:56:46 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 08:56:46 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Date: Mon, 03 Aug 2026 16:54:44 +0800
Subject: [PATCH v3] arm64: errata: Add NXP iMX8QM workaround for A53 cache
 coherency issue
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-imx8qm-cache-coherency-v3-1-c518d0da3d3b@nxp.com>
X-B4-Tracking: v=1; b=H4sIAFRXcGoC/4WNTQ6CMBgFr0K6tqY/UMCV9zAuSvshNYFiiw2Ec
 HdbXOjGuJzkvZkVeXAGPDplK3IQjDd2iMAPGVKdHG6AjY6MGGGClKzGpp+rR4+VVB1gZTtwMKg
 Fc8pqXWjJNVAUz6OD1sy7+HJ9s382d1BTsqVFZ/xk3bKXA027v5FAMcWqrkQOrCI5L8/DPB6V7
 VFKBPYl4eSnhEVJIQoqoaGypeIj2bbtBSuftXMRAQAA
X-Change-ID: 20260729-imx8qm-cache-coherency-3129d5da3de1
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "Ivan T. Ivanov" <iivanov@suse.de>, 
 Francesco Dolcini <francesco@dolcini.it>, Frank Li <frank.li@nxp.com>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, imx@lists.linux.dev, 
 Peng Fan <peng.fan@nxp.com>, Steffen Eiden <seiden@linux.ibm.com>
X-Mailer: b4 0.15.2
X-ClientProxiedBy: SI2PR04CA0016.apcprd04.prod.outlook.com
 (2603:1096:4:197::7) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|DU4PR04MB10767:EE_
X-MS-Office365-Filtering-Correlation-Id: 58f1dea6-22c0-4414-ca70-08def13d25c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|19092799006|23010399003|11063799006|56012099006|10067099003|6133799003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	Q8NoPdRgilXw3Eq8E8LEyDRmA9KeRJPpWhmfhXws6YxprbO1Jxy/D6xPt1j6kBre/zwSQVKnvbhHh0iS5Rru4uLaokZdhcrko/eEjRClrUZ9Ld+E4tWJoCT+p3XXfINVv7u/BoOSDEyMVyhmuDIgzrgfmeiGaKgbGP3iyZ0gbc3aAJoo4J2vzIH9nev+DNV2OBR6wCefCaQzW1jE1cDgEiTwVex5Lrch7K2LEY2zmVcHktLhDcE9JAE0EgpF2WSoDbwqZSTfM02uPBDGTA0N6Ftsmo9WDMJKIsuaVRKPTe3zevBP+ZUWRRzHC1J3d1l0nY0Epr5kScDww47/H6oknlMkzingHde8hYgVfYnb8pTRZCinnR7oX4MtfVaUtF1jxuhlMQ30nnvFK9qEGETsiQglFyRbA5L9Cl1rt2IK/qvbi+IEV15BkoZBsef99JiqLt0xiA5bKWX97ThZ0uVB9pwyoKSFshcLGIFIyczZvSo4lc71ildbFM4GMdvHTX8nsTWE1nbSdTF9VTu5PkM9cJr3cTxhXy5rPzT7YguMc6ItnKS7A3DPt8d532Gg/TLF042fp2K9biJU9FdQs4f6lqLE+XTTF/ztq8WF5BxJReAfvi9wG9dXtCVtMmYZhhhf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(19092799006)(23010399003)(11063799006)(56012099006)(10067099003)(6133799003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFFsQk1KUlU0c3ZqcHZSNUFVQzNrcEswTnpyc3pOU1RhMjNENk1Rb2k5SmRN?=
 =?utf-8?B?N2tYNUhQeWJNekowNGxUWk5xT0NiUW9rRFEyNS80NWJSWlIvbnZ6RExlckhu?=
 =?utf-8?B?cjhFb3pkUnQ3N25SOC9IR2Q0R2pJdFQ4bnNDVG5pNnpzSUhzbUx4c2VzTmhn?=
 =?utf-8?B?UjVQbHA5cytoUkd6Tm1ScFlVWDBsKzk3U0FIUU5QNkVzaXdtZFVQL3pNaUkw?=
 =?utf-8?B?ZUNRaW1mRUZnZVA0RHlXVHVWbHQzWTdudk5ydWVMWTFZMk1WWkVhRW1LQjdV?=
 =?utf-8?B?eUcrUmpzUU15UkhramN5WjhoNzZKRWN5dnh6K1lYMWxrSGprVEJHTlFVMllo?=
 =?utf-8?B?MnduZ1h1YUs1WWgwV0xOUmt6VEVkdnZBUFQxTnM1aVhjZ0tLV3NsZTliV3FF?=
 =?utf-8?B?dWI4YXk2QW1VSlFvcVA0MmRhYVF2bUNaalROQy9RbHMxaHQvM3VUQVVyZHVQ?=
 =?utf-8?B?cnBPcjYydG9pSllUOHE1T2lrTFVBT29Jd01sazdzaXUrQW1DdDVrcFh1Q3pN?=
 =?utf-8?B?aENFMGJoNWhXV1BQb29XWHcyL25IWUl2WHdoU3R1bzgxMkVMVTJURGFGaXVx?=
 =?utf-8?B?OVRuY1N1ZlVUeStxUzVBWGtubFRaQXVFaHJWeEtLdEhmM1BQYmZsbW9jeGNi?=
 =?utf-8?B?YUJXcEt0OC9lbDloVkxIRTdPQUJEZDVqUVhqZmlLUHlvSXM3ZzhjS0V5MWg4?=
 =?utf-8?B?YXo0SVNaQlJPWGhkUS81WDRHaGpvL0dnQjg1aFRyNzhmWWlmNDNVaVJReWlv?=
 =?utf-8?B?cXpXMnh2QVM0TUUrNmRyN3lyRTJ3QUFzd2RCR1BRZ1pTSlJHRS8zNjh3WnFC?=
 =?utf-8?B?bHpqcVIvUDV4czJIYXhwQklGZ1BlVTg2R2xKSVd6dlFpcE0yR29FbjJFaFdu?=
 =?utf-8?B?MVU0SU11c2dBZU1sMEdWUGt6N3BYNHJSbjhWZVdmWS9sL3ZWWkgrZnoyMlVm?=
 =?utf-8?B?RmxNdjd5ckxUUGtNdEdOWDN5UU1UdExaMTVwdmxjcjlGWUhsM1I4YWp0WXAx?=
 =?utf-8?B?ZG9XU2pMMmM0N2RrSmRTekNxK2RNeXVZSng5bC9VSmJZaVNlYzJZVkZFYUNp?=
 =?utf-8?B?djBqdXZvUy9ZZ2NuM1NEQjk5ZXlsWjNpMjNGN3hHakZFSk9PR1dKNW9XTENS?=
 =?utf-8?B?aVdYSEl6SlljdGROeEJRRElPOEhOU1B1ZHNqazlvMm9HTGt1Nlh1T1dRa0ow?=
 =?utf-8?B?ZHF4OFRJdFR1TXJrUURXTnFDM3cwNTdIZkZiazVxcmo1T1dyQWxCN0xaWnd5?=
 =?utf-8?B?RW5YNW44a3N4UTMxU0FyZm11U0FvZjIwOXpJcnZyUCtiUFUwaWFMdlJ0TWFs?=
 =?utf-8?B?YW93d0o5N25SSHp2MFFQbjRFbTdmR0pXSzNlcjBIQmF2NjIzM2kySUdwWWhF?=
 =?utf-8?B?aXZCWStSK3V2dEwxKzJrY3BBNmp5MlI4dUY5QmQ2ZTBuWFZ2YmdNSXFSZ1Fw?=
 =?utf-8?B?M0hoaHJoQXZ4VDF3ZGxnVmFxLzgzdTZzUnRHcDA5QjNqYThIM2RYeDVQWkw2?=
 =?utf-8?B?azBGb3VNbjFOZmsrSWRWeHk5cllKbDJjZU1kTUFXcUZ4U0JoYkszVkM3OXBI?=
 =?utf-8?B?cDUxTFVtc3ZlTElkZE1vdVZFcVhTWlEzTXRzQXZuNDQyRElhUHUzdTRWejF6?=
 =?utf-8?B?T0x5K2JRakVTYU9kY1Q2eGQvZWlZQmdUd3ZGOHdJZE96VUdLM1F0UFNNenVY?=
 =?utf-8?B?djUveWRJNmxKR3lWWHFUall4T3R6cE5nVXFWSmdhYU42SlRRaFh4RmE0TXZS?=
 =?utf-8?B?VDFpcThOZjlMUWNvd3FSeFhMYTB5allEK2didXVxUm0vYThXem4rcWVTZUhw?=
 =?utf-8?B?eWVENHM5TXBuWjVMRmk2S2cvcmdONmUzdFNjUVp1MUZWSkZ0SmZFMmdLcjhp?=
 =?utf-8?B?Rmh2S1Nkazc2S3NWSEdEWW1xTmdjd0djUlNUUjZuQ3VscERRbVhVRGFzcTBU?=
 =?utf-8?B?QnJYalYzaUhvTExreGJTSGlxdHhYUTNzWU9RMVhNR2d3bExLWnkzVWRzSUpo?=
 =?utf-8?B?OVBhUW1SM1RVdG9PdkRGY1A2MTYwUU1nTzFwWUsyWVNuSjEwYlljSXdwbjVq?=
 =?utf-8?B?VFVWdXpFaWtqazhJVTM4dDdyUzNxUzRuVnZXbHY0ZkxHQXZvdDRYdEw4S0x2?=
 =?utf-8?B?Ukk0dmcrOVJHaG52QW9JeUZ3OUY3RlpsdWVSOWVqMlJ6R3JacUx2T0loVDR3?=
 =?utf-8?B?QkN3ak14K1ZiL200WWIyNlAwL0lIdm41SmVuenhQNzVYWjdyTFlJV1JQQ1k3?=
 =?utf-8?B?VjdIT1RjbUk3R0YwdkhOencyMTliYWtSeitUU1paK3hJQUdXU053V3lGYjdj?=
 =?utf-8?B?ajFhVmR2M3cxVml2dFVZcmxWdG94K2NZQWJkTjFvMWtWOUFZK21zbllTbXpi?=
 =?utf-8?Q?KkviF2EpEPrJ6Qw2NELzsYN6QWpSvagDLEsd+?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f1dea6-22c0-4414-ca70-08def13d25c5
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 08:56:46.4871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ov3ajGtjOD2sCWSVwnBI0dEASV+eddhDDl16Ni210TPYAJqZRZ57CFWgNeVSNsXE81JWjtWk2wlR9+qlU19vVcQzStSpD4t1AO7ybpuN+e8c3o8vzppverCkmEz84t0X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10767

From: Peng Fan <peng.fan@nxp.com>

According to NXP errata document IMX8_1N94W[1], the i.MX8QuadMax SoC
suffers from a cache coherency issue (ERR050104). The upper bits, above
bit 35, of the ARADDR and ACADDR buses within the Arm A53 subsystem
have been incorrectly connected. This causes some TLBI and IC
maintenance operations exchanged between the A53 and A72 core clusters
to be corrupted.

The workaround requires:

  - Downgrading targeted TLBI operations to broadcast-all variants.
    Instead of patching the low-level __TLBI_1 macro (which interferes
    with the REPEAT_TLBI workaround and causes excessive over-
    invalidation), redirect high-level TLB flush functions
    (flush_tlb_mm, __do_flush_tlb_range, flush_tlb_kernel_range,
    __flush_tlb_kernel_pgtable) to use VMALLE1IS via static key checks.

  - Upgrading IC IVAU to IC IALLUIS for both kernel (via ALTERNATIVE in
    invalidate_icache_by_line) and EL0 userspace (via trap-and-upgrade
    in user_cache_maint_handler with SCTLR_EL1.UCI=0).

  - Disabling KVM since correct TLB maintenance cannot be guaranteed
    for guests.

  - No need to touch SMMU Broadcast TLB Maintenance (BTM) since i.MX8QM
    does not support broadcast TLB.

SoC detection uses devicetree compatible string "fsl,imx8qm" since the
boot CPU MIDR_EL1 (0x410fd034) and AIDR_EL1 (0) are not unique to this
SoC.

[1] https://www.nxp.com/docs/en/errata/IMX8_1N94W.pdf

[ Reworked per review feedback from Will Deacon and Mark Rutland:
  - Move TLBI workaround from __TLBI_1 macro to high-level flush
    functions to avoid REPEAT_TLBI interaction issues
  - Add kernel IC IVAU upgrade via ALTERNATIVE in assembler.h
  - Add cpucap_is_possible() entry for compile-time elimination]

Co-developed-by: Ivan T. Ivanov <iivanov@suse.de>
Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
Link: https://lore.kernel.org/all/20230420112952.28340-1-iivanov@suse.de/
Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
This picks up the work originally done by Ivan T. Ivanov in 2023 [1],
reworked to address review feedback from Will Deacon and Mark Rutland,
and rebased onto linux-next (next-20260723).

Changes from v2 [1]:
  - Moved TLBI workaround from __TLBI_1 macro to high-level flush
    functions (flush_tlb_mm, __do_flush_tlb_range, flush_tlb_kernel_range,
    __flush_tlb_kernel_pgtable) to avoid REPEAT_TLBI interaction issues,
    per Will Deacon suggestion to use static keys at the higher level.
  - Added kernel IC IVAU -> IC IALLUIS upgrade via ALTERNATIVE in
    assembler.h, per Mark Rutland review noting that only EL0 traps
    were handled in v2.
  - Added cpucap_is_possible() entry for compile-time elimination when
    CONFIG_NXP_IMX8QM_ERRATUM_ERR050104 is not set.
  - Dropped SMMU BTM changes since iMX8QM does not support broadcast TLB.

[1] https://lore.kernel.org/all/20230420112952.28340-1-iivanov@suse.de/
[2] https://www.nxp.com/docs/en/errata/IMX8_1N94W.pdf
---
Changes in v3:
- Disable KVM via kvm_disable_mode() setting KVM_MODE_NONE from the
  erratum cpu_enable callback, so KVM disables itself gracefully,
  instead of a special-case check in kvm_arm_init() (Marc Zyngier).
- Link to v2: https://patch.msgid.link/20260730-imx8qm-cache-coherency-v2-1-5651aeb1af16@nxp.com

Changes in v2:
- Skip the workaround for local (TLBF_NOBROADCAST) TLB flushes; they
  don't cross the core's external interface (Mark Rutland).
- Preserve IC IVAU fault reporting: run "ic ivau" for the local fault
  check, then "ic ialluis" only on success (Mark Rutland).
- Link to v1: https://patch.msgid.link/20260729-imx8qm-cache-coherency-v1-1-c9864e280437@nxp.com

To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
To: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
To: Steffen Eiden <seiden@linux.ibm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvmarm@lists.linux.dev
---
 Documentation/arch/arm64/silicon-errata.rst |  2 +
 arch/arm64/Kconfig                          | 16 ++++++++
 arch/arm64/include/asm/assembler.h          |  5 +++
 arch/arm64/include/asm/cpucaps.h            |  2 +
 arch/arm64/include/asm/kvm_host.h           |  2 +
 arch/arm64/include/asm/tlbflush.h           | 62 ++++++++++++++++++-----------
 arch/arm64/kernel/cpu_errata.c              | 33 +++++++++++++++
 arch/arm64/kernel/traps.c                   |  2 +
 arch/arm64/kvm/arm.c                        |  5 +++
 arch/arm64/tools/cpucaps                    |  1 +
 10 files changed, 106 insertions(+), 24 deletions(-)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index 868bd9eed9a6..a90fd2ec532b 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -321,6 +321,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585         |
 +----------------+-----------------+-----------------+-----------------------------+
+| Freescale/NXP  | i.MX 8QuadMax   | ERR050104       | NXP_IMX8QM_ERRATUM_ERR050104|
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | Hisilicon      | Hip0{5,6,7}     | #161010101      | HISILICON_ERRATUM_161010101 |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index faccdf847a67..eea6774baf0d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1454,6 +1454,22 @@ config ROCKCHIP_ERRATUM_3588001
 
 	  If unsure, say Y.
 
+config NXP_IMX8QM_ERRATUM_ERR050104
+	bool "NXP iMX8QM ERR050104: broken cache/TLB invalidation broadcast"
+	default y
+	help
+	  On iMX8QM, address bits above bit 35 in the A53 subsystem ARADDR and
+	  ACADDR buses are incorrectly connected. This corrupts targeted TLBI
+	  and IC broadcasts exchanged between the A53 and A72 core clusters.
+
+	  Work around this by redirecting targeted TLBI operations to
+	  broadcast-all variants (VMALLE1IS) in the high-level TLB flush
+	  functions, upgrading IC IVAU to IC IALLUIS for both kernel and
+	  user-space, and disabling KVM since correct TLB maintenance
+	  cannot be guaranteed for guests.
+
+	  If unsure, say Y.
+
 config SOCIONEXT_SYNQUACER_PREITS
 	bool "Socionext Synquacer: Workaround for GICv3 pre-ITS"
 	default y
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index effae53e9739..b35c9308e32b 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -455,6 +455,10 @@ alternative_else_nop_endif
  * 	Corrupts:	tmp1, tmp2
  */
 	.macro invalidate_icache_by_line start, end, tmp1, tmp2, fixup
+alternative_if ARM64_WORKAROUND_NXP_ERR050104
+	ic	ialluis
+	b	.Licache_done\@
+alternative_else_nop_endif
 	icache_line_size \tmp1, \tmp2
 	sub	\tmp2, \tmp1, #1
 	bic	\tmp2, \start, \tmp2
@@ -463,6 +467,7 @@ alternative_else_nop_endif
 	add	\tmp2, \tmp2, \tmp1
 	cmp	\tmp2, \end
 	b.lo	.Licache_op\@
+.Licache_done\@:
 	dsb	ish
 	isb
 
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 76350b38f0d7..0c3bfbe99aad 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -66,6 +66,8 @@ cpucap_is_possible(const unsigned int cap)
 		return IS_ENABLED(CONFIG_ARM64_ERRATUM_3194386);
 	case ARM64_WORKAROUND_4193714:
 		return IS_ENABLED(CONFIG_ARM64_ERRATUM_4193714);
+	case ARM64_WORKAROUND_NXP_ERR050104:
+		return IS_ENABLED(CONFIG_NXP_IMX8QM_ERRATUM_ERR050104);
 	case ARM64_MPAM:
 		/*
 		 * KVM MPAM support doesn't rely on the host kernel supporting MPAM.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bae2c4f92ef5..edac8fd5b2ac 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -73,8 +73,10 @@ enum kvm_mode {
 };
 #ifdef CONFIG_KVM
 enum kvm_mode kvm_get_mode(void);
+void kvm_disable_mode(void);
 #else
 static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
+static inline void kvm_disable_mode(void) { };
 #endif
 
 extern unsigned int __ro_after_init kvm_sve_max_vl;
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 14a78ac0f800..a05520d3a013 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -378,9 +378,13 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
 	unsigned long asid;
 
 	dsb(ishst);
-	asid = __TLBI_VADDR(0, ASID(mm));
-	__tlbi(aside1is, asid);
-	__tlbi_user(aside1is, asid);
+	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_NXP_ERR050104)) {
+		__tlbi(vmalle1is);
+	} else {
+		asid = __TLBI_VADDR(0, ASID(mm));
+		__tlbi(aside1is, asid);
+		__tlbi_user(aside1is, asid);
+	}
 	__tlbi_sync_s1ish(mm);
 	mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
 }
@@ -580,23 +584,28 @@ static __always_inline void __do_flush_tlb_range(struct vm_area_struct *vma,
 
 	asid = ASID(mm);
 
-	switch (flags & (TLBF_NOWALKCACHE | TLBF_NOBROADCAST)) {
-	case TLBF_NONE:
-		__flush_s1_tlb_range_op(vae1is, start, pages, stride,
-					asid, tlb_level);
-		break;
-	case TLBF_NOWALKCACHE:
-		__flush_s1_tlb_range_op(vale1is, start, pages, stride,
-					asid, tlb_level);
-		break;
-	case TLBF_NOBROADCAST:
-		/* Combination unused */
-		BUG();
-		break;
-	case TLBF_NOWALKCACHE | TLBF_NOBROADCAST:
-		__flush_s1_tlb_range_op(vale1, start, pages, stride,
-					asid, tlb_level);
-		break;
+	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_NXP_ERR050104) &&
+	    !(flags & TLBF_NOBROADCAST)) {
+		__tlbi(vmalle1is);
+	} else {
+		switch (flags & (TLBF_NOWALKCACHE | TLBF_NOBROADCAST)) {
+		case TLBF_NONE:
+			__flush_s1_tlb_range_op(vae1is, start, pages, stride,
+						asid, tlb_level);
+			break;
+		case TLBF_NOWALKCACHE:
+			__flush_s1_tlb_range_op(vale1is, start, pages, stride,
+						asid, tlb_level);
+			break;
+		case TLBF_NOBROADCAST:
+			/* Combination unused */
+			BUG();
+			break;
+		case TLBF_NOWALKCACHE | TLBF_NOBROADCAST:
+			__flush_s1_tlb_range_op(vale1, start, pages, stride,
+						asid, tlb_level);
+			break;
+		}
 	}
 
 	if (!(flags & TLBF_NONOTIFY))
@@ -657,7 +666,8 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
 	end = round_up(end, stride);
 	pages = (end - start) >> PAGE_SHIFT;
 
-	if (__flush_tlb_range_limit_excess(pages, stride)) {
+	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_NXP_ERR050104) ||
+	    __flush_tlb_range_limit_excess(pages, stride)) {
 		flush_tlb_all();
 		return;
 	}
@@ -675,10 +685,14 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
  */
 static inline void __flush_tlb_kernel_pgtable(unsigned long kaddr)
 {
-	unsigned long addr = __TLBI_VADDR(kaddr, 0);
-
 	dsb(ishst);
-	__tlbi(vaae1is, addr);
+	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_NXP_ERR050104)) {
+		__tlbi(vmalle1is);
+	} else {
+		unsigned long addr = __TLBI_VADDR(kaddr, 0);
+
+		__tlbi(vaae1is, addr);
+	}
 	__tlbi_sync_s1ish_kernel();
 	isb();
 }
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 5db8f0619e4b..4ba68c1f29b2 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/arm-smccc.h>
+#include <linux/of.h>
 #include <linux/types.h>
 #include <linux/cpu.h>
 #include <asm/cpu.h>
@@ -13,6 +14,7 @@
 #include <asm/cpufeature.h>
 #include <asm/fpsimd.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_host.h>
 #include <asm/smp_plat.h>
 
 static u64 target_impl_cpu_num;
@@ -200,6 +202,28 @@ cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused)
 	sysreg_clear_set(sctlr_el1, SCTLR_EL1_UCI, 0);
 }
 
+#ifdef CONFIG_NXP_IMX8QM_ERRATUM_ERR050104
+static bool
+is_imx8qm_soc(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	WARN_ON(preemptible());
+
+	return of_machine_is_compatible("fsl,imx8qm");
+}
+
+static void
+cpu_enable_imx8qm_err050104(const struct arm64_cpu_capabilities *__unused)
+{
+	cpu_enable_cache_maint_trap(__unused);
+
+	/*
+	 * TLB maintenance cannot be guaranteed correct for guests, so
+	 * disable KVM as if kvm-arm.mode=none was passed on the command line.
+	 */
+	kvm_disable_mode();
+}
+#endif
+
 #define CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)	\
 	.matches = is_affected_midr_range,			\
 	.midr_range = MIDR_RANGE(model, v_min, r_min, v_max, r_max)
@@ -1030,6 +1054,15 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_broken_gic_v3_seis,
 	},
+#ifdef CONFIG_NXP_IMX8QM_ERRATUM_ERR050104
+	{
+		.desc = "NXP erratum ERR050104",
+		.capability = ARM64_WORKAROUND_NXP_ERR050104,
+		.type = ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE,
+		.matches = is_imx8qm_soc,
+		.cpu_enable = cpu_enable_imx8qm_err050104,
+	},
+#endif
 	{
 	}
 };
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 914282016069..d6391ab20db3 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -586,6 +586,8 @@ static void user_cache_maint_handler(unsigned long esr, struct pt_regs *regs)
 		break;
 	case ESR_ELx_SYS64_ISS_CRM_IC_IVAU:	/* IC IVAU */
 		__user_cache_maint("ic ivau", address, ret);
+		if (cpus_have_final_cap(ARM64_WORKAROUND_NXP_ERR050104) && !ret)
+			asm volatile("ic ialluis");
 		break;
 	default:
 		force_signal_inject(SIGILL, ILL_ILLOPC, regs->pc, 0);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9a6c72a18672..1b9213d3e168 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -3176,4 +3176,9 @@ enum kvm_mode kvm_get_mode(void)
 	return kvm_mode;
 }
 
+void kvm_disable_mode(void)
+{
+	kvm_mode = KVM_MODE_NONE;
+}
+
 module_init(kvm_arm_init);
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index fbf27e887e71..fb3fe9736cc6 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -123,6 +123,7 @@ WORKAROUND_DEVICE_LOAD_ACQUIRE
 WORKAROUND_DISABLE_CNP
 WORKAROUND_GICv3_BROKEN_SEIS
 WORKAROUND_NVIDIA_OLYMPUS_1027
+WORKAROUND_NXP_ERR050104
 WORKAROUND_PMUV3_IMPDEF_TRAPS
 WORKAROUND_QCOM_FALKOR_E1003
 WORKAROUND_QCOM_ORYON_CNTVOFF

---
base-commit: 9eebf259d5352b87080d67758f483583d9e763d7
change-id: 20260729-imx8qm-cache-coherency-3129d5da3de1

Best regards,
--  
Peng Fan <peng.fan@nxp.com>

