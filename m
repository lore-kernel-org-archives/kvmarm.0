Received: from CY4PR02CU008.outbound.protection.outlook.com (mail-westcentralusazon11021133.outbound.protection.outlook.com [40.93.199.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4692749E6
	for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 22:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.199.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744755234; cv=fail; b=Y6d69zz4dl2nQgEQZgIujFYMk6fstQoRShqL5UX6R0Vn/beXdwWsCvM2LzkORTswerqArpcCMJlXTkVAyeDosmODEcn6HrnCDz5ehimTa1ORRuNn6alJey3lzTPBC14jJ0gY8su6dxk9vSg0ihLH1yghLy0uFo8V66qnViLEMhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744755234; c=relaxed/simple;
	bh=Dc6Zuoz5+gYO5TvqZEbDCgQmWUDHWrasnFEyyE6LPHc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=J5InIBjvyD7ebadZifa/LyYKzTXNDb8AT9MxASVwNzoTUcXmoTXD7umzOjt+O6Ef3THJrVBrskRvWM7cS2GSmRJpkppr78tBmk3SbcXBuIKTX5j+/05kpUeCPpxL6JNZt1cLxUZeBtf0tr5KfJhVf2oHGcs1owhRZ7nTfduREc0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=egOves/a; arc=fail smtp.client-ip=40.93.199.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="egOves/a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JjlHOdMkXsKPE4R1RXZobPgzpFuLWGXt2+mi3dCojFYpc0AWKnS/2j4tHNHcYc5ZKBF7n1w8sFX3EVU/xcuzdgELNonWf48h745FbN8LEG7PmkvhMgB+LXZcCSXvdbwlMZCjvlWRpPuv8z7J3WptAyiHVUQ/4y3XSjn9O9TsEH+OAJ535GZ297vdPE5q8+c2DkIONk0wXZOkI81YfBQvbtIdQn7+zkFQXyMQBBl1p0oUiq+7N8lZTKS44d3QsUHqXaTKbuKMm1Er1aRPO79LbpUxDnVqNBn08Gjs9UFPvrL+Kof7l4sukZ68eEunMVPnZ3UIw1/iiKoZXtNPpK26zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w3Kk51MJv9d2vEj0wbXx8bw/OcoTGauLNOmP7VgG7Ow=;
 b=WveAQEk3n4EOPcqy8xo4yjx9/IFfYzYQVbnYShNM2ff/HcvcY+liKW2kMKuhNxuUOWqz2/4tnEwqxceUwNZ2iPQZFg4LZVxJi7fWxzqOHCeU9gEw4S3+ab9H/hMb2aVujsHmtdp6u6yY3HA6bReaI1KN+9QmDVJUBi6suAVhSnqNx63xh9cW565RHduz95564/KN6aAt7dgMkDBckyILmo7Zp9dFAgBQvbBRy6PyT5O3gJSGNC8XeB472BoIslfDu0LSIkYDIomN3r7Kf5cyJgCmtYLqSPBumO1XPf1Qiiwlh7Lbit1XzvLWIVTHcZtEIC/LDSmAWcInFj2mniI1JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3Kk51MJv9d2vEj0wbXx8bw/OcoTGauLNOmP7VgG7Ow=;
 b=egOves/a8vPxzbq1Nx+bgmJq+rta0V6Qk92rW+mU0xQj35YO4JmcwNMSt6+bul2baK19KSv6JjnsanulztMJwglwewQl1Mi3q4xMDlD5ZsqUN0pyk3gxPbR+bDs4xaFrjtFUKKFjG8aaITMeszaglMEGqSwMMF0j/r7qn6vPnfI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 DM8PR01MB7144.prod.exchangelabs.com (2603:10b6:8:6::22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.27; Tue, 15 Apr 2025 22:13:47 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.8632.030; Tue, 15 Apr 2025
 22:13:46 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, James Clark
 <james.clark@linaro.org>, James Morse <james.morse@arm.com>, Joey Gouly
 <joey.gouly@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, Mark Brown
 <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "Rob Herring
 (Arm)" <robh@kernel.org>, Shameer Kolothum
 <shameerali.kolothum.thodi@huawei.com>, Shiqi Liu <shiqiliu@hust.edu.cn>,
 Will Deacon <will@kernel.org>, Yicong Yang <yangyicong@hisilicon.com>,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, open list
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm64: errata: Work around AmpereOne's erratum
 AC04_CPU_23
In-Reply-To: <Z_6SKjdvje1Lpeo3@linux.dev>
References: <20250415154711.1698544-1-scott@os.amperecomputing.com>
 <20250415154711.1698544-2-scott@os.amperecomputing.com>
 <Z_6SKjdvje1Lpeo3@linux.dev>
Date: Tue, 15 Apr 2025 15:13:43 -0700
Message-ID: <864iypgjjc.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::13) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|DM8PR01MB7144:EE_
X-MS-Office365-Filtering-Correlation-Id: eebe1153-cb3a-45b2-dcc9-08dd7c6aca68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|52116014|366016|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pVx3egfPDYhDC6qSnrXqB4YqXoNyXx/FITziLPcN0E9hQ7StrdUZBeN45UPD?=
 =?us-ascii?Q?nIwAJQFqV+YL5dS438Skf+huii0nYlV1hbRfNdJGXWUz2+UseptKrN6vPU3b?=
 =?us-ascii?Q?+7JkldD4s+82BxuA3g7ZijpBrQVgtdvC41sHLEKXv1KzXusAqBJ91IZVB47g?=
 =?us-ascii?Q?TTX3iHWGlruqAMyHEpNezHAnmND3Zy8c1sDWG0gQjFQT6VBkVrahIb9X0f+Z?=
 =?us-ascii?Q?x8wg/m0AgbJrtU0H1oOtHP0YX45fc9sPk93XO0H8AZcOmcZA2SWkBKLKfxqB?=
 =?us-ascii?Q?Bd53hFaCfgeDHWGfhohs49OBMQ6TD3t3ONqGm1xwc9IIPGIDn7XYM2HPoX8/?=
 =?us-ascii?Q?/c4RgJDkFr71EB+9uTl1/RGdLYaxEilEpyVQIVFHQ7OE4dMjtPxK54SKvMuU?=
 =?us-ascii?Q?X014KMwRb7YkcyzQP4GxxicyUivT5XOzlKa8JxK78ybP/I7iKSBdqdDKweY1?=
 =?us-ascii?Q?4kPwGRM2ZSG0vAQFarZBR2seIS70bnC95MgSx2bsbFp3LqMP+/PRwZ+OIhlY?=
 =?us-ascii?Q?IW2zhuhLHMgPIDbw6Halloa6jgId1VwGt4oLV25vpH0jXhXqlrchV/ybr+MD?=
 =?us-ascii?Q?wyqqvCFwqJ44sU/pqyTU+6oPVBxTbeeK3PGD1JS9EGoSkjS/xtvYLhyyy5ky?=
 =?us-ascii?Q?T3yIrrc3zSFPL7QhjcSbyI5VnNwffpsB7EACKhaKlhEVdSTLq+clqJdQSP+9?=
 =?us-ascii?Q?B6xA/Xs3w4PwN/cQfx+Dopwl/JViImAW9dN5f7Xc4iGyWTYDbAy8jLbHa1Hj?=
 =?us-ascii?Q?Wqj7bQmBk44biBltF9sgQB3VaY2+sL8CsXUr4cGcohAMhhN0AGBgGqSvs4Lt?=
 =?us-ascii?Q?2LPYxTbDhyrt+x6JEUZ49O6K5QZcAtFByuQMsQnMjLniOfji+5zjaNe/5RsL?=
 =?us-ascii?Q?Khyq0ITtQZWJabjaHZu5QnzIbm/Lbx8ogcrRQGmz9dmGX3mQKZzrgutUMHgx?=
 =?us-ascii?Q?AgPpjy4C/HwX2BJJtxmiU+/ujaCkrKn1wGW9/Yi7M+J9JbY1Izv9SPvwambs?=
 =?us-ascii?Q?mHpoeYSxEY66Bag7Ol6nBt0n8Ub6mzje+hJMEyI/h67xdfS3eOI9f44fBSO9?=
 =?us-ascii?Q?uXNe7EutfkoB+erii/oBNUu3WKyILuN0qwxbnH23szy6/AeHRF9bIdMfMwq1?=
 =?us-ascii?Q?Vnplviy6WC6ubfvQuoVBLz8o6wdR8yoFIee77IoZTcVjwRhbAbWv9coxcU9U?=
 =?us-ascii?Q?RH26zl3plVa2yDRYohxUHTYcqYLkfaf/p6h8BtOH8iqIdKRLgVJZRIUb4FUO?=
 =?us-ascii?Q?Iwe+pBZmtiwPkQhlGf9Bpq+t10nSzjGCJvGEJw5LcrsncFaTXbqaLzkM4/Q0?=
 =?us-ascii?Q?fZ3QCKccDD9FAybpWm4msoAYzhBUncU26DH0+RZggOUKk5E4JelLzCFAjNPj?=
 =?us-ascii?Q?xufhythbw80ylBBG2FTFBObtUAHj9OOuIcrAqhM6MQUTM+k3alXMVRVuNLTE?=
 =?us-ascii?Q?RrgPNBnjXAy6kyLTNDC6juJoQYYrMmAE0Hx6tEOySY4EnSNy0lF6IQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(52116014)(366016)(38350700014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Abzy5C05RAeBF2KLxZiXUua+j5xqTLkBad21+yB90UqO4wEN5znMHXZRx9Ik?=
 =?us-ascii?Q?sOjDrn4VCpmKwAPEStm/+X6YMj9OH8BUeQUgUFUQa/60m4+L5qfzTJ+iD8+o?=
 =?us-ascii?Q?JF8FbValWB+ziVNta3TgiejTJ4Bq9bVBoFnm4jpQZsC1DCUCu1lqv57UWqG5?=
 =?us-ascii?Q?1bdQEvcIqbmaJQvtn38z5U1czOINNxcpVA4waZ1RjoEDlubzna7xb0v0DPqE?=
 =?us-ascii?Q?dcaatdK7DtaNfOStcmphmo7QXEIFo+wbYv96untKe2qBZMmK4FquwzuWDvrm?=
 =?us-ascii?Q?Sk56DdGWg6YEuqFm8SV8IgdHHlyfWL3l2ax0H/YtSRb2jCqdWptSHpqkCizT?=
 =?us-ascii?Q?2TKMMA+7NJLiNHbv4ueJ7Iyzx6R//4yrrLIAI4pomNCMzWpUd9uKhlwfSbai?=
 =?us-ascii?Q?ENQkWJ1dn1ELF8caMDfFk25/G3x9If5kFonc4Fh5+7XA8Ba7hl10T3hFlFPd?=
 =?us-ascii?Q?bkvpnSklmLG6gUQsfq1mh0eoAMaU9VYja7Oxe85JlBq1An8Vkq7mFemzmbUn?=
 =?us-ascii?Q?lmDGmRzXNJcGJrm8DK8e0hfBK6QNaBiTFQZes1mXCQQADf9cs8yat8Ev5JMj?=
 =?us-ascii?Q?UaQKI6OGZtuHNJRClFm8tMFNZzwnkZpm3s0VvwVm0pb/2YvbIR621JfoAUoT?=
 =?us-ascii?Q?3LFEBQxi+YARC0NypLI8xe3rH2qopwWUQ8m7D9wm1u5dpV2n7rf7XRy1JhGU?=
 =?us-ascii?Q?8A6241/UZvFjdiHEzqRliByqOSjxsAANhfJbboJMjUrm7CcF6FjZT1kY48PB?=
 =?us-ascii?Q?HY2dc+cOOb3Ktl7rYUK/IcgEDHuQxEK3mF81dCm5Wo9+gVxcueYDLYOA+mMN?=
 =?us-ascii?Q?N9GnBlruU7agD739UFp2flDaBqWsqtTjx0MCfH1wVCoBXGAYpKXSw+B8qq6C?=
 =?us-ascii?Q?KvCa7F2Au9hitUwfv++a2jIXO9mNw4kjaWMK9nfBPKIwhCSt3xZ8saEYa1wc?=
 =?us-ascii?Q?OQL60doD4+A51bpeaiaSHhwxncF1oAUaEnlMeOBIBzBwJKEvnTXam7wENqwW?=
 =?us-ascii?Q?VGWdqJuZLBBpTNQoYWNomOtbFE37Sd0RKCKAN5UXVt3Pi/UAE4EpzOwWrRib?=
 =?us-ascii?Q?n+CN6NS8Mn7jfH53CoI2KpwV3t/XqyZFWA9SVSrlMv0eNefevVbK7zdSUnIT?=
 =?us-ascii?Q?f14uSa8J1mWugmsF5Fo095GVI94560sW3qfh2M+b2pfFy+U/pFl1a+rWtJvv?=
 =?us-ascii?Q?iAKAjEUD3sr/xeYreOO9P+vT3dk5tztnXPjljciR5igB4dpmUsqryeoniJhS?=
 =?us-ascii?Q?eSXmxIVJA6gxVA8ibzQbPtMRmTbOM17uM5DkxWzlxS3V+ZIpPSMmepQ+fiTx?=
 =?us-ascii?Q?zUPQQ12KakSE8gLHgyk9qx7hmb4g663bf/8Lj3LoLboZCegGiuFs+oRXNlq+?=
 =?us-ascii?Q?aQqXvVw7H9sU7nfdOgV7Ml8B7mwh8KbKTlE4yUpzquxBF5BHKnoieyCws5Oe?=
 =?us-ascii?Q?BaSga0PpZ/1eCo1aIKjA1Bctg0wWJsHfx7HdfAtDoyKaPPBvETutcumtHupv?=
 =?us-ascii?Q?fZbYXBkf0M7k+XLiVsEWsyHGsOMQ1IV5Oe9kLxtuQgMEbBqMcz1OuVRt0pH4?=
 =?us-ascii?Q?2HS8xKfPfPmbGzwJtMW68TWoceUK0oAzi3tEbGJot32a738KXFFvwAISG4/c?=
 =?us-ascii?Q?B6Frmr+WTbwnsbu6SHojro4=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eebe1153-cb3a-45b2-dcc9-08dd7c6aca68
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 22:13:46.4600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XsNvfriM/ztDyuI2+cQnj4LNqLoOBZjk6+/jER0MU8t09e8fPUrkGyyTK8km4MzgxEGPxl7rBUTPGrZhhO9o8HyFGApq3NAuSKI0CKXzGRkIWgS5adUh7kTE0zRcXSvf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB7144

Oliver Upton <oliver.upton@linux.dev> writes:

> Hi,
>
> On Tue, Apr 15, 2025 at 08:47:11AM -0700, D Scott Phillips wrote:
>> Updates to HCR_EL2 can rarely corrupt simultaneous translations from
>> either earlier translations (back to the previous dsb) or later
>> translations (up to the next isb). Put a dsb before and isb after writes
>> to HCR_EL2.
>> 
>> Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
>> ---
>>  arch/arm64/Kconfig              | 13 +++++++++++++
>>  arch/arm64/include/asm/sysreg.h |  7 +++++++
>>  arch/arm64/kernel/cpu_errata.c  | 14 ++++++++++++++
>>  arch/arm64/tools/cpucaps        |  1 +
>>  4 files changed, 35 insertions(+)
>> 
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index e5fd87446a3b8..2a2e1c8de6a16 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -481,6 +481,19 @@ config AMPERE_ERRATUM_AC03_CPU_38
>>  
>>  	  If unsure, say Y.
>>  
>> +config AMPERE_ERRATUM_AC04_CPU_23
>> +        bool "AmpereOne: AC04_CPU_23:  Failure to synchronize writes to HCR_EL2 may corrupt address translations."
>> +	default y
>> +	help
>> +	  This option adds an alternative code sequence to work around Ampere
>> +	  errata AC04_CPU_23 on AmpereOne.
>> +
>> +	  Updates to HCR_EL2 can rarely corrupt simultaneous translations from
>> +	  either earlier translations (back to the previous dsb) or later
>> +	  translations (up to the next isb).
>> +
>> +	  If unsure, say Y.
>> +
>>  config ARM64_WORKAROUND_CLEAN_CACHE
>>  	bool
>>  
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index e7781f7e7f7a7..253de5bc68834 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -1142,6 +1142,10 @@
>>  	(IS_ENABLED(CONFIG_AMPERE_ERRATUM_AC03_CPU_36) &&	\
>>  	 __sysreg_is_hcr_el2(r) &&				\
>>  	 alternative_has_cap_unlikely(ARM64_WORKAROUND_AMPERE_AC03_CPU_36))
>> +#define __hcr_el2_ac04_cpu_23(r)				\
>> +	(IS_ENABLED(CONFIG_AMPERE_ERRATUM_AC04_CPU_23) &&	\
>> +	 __sysreg_is_hcr_el2(r) &&				\
>> +	 alternative_has_cap_unlikely(ARM64_WORKAROUND_AMPERE_AC04_CPU_23))
>>  
>>  /*
>>   * The "Z" constraint normally means a zero immediate, but when combined with
>> @@ -1154,6 +1158,9 @@
>>  		asm volatile("mrs %0, daif; msr daifset, #0xf;"	\
>>  			     "msr hcr_el2, %x1; msr daif, %0"	\
>>  		: "=&r"(__daif) : "rZ" (__val));		\
>> +	} else if (__hcr_el2_ac04_cpu_23(r)) {			\
>> +		asm volatile("dsb nsh; msr hcr_el2, %x0; isb"	\
>> +			     : : "rZ" (__val));			\
>
> At least from your erratum description it isn't clear to me that this
> eliminates the problem and only narrows the window of opportunity.
> Couldn't the implementation speculatively fetch translations with an
> unsynchronized HCR up to the ISB? Do we know what translation regimes
> are affected by the erratum?

Hi Oliver, I got some clarification from the core folks. The issue
affects the data side of the core only, not the instruction side.  I'll
update my description to include that.

Speculation after the `msr hcr_el2` couldn't launch a problem
translation when the `msr` is followed by an `isb` like this.


Marc Zyngier <maz@kernel.org> writes:

> On Tue, 15 Apr 2025 16:47:11 +0100,
> If the write to HCR_EL2 can corrupt translations, what guarantees that
> such write placed on a page boundary (therefore requiring another TLB
> lookup to continue in sequence) will be able to get to the ISB?

Hi Marc, I understand now from the core team that an ISB on another page
will be ok as the problem is on the data side only.
