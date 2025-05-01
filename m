Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2118.outbound.protection.outlook.com [40.107.93.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563FA6FB9
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 15:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746112702; cv=fail; b=g6G/ithbIPWKwcjGqcI4wcmwRmKjIiFahAvWWUIeA7fYWL465qhqkGWdknd0HNeWhOGu3RS8PmW/XlCJZ9Ka070vfy7ZtgbkfnsZZoC+gN1Rx2slywlmTdV7lvMajQiaaFGJzedSYrrkLhHGV0WAUj2VwZiSOAf+x7gfvqTcC6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746112702; c=relaxed/simple;
	bh=aS2zyR6almAiHlJWVzcm+dX9+jol6yLENwmmq0Pz/P0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=H05hJX5vBuFmMdbmqb0MElgB6a22OTgS12EPba0ubBgz75jR+0CiwC7jwgDVCwBlkVHWsUWHxHbv3YOfu4Hho+rVNvzA98mIqtZXvbNczZVhSHD0gAM4kFKY5OmH/4Ug9ppIxIwnMjnCGlJtPgYZ8AR/XMRL8zUv7lhtE9NrSq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=Cybod6Fz; arc=fail smtp.client-ip=40.107.93.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="Cybod6Fz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U2lGWqlOTnxhCJYpZXKkEtlj7jT3a/9VgpbpmqcgUv1N01cDVRUtKnLI8mJdhwshRkmOt9/OxcP7nnITZTyqVxv8M1ARV290TCZBvNBPC4SqoXBhEheUa6eMNhY+2/73e86TsxjjYtvNiJxxAi4C/220jWWuEWko/hcL08f2cpBsvcWoyU8u3qhvDZdYKmoYiqXcpfvk16sOSwf3YNgcIIRBp9zH733QKStocGYPrn1UB0YG/Z73Ez3uUk+LyuOFPZL5zOSdz+KkSzxAZSRiYsU7nUM26KwfacEk5IJk94GCtW/KpHEERh+8xqsmOyzuOUQQ812rDyMn1ZoglZZLGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ixq1fsxLDyCVegWJrvCa8Ua4CJ/PDy6cRN9kOMClm0=;
 b=p5UIe7T9/lVc3lJZL5ZTPqe1v48Zpuo4KrvaFKW1MH+rIk2x0TjKq5sBcEihD/KI9FPyCMzgdTPkmoxnh0U8Y8T0j1uixl0ABKkTW74LmnXE2vGvtY+Xoo3ATsEdMHwNo6/D6NsTOMZtLlbP6S96rgf2bDbFnX0f/gtLiW1h+iB64cNpt1jgHYRAs69vprrrQu/1/W8FnyEXvVJeJ4EFv4thpVrZC5YZXrDUl8h120mw/SaIFMsyquYeGL5PUeYtY9fkRAccRYgIO3ELEno6oTTyqAeALZyeRET1YDnEp5BxHt6IV2nElIK12jJVqJFzhULQNYh2H8sQbNow7LGbGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ixq1fsxLDyCVegWJrvCa8Ua4CJ/PDy6cRN9kOMClm0=;
 b=Cybod6Fzek6ue0aNJb/ghADGpV5Hq3Ry9zNUFbt/evpGUPkYaP8RChZEI6jGwC6Wysu+yntFmtthdI5+tNUE21E/tkmWmhQIfz4quuV23juTwsb+E96jJTLyK+o7yu2mwzOmR0a4pFWut1Z2se7vnGs/tFdYy+niEOR+GPUMj1I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 MW4PR01MB6212.prod.exchangelabs.com (2603:10b6:303:71::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.24; Thu, 1 May 2025 15:18:16 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.8699.012; Thu, 1 May 2025
 15:18:16 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, James Clark
 <james.clark@linaro.org>, James Morse <james.morse@arm.com>, Joey Gouly
 <joey.gouly@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, Mark Brown
 <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Oliver Upton
 <oliver.upton@linux.dev>, "Rob Herring  (Arm)" <robh@kernel.org>, Shameer
 Kolothum <shameerali.kolothum.thodi@huawei.com>, Shiqi Liu
 <shiqiliu@hust.edu.cn>, Will Deacon <will@kernel.org>, Yicong Yang
 <yangyicong@hisilicon.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arm64: errata: Work around AmpereOne's erratum
 AC04_CPU_23
In-Reply-To: <865xilir33.wl-maz@kernel.org>
References: <20250425024741.1309893-1-scott@os.amperecomputing.com>
 <865xilir33.wl-maz@kernel.org>
Date: Thu, 01 May 2025 08:17:53 -0700
Message-ID: <86a57w9x7i.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0125.namprd03.prod.outlook.com
 (2603:10b6:303:8c::10) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|MW4PR01MB6212:EE_
X-MS-Office365-Filtering-Correlation-Id: cfa1e48e-20c3-48a7-9863-08dd88c365ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|7416014|376014|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dVv0cSyqVlx/wi/Iv5I0O+GbPxS35f8yyOWLeHN7zLYsOXSmgXHNRHKT3wLH?=
 =?us-ascii?Q?HDeELWxXY4d8Y/4OO5vjgQn5C1k827HipmerphdA/dpHNIhwE4nwBZUt/FOF?=
 =?us-ascii?Q?e5ON098i7CJTBOIKnRW+GkPld6OEPnFf262HCRieMqDWULcau6l5yPvIJHMc?=
 =?us-ascii?Q?86kHGmBKmppFoZFJEzWHL07yVZcBmf4lZwR7nvW0iVbFTPtgMbJgshpyPu5U?=
 =?us-ascii?Q?WRueTfskdAHDQnlXG//wzy92vVI8EfeBOi3gO+10yKED1nPqLZsIYlAcX5ha?=
 =?us-ascii?Q?CR2t/hRo4p+SellPzX2gJcNfC/fVp7fJNjLwkGkrsiNFu6FoQPezzi6rtYEI?=
 =?us-ascii?Q?wp5olID9BXhkE3lj0ELM1MzdGXfwhQ+VJxLrJDWcOuyH1DxYVtfUoctDavwG?=
 =?us-ascii?Q?GHMSZTxoBYhNhnBWAZ3n+s2hAKYm2avhZPSXwrbK3/yDcUkhURuJAF+ioZc9?=
 =?us-ascii?Q?sBmlbkE3+t4S1LVynDkHnSP3c4JjOsamSnDRHWD+5u8O3kmSsCc1sR7h7yij?=
 =?us-ascii?Q?WO/tBypf/VOZFnaXGT6SLWqvt1h5Esu+J73Y0zynudymMupGDoukw/m4fh3C?=
 =?us-ascii?Q?0+sBq7/XeVEic7S/9wf5PyQ+irOF3qT+y28H/zVxnHLhRNQfguO4h3cbsI6n?=
 =?us-ascii?Q?z4HZXI4Fm3LzkeSYToCpn1x+E8KrgZ+Q8iUB+LYpQ46GvEVVWymJZJ6ldtwR?=
 =?us-ascii?Q?V8d+JOJuOqu9wr3nZAANTfvdiIkGWY0YzO2g3ZyLQdS/oY4lRZxsjdBk8iQz?=
 =?us-ascii?Q?EXd1N3ElAW/Tw2urCkD5/ZfwnIfvPEFHkz4VcP8NIOeVORxUy0HQPc1Dn48f?=
 =?us-ascii?Q?UcULate1SEsiuGu/6P5bQs0NtsN7a3XfcszbeWONEQcTNpIskd6+yRkcaBba?=
 =?us-ascii?Q?cEtE7J54EjVyrcN0zOxb6FbVvBDMX84Wb2UDzKH5Acxh9fwcar43iFVCzPNg?=
 =?us-ascii?Q?3tB23Ij/yeahzn5JIrCvMZ2lAAD/MZB8hkOx2K/JSw3Qxt2ys4BTtWAny3/q?=
 =?us-ascii?Q?JOnsSQVsHP4JSdMT/N2KOA1rbLqmijtJ7php6R9yOqfAb6EJsb0FKfprmhYo?=
 =?us-ascii?Q?pINdeja0wJZ12Hr9lT59PpxBOmf5gf4PwZzwZk9CYoPekn2Bq5rmrJw6ljNN?=
 =?us-ascii?Q?V7h/wq5nriFO1f2E512AnfUWw9GZftarFm59tM52jxi7D14zu1/EUGtIhshd?=
 =?us-ascii?Q?xlstJSUOQhuScUYP4y60afMIbdirqp52izsLVLxI7ExsOClRsvZP2USxpALy?=
 =?us-ascii?Q?59rC8OzBpKECejpkSL10VFjRAXNl/uXE3VKhUOQ9l/N3UDA9Z03KoRxUn8dS?=
 =?us-ascii?Q?6mUx2d6JVU3YDwsf8F/rV7puhDLmGUjSrspDGB2x2tgBG1AdQm6WAwKoV9Qs?=
 =?us-ascii?Q?8EzYbELy+6UzcrLaYKAn35PC8oT+wCSd36i4/ABTQb25G5jYIVfVJo6u6Bs0?=
 =?us-ascii?Q?6oWx9X7X2s0fNj6wPy4lRKGLnIQ04sS06bfm3DVa3qpB3FdaSSHE2iypU15T?=
 =?us-ascii?Q?7WJ1cEIlWgOm9QE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(7416014)(376014)(38350700014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sje22o6nWEZLgj6GW+Uq37lQVmcV+x+YLQtDS/agDb3OfEg/ObYh0S0fo2LB?=
 =?us-ascii?Q?whj/pDQzuzZJJ4Wr7toSh/3rV4vf+IKBd4k82OpbUZQhP+jhKhKzKlIeVTNP?=
 =?us-ascii?Q?mHvsKzPTfCMjZdOtcoCof1LhncG4AA3Yo8m2xYNAEL/Q9AYoVPt9GmfdwR6O?=
 =?us-ascii?Q?Ls7YhYlhMuxV7mz3ccRRGcpGvOzBMgKDs3HTEEAUEG1cNDH0UOUw9W/uFk12?=
 =?us-ascii?Q?/E2Mxks9ffAX/IhiVc327BqqW51YXgD1DHlmKMXLKMvQC3G7ZmyVfnl++r7b?=
 =?us-ascii?Q?oRSlvNbYVkMMFgWmBGKTLNl1ksdFsDYU9K2wb3ziuKoPI6l8+yiw9Z29NJ60?=
 =?us-ascii?Q?LY4c+KraOpFjsOQcRrz4jcDBcJwXuyT8ZdTxoA92e4nNpaejSOytj/57Rn0I?=
 =?us-ascii?Q?KIod/CFOO636hq1jjlKGGYLIpwz0fW1NTBmI0VpslGh1R70rshFzt9RCVcnI?=
 =?us-ascii?Q?/1TXgWoddp3R1S7hw3A1D0CSv4BG2cUAt9Os955MhOgNMM+r4cFiCvdPe36z?=
 =?us-ascii?Q?kZpoCkYYcPfP3weKRUHwJisyLfSJbJ0QG/pVmY972ozc/IexkeX3NkDn/20z?=
 =?us-ascii?Q?VuhWOBb/kQRMaePLq6NRDG9CWKMIELQdVOUWiLMTVPQGgesJQtMj+jCEstQl?=
 =?us-ascii?Q?AUPW4Q5+qz0eE/9Ck6DzMZ4YMatFzz8fCUQqjHWL9yl6U0SzoBGuJTI56+6B?=
 =?us-ascii?Q?PLgquOYcq5lGZm5wblAK9T91/Z4W/d+BXijW6q3yjVL5c5ePC0kSLlaaguHm?=
 =?us-ascii?Q?zuUZSMsOZoWWXhMyuKDHXxVPb/XuLrxOo2K8gHXPjYCq7LF7evVwmYGHfwN3?=
 =?us-ascii?Q?Lk5Z/xKfKuF8TqQoLuyOYrHBO2lE3MrSMeSbG0icJPitF4yYr+6Ae4pWnvnh?=
 =?us-ascii?Q?gMxa/UeuMnVv3Dy9ZkohyLoOoDaWlYdsBuzqFj2ycOjttL3onSlBc1WLwYjx?=
 =?us-ascii?Q?XVAX18Yje7WujrJsVuu3McYya1w6M0VuExhrT7q4Vzs4e7AMYMjEcXl8yQG8?=
 =?us-ascii?Q?wu7RIiBrHg1HeXumryeeP0qqnkZIka1XWsh/CRd7NJaZkSlo/pYmo2h7cyUY?=
 =?us-ascii?Q?D11HxpBYIvtBmjdpvCAEw9XH+JS7BZ9nw5rf4Oea4Thnnutu9a6BnGwOdsYX?=
 =?us-ascii?Q?msYyj2N2H6dVgA9Pg+0Rv5jjXZGWfYfgdk0wiuJDkjXY+EEqEB5xUsmZKM6L?=
 =?us-ascii?Q?BjfM8gvYXHmhLQ+NUDiLlBcGnde9jgJeCjm9c8ygC1tMF3F5kYGfiw7ZtnI/?=
 =?us-ascii?Q?0LEdGEYjCrWOlqGPTUythsZE2HmVVDb0NI37AwxH6/skWt+HwLYypECx9SCF?=
 =?us-ascii?Q?v4vJtneIobngfN4IreNaapvFnoZgS30IgkLEapsSGRtYfl98uh5URXDI9m0j?=
 =?us-ascii?Q?D/avOFkzCG6/bRq2f7rhzukApwE5oJhQR3HiOi5QKiDTtddX4cxCVrzCNkEh?=
 =?us-ascii?Q?xvJ9l7Z0WbtpDP0nXGedzfsWD5N+DPZfCAyZrtTQHNET6f3M3D1GMvGBO9gm?=
 =?us-ascii?Q?Gh7IeIXJ+vfV74AgBPFQhBqdXyChJUbiyyg4v+Gl5LtQHDoX9oAFTECqmKZW?=
 =?us-ascii?Q?rl+LfqYIFE6QN/Huc4iQmpSHYlbHjNKdSGQ71g48t4aYjFpFoaqtkVRHSLOp?=
 =?us-ascii?Q?8ZUNWc1kStAAaQc0nhfNBPk=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfa1e48e-20c3-48a7-9863-08dd88c365ad
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 15:18:16.5328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tQuboGMWRt1Ro5EIyuyjk+Vm13/fDwd3ACG0e1htxh2B8Qaa3cCf1FYKSCdjz/phUuz249zysDlxzqAF9aNNB+GW3k1mYF7dLCQO0PmYh+Ir2WjQtbqholtdw/XPbNl6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR01MB6212

Marc Zyngier <maz@kernel.org> writes:

> On Fri, 25 Apr 2025 03:47:41 +0100,
> D Scott Phillips <scott@os.amperecomputing.com> wrote:
>> 
>> Updates to HCR_EL2 can rarely corrupt simultaneous translations for data
>> addresses initiated by load/store instructions. Only instruction
>> initiated translations are vulnerable, not translations from prefetches
>> for example. A DSB before the store to HCR_EL2 is sufficient to prevent older
>> instructions from hitting the window for corruption, and an ISB after
>> is sufficient to prevent younger instructions from hitting the window
>> for corruption.
>> 
>> Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
>> ---
>> v1: https://lore.kernel.org/kvmarm/20250415154711.1698544-2-scott@os.amperecomputing.com/
>> Changes since v1:
>>  - Add a write_sysreg_hcr() helper (Oliver)
>>  - Add more specific wording in the errata description (Oliver & Marc)
>> 
>>  arch/arm64/Kconfig                      | 17 +++++++++++++++++
>>  arch/arm64/include/asm/hardirq.h        |  4 ++--
>>  arch/arm64/include/asm/sysreg.h         | 10 ++++++++++
>>  arch/arm64/kernel/cpu_errata.c          | 14 ++++++++++++++
>>  arch/arm64/kvm/at.c                     |  8 ++++----
>>  arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
>>  arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  2 +-
>>  arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
>>  arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
>>  arch/arm64/kvm/hyp/vhe/tlb.c            |  4 ++--
>>  arch/arm64/tools/cpucaps                |  1 +
>>  11 files changed, 54 insertions(+), 12 deletions(-)
>> 
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index a182295e6f08b..3ae4e80e3002b 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -464,6 +464,23 @@ config AMPERE_ERRATUM_AC03_CPU_38
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
>> +	  Updates to HCR_EL2 can rarely corrupt simultaneous translations for
>> +	  data addresses initiated by load/store instructions. Only
>> +	  instruction initiated translations are vulnerable, not translations
>> +	  from prefetches for example. A DSB before the store to HCR_EL2 is
>> +	  sufficient to prevent older instructions from hitting the window
>> +	  for corruption, and an ISB after is sufficient to prevent younger
>> +	  instructions from hitting the window for corruption.
>> +
>> +	  If unsure, say Y.
>> +
>>  config ARM64_WORKAROUND_CLEAN_CACHE
>>  	bool
>>  
>> diff --git a/arch/arm64/include/asm/hardirq.h b/arch/arm64/include/asm/hardirq.h
>> index cbfa7b6f2e098..77d6b8c63d4e6 100644
>> --- a/arch/arm64/include/asm/hardirq.h
>> +++ b/arch/arm64/include/asm/hardirq.h
>> @@ -41,7 +41,7 @@ do {									\
>>  									\
>>  	___hcr = read_sysreg(hcr_el2);					\
>>  	if (!(___hcr & HCR_TGE)) {					\
>> -		write_sysreg(___hcr | HCR_TGE, hcr_el2);		\
>> +		write_sysreg_hcr(___hcr | HCR_TGE);			\
>>  		isb();							\
>>  	}								\
>>  	/*								\
>> @@ -82,7 +82,7 @@ do {									\
>>  	 */								\
>>  	barrier();							\
>>  	if (!___ctx->cnt && !(___hcr & HCR_TGE))			\
>> -		write_sysreg(___hcr, hcr_el2);				\
>> +		write_sysreg_hcr(___hcr);				\
>>  } while (0)
>>  
>>  static inline void ack_bad_irq(unsigned int irq)
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index 2639d3633073d..d41eeba7f8201 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -1185,6 +1185,16 @@
>>  		write_sysreg_s(__scs_new, sysreg);			\
>>  } while (0)
>>  
>> +#define write_sysreg_hcr(__val) do {					\
>> +	if(IS_ENABLED(CONFIG_AMPERE_ERRATUM_AC04_CPU_23) &&		\
>> +	   alternative_has_cap_unlikely(ARM64_WORKAROUND_AMPERE_AC04_CPU_23)) \
>> +		asm volatile("dsb nsh; msr hcr_el2, %x0; isb"		\
>> +			     : : "rZ" (__val));				\
>> +	else								\
>> +		asm volatile("msr hcr_el2, %x0"				\
>> +			     : : "rZ" (__val));				\
>> +} while (0)
>> +
>
> I'm worried that some of these accesses may occur before we compute
> the capabilities. I'd be more confident if the default was to have the
> workaround, and only to relax it once we know we're not on a broken
> system.

OK, will do

> But that leaves the question of the early stuff that runs before we
> get to C code. Are you sure this isn't affected by this issue (for
> example, the code in head.S, hyp-stub.S, and el2-setup.h)?

Ya, that's a good point. The corrupted translations can happen
speculatively, so there's every reason to think all those places also
need to be considered. I'll take a look everywhere now, not just at C.

>>  #define read_sysreg_par() ({						\
>>  	u64 par;							\
>>  	asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));	\
>> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
>> index b55f5f7057502..60f1b70fc0845 100644
>> --- a/arch/arm64/kernel/cpu_errata.c
>> +++ b/arch/arm64/kernel/cpu_errata.c
>> @@ -557,6 +557,13 @@ static const struct midr_range erratum_ac03_cpu_38_list[] = {
>>  };
>>  #endif
>>  
>> +#ifdef CONFIG_AMPERE_ERRATUM_AC04_CPU_23
>> +static const struct midr_range erratum_ac04_cpu_23_list[] = {
>> +	MIDR_ALL_VERSIONS(MIDR_AMPERE1A),
>> +	{},
>> +};
>> +#endif
>> +
>>  const struct arm64_cpu_capabilities arm64_errata[] = {
>>  #ifdef CONFIG_ARM64_WORKAROUND_CLEAN_CACHE
>>  	{
>> @@ -875,6 +882,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>>  		.capability = ARM64_WORKAROUND_AMPERE_AC03_CPU_38,
>>  		ERRATA_MIDR_RANGE_LIST(erratum_ac03_cpu_38_list),
>>  	},
>> +#endif
>> +#ifdef CONFIG_AMPERE_ERRATUM_AC04_CPU_23
>> +	{
>> +		.desc = "AmpereOne erratum AC04_CPU_23",
>> +		.capability = ARM64_WORKAROUND_AMPERE_AC04_CPU_23,
>> +		ERRATA_MIDR_RANGE_LIST(erratum_ac04_cpu_23_list),
>> +	},
>>  #endif
>
> This needs to be captured in Documentation/arch/arm64/silicon-errata.rst.

OK, will do, thanks Marc.
