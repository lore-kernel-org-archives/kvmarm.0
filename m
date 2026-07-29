Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011013.outbound.protection.outlook.com [52.101.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A7E477998;
	Wed, 29 Jul 2026 12:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329304; cv=fail; b=XyXZ3j/yhBusw2pa3wgRZkfKGOI7aQvrfo9X9zeWuLwczrUMnhuvrf486w6JzOjNmI3PI5ruZTictrGYG2N21qvtAxECw3/PgdoVmbplCqwylFY1P7bkpeYSdpyWQ+Vg6RuFfGzdUJ4R5Hw70bKZCin6uIGmTburSASrO7DTRH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329304; c=relaxed/simple;
	bh=Hq78gP1hI23IunTxdf2Qi/KaOWRJ66GzT4KRvqxYm5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=f2amN+eyEknDafg5cpF/nVjDCKcQl6K/MNQyTbcy+2YobP+u+ed9qMA6cIT2i/K/mMWK2MIi94aBYJv6iaogNQb9f8AJbOW/ULNQjtUYZBJQxJ43vyJctV2zo+9+5IEdNsWukGr6yI2NePaKIQ0aZfTMhK1+1oj28/Vcrr0zSZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=rSZBU55x; arc=fail smtp.client-ip=52.101.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="rSZBU55x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LGN+1CRss2RT5g6wDwZnAzGOXqWh59xGpK6xXwDCg8Byrl/iYjvy71zsJXcouaSdPUwTCKHO9IuMeIve2Kq8uKVfdaOW+h5RAu3Zc5hPnvdZShs+sZchRBwR1L8ftDVDKii5IhEicyjCE040HBgCBxv+TXLRrD35i4z+nJlFP3MBbTaAZCV6Pd3D9rySSartB4KwAkHEv+H34QOoBKT/Elx8ewESnPj7b0G0lcyx4p+eNm4N60uQ4msv71sIxrJP4YY5DzvEjCS5XzF8WT1H8re6yZG9TeZgFJy6sb6VYQPoDjCPCYGeQERHQ2MkBnuEsMOSaKICt5PJ24uNNe1cXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wY2z2naCN/wW7JTS6rmtxDUEVDrtu2VWnySFhQoTtls=;
 b=uvDvEcObhxEWKNcaLI1u34P9BbofVEZjslim30FU2Rj2w8bub0dCnRbwoLltjVW5B0YZi+zr74d7qYA54baxFxvm4mCddi9Sn3EfgXO7XwkTHs/BfQyOu1oipA9D1+471LlgOo5cNhEhEXuvPZh5zUMY1ZTgsb4/2Jc0DnN0r9WURG44sRC8duDpqVJbc4/EbZhH4YNi3h0Go1As786Y8WS8ZRHLDN/zuQ1lLAsO6KRshOiwIFktBgcB41HUblkZQXJrzNA7Pw+d1ve6u4A+BGDD9wJ8ZEZ5v3TKSNbSMS/0TVrJnWRYZEwyzDFgGRFb5wCV6A68GdsGZzR8m9TKRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wY2z2naCN/wW7JTS6rmtxDUEVDrtu2VWnySFhQoTtls=;
 b=rSZBU55x4osTsO2PFmcEijcONhwQjNljRSkBnazGPt6tm+29nbI6eDFDuAbAdlu/+Ph/S6NG/cGQ7441tGWS0Vx07kU7/cXa/WNKHY5KEE5dhEVqqNGMh/COGgxrNbo5RLIWYzEzl0hXuMZM9mIxG81RAaYZ8taCQl/pxg1YUhzBO8fEA35sjBendFuEIepzW9NYPOUQDEmUcOYlusgKbd+g95l5UBwuvI55dpCq4i9rfwxezmNdub2m6k19n5CsvzTxUbUsmJ1mXxhljP8IO2YbjAz4m//QGQ21qolZyFdi9uIo6yd50nVmwWU9437mCNyIxYtG6n4gk23Qe3utPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by MI9PR04MB170442.eurprd04.prod.outlook.com (2603:10a6:290:c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.13; Wed, 29 Jul
 2026 12:48:20 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0245.010; Wed, 29 Jul 2026
 12:48:19 +0000
Date: Wed, 29 Jul 2026 20:52:04 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	Francesco Dolcini <francesco@dolcini.it>,
	Frank Li <frank.li@nxp.com>, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, imx@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH] arm64: errata: Add NXP iMX8QM workaround for A53 cache
 coherency issue
Message-ID: <amn3dMLIuxYFFtoN@shlinux89>
References: <20260729-imx8qm-cache-coherency-v1-1-c9864e280437@nxp.com>
 <amnNAJC4yHVsZaN8@J2N7QTR9R3.cambridge.arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amnNAJC4yHVsZaN8@J2N7QTR9R3.cambridge.arm.com>
X-ClientProxiedBy: SI2P153CA0001.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::7)
 To AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|MI9PR04MB170442:EE_
X-MS-Office365-Filtering-Correlation-Id: dd24c3e2-3ded-4f53-1a04-08deed6faad9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|19092799006|23010399003|6133799003|22082099003|18002099003|3023799007|4143699003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	RZp5jO17YugGs1jk6N8GYy/E6s8cDvsI1jGiEoE1rEdx5NxAwihMA6EqLK3aqxsh3UKhqG9Xwc5LpvZUjjHHk0H7McBDWxxx1gA60JT+CwHALSfyftnUZUoGk6fpIk8gowYeklyIuEceT4xCcONQpINkK5a2w6JrYRSvOoR0rPyqHID6IBJrU4m97km/bhFb1xglIVinZVJT9svhMynTfxsDQ0i4TXfYIvwe1upyb8fMrXwI26IWydQ8BeNnoLSlDzRZj3CYw3nqzq4HshCkpx/QZRLYwSdXZjyIcvMmcAZCu3laJ1W87c40zT87Xzn1ys9wRipAvT/chdYQHnzN0FLc+AtKlQoME4oXO4MF1pxUpGJpr5kEOOXgv9WkPtWp3N0xN4rhEzF76YEdY/QhhMcM3i9ynju0Jevr3cHjtBBHB9/qtncsNyu2Ls66Dk3dtTfzqXT6cRgxqVs1m1P2JDbWzpQ+wSTPAEyjCw1xF9IZanizST3EI2tKKYK4lLtX4QYv9ESKcIZaPe6UDx8PFBsDE3dU2vSrBk3o+4lXcJQGLhaw/DZataE2pYp4e60j6DTr5JflhF6BdxijAVkW+SwEnrCxK2fH9gRX5S+a0ZEq59mPm/GZgPFAW1xXRzi2k/Sys/cfYxg8KzIO8Ehx9ZMa5cQEHrorB+mDwbp/1bs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(19092799006)(23010399003)(6133799003)(22082099003)(18002099003)(3023799007)(4143699003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xQEUPgVt9QrS0Fp1ag9oRvFQkxzw3XItC6JCtlblM+5LwcJzPGBlUdzMyRaq?=
 =?us-ascii?Q?RvbbnNBQMgT1ajz01XhspIOXTzsi//5s7pS1GCyz29gMRH75TMeL5OtCpLy4?=
 =?us-ascii?Q?0JYo47C8c80CQo2y32G4a5htKKSEwzztTI8yJO2NCPQFgmv8Q4MO8Rsvjh7C?=
 =?us-ascii?Q?BRdDMqFN6z5KIhg+06PsTr2u0r97fP4jn0LbQZVS5SFtFLPaoPpaw+dSDQHk?=
 =?us-ascii?Q?csCpedm2vU/JGwywhpS+REeFwYIbF4RLqBKnbusKVmdTTXo9AK/RuMOzLUaK?=
 =?us-ascii?Q?5N0HY7rjAC5iV1Bohat67ABVw+jHCrNwD9rENi9S8ilMVICtzCjHpglFaNX4?=
 =?us-ascii?Q?ersvtQndAgFMSMs9v3tkOeETUYVIvh/R+lGyDhMNhXuYk3Q+hN+kv0p4bnlf?=
 =?us-ascii?Q?AXy7RZGCc9Nwq3alJzlUbxgr4rI0xCOo61JZRfgdlk8DsoEoea7n2gto+uah?=
 =?us-ascii?Q?VnXtu6bicDRV8zB8fvxpILD0LIWBLX+8UXQTzodxNk3xFEbL4CSdqAxzcAB4?=
 =?us-ascii?Q?h75Y5MVgm4HFnBoI7KW8TcOBTs+KCQrmowz1UvXZE05nX3G7XVZw50Qcf762?=
 =?us-ascii?Q?JeVEnV2aEauCQA7AzgA705N6/OvaeOrZletFGGamr9Y9ELkMz82dTEde/YtE?=
 =?us-ascii?Q?TIwkcBi28arR7hhaoabCsgIvJb4gvq9s/dqQaZogwxI6pigxEPJN7/t22O2J?=
 =?us-ascii?Q?c+L6ojj33HNsZkuvJdwZiwr1J3MJCaIvHrAA2sX2dxB8zNkoVhuz3Bsf//G3?=
 =?us-ascii?Q?v7Ptd4N+YQw6dkPQUJwQXALO9iEXLHVGszG2O8IlM+ceTquc88T+QYTYAx8g?=
 =?us-ascii?Q?FaoaPzZD53n4OeVymF4NZqBNNPno8vc1OHoQa6pSZeVHxQApowUkZyfV22uw?=
 =?us-ascii?Q?roxGLOVMPXDSVjBvwNM00JSA53VRcCT1BGL0DPH3Q1laDJeDBZBS+9nECDc9?=
 =?us-ascii?Q?QOZ5gXV/ixybYCwFmkHz8GifMD+GYFjMkx7+g6gE2eyaWTNE7SBkptkSbNZA?=
 =?us-ascii?Q?9XSjVqdH5/qybvjIiIimtWIDqtVgq0kkDzJioLpP0l8GXPwPA7AoSzTZC7cv?=
 =?us-ascii?Q?HEPc71v/8YQWDU3H9an6KK4v9Si6r11rg2FtDVUxfJ6DHOM2FWPm3Q0x+4wQ?=
 =?us-ascii?Q?g2lnF6aNNoXavpelu1QnStU5LcuMMNDGO9Pxn55jHEwN4EZ8zeKomsM+NvFv?=
 =?us-ascii?Q?RLe9GHkFnHtKSWyh2DRYBUB3XImHEMDMbi8yxFKuELOcqyhUGOLgPM5F/YZT?=
 =?us-ascii?Q?KiSyZiizQflGPFsUp3+MlKnIYa4BW87FYTz6bz5Y8LuMgTtnQjIbTwmy9q3W?=
 =?us-ascii?Q?f5c6kzL1735rVUm2Wrw+5qnRDJxkHsDMlOJkByCe2Fw6WF8oAtkbSAQqH73j?=
 =?us-ascii?Q?2RruDA9A5cFfkGH7m5LRxE4G1NHy32KRjqWymPTAEThdpzZJak7/BlHCC/ng?=
 =?us-ascii?Q?VuVBT0w9kLny8MF3+zC7CbQziSk2AAFi2aD4hPWaJRg4rfXwHP1VIUhPDhya?=
 =?us-ascii?Q?WjGwZVzQeZXpXOcKHVRyMMYS0x5cpdCHs9ErYjeKNukZ8+ATglpMwWBM/db0?=
 =?us-ascii?Q?HA2zob3sd1mfPogMcjaePd8w9HiiBXeS2siGLvuzlgrpwSysGqnK01yWG/ar?=
 =?us-ascii?Q?vmMOjKu2kj8Rr0hAtPvVl3JLivcHl+2F3QjqUeqpARp4hRa4h3QKAYwH74V2?=
 =?us-ascii?Q?iu6DN2N6ikXaCuiP3wZ25FJ6p5kIPpq30uHe4eEMpQ24mLipsdpc6VddrKeN?=
 =?us-ascii?Q?LPkYBhVF0VjEYxxvX48wE2ReYF7l4E0GboF3AR59onsjUkjej9N4?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd24c3e2-3ded-4f53-1a04-08deed6faad9
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 12:48:19.8089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: raWWHo0GO5IRqzJui768DZdoXeUz0QWmiYc1H5jllI4EwluaeklpffxQgV1fUMIM8nM+GV9IFlIO958zDNHnUH7efLMa2P3O3kwB0ui52nlorTmnmLKBq3b54qY4p1+y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MI9PR04MB170442

Hi Mark,

Thanks for your reviewing.

On Wed, Jul 29, 2026 at 10:50:56AM +0100, Mark Rutland wrote:
>On Wed, Jul 29, 2026 at 11:28:52AM +0800, Peng Fan (OSS) wrote:
>> From: Peng Fan <peng.fan@nxp.com>
>> 
>> According to NXP errata document IMX8_1N94W[1], the i.MX8QuadMax SoC
>> suffers from a serious cache coherency issue (ERR050104). The upper
>> bits, above bit 35, of the ARADDR and ACADDR buses within the Arm A53
>> subsystem have been incorrectly connected. This causes some TLBI and IC
>> maintenance operations exchanged between the A53 and A72 core clusters
>> to be corrupted.
>> 
>> The workaround requires:
>> 
>>   - Downgrading targeted TLBI operations to broadcast-all variants.
>>     Instead of patching the low-level __TLBI_1 macro (which interferes
>>     with the REPEAT_TLBI workaround and causes excessive over-
>>     invalidation), redirect high-level TLB flush functions
>>     (flush_tlb_mm, __do_flush_tlb_range, flush_tlb_kernel_range,
>>     __flush_tlb_kernel_pgtable) to use VMALLE1IS via static key checks.
>> 
>>   - Upgrading IC IVAU to IC IALLUIS for both kernel (via ALTERNATIVE in
>>     invalidate_icache_by_line) and EL0 userspace (via trap-and-upgrade
>>     in user_cache_maint_handler with SCTLR_EL1.UCI=0).
>> 
>>   - Disabling KVM since correct TLB maintenance cannot be guaranteed
>>     for guests without the proper devicetree.
>> 
>>   - No need to touch SMMU Broadcast TLB Maintenance (BTM) since i.MX8QM
>>     does not support broadcast TLB.
>> 
>> SoC detection uses devicetree compatible string "fsl,imx8qm" since the
>> boot CPU MIDR_EL1 (0x410fd034) and AIDR_EL1 (0) are not unique to this
>> SoC.
>> 
>> [1] https://www.nxp.com/docs/en/errata/IMX8_1N94W.pdf
>
>[...]
>
>> +	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_NXP_ERR050104)) {
>> +		__tlbi(vmalle1is);
>> +	} else {
>> +		switch (flags & (TLBF_NOWALKCACHE | TLBF_NOBROADCAST)) {
>> +		case TLBF_NONE:
>> +			__flush_s1_tlb_range_op(vae1is, start, pages, stride,
>> +						asid, tlb_level);
>> +			break;
>> +		case TLBF_NOWALKCACHE:
>> +			__flush_s1_tlb_range_op(vale1is, start, pages, stride,
>> +						asid, tlb_level);
>> +			break;
>> +		case TLBF_NOBROADCAST:
>> +			/* Combination unused */
>> +			BUG();
>> +			break;
>> +		case TLBF_NOWALKCACHE | TLBF_NOBROADCAST:
>> +			__flush_s1_tlb_range_op(vale1, start, pages, stride,
>> +						asid, tlb_level);
>> +			break;
>> +		}
>>  	}
>
>Are you sure the workaround needs to be applied for the TLBF_NOBROADCAST
>cases? The NXP document lists non-broadcast TLBI instructions, but I
>strongly suspect that's in error, as those shouldn't result in
>transactions over the core's external interfaces.

I think you are right, TLBF_NOBROADCAST should not be applied with the
workaround.

I will use below if this looks good to you.

 if (alternative_has_cap_unlikely(ARM64_WORKAROUND_NXP_ERR050104) &&
     !(flags & TLBF_NOBROADCAST)) {
         __tlbi(vmalle1is);
 } else {
 ...
 }

>
>[...]
>
>> @@ -585,6 +585,12 @@ static void user_cache_maint_handler(unsigned long esr, struct pt_regs *regs)
>>  		__user_cache_maint("dc civac", address, ret);
>>  		break;
>>  	case ESR_ELx_SYS64_ISS_CRM_IC_IVAU:	/* IC IVAU */
>> +		if (cpus_have_final_cap(ARM64_WORKAROUND_NXP_ERR050104)) {
>> +			/* ERR050104: upgrade IC IVAU to IC IALLUIS */
>> +			asm volatile("ic ialluis");
>> +			ret = 0;
>> +			break;
>> +		}
>>  		__user_cache_maint("ic ivau", address, ret);
>>  		break;
>
>This doesn't address my feedback on v1:
>
>  https://lore.kernel.org/all/ZIHisLL9FXlbuMLJ@FVFF77S0Q05N/

Sorry for missing this one.

>
>... which I see Sashiko has also spotted.
>
>Please make this:
>
>	 case ESR_ELx_SYS64_ISS_CRM_IC_IVAU:     /* IC IVAU */
>	 	__user_cache_maint("ic ivau", address, ret)
>		if (cpus_have_final_cap(ARM64_WORKAROUND_NXP_ERR050104) && !ret)
>			asm volatile("ic ialluis");
>		break;
>
>If there's a reason that doesn't work, please explain that reason.

It should be ok.  I will take your suggestion in next version.

Thanks,
Peng

>
>Mark.
>
>
