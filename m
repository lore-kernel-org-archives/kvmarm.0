Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011040.outbound.protection.outlook.com [52.101.65.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0442B1A6822;
	Mon, 24 Aug 2026 04:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787544280; cv=fail; b=VOUTA3AG9e0rCdjKhn9iIYHQLqFuTPmqQ8kWeYMUvVGIx/b9tLFwrrCbU0nPbhYXyZHSg2trW9w1aXVah4DqDXjL2c+gedcbAP7oVgIds32s5k/gir1OKYMXpZCyhSw/iUZCG3YX+cEmmFNKDk2r9lZGXf7g8hm8oODDN62wwGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787544280; c=relaxed/simple;
	bh=sKXAN9S7xwLWvlPdgcmrI82/K0ID2xZcrupPzMjczZE=;
	h=From:Date:Subject:Content-Type:Message-Id:To:Cc:MIME-Version; b=psypZf/d3MZfnNu/Ms5iIivqt1C4s4xIWZqJ9kpXbSpBxbe4Q8pz/1tM+evAo/bK9SR/eZlPQLQ6C0Effq7hE9iZks9VTS0Cy5ciA4PlHXNIUnZC/RWZq20PqXgi33ddtMRmo48FJCr5WyHxBE+/vnKIouuewM+A/uPAb4dR7DI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=SjRZD7jW; arc=fail smtp.client-ip=52.101.65.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="SjRZD7jW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XnXyiI353dEzPf7dVCJI7HvGPlIr3K2QHkBSv0kalXjt5GUNzjqsxwHGSB+UzB7E6xZp1m5LniTrvdf4yJhUG66u1RlF4e6VVMj9dxvSJ8MGAz4xJy+SmN2ZcGLAIFy85te7STxSJDTO5/fW3lJQB4NXEFYOBbCssM+aMKt+UqD5MIekx55pPH7V2J0AAh8x+WO8RFoHYg9WlplQFPoVcwaKvIjRymD8aftz9eLWma5x9sEkDRp7uXuP6eiYZfPiX98El7fKXXCM0RmenDP5JgRXPbGfklFxiBnesNvWAneo68M/hN99f3qne3bopaU40FMytXDcuz27GdeHQx4k/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0HN8T4sfgH+rv0WhFiwNPRZjRCFi+ToFQfWfjH6A5I=;
 b=Y4p11fxyMWpvFlHCN4Y/RMEWHMurFfF0m5ky6ZOdTp1gXGQ2C+x9PjALbzOyob5yJAW8NI64KBuQVQequ2qZ2zTHo0xaoTbJ9Az6ApZyv1FkB2Gyes2b7qscNyh75XUdFlwdAI+ZFn8flWtWyMqZct5XXajzypRhGdikSxQQgg70MKBuT/WtX6XRxSHdQuvfrgET+q60GH7c3aXDlvEezbWLhftAdywtfeA3mdIe3dEBBhrJij04i/rjoO2lC04fkx/S+d03LwcPHyAapizZpX4v341LRBLbbhsZCDJJMoHnpEClJgvNkP4GmbenirEYycjzaG74b6kyalVFV31Dsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0HN8T4sfgH+rv0WhFiwNPRZjRCFi+ToFQfWfjH6A5I=;
 b=SjRZD7jWsxUaG9gAq9DGGJ8DoFwuhE1XHgYnxlhrAapD/yLCZ6HbHD/glICT+mSiYE5qz8oRRYn+vi2luNIbKizquLwQylyak2W0cYM1QsYk402h2g+fK2qTw9oaOwj2uo/ut3SjVnXwpmD/q5/+ff19RVu6IH4nzlc1+o4icG4vkx/XTp5Fzj9K9m1g0ZlzAJ49zlwhsBhGkj1yceml+k0a7anSJ3smiHzaRYwYLbTXlya+d1OaPxM78Zhp4leKkyr831fO141OaP11zB8QU39QJb2MW5mUT1DWiqfOcI/tivjCyySHw7kEmaaOJcd6vLWAHTEW2IoIwf3ExhmDYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by AS8PR04MB8056.eurprd04.prod.outlook.com (2603:10a6:20b:288::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 04:04:33 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 04:04:32 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Date: Mon, 24 Aug 2026 12:02:04 +0800
Subject: [PATCH v4] arm64: errata: Add NXP iMX8QM workaround for A53 cache
 coherency issue
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-imx8qm-cache-coherency-v4-v4-1-b2e528c7d05e@nxp.com>
X-B4-Tracking: v=1; b=H4sIADvCi2oC/yXMQQ6CMBBA0auQWTtJ01ZSvQpxAePUjglFWiAQw
 t2tsnyL/3fInIQz3KsdEi+SZYgF9lIBhTa+GOVZDFrpWjltUfrVjT1SS4GRhsCJI224WPSOrsb
 clNG+g9J/EntZ/+/mcTrP3Ztp+g3hOL4mme2CfQAAAA==
X-Change-ID: 20260824-imx8qm-cache-coherency-v4-f8c5339032fb
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>
Cc: "Ivan T. Ivanov" <iivanov@suse.de>, 
 Francesco Dolcini <francesco@dolcini.it>, Frank Li <frank.li@nxp.com>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, imx@lists.linux.dev, 
 Peng Fan <peng.fan@nxp.com>
X-Mailer: b4 0.15.2
X-ClientProxiedBy: SI2PR01CA0052.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::11) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|AS8PR04MB8056:EE_
X-MS-Office365-Filtering-Correlation-Id: b000edee-97da-4c2b-2014-08df0194cd78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|19092799006|1800799024|366016|23010399003|13003099007|921020|6133799003|10067099003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	62G2Ojp98+TMQKa76mN9ldysoLbe6a6/Z6HNUrb6EORHqxYEFONj8AgB+Oxju8TVxluL3bJwdoUUhze28CzT45NUq2gGJhE72HCBHEbE/Oj8CC0jtWDDaK77JaZ3iJBFwmRqrQC+8FzrwQ/cL+Cx4um1fpvujem30Jt/ANHKFC/+JxIww+VkrU36uqQC7vnHOIRl2e4/vjdsUF6IbMDuCsVcDyu/e+egLM5JwSdA22yBoBXVDG6RmcQTtHy3ELCNKul4WZ6cx/R+f6yWHSS4Axf/J86AakR8zl80QWqlHSYCmllsK6oaSiY3IGSM6MJcp1988OEG1TCxjHdFcj0Ai/vVCuJmJIMoRDpozjEmHRIMIO3A3I49My+bUXCVtRc4lwU2cLS9bQk4IrbXd1yYNU2qeqozjhF5VmoHpNclew5PK+/REBS0LswLCKKJgzuhe/sKJMi0bH8JtzvhfvZrr2g7mJXcNRXEOKZzwxo1TTT7nhQpp+eJo2QrFtFwqUfk8I1VKwSLarDj5YIFgDWISP04tKCsbVZsc7RtfK7aFxqutvQJ+g9nMYnpGA5zkNR8q7O/El4R42lmE2M081rKNuOnv8ppd43d3DyOpJbh7NOPGP46SGPhOAC+4vu39K5aIBMdRDLCp3z8Xc2sbKcTG7eP1st+/hZzzJ+eqUEB++0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(19092799006)(1800799024)(366016)(23010399003)(13003099007)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3hpbklsUWdrcXpUbmozK2VpalNLMVFaLzV2Nk1zdXhLYi9GRlBaYUw2WEVx?=
 =?utf-8?B?MnlhbjdTcSs5b0ZvZkNPdkc3MGxiallqTHRPNExZaFZ6eUJud1F2VzZIMGRq?=
 =?utf-8?B?MTJhRGZHQUlsdEIxRE01OUhzd0FrczBsdEZpdjBSdllGTXZ4NDdzalQ4TDZ5?=
 =?utf-8?B?TEpyTkZEYWw5QW9DUkpqb1pJU2RTT2lGRTR1Nk82OUVrOUhxMjNUKzUwWXNr?=
 =?utf-8?B?RlkxeHFpbFJzbHcwV21xZ0Z3NGkwWklxdUx3c3Vodk5YbGM0N3Q4amZVaU5B?=
 =?utf-8?B?dFpDRWxZMmV6WFpNNStkckJ0L1RoODNwSXBteUdpY0VVZ01YLytXcE4wTEJL?=
 =?utf-8?B?STFXcm1hTTNCQWovbnZpQVdvd2U1WmlYQVdPckRXd2JhT01qWU5uOUFXVm9t?=
 =?utf-8?B?WDN2ZjBDZk9TS0s1dlBvaEdWU3AxeEtuc0Z3cm9QSi9BVzhwTkphTGdWV2sr?=
 =?utf-8?B?ODVGdGpwV1gxN1J0YVQxMDZBUGRPMXh4N3lrZkd5VzdqYVNyQUhMNThHcXdK?=
 =?utf-8?B?MDJRVXFuMm5oYWtGNGZ4SGdSejg4M1hyNjV4VUNEajBGanoraEZNTlZsRHJZ?=
 =?utf-8?B?WGZMRmJiQTQrM2J1RHZBbmFaOURJR0E4eWtRTExuOEpucnk5Z0JzV2xNcXIv?=
 =?utf-8?B?T2NXbUZqM2pQZW12M05IUjQwRG9VSUZiNXJyeUNhc2gvT0lFb0xJUUlJN2hV?=
 =?utf-8?B?aStkUWZvUkhYcnNEV21jQ0pISTg3L0svNG9Qb0Mvd1BCZ2JrSWRaKzhTQUhP?=
 =?utf-8?B?a2g2RGNlV3BoMUIwUjBOZTR4eTZKZ0JJYzQxNXNsWXpjR2VmL0tTdUwrNCti?=
 =?utf-8?B?V2M0ZlR4a0N1S3YraUVkMXFCa0M3ZUNHKzRzcG5LNWJzUVVsM0c3THZiN29B?=
 =?utf-8?B?aU9KakJDLzhTM0d3ajlRTHpqcytCZDdDTlExSEM0SG5UNytUengzL25nNlNY?=
 =?utf-8?B?UGk1dVRHQ216VGNkdHB4ZmpOTWdNdkw4emptQjJHWVJPVkJoYWE2bGVzU3NB?=
 =?utf-8?B?NjJBSnM2MVZsd3VKUVZiRVhrTEFLVUd4OUJXdFl2aUVZTVFKMXFRWEkrNEdR?=
 =?utf-8?B?bXVhZmhOMU9uanR1Yk1zYUZkUGlxZGpxMUwwU2VJUHZhdFZDMnk5WmZXYlls?=
 =?utf-8?B?OHN6dTJHQzhyUkR0cXpjTDZyb0FyNm9iL0prLzVlTEtzR29sRVdkZmNUMFdZ?=
 =?utf-8?B?Qnl2VlNyWmxjUGdnYnNKTThJSFRidk1XUHdJYU9ZMzJpdkFCcU5IMHdEL0Jo?=
 =?utf-8?B?REJ5dFN2MzBIK3ZSRkFIQmVvS21VNHhhSGZPWnM5dVdkanBOL0YrM0VmV3lO?=
 =?utf-8?B?U2ZNQi8zUDRTK2xKUFFIam5JWWg3L0s4anp5RmNucEJvem1EL1BiL1NxcXhr?=
 =?utf-8?B?SUg4VlpCS2Exa0I4MWhNaFJ0dU9OWmdMcjBhR0MwVFBnVzBIQUFteTVtdGQ5?=
 =?utf-8?B?NktIbmdRcFdnMjFYNG9uVW1WSlBxeVJoa0ZGVFpRVGxjak95NXR0b3dSRStJ?=
 =?utf-8?B?SUFiOUplVEpBZ1pFU092OHR6eGk0VEJwajg0Mld0RkZZYjhObnZrUnozWWFE?=
 =?utf-8?B?YldTL1dQVmNTTFlXK0o1a0d0QXJib2pQUEpJb21waUhZTDZGbVkvdGY0VDhO?=
 =?utf-8?B?VVQ2VGx0bVJKMHFXTitzTGZlMGVTcm1pSmJhQkYyWUJId3VKU3U1SVdXb1J5?=
 =?utf-8?B?Y0FQKzZVblFBMzNlbjdBVzJ2OTBqQ1dSQUowN0hCZEtZNU5MWEZ1ZHlWSklF?=
 =?utf-8?B?NHJnbk81VXpPYlM0OTVlaFNKc1ZtRmpScjY2VzVUQjd1ZkN1ZkE1dDFwUlNJ?=
 =?utf-8?B?TU5oYjVVaGZkWXpMVGRiSmMyb2xzZkJjbVNOQ0c3cDMxakRIY0tpZHhrODFM?=
 =?utf-8?B?T21WckxPMko1cFl5eGxDcFBuS0RPeS9WMCtDaW1GZTVGOGNKdEdna3EzMTBE?=
 =?utf-8?B?bGkvdW5qcGY2Z1FMRDhJMFA1Q0Y2R2pOdEtCYzhScGJDOWxMNW41KzB2UlRW?=
 =?utf-8?B?c1dlUmZaY1JORklnaEFPRGFHVjRmdG9iNTN2ckhEWEFaTmRnSTh1STc0RW14?=
 =?utf-8?B?UHBiNGtmc29OZnFqQmYvV0FLdFpJUmRFN3hqWkZ3NXFOcWlZclk2SkhZeTFE?=
 =?utf-8?B?RTMyY2o1dWlvZHhPcFJDa29tZ3ZtcTFpZm5yM2FscGZUL1NZQXdDU21OOEI0?=
 =?utf-8?B?aHpublN3dzhFeTRYRTdXeUYrT2ExNmVQR1pOWHFvMGN0akorZ1dGZzc1SzlW?=
 =?utf-8?B?WDcyNUlXRHhXZjNIZDlvMTBKYXo1UmZROFQvVjR5MzhrOWpjakpFTUF6VUZs?=
 =?utf-8?B?bWlOOEhid01mQmp1Ulk4NnZ3TFA3eUFsdFNiRkZWVktsZ0JuWFVNNi9PV2VU?=
 =?utf-8?Q?90eRiRwB/wicEwFlsqGzb+HYZ/WLpG1+0GG4D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b000edee-97da-4c2b-2014-08df0194cd78
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 04:04:32.9315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TY8sApLLcLYK0SiUm6KZq11zHOnR1ETMsxFWp4Fz/H1flhfoL1mrP8FM/yE7zA/9UiR5wV1fHWpgnY42vfnsFEtSvkGoI5QlJqqOw+x0wH+/AK6tHPg1xASCYGw2Lh8K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8056

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

Co-developed-by: Ivan T. Ivanov <iivanov@suse.de>
Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
This picks up the work originally done by Ivan T. Ivanov in 2023 [1],
reworked to address review feedback from Will Deacon and Mark Rutland,
and rebased onto linux-next.

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
---
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
---
 Documentation/arch/arm64/silicon-errata.rst |  2 +
 arch/arm64/Kconfig                          | 16 ++++++++
 arch/arm64/include/asm/assembler.h          |  5 +++
 arch/arm64/include/asm/cpucaps.h            |  2 +
 arch/arm64/include/asm/kvm_host.h           |  2 +
 arch/arm64/include/asm/tlbflush.h           | 62 ++++++++++++++++++-----------
 arch/arm64/kernel/cpu_errata.c              | 34 ++++++++++++++++
 arch/arm64/kernel/traps.c                   |  2 +
 arch/arm64/kvm/arm.c                        |  5 +++
 arch/arm64/tools/cpucaps                    |  1 +
 10 files changed, 107 insertions(+), 24 deletions(-)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index ac3248b9f2f3..0d959b749802 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -327,6 +327,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585         |
 +----------------+-----------------+-----------------+-----------------------------+
+| Freescale/NXP  | i.MX 8QuadMax   | ERR050104       | NXP_IMX8QM_ERRATUM_ERR050104|
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | Hisilicon      | Hip0{5,6,7}     | #161010101      | HISILICON_ERRATUM_161010101 |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b5a51b0ef944..4a4e4c293e5f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1455,6 +1455,22 @@ config ROCKCHIP_ERRATUM_3588001
 
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
index 0b58b550e8dc..43c13700f17d 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -451,6 +451,10 @@ alternative_else_nop_endif
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
@@ -459,6 +463,7 @@ alternative_else_nop_endif
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
index 27fe0cd5b2d7..762ceb56c058 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -73,8 +73,10 @@ enum kvm_mode {
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
index 5db8f0619e4b..9d410a06c201 100644
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
@@ -200,6 +202,29 @@ cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused)
 	sysreg_clear_set(sctlr_el1, SCTLR_EL1_UCI, 0);
 }
 
+#ifdef CONFIG_NXP_IMX8QM_ERRATUM_ERR050104
+static bool
+is_imx8qm_soc(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	WARN_ON(preemptible());
+
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
@@ -1030,6 +1055,15 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
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
index 8b080804bc90..d010d9eb3ad7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -3159,6 +3159,11 @@ static int __init early_kvm_mode_cfg(char *arg)
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
index 2775ba3359cf..6875ae501dcb 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -125,6 +125,7 @@ WORKAROUND_DEVICE_LOAD_ACQUIRE
 WORKAROUND_DISABLE_CNP
 WORKAROUND_GICv3_BROKEN_SEIS
 WORKAROUND_NVIDIA_OLYMPUS_1027
+WORKAROUND_NXP_ERR050104
 WORKAROUND_PMUV3_IMPDEF_TRAPS
 WORKAROUND_QCOM_FALKOR_E1003
 WORKAROUND_QCOM_ORYON_CNTVOFF

---
base-commit: 903c1cf6dff9964e71eda98a39e2e5d442050472
change-id: 20260824-imx8qm-cache-coherency-v4-f8c5339032fb

Best regards,
--  
Peng Fan <peng.fan@nxp.com>

