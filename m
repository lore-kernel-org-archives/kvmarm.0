Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011054.outbound.protection.outlook.com [52.101.65.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB5C4477F3;
	Thu,  8 Oct 2026 13:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465545; cv=fail; b=XShdIFVYQOW4CJ0+e0f/Dl/RnwDXJ0NbX+da/qtLfY25eJTpiM92clatKZufTbo76efZCfaEVk6rVaqODuLGda2rdW59Fk9GgzWsvL91xhvMXr9X4CsGu0hPs72o5vIcVO/LNlEDOWRvgbq1hub9uawa9K9roZb0/S9a0PsvYis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465545; c=relaxed/simple;
	bh=mCHdKoS7tE59d8qb0GPau+QxikOtcsQ+uprCi1pIFiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FwhDOtn5uGe77818Hj/rf5cv+WXHmxFKqPS31wVoEBZhyIdoVLI5mx6bWywgd4n27Df/k8P80UvFuC4M+51JL8+hU2WMCUh6fEin8QTSE0YqGxqAdyzjjewQuTAssIUlj5rfC4LN85W6wYn8vegMwiWx182KoZ8uxAgwQYS6lso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=RFoDK36b; arc=fail smtp.client-ip=52.101.65.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="RFoDK36b"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iM0est+LNwdGJ3HvaGw3A1BTOlbONmuUgu1xHuhafK5Y2fy37w40YBs76JHkBpp42BWwS8iwMO7+eIKW7vhDQwxKMwnv3HyMoPHkgQeVimvN4kgAgyt5NIbirCOeuDVshh6JxUFL4GE8EJSMiVHzkTmk7pQRPb04s3j/sw6f4rrzo7Yv2eMOGwzGEayppFkzT66cK7X1y2/qDF947S44E1rM6dQ4Sp8blSEM3kG14QjhWMVO4mfZPPB7rqOAIVKqhZ61NKjPryL82BF1Ky0RUpFa4leS01yq7dg3Fr5l9x/+5aih8GmX3WmGcofD4Z/b8DI+9jVKQrWpl/gU1y3UqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/bFSrGAHxfe12cuM22n1Yde2HLJkpV8N+byWV3Faj3c=;
 b=HAWBAvYnd2NFedp3P0n8cnWmXF7UZf/ZfTagAgTCmU8KQ/IDSNmMFNEJc3K4Ux/5yiOM9qEsUacWTZIgywgobEVk+OuVCiYEBU7BtQubFFdWepQUTYwIjYfhEy+xkngH6d4Vf0orrISj0ZtYqi3Yd3bBjh9iJt7q9c+TcVovtxq9qNDC07ms46h0TqqkFHH10ue8Q2qbvX1x9rZjJGNFzdRPCNiitaqpmPyrLWsr+FzO9+8E/OheGIvIeHewbJmrbnwxD48Y3Sp6CIrbG3mfV+iDQOj7DhXRsWOypWg2Z/9FBz9pw/N63ydSyCeiWY4Lc6u/Gnm6ZB9sv4AyyHHI+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bFSrGAHxfe12cuM22n1Yde2HLJkpV8N+byWV3Faj3c=;
 b=RFoDK36bDfnk8wJxP+NIJjXjpO0KjNw2nGdTIlT3kJfnV3jND7003B3htNBymZ2RGTsmwKAM9I9BWXybvZA/t4y1fWnkaV0mUeNwOpdRvvSE7fH6rnHtK/YYvlCKjLzbu+xbflBgzLBCmbD8IKb4XgU6DDOft7B8dQnZeAiBPLlsgMkl+RItXEXsXywchFKvOPNIXhCvg77EtfpcHtHzbhfauhX29qgr5YxG0T1RfUYyzBolJUy9srdq0kEyp9i1fai2pWLF7fHvvduxRkh6WdY6+og8dyZrBvwGYLYppDKULeNBavGrvfQ/5H9J8tDhkyZdCX6ECsqcslu7dUZQlQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by GV4PR04MB11824.eurprd04.prod.outlook.com (2603:10a6:150:2d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Thu, 8 Oct
 2026 13:18:59 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0496.010; Thu, 8 Oct 2026
 13:18:59 +0000
Date: Thu, 8 Oct 2026 21:23:31 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	Francesco Dolcini <francesco@dolcini.it>,
	Frank Li <frank.li@nxp.com>, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, imx@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH v4] arm64: errata: Add NXP iMX8QM workaround for A53
 cache coherency issue
Message-ID: <aseZUwi0CYTXuE/I@shlinux89>
References: <20260824-imx8qm-cache-coherency-v4-v4-1-b2e528c7d05e@nxp.com>
 <asTZEhzMDs869r_n@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asTZEhzMDs869r_n@arm.com>
X-ClientProxiedBy: SI2PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:196::19) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|GV4PR04MB11824:EE_
X-MS-Office365-Filtering-Correlation-Id: 39a11896-4f77-4994-b7e8-08df253eb692
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|19092799006|1800799024|23010399003|366016|6133799003|18002099003|22082099003|10067099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	/gSbd0tZMqogKPPyXT0ypr5L8vKmWD2O1iNLcCCBtS3m64+7Iwq8hhWnIglV0/zc9kJOfOqZLgbNB8Qs+EJRN1GbiCYeA8jmEjp0v0hDUy1LB4FERMdyUKerPSIgVL+CuoqYwvx5Kmab0tKs/lEQaSbzvKBATksk18HyX8ExnSvZnaqWiK5G0tAf9RzzJTsn4qVDaGB/akv5KoP+b7AKaKOXcIVkVP4cmxIjdiIonW+06KZYfTOqSYkmSU0RM1+qBQgppaGjP0UIJXyWyCY9hWTS1impayjUkTQ32isTtn7G7hjp5d/6mpa88GFPcXMyroQ5GJMrbcv33v87ikEUYloeb65A8p/3O89OSmb9hktAs20D6Yuqj2Q3Jh4pQZa75yso57IF+XiWksD+Bu0dX27JS4gvmpWy9FlXbACBCX8pcyUhqlzSjoyQDFk5697OlkwMa0hYddbr/PZ4DQHpKgHSO/BPyQ3179iMTR6GZmCIeUGB7nKVgg8pbzXvQpbIve94noA2uaKKI8YiBfqs/SXT5NMd7KLBZ6cJiL+zbfmawS6shySACfOQn6CYcLJK/t8KSEksqe1JetjcWx6k3Lk80jTvBuN1Pmq79uGnV+CYBBQnD+1jzB01UcSJ7w4+qs8OtyfyxENR8ukGNPxxnNG617bOiuTsF+Xr6bvm7wY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(19092799006)(1800799024)(23010399003)(366016)(6133799003)(18002099003)(22082099003)(10067099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eigUFtqqOcsVqtu9WPg8befdj3Hu1nYHMZBIbB2dtNZcsizfZUw9ZayKfAml?=
 =?us-ascii?Q?zE2pzuRI0WUp70+xjuntOn6wXxvXzLZbqMYJyk0yDnHzKItP9ssNUnSbaMjf?=
 =?us-ascii?Q?v4GpVScji0HxZjWdzq2uRSdO17dhavbl4QELopgAD4d9m5oVCAYQHVoe91aG?=
 =?us-ascii?Q?QukbpiGXQXE4VgCH7OVexv6JPKQsis512FjypCCGUHJHyBtbMaAE9c8V2iZg?=
 =?us-ascii?Q?HAktACMmDX+yoP8y/E9yAbtlZ3y7tBJoifiuWvLA1+RlTzA9qoyQiCqglnGT?=
 =?us-ascii?Q?KN0lYkdSRIpv92NRFArnvcpFJwk0PrhUbCfkop5h5WXYs3z+u5wgTHte8bB9?=
 =?us-ascii?Q?710tTBHQNd66hCniq/1mI25mdI88f/kYslSf53ekPd1I6TgohtzCfe9hzKJJ?=
 =?us-ascii?Q?4x4n2rJEz0fG1gTeIqa0wuTnyD566nA5ss/Fbh+GXcJHF3lIqi3Tn64e35S4?=
 =?us-ascii?Q?zenMRoP30XE4xgpwRLpytOBzIxlL4fTT4Gocxs1jVQLqSqyixiBt3TNFhIw/?=
 =?us-ascii?Q?6LoCCO9zT8+1NwwHfoq6oBBclThp8d6MpkPZFcIWL4yplhlDCsWM9CazDM6B?=
 =?us-ascii?Q?pa+DPYkj2GOm8h/xOEwSC9vXXPQUP2P90IdYPreUfITUs1l92GvakTwRCwK3?=
 =?us-ascii?Q?jQ7hNkJ6mfeLPqYqK4ybvliI+tITGRMl0UXlecIb9+GxrmUKF/zHdeiMSrCq?=
 =?us-ascii?Q?S+AQEGBQpU16L/DG6WHi7D65i+BE8qxyulGIElzmt8n6P0csh5GK2tcYNrZB?=
 =?us-ascii?Q?vzRNOYkymW6lohOD93U8J9lNbrJHVDq/OrkIjJxAduDApQd8ldJRkErMWF+w?=
 =?us-ascii?Q?HEoIi1ppVF3Y/mYTId4xOMnYg6uRGLrY5X5g9Bo9Mu3uJQFsAYV8kwJ3N/+m?=
 =?us-ascii?Q?x+I0iVqfAuIXeHRyV+zgOtiocUxW91h1uYAuxQZ4w+OFSdZDDU78NOZ7VJo7?=
 =?us-ascii?Q?dlYOx5V+3E8bXtt2uKtyLJlN+T6jQVaCoiRoAtQXaU6wusvKur/FgWH8rA5J?=
 =?us-ascii?Q?ksRh8ORnswGkJZfkYhCsN0tJEp89j3SKeqHL5c0ZdrHy8sRewrxvEZlcRkMR?=
 =?us-ascii?Q?FWToO+U5/36U5ZOw3stP9hgjNzlyqCvm7m/2PoIIn0HOGfn7O7fF9lrs0Y9h?=
 =?us-ascii?Q?1c5yE7N8oHRo/Xo9r9X5eGsrpb7+Ug7kO7OVayqzXzKktlQpnmZfj9Xc5Juq?=
 =?us-ascii?Q?Ds3+WiUi39xB9yErges8XtSXYo4Eyl/pPUK5Vxo2JlVlmI0Ztqy/JKQWJoUP?=
 =?us-ascii?Q?/FM1x1eo4aqsgWyXjj4ZMLv+qNbh6cLnjri8qK1Gu+jjbw1niBLhWxxJfj8Y?=
 =?us-ascii?Q?NFnTWFx16i36Aai6L8VtmySCE7SauMgfNoqhUEbYyGBxZH0/DuA95Kv+4fm9?=
 =?us-ascii?Q?RvuozkQlL+2Rq+futr95u4y8YVUxmOs1aYIiONrksnk6S03ExQoxElTD6JFA?=
 =?us-ascii?Q?np9RNWMuRqcrqh2zfxea+6LoEBicJTNaYjrOxgYI135pFUDe6F99bKBQ8DdC?=
 =?us-ascii?Q?Q/8vg9q4+U4eNMd0sjtqJ246vNgrU2fpu+tsOJRIBBwaCDQRmThpsefNCKfy?=
 =?us-ascii?Q?v+US/CbmyNU0qely0FJZwbfp9ERNPY2phduM3P9QfskO4WQ9hFCzRxpoTB+7?=
 =?us-ascii?Q?Gj+auun5phGEcYKSTajHUwzmpStxoxeD/Z1SvvGr7DQiDzkeJYZ9E1sbv73g?=
 =?us-ascii?Q?So45OQPGyMjp64OFzHea+1EwsC2u+IsnJB6U/53LvSZtScJGPOFBw4VUDJqC?=
 =?us-ascii?Q?+iK97tSKaulOjL5OAtNhtYYXgq05Ufd3zmqsGo8RxLdAf4vGmb48?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a11896-4f77-4994-b7e8-08df253eb692
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:18:59.3757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cc1v4wwmqhulu5NE2zc3gkZZolsxlZWKkKKF3q746+x3LiFi4rPF/fUBwe7N2MbJonaOcs3VMTihM6OGi3F+BxGQ76dBDtjQbao2SudZT/jjOGSJfp6tyGsvwAhPibtW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR04MB11824

Hi Catalin,

On Tue, Oct 06, 2026 at 12:18:42PM +0100, Catalin Marinas wrote:
>Hi Peng,
>
>On Mon, Aug 24, 2026 at 12:02:04PM +0800, Peng Fan (OSS) wrote:
>> From: Peng Fan <peng.fan@nxp.com>
>> 
>> According to NXP errata document IMX8_1N94W[1], the i.MX8QuadMax SoC
>> suffers from a cache coherency issue (ERR050104). The upper bits, above
>> bit 35, of the ARADDR and ACADDR buses within the Arm A53 subsystem
>> have been incorrectly connected. This causes some TLBI and IC
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
>>     for guests.
>
>Do you need virtualisation on such platform? An alternative would be for

We not have KVM support in our software release for i.MX8QM.

>the guests to be aware of the erratum as well and use the right TLBI/IC
>ops. But you'd also need to upgrade the VMID-aware ops in KVM (unless
>the hardware can't work around stage 2 TLBI at all).

We not have test cases for this since KVM is not in our release scope. 
Could we take this as a future enablement to avoid uneccessary churn

>
>>   - No need to touch SMMU Broadcast TLB Maintenance (BTM) since i.MX8QM
>>     does not support broadcast TLB.
>> 
>> SoC detection uses devicetree compatible string "fsl,imx8qm" or
>> "fsl,imx8qp" since the boot CPU MIDR_EL1 (0x410fd034) and AIDR_EL1 (0)
>> are not unique to this SoC.
>
>That's fine but I wonder whether your hardware implements the SoC ID
>SMCCC. That would come in handy if some future revision fixes the bug.
>The DT string doesn't tell you version/revision.

Sadly no, we not have ARM SMCCC to get SoC ID, we only have vendor SIP
for i.MX9 to get soc information.

>
>> @@ -580,23 +584,28 @@ static __always_inline void __do_flush_tlb_range(struct vm_area_struct *vma,
>>  
>>  	asid = ASID(mm);
>>  
>>  }
[...]
>>  
>> +#ifdef CONFIG_NXP_IMX8QM_ERRATUM_ERR050104
>> +static bool
>> +is_imx8qm_soc(const struct arm64_cpu_capabilities *entry, int scope)
>> +{
>> +	WARN_ON(preemptible());
>
>Not needed for a DT lookup.

Will fix in V5.

>
>> +
>> +	return of_machine_is_compatible("fsl,imx8qm") ||
>> +		of_machine_is_compatible("fsl,imx8qp");
>> +}
>> +
>> +static void
>> +cpu_enable_imx8qm_err050104(const struct arm64_cpu_capabilities *__unused)
>> +{
>> +	cpu_enable_cache_maint_trap(__unused);
>> +
>> +	/*
>> +	 * TLB maintenance cannot be guaranteed correct for guests, so
>> +	 * disable KVM as if kvm-arm.mode=none was passed on the command line.
>> +	 */
>> +	kvm_force_disabled();
>> +}
>> +#endif
>> +
>>  #define CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)	\
>>  	.matches = is_affected_midr_range,			\
>>  	.midr_range = MIDR_RANGE(model, v_min, r_min, v_max, r_max)
>> @@ -1030,6 +1055,15 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>>  		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
>>  		.matches = has_broken_gic_v3_seis,
>>  	},
>> +#ifdef CONFIG_NXP_IMX8QM_ERRATUM_ERR050104
>> +	{
>> +		.desc = "NXP erratum ERR050104",
>> +		.capability = ARM64_WORKAROUND_NXP_ERR050104,
>> +		.type = ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE,
>> +		.matches = is_imx8qm_soc,
>> +		.cpu_enable = cpu_enable_imx8qm_err050104,
>> +	},
>> +#endif
>
>There's a precedent with 4311569 to wire up a SoC erratum into the CPU
>errata framework. That one is a system wide feature, so only probed once
>for the CPUs coming up at boot (though still probed for each late CPUs).
>For iMX, you need this turned on early, hence the boot probing. But
>calling it a strict boot CPU feature is a bit of a stretch. It also gets
>probed on every CPU, unnecessarily.
>
>I think we could do with something like below (maybe as a preparatory
>patch). We could also add it to 4311569 even if it changes its scope
>from system to boot CPU (the early param is available).
>
>Only compile-tested and haven't tried wiring up your workaround:

With type set to ARM64_CPUCAP_SOC_ERRATUM for i.MX8QM and your patch
applied, I not see issues in my test.

Would you post it as a formal patch or need me to include your patch
with i.MX8QM errata patch in a patchset?

Thanks
Peng.

>
>-------------------8<-----------------------
>diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>index 4f04ad82ea34..669f808e379e 100644
>--- a/arch/arm64/include/asm/cpufeature.h
>+++ b/arch/arm64/include/asm/cpufeature.h
>@@ -266,6 +266,13 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
> #define SCOPE_BOOT_CPU				ARM64_CPUCAP_SCOPE_BOOT_CPU
> #define SCOPE_ALL				ARM64_CPUCAP_SCOPE_MASK
> 
>+/*
>+ * matches() is called only once, when the capability is detected, and the
>+ * result applies to all CPUs. Secondary and late CPUs are not checked for
>+ * conflicts but cpu_enable() is still called on each of them. It has no
>+ * effect on SCOPE_LOCAL_CPU capabilities.
>+ */
>+#define ARM64_CPUCAP_PROBE_ONCE			((u16)BIT(3))
> /*
>  * Is it permitted for a late CPU to have this capability when system
>  * hasn't already enabled it ?
>@@ -293,6 +300,13 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
>  */
> #define ARM64_CPUCAP_LOCAL_CPU_ERRATUM		\
> 	(ARM64_CPUCAP_SCOPE_LOCAL_CPU | ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU)
>+/*
>+ * SoC (not CPU) errata workarounds. The erratum is probed once on the boot
>+ * CPU, before the secondary CPUs are brought up, and no secondary or late CPU
>+ * can conflict with it.
>+ */
>+#define ARM64_CPUCAP_SOC_ERRATUM			\
>+	(ARM64_CPUCAP_SCOPE_BOOT_CPU | ARM64_CPUCAP_PROBE_ONCE)
> /*
>  * CPU feature detected at boot time based on system-wide value of a
>  * feature. It is safe for a late CPU to have this feature even though
>@@ -414,6 +428,12 @@ static inline bool cpucap_match_all_early_cpus(const struct arm64_cpu_capabiliti
> 	return cap->type & ARM64_CPUCAP_MATCH_ALL_EARLY_CPUS;
> }
> 
>+static inline bool cpucap_probe_once(const struct arm64_cpu_capabilities *cap)
>+{
>+	return (cap->type & ARM64_CPUCAP_PROBE_ONCE) &&
>+	       !(cap->type & ARM64_CPUCAP_SCOPE_LOCAL_CPU);
>+}
>+
> /*
>  * Generic helper for handling capabilities with multiple (match,enable) pairs
>  * of call backs, sharing the same capability bit.
>diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
>index e0c09402540c..a418e240ccce 100644
>--- a/arch/arm64/kernel/cpu_errata.c
>+++ b/arch/arm64/kernel/cpu_errata.c
>@@ -986,7 +986,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
> #ifdef CONFIG_ARM64_ERRATUM_4311569
> 	{
> 		.capability = ARM64_WORKAROUND_4311569,
>-		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
>+		.type = ARM64_CPUCAP_SOC_ERRATUM,
> 		.matches = need_arm_si_l1_workaround_4311569,
> 	},
> #endif
>diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>index 84053f0a8e01..0e4c3de78c1d 100644
>--- a/arch/arm64/kernel/cpufeature.c
>+++ b/arch/arm64/kernel/cpufeature.c
>@@ -3695,8 +3695,11 @@ static void verify_local_cpu_caps(u16 scope_mask)
> 		if (!caps || !(caps->type & scope_mask))
> 			continue;
> 
>-		cpu_has_cap = caps->matches(caps, SCOPE_LOCAL_CPU);
> 		system_has_cap = cpus_have_cap(caps->capability);
>+		if (cpucap_probe_once(caps))
>+			cpu_has_cap = system_has_cap;
>+		else
>+			cpu_has_cap = caps->matches(caps, SCOPE_LOCAL_CPU);
> 
> 		if (system_has_cap) {
> 			/*
>
>
