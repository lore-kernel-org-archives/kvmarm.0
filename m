Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011029.outbound.protection.outlook.com [52.101.70.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CF63B0ADE;
	Fri,  9 Oct 2026 17:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791566600; cv=fail; b=ZensBCHcyesKcXsx02cQx2heT3ii1subBKE9ABXcvNbd7B5BnAwKBjRCpwz0LxCrWtfKA2HkWSCn4CggHQ1iQglPVQu9EycIXl+ymZASTAvq1n6T8WyVap0jvjH1Hp6DHfGr0cs7UDLt1XPc+dwj1lHbFQbGfzQgurt/PmcsfAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791566600; c=relaxed/simple;
	bh=2pVR/H0xqKguqdjwDWf0CWyoa+pQZI8h2UnqZsUiaVI=;
	h=From:Subject:Date:Message-Id:Content-Type:To:Cc:MIME-Version; b=u5tj63nVE4lJ9eLh9pRWHVLq4Ju8S1+8+kb/6ho0v3H/01jEwbEXVw5f8Atrjj0q+XoLxC174wWwK8HW88PvBMQiyeUkLeHIftdHoYR03wGglNhlFwA3+oi5WboQXiUyMBDKzl/tpi1T+4LX7Tv6r4OHMdkC5+4g/4ei2WttanY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=cWGdgrDS; arc=fail smtp.client-ip=52.101.70.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="cWGdgrDS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A6fjbKulyTmg/xYTjutRWowNVJE5Qwd+IrN6pyxHkOdLQDfo4uKzRilhBPQqCA8Qzgc94060cX2B5pR3S/sn618pjAu260WhXImn5eCseXeWBScNzyqWnEH5CPpT4k5+2uj6FLzv/G7ucP8M679ui9JXD67dmJ11iGGOsImKUG+ojVSS7UThOKh7f5WDaF6pg2p8LEARon1dg0D7VmHC9NcgYlO9E7SdmTkqTl1u+gIY2bjq/XqzLxOFoBhwY3lbRg3lFQmhQ7Rnsp6jDU94kDQ529BTB5d5xyitndOPOLl+JjJRKCI9ZJO31LatIl5ehwKyNEv5P2lh7AdBaS5YIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7xSdfmPnPUc8sZT4dj2wUkaB+SkdEs7bg7vUhbBoAY8=;
 b=mHykxQFrO19pqr9tnQV5cvaTBRZmlET4h5vbg7v2EzQIMIq8kAwLymRqgpqluqJcSVTmiH89fTqUPIVp6Y1YBhzNUxt4Uv/pwLZl+8uGeMPvY0NzlFFYiWPm3Q/MQM0XyTma43vAMrakxrzm3+MsIQBglSGDJutqtZcHC4AqbGdeagb7TdqN4vfyJPRxobrV2mExzg10U5lp9eKtSHYgpV2nBdnUUPE32e2YufG6y45dBdgu+SJ5sFqS05ZXIZnoDloWuDzjpghVgxgT9I0iHboEsFP5FaHUrCZB6Uq6qzfpxsHuGG/znfyNj1Ljs+V4GRNJBxuKgjGN2L223O5UFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7xSdfmPnPUc8sZT4dj2wUkaB+SkdEs7bg7vUhbBoAY8=;
 b=cWGdgrDSGss71FFTbnSkFZabsaqyVxgthg14Njus1uB1R8I3fEU2tWJodAr6K4CGqbnsusg4uuNZtnSY0Uh+kLInPfWXwvDvxJ6CXivzAb/7+G2xXkTH0cwxx2J86EXYyrUXO3/HFFVj8aKL2ND0OZxW96Y5/lkNNCGEUCTeOnFOjRwSUCjB75evBR1MfUxsflNzSfk4jpPMygdrvUOWVO1Xa0sF5KaPP2VA/ajNySGtmwIF5PU/+/vZtO+/35ryYnoXLDgbMY8jImzps1B1aMG3u59kGO83N7DrIYbPdh3RXp1L59GtYz7t03iujFYhRmtF0tPo5ohHw8daEXybmw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by AS8PR04MB8343.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Fri, 9 Oct
 2026 17:23:15 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0496.010; Fri, 9 Oct 2026
 17:23:15 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Subject: [PATCH v5 0/2] arm64: errata: Add NXP iMX8QM workaround for A53
 cache coherency issue
Date: Sat, 10 Oct 2026 01:19:44 +0800
Message-Id: <20261010-imx8qm-cache-coherency-v5-v5-0-c9d6cd60c0c2@nxp.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADAiyWoC/yXMQQrCMBBG4auUWTuQVFuCVxEX6fjHjNBUEy2V0
 rsbdfkt3lupICsKHZuVMmYtOqWKbteQRJ+uYL1UU2va3hrjWMfFPUYWLxEsU0RGkjfPHbu99cH
 Z4WD6QLW/ZwRdfu/T+e/yGm6Q53dI2/YBeMyf1n0AAAA=
X-Change-ID: 20261008-imx8qm-cache-coherency-v5-831af81b406f
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
X-ClientProxiedBy: MA5PR01CA0066.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b7::14) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|AS8PR04MB8343:EE_
X-MS-Office365-Filtering-Correlation-Id: f16ceda5-e9ab-4c4e-4ef0-08df262a0040
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|366016|1800799024|7416014|376014|921020|11063799006|10067099003|56012099006|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	sceN0NDZq4+29Q6S7zln958N2w2QA5n4CPQGV4Xq7r6+uA1TTiFGQ+wuoptZcwENZ4D0v6kU+xYOj2FWllgmkV0LodOaFgJ72Xnith0XXvhvD0ZE+ShvpqG8tUnqeZpSqN9EjnDcEHmEb2+dq42HR9ZmframYpagTcSQ6OcIHNm5ujWlcVMjAGTPCdLW2V1Tn92ze6/QjjtXZ55MraiorSa1SHCs4mbIu001una2onO1dQz9byrt9H5A5tcwd8ewKABH4LVSTBzxZ0v16eBl9h0o2zYbuHv8JCMzLIYG56kM+9xjoAjPNlccBpZK1hcu3+qCoZFY/eido1Sx0b0V1sRpMBj8BBG5jgU2G5LajNLyatRtM7gICshwgFMUURlHdZSGts6SNQHMeYkmB7/ZfQ0f5mn1H/ildBC4FdhCnY+vuPg4ZnAlaPYjbYgqA740un1k/PMMulcPm1MqHQDpq945RT0HPiuH+SpjuvO6RJ7fCEWBYagPBnvrrUl81Y4jIXXkHrSk4zPxFeDlLUEzNQ4fytA+BUUUpzATWGggVUvuOmF34rsXtLRl2atQSnbgd7a9IplG6af8RIGDurZc3MegWmQ3ujduQF6OcfjGrhIVekaaR60/n9mEgJjrjPb7W5TLU//CIL4Lz2YckJDv7Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(366016)(1800799024)(7416014)(376014)(921020)(11063799006)(10067099003)(56012099006)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlV2MllFSHE1ZEdsSHIxY2JZb0hYT0FKTCtmVFNBa2Ntdzh0MkFSemdoTHNC?=
 =?utf-8?B?a0cwd20vYks1WmZLT0NFWUdneThZaGFnU21hL0NwTWlGU1Y3OGxSdVBLb0p1?=
 =?utf-8?B?aThmR3VVTDh2SmtHeWRCd3diUUFxYmdIOUJLSGxRQU9kUDM4eS96L0JQK1dV?=
 =?utf-8?B?YzV6L2RHVng3MHJoUzNlSnkrY3pLcjV2bEdtL0piZzBucnlHeVNZaTdUK0kz?=
 =?utf-8?B?bTJtbTdCQ1BTQ3E4QURzREhKZzhDaGRnVE9rNjRsQUh3S3lQNEhZUndXQjdo?=
 =?utf-8?B?a2JPVnJwZEFrTXZObG5UYmVCU3RNU2JYQytVR3ZaM3ZXbnVva3dFaXpaVnhq?=
 =?utf-8?B?VC9BckMydWFUWCsrdmpGQWkweFJ5SDRvNENzbXpaTnpqbDB1NllyWDYvR0di?=
 =?utf-8?B?MW1NbVhienhTc0k5eUt5em9BajZYbFE3YzljN09TVmF2ekJKcXdXR1ViaGxH?=
 =?utf-8?B?Szd2WXNRRnUxaE5zMUZUWVgrM0Q5SWlrdytHRmwyMG50M2xDVjAva2c2UlN0?=
 =?utf-8?B?VDlObGNUaGdxMXkycmY1ZHlCN09Zb1l5Qi83VE9ZeWZWKzFxcEZIVFpzS0wy?=
 =?utf-8?B?WXdaY0lyTGJmclRHOXhJYXRMK3QyL0g0MEw4eHU3bnQrVkJhNmdTNFBBV1JC?=
 =?utf-8?B?bzdYTWtSK2d4WmFsMUtqYWtkbE0vVWRjUml6dlAvc1FpZWIwVldteUJXalhL?=
 =?utf-8?B?SFZuQXcvM2tLdkNmeXpKYStNbzZNUzVzN3loTFVkaEZiQ0ljUjMwY3hjem12?=
 =?utf-8?B?NmhZenpoaEI0SDV4K0ZMTWdQWmM0MktvcVFxM20zQWlWZlFxNW1MQ3cvMkVy?=
 =?utf-8?B?dFg5NTZPNDdtaVRUczlYTjVsR2hmTnZQRlRybFJWWXg3U2VHU1R5THk2V0Zw?=
 =?utf-8?B?RHdvNGZKQWYwOUgrUjZLMk9hV2xDRGxmZk9lOHZUSTFMU3ZsQ3ZoblZCMzNo?=
 =?utf-8?B?YnlZaklvK3ExZ1ZFRkV4WWp2TVZqRExkT1A0d2VvQU9PY0tqaG5ZYkZJTEN2?=
 =?utf-8?B?dzRvMEZQa1Z3SCs1WVpiVDFyRmxiay96Vm01a21OUndwS2NaK2hUaC9wNGtY?=
 =?utf-8?B?YzdxUWlaVWtsNTF5b1AveWZQSWp4OStjcVlSQXRXc21oTEZRQTVwN2FCcURD?=
 =?utf-8?B?SHdyKzlnM1RSVUlmSmNIV1J1aWVjSVhxMVlhY2JENWtJSlArMWN5VVJteTdC?=
 =?utf-8?B?S3Z2RkxFVzhoTmJLMDlrMzBIUHFicU1PdHZsNEV4MWJtT1JTenNrOVN0MzdS?=
 =?utf-8?B?cStaeHVWMmZjNlIyVGJwMmhCaDNDalNHTUx4Y1MrK3B3amJQbytpK21Rbzk1?=
 =?utf-8?B?YkNmNDlPKzRzYWRIUklaWFJYdUlCNEZ3d2pROStJbUdwTlhoT25VK3RIaEhQ?=
 =?utf-8?B?TjNDU1BnQldOVDdPWUNuWlZpSzNZM2grY2NqUURkWlBaYUxEQzlGN2JheDMz?=
 =?utf-8?B?WHZKN3dBNzQxVU5RUHhEYmltRW1mZFR6cGJWVldMcERQZGdrdVJSQ04zSVlL?=
 =?utf-8?B?azhYbE45NWxzVzBrWTBIUlpHVDdDUVc1REdHTG8ra1lpU3JWSjRTOEVoeWhC?=
 =?utf-8?B?Z3luNzVRc0xpWHJRT2pMdXZhdXVabm03WXhVdTIxQXhGWW5TYTZtaTRiQnJa?=
 =?utf-8?B?TFVrMkt2RzhsOHBrOWZ2MTBIdkVIUTh5UmpaQ2FpRHVTWXVZMDkvclQxbDZW?=
 =?utf-8?B?ZEFla3pOenJTZUdoRjN1aHFYUjBNdnJjWEY3d3ljc2d1UTU5RFRpSlBGbkJH?=
 =?utf-8?B?amtpdHg1cThOOWg3T3c3NVV6eXUvWU50UC9RMW1oMjhlLzQwZHZJR2w5M0d4?=
 =?utf-8?B?Yjl3UFJsSjlHN3BlZFFPaEEzaHFOM3pwVUpQWlowb1ZTUlptcUVrc1MvZXpG?=
 =?utf-8?B?V2N2ZnNUa0E3MlFVYzdwbG1VaERuRnNPdy9NbzJzVW40K3ZzRmxLT0UwQ05s?=
 =?utf-8?B?dUVEakMzV2tZVjFDdHV4dnJRRWJXZ2x3dHV2dDBnRVUwK01ObmkzMTV0SDhm?=
 =?utf-8?B?bnkyeFNYOHFaSDMwbW85WExPRkRiR01jb2ZzUm95OTZNS2tPcFNRdW1zYnRQ?=
 =?utf-8?B?eDhaY0lqK0RNR2plaGdjaENsY2FvR0hNS1NuSlF0UUlxbEwxUVI0TjUxUEdy?=
 =?utf-8?B?K3VRcHBYazlDMU81dHBLVFBYTEdNSlo0NkxPYVc4L3pjcG0vSXNDdFR1VVU5?=
 =?utf-8?B?NVFCSGE3ekJ1Si9HajBRcHFTQTFJaE9TU1hvZDRwSzdvQnZXZlFTUXczVUN3?=
 =?utf-8?B?Z3NoTVJHTjZtL3NtQzFacThneHFNWitNM1pzK0FCSDEyWUhLVnpNalI3ZXMx?=
 =?utf-8?B?MVBxeDdlcThUR28ybzgxTnc0T3dTN1RjQ0FsNmRScTFaTWtCVlp4Qkp2SWIr?=
 =?utf-8?Q?roOSljKTYF0z+B9dmbT+OsdgH+cUxKfGQVBAR?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f16ceda5-e9ab-4c4e-4ef0-08df262a0040
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2026 17:23:14.9291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8yI3MdY7+NHQ2QqpImjEgSGbfIY26yIFj9O98CtQFlCAGFaM1HX/raQa9Ro2Thu8p/7ywoWhlg9iXh3iRm9I6mIt7G5XC/Lb75i9z4tZJ+3vAQj87+mWjg0oZoyrjOC3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8343

This picks up the work originally done by Ivan T. Ivanov in 2023 [1],
reworked to address review feedback from Will Deacon and Mark Rutland,
and rebased onto linux-next (next-20261008).

According to NXP errata document IMX8_1N94W [2], the i.MX8QuadMax and
i.MX8QuadPlus SoCs suffer from a cache coherency issue (ERR050104).
The upper bits, above bit 35, of the ARADDR and ACADDR buses within
the Arm A53 subsystem have been incorrectly connected, corrupting some
TLBI and IC maintenance operations exchanged between the A53 and A72
core clusters.

The workaround:
  - Redirects targeted TLBI operations to broadcast-all variants
    (VMALLE1IS) in the high-level TLB flush functions.
  - Upgrades IC IVAU to IC IALLUIS for both kernel and EL0 userspace.
  - Disables KVM since correct TLB maintenance cannot be guaranteed
    for guests.

Patch 1 introduces ARM64_CPUCAP_SOC_ERRATUM, a new capability type for
SoC-level errata that are probed once on the boot CPU rather than on
every CPU. This also converts ARM64_ERRATUM_4311569 to use it.

Catalin wrote the code, I just wrote the commit message, so put
Catalin as author and me as a co-developer.

Patch 2 adds the ERR050104 workaround itself.

KVM is not included in NXP software release for this platform,
so disable KVM.

There is no SOC ID SMCCC, so use DT-only approach.

Changes in v5:
- Split into two patches: preparatory ARM64_CPUCAP_SOC_ERRATUM
  infrastructure (Catalin Marinas) and the ERR050104 workaround.
- Use ARM64_CPUCAP_SOC_ERRATUM so the SoC compatible check runs only
  once on the boot CPU instead of on every CPU (Catalin Marinas).
- Drop WARN_ON(preemptible()) from is_imx8qm_soc() since it is not
  needed for a DT lookup (Catalin Marinas).
- Add T-b from Franz Schnyder
- Link to v4: https://patch.msgid.link/20260824-imx8qm-cache-coherency-v4-v4-1-b2e528c7d05e@nxp.com

Changes in v4:
- Rename kvm_disable_mode() to kvm_force_disabled() and place it next
  to early_kvm_mode_cfg() (Marc Zyngier).
- Also match "fsl,imx8qp" in is_imx8qm_soc() since the i.MX8QuadPlus
  is equally affected (Francesco Dolcini).
- Link to v3: https://patch.msgid.link/20260803-imx8qm-cache-coherency-v3-1-c518d0da3d3b@nxp.com

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

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
Catalin Marinas (1):
      arm64: cpufeature: add ARM64_CPUCAP_SOC_ERRATUM for SoC-level errata

Peng Fan (1):
      arm64: errata: Add NXP iMX8QM workaround for A53 cache coherency issue

 Documentation/arch/arm64/silicon-errata.rst |  2 +
 arch/arm64/Kconfig                          | 16 ++++++++
 arch/arm64/include/asm/assembler.h          |  5 +++
 arch/arm64/include/asm/cpucaps.h            |  2 +
 arch/arm64/include/asm/cpufeature.h         | 20 ++++++++++
 arch/arm64/include/asm/kvm_host.h           |  2 +
 arch/arm64/include/asm/tlbflush.h           | 62 ++++++++++++++++++-----------
 arch/arm64/kernel/cpu_errata.c              | 34 +++++++++++++++-
 arch/arm64/kernel/cpufeature.c              |  5 ++-
 arch/arm64/kernel/traps.c                   |  2 +
 arch/arm64/kvm/arm.c                        |  5 +++
 arch/arm64/tools/cpucaps                    |  1 +
 12 files changed, 130 insertions(+), 26 deletions(-)
---
base-commit: aac26bee2287c88af5be5a5ff96d783b19a28790
change-id: 20261008-imx8qm-cache-coherency-v5-831af81b406f

Best regards,
--  
Peng Fan <peng.fan@nxp.com>

