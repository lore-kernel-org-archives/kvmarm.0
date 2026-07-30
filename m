Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013043.outbound.protection.outlook.com [40.107.159.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9907435AB1;
	Thu, 30 Jul 2026 13:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785419697; cv=fail; b=jqM85MOiUf7mUTtGtGfDOwZjgYQt3P7gQczN3hIOq8D1/9FwR/22+Q+hAUZIjHlqYjBoWlepFzTAvQPNq1MQ8CAmAol3XL43u5cEL0vVEgRHBQU5/Ts0/Icpux2UtQG3BIH+lRCtsj015W8MHImsFuery0JLN+tplPQdl5+zjJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785419697; c=relaxed/simple;
	bh=gdCyjPl31U9X53MvJ0OSbVSiP+8aBxtR9NmEoCzqkZg=;
	h=From:Date:Subject:Content-Type:Message-Id:To:Cc:MIME-Version; b=o4Z/c3UqluuRIGyoJ8LykQt1PjzVSMaP38+pUj+t5a/rxNdu+ILN6Nn+JnjYVTFxYt+MCbcNaA5iRczHFMZBg71YhANYEst98NXn0dWt6fuDEMfImsRQT1PbJiQLt1mCaMLErOc1ASrS0RKy+6sfUnrw1YLwPIr9sKhyqwPqNTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=ieB7bEYv; arc=fail smtp.client-ip=40.107.159.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="ieB7bEYv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IdANODgfm8KleDPgvYm0wDhIuaFESkQmwa7qlHWZx548g9Z6PvPfw31JDq3m5qKbBbznEw3D3lMyFza3XNlkX550pvFcV3WFtXxGtSq9myEpQHEVSdO0Xpx8HRHE9mb0i39AI3/QhxxUdvbE0fhs4mCTVfkpwztQaGIUw+aHbWo5WmfaLTLzy2uMJHQwXnXIoXBMWi0/VoVOf0TizhDNyUi2xQYz6oTfj9GkSPk71P4vT30wWaDtGw+9CczJuwgkq1/Ob5XG+wS7yheuf2qjrlNBJgqiCZc8B24pQ294xttAvWKjw6yO2LUqBDgstNZRhvMccPR9XQ9lWr9HIMmCjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8wfHXzLtT3KSH1AkfwGGMSHm3cZublZBD+EK4E8Pg24=;
 b=gRxCuzijb0DXmRA8hsz/TOTSMeCXCoEVisxdjDX3CBQibd92S8xsDyB0SU5zouSXRsfCILmIRgMezTDRV8Saeo0jsvaC2X+d+tFODyF43uoK7vGalCNBiskA+llxnb/CNRQnjy2cFYXCI9eL2wWQo4Bwgj3wvnmXYvqGW7elJT10rZHbUYHNcwmc42l9ms6Lp4H8JS1xBT0IvZ125q06B4zMRalDmWfxVWmjFn52wo+OPmeXcuAnoFiyZMoTedgRyvGLqQzjyKU5CjqW7OrVnDe8pLp9nU0iaxkYwngqXzjOt42od7y03J6Zlq53/rsf4pkVlGEV0bD0vBpeOPbonA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8wfHXzLtT3KSH1AkfwGGMSHm3cZublZBD+EK4E8Pg24=;
 b=ieB7bEYvoetrAu/4h4V+iHXGUknxvaUQlnH78qhcNXwvLziEk2T/5AxAZkwy6Dgq+Am60u98nHP2fs9KP7DHQLPwwNmyu6T6pp7X7Csy/09t8Qk0j6uWxM/9HqqmXNzZz8MLdnffbzPueC9NJ21OyzjqHSk62eDS3ueI2PxJ4Cm5sIZRhC2w++XyjdTrd2w0uYHg5gUANbuig2q0CJ3wS+4Zn2JDKxT6V0SoRgGALTElUhruLZGbnhFl9KG3fSexBZeIkme6xm8y/fJu8bHthbjYFbqA3xM8yUodO7PAJr44Tuwd+RvrSnJ+29gKa+uxHLxvgX4ZY8GP4TMZr14i7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by AS8PR04MB8850.eurprd04.prod.outlook.com (2603:10a6:20b:42d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Thu, 30 Jul
 2026 13:54:52 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0245.010; Thu, 30 Jul 2026
 13:54:51 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Date: Thu, 30 Jul 2026 21:53:02 +0800
Subject: [PATCH v2] arm64: errata: Add NXP iMX8QM workaround for A53 cache
 coherency issue
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-imx8qm-cache-coherency-v2-1-5651aeb1af16@nxp.com>
X-B4-Tracking: v=1; b=H4sIAD1Xa2oC/4WNTQ6CMBBGr2Jm7RhakB9X3sOwwOlox4QWWyQQw
 t0FPIDLl7zvfTNEDsIRLocZAg8SxbsV9PEAZBv3ZBSzMuhE50mhK5R2LN8tUkOWkbzlwI4mTJW
 uzNk0qWEF67gL/JBxD9/qH8fP/cXUb7XNsBJ7H6b9eVCb9/dkUKiQqjLPWJdJlhZXN3Yn8i3Uy
 7J8AYLwRZzMAAAA
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
 Peng Fan <peng.fan@nxp.com>
X-Mailer: b4 0.15.2
X-ClientProxiedBy: SI1PR02CA0026.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::11) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|AS8PR04MB8850:EE_
X-MS-Office365-Filtering-Correlation-Id: 343dcdeb-46fe-4a7a-7e68-08deee4220a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|19092799006|13003099007|6133799003|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Pg1vj46sloEisdSSqmxBB8cJInSovW4W+2rvqlbG9+0AmTXXdCkZA6SV7zlwvte05WVXTcTDWEo/5RNf/b3SndqSqowuRVbLr4pkQ6cfZ6DY2sNMV41op4nYXVDBaLS9QhFrTAviUFhPkXvEKnkqszxUMUxh8BBx30oVWLpHapaCRVMQPv3NLHkCe8bCCnd+ZfoK1aOxFPtSJ/GMUuLkae5WHnkacAjDpwUKbIRKJY+2QpX5PULswQtJ0YF6MZU1xf44Qdz2TJVvhTD10mtjRCRmptC7UfgV04ehZuIiTkU/wyaaxtX28rzASAiiaN4zM2Nbob84SuKBdbmuZpCn9FRa7rtNHKdKxuKH9OgBGKoEsWmoI8Y1TrmnkqX03cYwQ+K+qvMJUolreYiLMbk1YbyyQwk6zjWk2RMhRaDrXczM8Ee8I8EW4DfP2O3f3qMFTSqjbkMM2ywG9G9853xReHZSQbHVkRhwUBai+sAc7FrGKW4RUctA0kCG0YcmVpTqbZR8Gl9GsQ49kmBNhqdnAecxmKPRU6OsL4vQSoWqtzSZU/k7tcEQ9XgaiwkRxv7bUYWYg+c4MUdjbOudsJTktwaj5TvLTA/KjN4TyHMo8/NwWDsyVcUcaqq8gclrCsLM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(19092799006)(13003099007)(6133799003)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXhNZkN4QzgrTkZqc0tvOHRHSmpIRlQ0OUlzWGxUSjBqbDFsSmQ4LzdJZ0xx?=
 =?utf-8?B?bURzSXY5aGVlK0Nyc0VNVHJiekZ0YklqNHlVYjcyYXdadEV6bEVpOFNxaWRi?=
 =?utf-8?B?ZTI1UU0ybUwvRHVvM3RqZ1NJU0tMWTFRbitNWUFydGdLTnY0blhpSisrRmNu?=
 =?utf-8?B?WU1za2FiM2lCSXFRU21mbG5kQUZ2cCtGWHI1aWEyTTJ4ekllcmY2OWR1bTJK?=
 =?utf-8?B?ZFdhaDJkZDJlNndZNkRXM2Y1SjhMeERkeXJKZ1crOFZ1QkRmNzhOK1BpYzVC?=
 =?utf-8?B?VEhwTGFUVGMwWm5Ca0xXcWNZb3VGMjJnOExrT2liaTBBU2hHY21oTFN4cEVE?=
 =?utf-8?B?V0VVQlVpRDZ2aGxDd0dIMElIMGVxUWlReHhIQWkzMmVkRWYyZVJjVHdLWGRm?=
 =?utf-8?B?SFpHd0FkYmpTS0JwOUlwV1craEdzQ09vV00yS0QrRVVpTFl6SDJxM01hU3I1?=
 =?utf-8?B?MTFLMkZOdk1sNUFnU3FaMmFnYmphTWlTekRXeExiQTdqNWdqemZ2ZmhxQWx3?=
 =?utf-8?B?QVViNGU0MEdtaWZhRkw5RFZnOERmblVuR2p2Q3hJNHJGemdJTVJQbk9qcWRM?=
 =?utf-8?B?UHlZSytsTDNvcWlTVGJBemczNk0za1JLbWI1V0tBbWlvSllGU3hYUm1Oc2NR?=
 =?utf-8?B?cWlEUW5KYXJYYXBQVTZNcXByK09UdVpsTnVHUSsvRUZ6NjlCV0lvQXNXVUZr?=
 =?utf-8?B?OStoR0lwdk52RUFJK2VrL3FTeXlzbFVJTmlhTVUyV01FNFh3T2pZS2IrSm1l?=
 =?utf-8?B?bWl3WjNERWZ1cWoxTHlxQlJiU1VWME9kMUE1VXZUc0p3L1ppVlRoN1UvNlNr?=
 =?utf-8?B?MzQ1VUxMQzF0ZXowVjNNRFkwc3Q3UVJCdTduQlFvYmZ3aWg5L21KaWpIRlBa?=
 =?utf-8?B?Y1BuaGJiZTkrcVpZK2hLS0gvbFl6NmpZbytnS29NM25xaDJsRTRlYzZYQU9k?=
 =?utf-8?B?TmRmS1R5dXN5WmVaNUVobE1qaTJWVnlCZGswUWNua0w4OHViZmxzVVEydlpY?=
 =?utf-8?B?aFBZY3NzYUsrQW42TnhmcUpXdEJPRUkrSnNVOFJwOS9KWmY1cjl3VCt6MHht?=
 =?utf-8?B?Rkg4ZGZXeEhmZml1ZzBmajhjSkZ2OThDSThTMU9NSlI1dHUrcWlPQlpSekJJ?=
 =?utf-8?B?TTJYZUlDRjlJMmxSNzRCNisrVjJ5azZyeFhFU1kwbFFCK1lYTkE2RHhvT1FF?=
 =?utf-8?B?aVNrVzE4Yk4yREY0Qy90NkVjcEZmenhsZXpPVmYybG1zemxuMkF5NVJ5Q01a?=
 =?utf-8?B?a1ppN0RiVlJqUWh5QXRMN2M3SGhCazBQbDk2UnN0dzZnOXhrUCt1T1pQakh3?=
 =?utf-8?B?RGRZODZuTE5US1pBQ0lHbFdsRS9uV0N1d0kvVDVEMEpzcjFXQXVTVW5pODF4?=
 =?utf-8?B?bHB2WjV5MGF6V3dlWmc1TWZBcGV4YjJUS3VzQXZQMm5pTmgyNkxpQjJrY2Rh?=
 =?utf-8?B?MXlLYXM1a0IxVzNVM29TWE1Jc3RjT1BhWjY2LysyZzZBS29EMG5KbU1PR0NT?=
 =?utf-8?B?Q2Z0a0lCWWtxL1hkb3ZuUEphalF6RjNVYkxMTU5BQkV5ZS9rc1NPTjRZSkdQ?=
 =?utf-8?B?SW1ObnI0QWtuY3NHOE8ySVAwT0FENFE0WW5VRUZlanM5Ulhjb20xTGlBT3dP?=
 =?utf-8?B?aGZrL0JSNVZnb2Y1enBvdlc2aVJoeEFQS056a2xTa215SjFRb0pnZDJqbVVJ?=
 =?utf-8?B?Y1d1YTd6a0UrTDhoZEt2b2lUbUpmL09kZHdDSE8wNmFNQjVyVU1KVUxOZTI0?=
 =?utf-8?B?ZTlFKzA4cFVHL2Jla1VNUjlpc1RGUSswWDY3ZExVZnZqOUdqV0tIL0xsRXBy?=
 =?utf-8?B?NTdpZ0lhZjVFbCtBTGFxSmdRcVJHbzNFOXlYVXZJK3FhbVBxS1k2KzVwUjdP?=
 =?utf-8?B?KzJENG9jMHh4UEhXc1BXaWNsc0VvSUtWcFFDTWVqZjllcFRucFJtRzlJZEdT?=
 =?utf-8?B?cWpLTjJVaDRHcjdsT3ZiM3FGTENQTlNUcnBZMFVpMzQ2Wit0UnpzeCszY0I4?=
 =?utf-8?B?Y0lRc0V1cmtKNzBKRGZHWWIxRTZoN0hodmxSV2oxdTZWamxZVERIYXBxcGYw?=
 =?utf-8?B?T2NsZ3JtU1VQejVEMUpVenN6QlRQbGRaOGpwZ2llZW9iQ2x0OXdzYnE2eDBW?=
 =?utf-8?B?ZjZ3czBvaHVOQ1VRbkE2YVZQRXpXOVVlZ0s1UnBVVys4em9tNVgzVVJkTmo4?=
 =?utf-8?B?bzlMSEFneVVPV3JjaWRhUW9uMzVDSm0vaFEraVgrd3N3NU4rN3l3UDlVdEtP?=
 =?utf-8?B?SCszb1hQRTVncUVCZyswaVhwVXdmeThvTWtWSXFIT214NFNWdTEyVE9MN2tD?=
 =?utf-8?B?S2hteVlQeSszRzVYTlhXdEZYSHQ2WDZEdUk1THN0U1UweE1JcGpPYUZIdVpa?=
 =?utf-8?Q?MUoqw9CserPMSJWrrwF+2mCDaZo1zutRp7wvO?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 343dcdeb-46fe-4a7a-7e68-08deee4220a0
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 13:54:51.9119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ahKmt5uL1VrCgRds8toNsWrMrJ+cLYtts5jnaYUwoPiUEprw9ZkWujbQkDCO2nZdWJINhsMQ2fHub0DM6H8suAiQ9G1tckCdpHIbyTq2l+RSxFpRic0NfXIuQ7bRwHyG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8850

From: Peng Fan <peng.fan@nxp.com>

According to NXP errata document IMX8_1N94W[1], the i.MX8QuadMax SoC
suffers from a serious cache coherency issue (ERR050104). The upper
bits, above bit 35, of the ARADDR and ACADDR buses within the Arm A53
subsystem have been incorrectly connected. This causes some TLBI and IC
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
    for guests without the proper devicetree.

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
Changes in v2:
- Skip the workaround for local (TLBF_NOBROADCAST) TLB flushes; they
  don't cross the core's external interface (Mark Rutland).
- Preserve IC IVAU fault reporting: run "ic ivau" for the local fault
  check, then "ic ialluis" only on success (Mark Rutland).
- Link to v1: https://patch.msgid.link/20260729-imx8qm-cache-coherency-v1-1-c9864e280437@nxp.com
---
 Documentation/arch/arm64/silicon-errata.rst |  2 +
 arch/arm64/Kconfig                          | 16 ++++++++
 arch/arm64/include/asm/assembler.h          |  5 +++
 arch/arm64/include/asm/cpucaps.h            |  2 +
 arch/arm64/include/asm/tlbflush.h           | 62 ++++++++++++++++++-----------
 arch/arm64/kernel/cpu_errata.c              | 20 ++++++++++
 arch/arm64/kernel/traps.c                   |  2 +
 arch/arm64/kvm/arm.c                        |  5 +++
 arch/arm64/tools/cpucaps                    |  1 +
 9 files changed, 91 insertions(+), 24 deletions(-)

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
index 5db8f0619e4b..1866eeec27ca 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/arm-smccc.h>
+#include <linux/of.h>
 #include <linux/types.h>
 #include <linux/cpu.h>
 #include <asm/cpu.h>
@@ -200,6 +201,16 @@ cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused)
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
+#endif
+
 #define CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)	\
 	.matches = is_affected_midr_range,			\
 	.midr_range = MIDR_RANGE(model, v_min, r_min, v_max, r_max)
@@ -1030,6 +1041,15 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_broken_gic_v3_seis,
 	},
+#ifdef CONFIG_NXP_IMX8QM_ERRATUM_ERR050104
+	{
+		.desc = "NXP erratum ERR050104",
+		.capability = ARM64_WORKAROUND_NXP_ERR050104,
+		.type = ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE,
+		.matches = is_imx8qm_soc,
+		.cpu_enable = cpu_enable_cache_maint_trap,
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
index 9a6c72a18672..734ccd7ec056 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -3032,6 +3032,11 @@ static __init int kvm_arm_init(void)
 
 	in_hyp_mode = is_kernel_in_hyp_mode();
 
+	if (cpus_have_final_cap(ARM64_WORKAROUND_NXP_ERR050104)) {
+		kvm_info("KVM not supported on NXP iMX8QM (ERR050104)\n");
+		return -ENODEV;
+	}
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
 	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
 		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
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

