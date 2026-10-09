Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013069.outbound.protection.outlook.com [52.101.83.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AC93DA7F9;
	Fri,  9 Oct 2026 17:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791566620; cv=fail; b=eTLN9krfZkQtkmJboLjAKl8qM7b2dM+S9t5OUSMDNvC8YHeXYVeEUoF4FMkW18bW6vpgtMJ5SzNMyBcnL5sCTS5PEGpsT34YnAAGouudTKlbPqPDTy5NgB4oH4B2BnyNiJm3fjl9iUB3T7BBCI32VqxfQhtCBfgRt4IkclZ/p9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791566620; c=relaxed/simple;
	bh=QEyjdtvOC6EtWjXpCq6r1C484W/ioCLS3I90wFIDbYs=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=a3V/T9AT77R/jJ2QpFyqFxxCGi6KW6ZS+lKVNQ5We96ZS92MOv57u7fvRDcrlkrowlwX2/QB0q8itABuqGryxppkxdh/yLnSTRsCPrfTPH6pnrV2zt/qA1ay9Gr1L64rjJ4YNzx3T2V5ULhzihK1klDYbVuPPau+TKDBiP2C0co=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=vgEnwz8Y; arc=fail smtp.client-ip=52.101.83.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="vgEnwz8Y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sCwcLpqHoGcTpt5s9JCRsm0Bs63b5JhbTH1D+p7LMoEBsMMNta4taSQV80C/JhXhiEjA2uv6L4rfj97SSFr5s0ax0McsxJyYCLgWDo1SJjosBoYFlBXJVNW4wG5Ycud+3wCibeb28fzPEZRrIb3/IN2aXUCdTttPx8vnR/7PbJZSFSZMXk8sDJTKZTrkfSjFevVRRbqFQt7jLnmfLhnWDi008ED6pN8x9+mXDLx3RkCFjz918iCrcjBpG7eHUcJhl9OcUb6OAyxyGfB0rs8NG1E7WY0ZABlwUiXbDsUWLKrSKF6X4Ws67WTg9KjcW2l8p4KPuYKYHX0vRaIIef9NXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6DRcd+qXewQzAjtWTsp6aqERv5a44CDpzmx4tFC6ft4=;
 b=qkvaI6d9kY9/UzMYL3Prj+K4tAXsV2xrPxRY+ryqo8JSsCe7DWbtOf1yOHEX2P+NkEc8GROkyMFuZGT9zwHVsJMzEkL8aadKaSyA5oRdhvQ6qBr/vhW/JkqsW1CEHY9KXNdUdNGLoL3tVAynKzTSYchbs90Adhoag17JfE8CYinyr+jJyXDJeLWealTX3XSAXDqrRNZ6XRKJ1MzJ0h+EM7ZRZKnA1N6aolvAuLXOVWeSg6Am3DslDwAnbZOujhTDy7beE4o9r60S3/xJH5W+EKj3i5Fvy5MfQlneXShJcJXBlGcy6GXVNiFmJvqWCooVqV78CKBlLnoQ/+aNx3blGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DRcd+qXewQzAjtWTsp6aqERv5a44CDpzmx4tFC6ft4=;
 b=vgEnwz8YEl6KqjYXCYCUwaX0O7KUN4nTqlM9A3W5zoLOhpDD4ja68J4btC8fkNUbgf0uSDkj7BmFptPwmGwZrhdMuCkjwamajiwj+xnQUZLBC61L6o5dzY38lBUmkhqU2thDUxj8zJHuLLeo9bMiOGdTZ3LX9OcX3IkiHUiv1Q75Jqe+lCFbSnYk+mTtW4wpyUxZIy6ac9TrsMae2p0ZtFzpd8ocWwRu4hZr4if+Z/mf9DJCy4sc+G1cdCwAr1AVH13rmjNRwZ3PcVXxNMPbZfM7M2IOPfAZFcC6pUhLsP3jWnxUjT82Rm9I/Cil/6mHKxZyXERjO8eNn1gZ+WWz0w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by AS8PR04MB8343.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Fri, 9 Oct
 2026 17:23:33 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0496.010; Fri, 9 Oct 2026
 17:23:32 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Date: Sat, 10 Oct 2026 01:19:46 +0800
Subject: [PATCH v5 2/2] arm64: errata: Add NXP iMX8QM workaround for A53
 cache coherency issue
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261010-imx8qm-cache-coherency-v5-v5-2-c9d6cd60c0c2@nxp.com>
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
X-ClientProxiedBy: MA5P287CA0062.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d3::15) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|AS8PR04MB8343:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cd921eb-c1c5-44a8-f362-08df262a0a86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|366016|1800799024|7416014|376014|921020|11063799006|10067099003|56012099006|18002099003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	x/dtCxVM+UW+j2I6CDSS6C0xGFL47KgBZaBk04Qdts97EwdPWEIqBJeuQ6AVTZpJAf0KDoc4G/S1ptDyCdL43DehQqvtxTl+5eoso76/BnfDQjA3qZTDmIvtw/fLrNHPX+ae8CbxNlRwhEo0dPwyXeUin7T7+eB45gjltyDaWje4FrSzanMNTxcT/0fVA/ZCgVSCWPzwpNBwcF2rziKlP1XCDRLyluqQ20HVbXUcCoFSfz/ahPUzTaH++zRshpcL7W0elBPfd+ZQzPFsIHGf9V7K0IyZMhUb8NzbJh/BrMv0fcs8P+jduUo7WWjTPyWBOQM0j19nbiIhULzShpUWKGhMytTnfbpGbdVfUf2mpXPnjR1ayR1JsPq6ukE8Ux9EAAPUdp0Fr0DhHBakHJw+nMDHVO/LEqBxZNddV1VaR2OLoNR249x9UiM4/KIv/B6D/oPAyrPCAFPIOYnVjdf/o50m7flov/OlufiJy6OY4VaWcCFtcvUza6Oxjx8BwSuVvy8H6MuWIrF6FfhQ/IiYrke53tg1mwdRaP0nAHO5jVyKbstAC6qLvVEh0FV1DTQmRMsXheiyEXlTNh0swluPD1MnsII148VmPC62qgLcTCNXmoOQoQlS+uW+rHA3Q72iPFovpWpP5DbVxynB3NLhe08LUIwk0xm+8tKv9vRzuHhuGKTm5Ksl/iOEbAPxPCIwDwYi4XX4ir4pLMKtBpSFyw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(366016)(1800799024)(7416014)(376014)(921020)(11063799006)(10067099003)(56012099006)(18002099003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dnBjNGEvQjJlTzhwUjVHVlpCZGIyTkxMa2taUXprZ21sa3dhRXR1OG9kMVgy?=
 =?utf-8?B?MU9oWWV4YlJqTVBGTDBEK09aS3YrZmVQVnBCZzNsL0ZMelpZRjhldVh2ejR1?=
 =?utf-8?B?c0NWQ3F3emwwWVlIN1FTSWQ5dmNkVXA2M3NBc1dlSVBpcTZLMXFBV0MzS0dw?=
 =?utf-8?B?REIrZ2NYZUhSVTJFMTFnUncwR1ZjdUdpOHpxUDRCQjBwOFdQUnkxL1ZnMDc0?=
 =?utf-8?B?UDZPTWxYU3NRVjErNlVVdGQ2QzBwcDdkOHgxbG5CUkNLVy9xRThHN1UrS2p0?=
 =?utf-8?B?V055TzRBWTNTQ3NWUi9BS1RIUWFQVVhBTTlwSEUwSXovcWUwWmNRTmxJM0h4?=
 =?utf-8?B?b1AvOTZzbllhYzhwc3h6Z1dzNUdLODN0WjNudjdoY0tnMnlhTnUycGFzdTFo?=
 =?utf-8?B?TDFSL0dXU3hGTGI1VWpyRUJEMDVTL09BZ0dlTlBISVI2bnpqWmgwNyt3NXVN?=
 =?utf-8?B?V0FmSmdMVUFVc0UrR1NhaVo0bEpuWkd3VFJlZ0p1YzdmRll4T0g3UVRBZHVk?=
 =?utf-8?B?d0Z4L2RLYW56eU9RK3VKT3JMQk80c3gyUmhKZFZnQ2pRVkV2ZDFjdHkxUU9G?=
 =?utf-8?B?bVoyR0ovb0ZTaVRXQXlLSlNwN3czaWhzd0RTSlhqbG1jZFRHQU5MRnVWdmlV?=
 =?utf-8?B?dUx5bDUwZFFUUzY2WDY4cVdmRDBRUS9rb2xMVDNyRlAzdElKay9XMktaVS9q?=
 =?utf-8?B?NU9FbjBuUGtwa1lKb3JHTWYya1RLL21HUEdDSk1QL2t4a1QyU0twbXZDUFlt?=
 =?utf-8?B?R2dRT0Frc2NWanpQL2pCTkxWT1JIMzJ4TzdQbFpUelF0V3puRmFiWHhEL0Ux?=
 =?utf-8?B?NFFLR09HY1F2Wm9NcDhJN2RqMkJEVGVSWHM3NGdOOVNPQ2tRUUpvME5kblpK?=
 =?utf-8?B?aXo1VDNTdDlMWmZzMlBUMm4vTDRqYTExT0tiaWpWL24xbmJkYmlxN2x6WkFK?=
 =?utf-8?B?WVdaNkxySjdINUtqVUQyM0dIQnNWbEVZdERKTnlqQ2kwMkkyM2wyWkpSNDcy?=
 =?utf-8?B?aXhLbDZxdVhkY0FDeHZiUm5EUW9DRFhWMHpaWU1DWWxtd1owMlZYSFRrUXpo?=
 =?utf-8?B?b0xrU3RURFdhMWRjWm5EVmNBN1BXQ1FBaUZPYTdzdC8zeUpSK1Y0TnJVOGov?=
 =?utf-8?B?OXFkU1RjMXdBSnBjWHNaSkFoVWV2RXhNOEhaemFPSTU2cUtLbktkMVZnNjFm?=
 =?utf-8?B?WlR4cWIvd2hGY2RJbFBqL3ptYXROUFFOQlhwaDZCYVFwblgvekNXdWdtblRW?=
 =?utf-8?B?ZVo3YXNIODlDaEJCNzBod0tXK0NRdWk4VDZFWlgzR2Nvc2VrSkRSTjJ6Um1G?=
 =?utf-8?B?aEthNjN6ZVEvNEttYUxyNGIvS0ZjUnhxc24zRWJSUUljNG9mMVJSRTFHWWgw?=
 =?utf-8?B?dGtTbitIZWR3SXZBYVNuQ3pRZXR2MEhiTUVCZ3VUbTA3cDd0cFp5bmtZMnJl?=
 =?utf-8?B?RVJqRXpHN2E3TGZrM2NoYm0vWTUyNVgwOUsrdEQvbXV2NmJpa1JLbWlTTVVY?=
 =?utf-8?B?MCt5R01VSDg0VVdGdjV4ODFOd0gwL0JCdTQyZmpZNzZ3M21OemxCNkdpSFJ4?=
 =?utf-8?B?OThxa2JGN3lsa0NZTlRDUFRDOWcwbndGN2hwa0REdTRqUzdHVkJMeS9DV3J0?=
 =?utf-8?B?VDJrUVZoZldkeTB5cENGQmlObHpONFJpSXdwRk9nZmEwZDFpaFppeHdVTGJ5?=
 =?utf-8?B?ZTFVUG1PMGhEOTFLRllRVTkvejZiMWxrUnVzanN1UzZKYTd5Z3lTVkNBUkVJ?=
 =?utf-8?B?WTRxcVNIbDJ5M0ttQmNPQm4zalh6blpCMElwR3ZyNEhnV0NLaU5mKy9OT3NW?=
 =?utf-8?B?dVlCZjdvNG1FUFRhRTMrVjBqOFlBdCtYYjZJMy9HbmVJaWRKSDE3eWhMNEFp?=
 =?utf-8?B?R3BXVCtxekpROFcwTjhXc2ZjSUd3NTcyQjVXMkJWejBLdEpVWVlNejZJRGtL?=
 =?utf-8?B?cU5OVjFGVStCTTZ1ajZLbS9tRzJJTzJhdGtNRjZxWDA5aDdzdE1CbjZnNTdS?=
 =?utf-8?B?MjFkbVE1TXM0dkxjRnRvSStRZ0tqejV3OUdJZVVaeDdNdjhhQlBEbVA3YXNW?=
 =?utf-8?B?YUNrV3ZnK2M0elhYcFdnTDhyd3dGUzgxbmltRkRYMzdVcjVCeDRySVNLenZI?=
 =?utf-8?B?NU9WR3QrSGlyZk9MZzM3RXZYQURQMVViMytTeVFGVU9sYjF4U1BPclVraVdk?=
 =?utf-8?B?d2c2MW9wTGFmOTBvSE5pcUh6cmdFOC94YnBuNUoyQy9VOE9BNnYydEErTHEr?=
 =?utf-8?B?UFZDOWtYTW0rREFlYkJBdThubFE4SXE2M2xHZUhreEFnbzZMRGZpMUFLRmlu?=
 =?utf-8?B?a2haMTFVVTNPUXN6Ykh3SzJpMWlsNmM5cVVjNkJiSHNtWDZJT3lIRGZhbnVz?=
 =?utf-8?Q?5Xb63Axa0Pm8O2Eshgl/QcW+R4V62FOMgmiZ4?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cd921eb-c1c5-44a8-f362-08df262a0a86
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2026 17:23:31.9893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EUeVxG9/tSCoa61Q52EGla3ILzWWV/oSNoqxzf1fGJnyxzjKEtTKTX7D8OmmVhQf4AfDHTSVYFuK8VaJZ3UXTR11hb+T9zNBjdCbeN8J6wCB8g7BfTjUZdoMV0JOTuWI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8343

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

SoC detection uses devicetree compatible string "fsl,imx8qm" or
"fsl,imx8qp" since the boot CPU MIDR_EL1 (0x410fd034) and AIDR_EL1 (0)
are not unique to this SoC.

[1] https://www.nxp.com/docs/en/errata/IMX8_1N94W.pdf

[ Reworked per review feedback from Will Deacon and Mark Rutland:
  - Move TLBI workaround from __TLBI_1 macro to high-level flush
    functions to avoid REPEAT_TLBI interaction issues
  - Add kernel IC IVAU upgrade via ALTERNATIVE in assembler.h
  - Add cpucap_is_possible() entry for compile-time elimination]

Tested-by: Franz Schnyder <franz.schnyder@toradex.com> # Toradex Apalis iMX8QM
Co-developed-by: Ivan T. Ivanov <iivanov@suse.de>
Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 Documentation/arch/arm64/silicon-errata.rst |  2 +
 arch/arm64/Kconfig                          | 16 ++++++++
 arch/arm64/include/asm/assembler.h          |  5 +++
 arch/arm64/include/asm/cpucaps.h            |  2 +
 arch/arm64/include/asm/kvm_host.h           |  2 +
 arch/arm64/include/asm/tlbflush.h           | 62 ++++++++++++++++++-----------
 arch/arm64/kernel/cpu_errata.c              | 32 +++++++++++++++
 arch/arm64/kernel/traps.c                   |  2 +
 arch/arm64/kvm/arm.c                        |  5 +++
 arch/arm64/tools/cpucaps                    |  1 +
 10 files changed, 105 insertions(+), 24 deletions(-)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index 6de353e3f338..9ecace8778c1 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -332,6 +332,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585         |
 +----------------+-----------------+-----------------+-----------------------------+
+| Freescale/NXP  | i.MX 8QuadMax   | ERR050104       | NXP_IMX8QM_ERRATUM_ERR050104|
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | Hisilicon      | Hip0{5,6,7}     | #161010101      | HISILICON_ERRATUM_161010101 |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 5f2db2cecf97..098d2ae41023 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1488,6 +1488,22 @@ config ROCKCHIP_ERRATUM_3588001
 
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
index 42a167a75486..020670814bda 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -420,6 +420,10 @@ alternative_else_nop_endif
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
@@ -428,6 +432,7 @@ alternative_else_nop_endif
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
index 14cc632c7671..caa8d105a184 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -121,8 +121,10 @@ enum kvm_mode {
 };
 #ifdef CONFIG_KVM
 enum kvm_mode kvm_get_mode(void);
+void kvm_force_disabled(void);
 #else
 static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
+static inline void kvm_force_disabled(void) { };
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
index a418e240ccce..cb9341c4dbeb 100644
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
@@ -203,6 +205,27 @@ cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused)
 	sysreg_clear_set(sctlr_el1, SCTLR_EL1_UCI, 0);
 }
 
+#ifdef CONFIG_NXP_IMX8QM_ERRATUM_ERR050104
+static bool
+is_imx8qm_soc(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	return of_machine_is_compatible("fsl,imx8qm") ||
+		of_machine_is_compatible("fsl,imx8qp");
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
+	kvm_force_disabled();
+}
+#endif
+
 #define CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)	\
 	.matches = is_affected_midr_range,			\
 	.midr_range = MIDR_RANGE(model, v_min, r_min, v_max, r_max)
@@ -1045,6 +1068,15 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_broken_gic_v3_seis,
 	},
+#ifdef CONFIG_NXP_IMX8QM_ERRATUM_ERR050104
+	{
+		.desc = "NXP erratum ERR050104",
+		.capability = ARM64_WORKAROUND_NXP_ERR050104,
+		.type = ARM64_CPUCAP_SOC_ERRATUM,
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
index d17c58c3b03e..2f94a1b8862a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -3239,6 +3239,11 @@ static int __init early_kvm_mode_cfg(char *arg)
 }
 early_param("kvm-arm.mode", early_kvm_mode_cfg);
 
+void kvm_force_disabled(void)
+{
+	kvm_mode = KVM_MODE_NONE;
+}
+
 static int __init early_kvm_wfx_trap_policy_cfg(char *arg, enum kvm_wfx_trap_policy *p)
 {
 	if (!arg)
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 58b6c084f9f2..20cc185649f9 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -124,6 +124,7 @@ WORKAROUND_DEVICE_LOAD_ACQUIRE
 WORKAROUND_DISABLE_CNP
 WORKAROUND_GICv3_BROKEN_SEIS
 WORKAROUND_NVIDIA_OLYMPUS_1027
+WORKAROUND_NXP_ERR050104
 WORKAROUND_PMUV3_IMPDEF_TRAPS
 WORKAROUND_QCOM_FALKOR_E1003
 WORKAROUND_QCOM_ORYON_CNTVOFF

-- 
2.51.0

