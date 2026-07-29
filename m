Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013068.outbound.protection.outlook.com [52.101.72.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579532D7BF;
	Wed, 29 Jul 2026 03:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785295848; cv=fail; b=sNqMvIA2WHmR2lzzDgM0XSamjvVz/po9i2mbRNblQ+IaEMS7CqMPF+YxFrcOFxrFED11HaQ//RDv7s3Qa7X6kwqDmF91++U9I5dEFiVN0ZQM4y8FlKc+29ckxI0iBr1hWJhnZoXel0vGrdJvc2ixBb4jkhgELUTtYikih6RBSsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785295848; c=relaxed/simple;
	bh=7lZKhZWZP8YZvKMvTxF/3KnlaP1IGPioqja9Rp/HHzg=;
	h=From:Date:Subject:Content-Type:Message-Id:To:Cc:MIME-Version; b=U7HOfxKhK4MXPJ7/d/xKgA/ys9oq5Zx2cHvy+cg14qZLddaJUivsqqOjGciR0iqdT+l8yboyEMOaTygeVZZEb55Wzwvnf235nr+MS2Afi9W9qDVdqUwR9Yn9mLLnGsMvHIK07P7rmH6+wvedmbcgPj2UxZaKPG0b6Tf/dUQgOHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=Hz31qHN7; arc=fail smtp.client-ip=52.101.72.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Hz31qHN7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MgoZ5gMzX6HXF2iIYFIVJTBW0uqQdedeSupiElqnc/SiFlfRgUnuKz/kvJFn+Uas5mJF3t1C1B3EtbG8re2X7d70788dTZOm23aWg/tnj5Jx42D7voodisoaAhlbAzJ953ygGlghAMJvtlp5qnmJAr40EZ35X5uO1Q8UVl6DDJCDrKN8InBcxPPyfhfp3dttSsQMdtvcQ5BewJeOJ2b/eT5B/5BSoBvfaInNtUyBg/4zFoW38WzqCuMSltobv8dAy1vqIb4ufREHBnkdgVw04R++MlxqTtiFWigT3plDthiznvF102EDMkXAHmSALYhCEaN7A3JxK+VRTVGGJhuA4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xhlZ4qL+Fh13/bsvPENbihJBFPjSn92gw0iAD/rDSlE=;
 b=i8O+WvD41wNEKFMx2NCzZJo3VP4XawWAF4QtdyoE2vdjxiPdm2ZLHWz69vgnqFad0/XzFyDUGprUroVYAokEBuEFCJSeQjMW2GATTD0qlI+pNnZ4Hm/98BK57wQ/9s6iCQpGGERJcHaTpFWjEpuu0MHMMBNlyiW3rd2RKhYcpyi7gz9oZf0eHgcNxvPGx3aHpDt5IcGTyc0UFpSmYevCdvlSdZ91PjQo37YzJSe688lp6CFvBTQlIiE1sRM7PASXMx4cMWu6J28Qn3baYZdR8OnXmGSbLCCfyAJj5fiEK017X+PxTjOWQUNf6ZQUzUhNGEABUtc9tY0Fbs6sv/mNWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xhlZ4qL+Fh13/bsvPENbihJBFPjSn92gw0iAD/rDSlE=;
 b=Hz31qHN7dt+m6BTj+PFyne6SPqshf2kFaD5xxPk4CC3EikTK+MmureFUr7tl5ABgBB3atFCYhwSzoVPA55Lz+H3Ekn/jnf9jzZFIZ7ng2Tqthq7ycFYLAkm6CdXEpQKiiJNG5bNWgl/uZGE1LE3e+94JesgDp7tR+7LQmhXTZ5ajvynqMq8drCT4SyA5G8xWGIC+YRnWoNtrYv7LpZHVIKxrPVomss2ZiARPIselWrYWQ6JhYKdOF0oJ4W4mBiv9pB9pyR1D8WONVlu2LgCWeEnqTh+IUs4yUcfcCbFVY0ZxV/F1uvjad/g81J2traKeW3ZZreRD4Uxbru4B8vaVgg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by AM8PR04MB7346.eurprd04.prod.outlook.com (2603:10a6:20b:1d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Wed, 29 Jul
 2026 03:30:42 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0245.010; Wed, 29 Jul 2026
 03:30:42 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Date: Wed, 29 Jul 2026 11:28:52 +0800
Subject: [PATCH] arm64: errata: Add NXP iMX8QM workaround for A53 cache
 coherency issue
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-imx8qm-cache-coherency-v1-1-c9864e280437@nxp.com>
X-B4-Tracking: v=1; b=H4sIAHNzaWoC/yXMQQ6CMBBG4auQWTsJLVHEqxgXdfpDx4SirRoM4
 e5WWX6L9xbKSIpMp2qhhLdmnWKB2VUkwcUBrL6YbG0PdWs71nE+PkYWJwEsU0BClA83xnZ+713
 jYajE94Re5//4fNmcX9cb5Pm70bp+AWrIZHF6AAAA
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
X-ClientProxiedBy: SI2PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:194::9) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|AM8PR04MB7346:EE_
X-MS-Office365-Filtering-Correlation-Id: bdfad713-abb7-480b-de64-08deed21c4b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|19092799006|56012099006|11063799006|10067099003|6133799003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	R3L4BgnVGu1NORsz/h1BCCTcVklw+LnIY9m0WT0cdOaKJv4yewknMvb5PGYLRI5Sofm7RLS1tY52JI/dlIoRkn+udEm5ZFT/gJ5TVruBaZBgwlhtUGfR/GraRge6G5rPtPxSxWrTQ26PCw+f4ZP7WUGPffBVaGlcmhY0kB6LU0se4tVkikw32rL5eSX/SLKsh5wbjJiCID00HoCvbnyNt8Z80MerV+hQ7kKk8dnwlUoAiTtzWfzWcFcKjSwft0pY7F1NEn2ysmiAvWrV/6uXAgQ/p1CdhPG8YcQ312zPoj447XrKK19sk9r+/iqIXa8fAr3v2sGLzWyQDDwJc338CDwqBxWW7uIlf+ykWu6yG7FKSB9RWi4xDbvRZTS9F4/XmFUw+wCRN3iMegZNZGO+skNcvNArzS3EnJTvl4s9OaiNw6iaEnDd+2IqG0Q/YCXgThks1gtLUyFReM2vCqO6RFkjSOSeeDqj9CrCgjGoHI2dNcB5J3hoSQE6BeoMKi+yU2hcKDn5RReytgxJv4YHiXa0RWsmaSHRjmiMXr6FIcCfQzshwvfXQRrGH6XIaE611JbCzmR9GemL4kWk5Lg49XieRUuTpwRtKmsNYuK1kXxlMYaVNfNbwtijJnCRf9qrlEZOvP7A1qm3G0kSw8z0r0CUQLMdyYfGA0ukIYeGI/U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(19092799006)(56012099006)(11063799006)(10067099003)(6133799003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0pXWXE4cEdYN2JRWWNqVk82eTJ3YzdSK2JZQzlMR1dCcitPZktVRDcwbHJM?=
 =?utf-8?B?MGhEMzNYR0J1Mm9jOU9oTVcyUTVyZWlnd1JIN0kySjYra1lTemZLSGdDU3V3?=
 =?utf-8?B?cm9hQ0dnaDRWeG9QOWNBck90Wm45cWtwNDdhcXYrQ0plZDZOelBCZHNkekdm?=
 =?utf-8?B?cW1GU2RlaFdnOGsrS0xOTGRzVXpBTUY1bDJ4b3lFWklsNS9lOFRzNGhyMU14?=
 =?utf-8?B?MGw1YU10OHY4Y3lWSFR6WlVyaVZzdEFPMjNFOHY4WjVTQ01EdkxkTGlZRFBT?=
 =?utf-8?B?NjdBUDFGekhIK2piejJWUmNENTlPTlNyamc5Q3lWQnBJVXArYWhRMllUWFp1?=
 =?utf-8?B?WEptSE01aGU0M0lQekdsc0hGakFHMVRod0s3dUJoUW11NzMxVFVtSnpoMGpO?=
 =?utf-8?B?TklOSHNLNkZIV1JDdHNhVWRSeDJPZ2JLcWdOZjRrUFhGRktqNWFJNm1zZ2U1?=
 =?utf-8?B?cFpDQ3JKUCt3NWFvVnppL2FqUzZyTDdiOXZMaHpiMHJjcHhUcVBBRmdQUUNU?=
 =?utf-8?B?YVNFaTBlVmdwdStUS0IrOWt4NHhXdEQya2Jqd2xBZXIwSk1uenp2T1JWVlVy?=
 =?utf-8?B?NTlmd0RGcWNGV3VGckZEL1dBQVVaRnlBanJiclhWczVvMzFyUEFkQ3JDZHZH?=
 =?utf-8?B?bm1mU1BwQm9nWks4cTVPWXNzdXhmQU5TdlFUMEJWTEROU2Z6NzhVeFJWbXBP?=
 =?utf-8?B?SzU1RjJvMlo0NCs3NTc1Y0xjTmFiUjB3ZTBGY3FQUi9tTmo3cGJrdTZSdDBx?=
 =?utf-8?B?K0NNVmdueGtSanBHSjBmNitWZDZOcFp4c0E5OVV6R1FGMHlwMGNVWitSSUQz?=
 =?utf-8?B?NW5IK2w1dG9CUFVOUHNGSHhLSGRvK015T1lrQjdzMEs3akxBR0tEZWJOZFZ0?=
 =?utf-8?B?SWEyZ1FnNm9oQ1VPbkFwN0tBb0RHWTVVWmJWKzdlRzk3MWwyS01xeGF5eHF6?=
 =?utf-8?B?MzRoS0JnSUtnOUJYRmJqZjBkNzBIazVXdU9oRWdiUmptc0pERkJ6clUyaklG?=
 =?utf-8?B?TkQ4RG9FTy9SOXlNZjJwbmx4UkFKQUdXaXdDZ0lyUzRibTJZeCs5MTBnanNN?=
 =?utf-8?B?YitGTElUVkovbUtuWGdWa01TeDRVRkxvK0VqMVpGL3dVZmw3SE5uckVBZ1c4?=
 =?utf-8?B?ZkplVzZWUXloOGtwN1Y0MXhDdm92RDRZSVJVUGJ6ZWcvblFKSXh6OGxXSlJ0?=
 =?utf-8?B?cGlPSXc0aHUxVVgwWXkzb2IzVXZ0QWdkU1p1M0Rtek1jZ210Y085N0JTaTR1?=
 =?utf-8?B?WHlUMnU1S205Um1HVTBjM2Q2WkxuMlM3RWErS2ViOHZYckt2d1VobzU0OVpv?=
 =?utf-8?B?MktuMTJSeUpsQUR1bk9RYUZsM3BzRE1Jb2ozSGJJaVBVbnRBQVdWdkNFN09M?=
 =?utf-8?B?UFBGa2hkaFhOZ0JuSVROSWk3UE51UG4vaGpLNkxsMlpNY2ttOUZIT2RtS3Qr?=
 =?utf-8?B?ZGZuNXBLN1E4akxJelEwN0o0MDVxV1ZJM2hVUy85RkxqNThPYnFsYzNlbUdO?=
 =?utf-8?B?L0ttTjhPSmlBNVovZDBrNlU3VjFHdERVY2twMGZCVFlBbnBSRVkxTHNlRzUr?=
 =?utf-8?B?Y09aajFYRjBuUnN6c0hKYlJTWFdyNitDMG1PaktUbUsvZUswK0wrZlYxQ3Zl?=
 =?utf-8?B?YThDQmI5UW44SGwvNmFrYWFZcC9vTnVOdU5ERFAwOFBIcGYyWHJpUTFjTlR2?=
 =?utf-8?B?UHE2UWwyMlFXY3hNOWFMNW81dDJid05oZmovUnc0dVFwR0xsa3B0bmxTWFJK?=
 =?utf-8?B?MzFIMHdZVzg4dDVScGpEYnIyS2xvQ0pBaUZCczZPdWJ5ZXQ4NFovN2ZMZzRB?=
 =?utf-8?B?RW1CSE9tQ3hVMDNDakIwRkJja3ZhWW82RjJISmtxVDIvLytZcFhTRE4rZ2d2?=
 =?utf-8?B?R0p3Sk9WdVhrN1BoaTRzSkhodlZUemV6YjZ3bytPV3JTd1ZpN2dJMG0rY3NE?=
 =?utf-8?B?ME5lc3J5ajVNUldreHBma3V5Umd4YlZCUzJra2Z2bEF2RmZjNWoyV0NhcjhX?=
 =?utf-8?B?em9VQmpyK3QyZHFGSy96dHRrdHdGL3htVlhnMmVUZFVlTkprN1hRb3ppNU1J?=
 =?utf-8?B?MVF3OXlMbkdZWGdRSEg1MTVGUk1rRTRWaUlRbmdmTW1MeXFIamtrOFNtYVBU?=
 =?utf-8?B?Z2FKTTN6S0NMdkJRMVY5aEtnYVFKTEZDRGx5YllSSm8rdHYybm9EN1N1amxq?=
 =?utf-8?B?NWxzR2gveHdDbjdjT3F6bEg4bEhNRnh0a21NN1BUdHRTa21rMWs3MnhoVU1R?=
 =?utf-8?B?M0NoUUE1V2JITWYyM2lsRVJ1TThJeXNjRnplSms3YlhQTDhlcWpmTHBpS0h5?=
 =?utf-8?B?c2dFOXdoOG1CWVhua00ydDFRa1hEYURidmZibTN3YmFVMVByZmdCeExpZHps?=
 =?utf-8?Q?UV/+8QUTtpAVliD6bjazBOElzmI4HU/VW5oCP?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdfad713-abb7-480b-de64-08deed21c4b4
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 03:30:42.4722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zM9J7Ki4W2lej2fyX7AGtA1IxZ5KIb9Viu+cLcaqPfYKnLWY/+R3yYg71O3jL9ESqhvSqceDLVvdZzIDvHjQuceLsgPnV+THv80vYk9gOgLihF9YLnr+GylBZazXiPF+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7346

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
 Documentation/arch/arm64/silicon-errata.rst |  2 +
 arch/arm64/Kconfig                          | 16 ++++++++
 arch/arm64/include/asm/assembler.h          |  5 +++
 arch/arm64/include/asm/cpucaps.h            |  2 +
 arch/arm64/include/asm/tlbflush.h           | 61 +++++++++++++++++------------
 arch/arm64/kernel/cpu_errata.c              | 20 ++++++++++
 arch/arm64/kernel/traps.c                   |  6 +++
 arch/arm64/kvm/arm.c                        |  5 +++
 arch/arm64/tools/cpucaps                    |  1 +
 9 files changed, 94 insertions(+), 24 deletions(-)

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
index 14a78ac0f800..87843e602127 100644
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
@@ -580,23 +584,27 @@ static __always_inline void __do_flush_tlb_range(struct vm_area_struct *vma,
 
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
+	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_NXP_ERR050104)) {
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
@@ -657,7 +665,8 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
 	end = round_up(end, stride);
 	pages = (end - start) >> PAGE_SHIFT;
 
-	if (__flush_tlb_range_limit_excess(pages, stride)) {
+	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_NXP_ERR050104) ||
+	    __flush_tlb_range_limit_excess(pages, stride)) {
 		flush_tlb_all();
 		return;
 	}
@@ -675,10 +684,14 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
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
index 914282016069..beb658a007d5 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -585,6 +585,12 @@ static void user_cache_maint_handler(unsigned long esr, struct pt_regs *regs)
 		__user_cache_maint("dc civac", address, ret);
 		break;
 	case ESR_ELx_SYS64_ISS_CRM_IC_IVAU:	/* IC IVAU */
+		if (cpus_have_final_cap(ARM64_WORKAROUND_NXP_ERR050104)) {
+			/* ERR050104: upgrade IC IVAU to IC IALLUIS */
+			asm volatile("ic ialluis");
+			ret = 0;
+			break;
+		}
 		__user_cache_maint("ic ivau", address, ret);
 		break;
 	default:
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

