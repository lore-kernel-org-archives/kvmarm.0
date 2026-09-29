Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010065.outbound.protection.outlook.com [52.101.56.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBCF3B774F;
	Tue, 29 Sep 2026 22:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790720267; cv=fail; b=ibkWjfX/67WldWIv+/wTzst12Ej6yE9bHkK/YSGTkusJIJDlP4SGp5GfKM46Ch0fVMWMZ5pb229Jse9ghD9i4BWu3TTO2sW5jcjRiClvMiKiYy2GPL4ROQh1s9mbTjdkyfsQcaohvOD3/xV5M1TOtA3jkcmhb+COP+OofKdPTJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790720267; c=relaxed/simple;
	bh=AuK5ziPkSppU4vSU0B1+Am8kWWJE0JMIsm5NRzdCCxQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QrCxI2PoyiXaa7XNiiEJ79+HO+NUhNGCE6UJWBSo3hWHDHGN8JrMMnr2h2dmtuOeXVB0pSFl+t8K79fqK04wAKA+5RRHCd2snH6o2lEW7Idu5Op03smkdgDvhlHNbDKEdCIzDbf1KHd4EYS5vrS0TQXk2nSsgBmb0h8CDwoJmuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tqlXYQhu; arc=fail smtp.client-ip=52.101.56.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tqlXYQhu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X2Nthezu7l3jzJVkzdS18FGEo2YYT0BgFgUkRfhlVcEqVnHbH2RtMMKuWAlyRbWjjJqJmbb2gEXCa3xHsKKjl7bjgEUhnLrSa7u0xeFBTW5zRHgG1o8k068BLoD++AcJfb3dZoSPlWZdz7GYUZowC2/BnTJisdKh0CbCJOaUlBfJC+iyFlpZO2wgOqxUET2g9mRlw1Fk5cA1hKKuH2Es7vfN01ZOHA+3EQsRXBD02T82B9p6pqxiHTXcUkrlOOcv/3Jq58f8elSPLD0dOA75ATU1gK7hwwnwS5IcBeFqpq6vmi64xWjIrfSapu7ifeV4e0HOVi62xyq0ma8oXC4HVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PwwBHiQWow3vHf1iCpN5N5H3Hq1/yfhZCAwxjwZ5/lE=;
 b=H2SD8Bh5Szo7mALNFNHE44poKlSgZnQR3fYbzRKh2f0thdpqjdn7pzZVv65EuP0z6EX2MWfQAfEGcJI5pKBxPTnO1PznnGWmlzAuyBWGTmpnT0TYWvPoA2MFh04O8IRg5At5fIvCyCxQ4ObDNwTGN5fpcJDeCyzzS3UPPwq080EVAC622G9GU/924IAYr3nwG48imTtg+Kgk4QD+USZGgqk8ofk3KsXKNHijEai+LF1FV48TbRm0JtAAAC9xhntVvkI7a9cWScBVpVi8R4jrgYCcCKgBfjGzVXuNAehtW7vjeu+nH/5vpzevwZHRNsaDmb8kRYKF6Q/yD+oxeWxxhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PwwBHiQWow3vHf1iCpN5N5H3Hq1/yfhZCAwxjwZ5/lE=;
 b=tqlXYQhur1nIrke6sxzLoY4AH6gRyygL+/dOZ3jG+tXGYTrTFpH3BsPU1AzOfltZJOuHFt3x8IwuYDxFCNB38eGHVW2h/Rwq9q7i+2LjaNRYPx5fSPDBTV6WSZ8CjgQvfbA3RJl/Bd2jKThWw3iZ4j+CJJZ5IjyoEAxAReHeHSURJn35PpQ7MF+SaSfVAbIuUKRw2Gvqw+u+gHV3tU4F6knjxmsZeGPvWFAiKF6EEcDkiuph/vj9F8D1x5qAce/OxU6HRExA1RmfLmEXl950HVsgiNKqLeKwnMv5U1LRvrPP7ughM/IU954P9i0GNuf0qMH/zfLPHM4P4jwozHpFYQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6089.namprd12.prod.outlook.com (2603:10b6:208:3ef::9)
 by FT1PR12MB352093.namprd12.prod.outlook.com (2603:10b6:170:a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 22:17:40 +0000
Received: from IA1PR12MB6089.namprd12.prod.outlook.com
 ([fe80::abd0:32b3:6f57:1d3c]) by IA1PR12MB6089.namprd12.prod.outlook.com
 ([fe80::abd0:32b3:6f57:1d3c%6]) with mapi id 15.21.0428.018; Tue, 29 Sep 2026
 22:17:40 +0000
Message-ID: <97938711-a762-4a06-a345-8e929f2e33a8@nvidia.com>
Date: Tue, 29 Sep 2026 17:17:38 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 6/7] firmware: arm_rmm: Ensure the RMM has GPT entries
 for memory
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 gshan@redhat.com, joey.gouly@arm.com, tabba@google.com,
 yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, alpergun@google.com,
 fj0570is@fujitsu.com, WeiLin.Chang@arm.com, lpieralisi@kernel.org,
 enju.kohei@fujitsu.com, sudeep.holla@arm.com,
 jonathan.cameron@oss.qualcomm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-7-suzuki.poulose@arm.com>
Content-Language: en-US
From: Shanker Donthineni <sdonthineni@nvidia.com>
In-Reply-To: <20260924135201.850038-7-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0090.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::35) To IA1PR12MB6089.namprd12.prod.outlook.com
 (2603:10b6:208:3ef::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6089:EE_|FT1PR12MB352093:EE_
X-MS-Office365-Filtering-Correlation-Id: 9251c55a-f857-452b-e6a6-08df1e77799d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|4143699003|6133799003|5023799004|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	QaecHNgkKIimUS4ACvSO6zF1Vbyi0b9hX9umvEcemMcrNxFd7SQsND2qZvFvbqu7zBCrNtWc+ZtbdsT/Kzwbe4gzqBmpDYwWh2fvtke94RwJi7tI5XIHj3PWtAm+771nh/nwGqHKC9cmGKKYCVaZ11ksyOd+KK6digGwQ0d3aj2hjfA29vQaZrdwCmFHwFYOXaGD8iI+lfiQEvDwfyL5HA1sOk7RKb3/EJy/t+EGG9Iy3XlGyvGwWhjK7zL+RESMLoLJyxD9rRhXGb6xDF2MwaHVJJd7vap80JxQBVc0r7QXRRgCJfaquEqS59YGeRxjezdovXIT5upPO0SHy/WcYM0vpfmimpU5g21Ii88HK/pMiGqIZSsGJd1cuRJhBhMyz513P0vQfzB7mTp6V5GJsSZq37+mfmCOarKr/zU5erLE+kZWKr0bfLFerjz1V/sJQluv1jfGx2wopf3qrtgBWLVlDHDGMBLey3gIfDrE0Xq4wc22TI+sHbUnaLpZGWs3MKGi3ev5nBusDPaJnEkzPNt6Pv5lznpg9zmSZoXmBvIoWk8CQvJ2JkICrJRQsmvswJOWvQfCm42EB7mY0anq/aVuOJx+XahtxvXDq2/Dr94PcQKwKTQVrZMtvBjtplOXuNDui6SM7ReKGeGQOhVlqlfbVZa993wb60sxz1DJES8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6089.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(4143699003)(6133799003)(5023799004)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVlJdnY0R1llbVZXNGo5emtheDNCbzYzREVaakFoYy9sVkljN09FSy80bHVJ?=
 =?utf-8?B?dzVSbnFNVzBnQ0x6dkV0MkdmRXpxZ3NielUzLzU5NHh5RlU4UkIyK1JQL3JJ?=
 =?utf-8?B?eEFlOTBIMWxwMTdtUjdYRDRvZnJCeld4VEdlQlpxbTRKc3Q3aEw0YVJHQlFR?=
 =?utf-8?B?UDZvME1NMGxmeFFuZ2FGL0ROU2kyZFlFWk5rd2xVSXZRZUJaMlV3U1g5SVlE?=
 =?utf-8?B?WHNDNHZucjFPZGdRQTlldXdjSHZOOXFNZ1hIenF6M2lUUkNJdmhJVmJMc1M4?=
 =?utf-8?B?bFJFRVE2clRISEdpVzBTRkZmaFpJNTFCbFd1VnM5WUYyNmNybzhwU1gvTEVa?=
 =?utf-8?B?MHNSNW9iQmp4TXk0T1EwNlp1ZkEwbTNVVjZBdWp4ampvVG9pOWkxcjZiRFhk?=
 =?utf-8?B?elRGUVJIQ3pXc2tGNkx2Q1FSMlZFMUJoVlgxbHp2dkVoRUZIdVRZblBIODJI?=
 =?utf-8?B?azAzdjZmYXQ2d3RoRitvNEw1ZlVJY1ZsSGhlMkUrTkZGUm95UkxNYUdwVmxw?=
 =?utf-8?B?d3BEM3dJcFdSd2lTUm5JR0p1NnJEYkN1Rlc3V3pDOXozVEptS2szVUxUb2RW?=
 =?utf-8?B?NFd1TmdoOHBJL3krK3NWdktBRkJzUkU2biszNW5CdlBDblhjMTF4VkFFOW5a?=
 =?utf-8?B?dnNGMGZtSFFJbHdHZmlubzUxd2t3L1NOWE1JQzROODE3U3pHRk55NjVGa3da?=
 =?utf-8?B?Nkc0WVpDcDBsMElCeVEzMWE1N1I2T1JlYkJLek5kckJCZVNoVzdNeDc3alNq?=
 =?utf-8?B?RnpKSzVWbDliV1ZXZVVmbjkrcWdSQUx6UmxXUUNNQklLS0hiMXVyQTdXcWQ4?=
 =?utf-8?B?UHA1d0FwakRmWkw3bjVzN1N2MVl4OTN5clYwUUVZSkJ5SCtDTmMrNE5zMUFH?=
 =?utf-8?B?LzBCclhhRkdzaFJjVHJFQUk5RmpBUVJBUUJrL3pvUkdKYncxREFneUM2Z01t?=
 =?utf-8?B?SVEyODR3MXpSVzcyczhzQWJGMEQ5UEhNYVhZMnF0aERSYnJoQlBOSEVKTnd4?=
 =?utf-8?B?OFlaZ0ptRXk1KzBxaEIxck4wZk1TRU9RQjFLdGJhSGVCWCtxejFZMDFpdkFr?=
 =?utf-8?B?YjZ6V1h6TDF4dmRWU0x4aTNORHhLVkpkM1dValFuZkViQVZtNVhCTXVZTlB2?=
 =?utf-8?B?OWxacGxpUVYrQU1kTjB3bysxTW9NR3V6cW9Lemk4THR1ZXFOYlp5RmcxTlll?=
 =?utf-8?B?NlFXLytpelhMb3BkMFA5N3pHQlJOakl4cWVSaS85ZS9OdWxtMWJQTVhWaGRW?=
 =?utf-8?B?VU9RN1kycGRVL2FtTGFWQUdyWFBxYkZ3U3dQaUxHRlRwYzZJeGRENmhJZlZE?=
 =?utf-8?B?a1p0MlN4QzdWdHh3bW5PcWEraEh6eW1JVGlFVGJUcXBCdE9oN2pLYTlET21z?=
 =?utf-8?B?MmtaU3Rja1psZHpMVEh3WEZuS2NPS2FGa2FIa3ZSVHZSWC9SaWF0TzlxVmYw?=
 =?utf-8?B?V0l0WG9Vb0lHcVkwQ1JCQzIzTG9vSmVKNXI4QkJ4RUp1S2xZV29wRFJmMGFT?=
 =?utf-8?B?c1AyQmZyUGczaVYrNjlIZm5zZEt1TE4ya2xWL0tQd2F3aE96dC8wWGwxc0I4?=
 =?utf-8?B?V2ZSWGR1cGxjajEzWnZLbnNxZUpsVlk5alFXb3FadWY1djhQOE95VDdWVmtm?=
 =?utf-8?B?TU5iVVZqNkVtT25Ya0dLNWs5K3VUMUVLWWQ3N3hSRUFzNHByeXFOUEh2UXZh?=
 =?utf-8?B?N0JJYzU2Ky8wWDJzZlE1L0IrZHhrdHZSSTliZnlBY2hrSENvamJTZ0lNWkVK?=
 =?utf-8?B?MGNwMnBiUnA2Tm0xaHhMU0w2U1BLTWhjbXpUTVdsZ1B3SENqTC9HaFRJNVp6?=
 =?utf-8?B?NkoxZXFKK3NxQ3Z6Q0U5REZoVW0rNytWeVZVeDVZSDFORmUwQmNVcmZNbzEy?=
 =?utf-8?B?bXdtbll4RlU2YXJ0MWN5ZmFTQUc1UlYvcjhybXpCWGRlZDl3eVZwVzBPbHB0?=
 =?utf-8?B?NGVVa2VFZnh1S3k2TkM1ODdjbklZV1V3UjB3aWs5eTRRTkdyaUNLcmdXWjNF?=
 =?utf-8?B?ZW96anlqZXgrNW1hNFpialRITTZWY2ZlOU5XNEdxajliOFJjYWljbFYyYU5y?=
 =?utf-8?B?SlRCY0xUMzB2NHBHWnVleXJQbDlnYTRuMzhEZnY4VnBMbVh1VlpTQlhrVGtQ?=
 =?utf-8?B?MzZZN2NaemRHb3Q3aFBFOXhabXM0TFFVK2s5ZWdsNTY3ZmtXWHFxTk9FcjdZ?=
 =?utf-8?B?bUwvNU5NT21OeUUyRnJvYVpGV0tVbHlMOTdCMG5sQ2ZYaktnQ3U1eHFISlR1?=
 =?utf-8?B?aGFnRTcwTmY5NmQrVHVEZFF2S0c1bGpFeURjZmtsaC9YQ1RCcXBUNWlXUlBT?=
 =?utf-8?B?Y2ZjT2t0d2FDMjNVdldwcCsxUHdQRHFrdGRiZ2pJajNSUjBYYzc2M3JrVk1J?=
 =?utf-8?Q?kb689osK/3DTpTTo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9251c55a-f857-452b-e6a6-08df1e77799d
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6089.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 22:17:40.2318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +i2vXOnOMJLqUyqm47eozB0fRq+xxpzVUcghOoVjR2t86nsIqvFfqTXJLs4SGhF2OEobSmXaHFg+zp7DIbG/aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR12MB352093

Hi Suzuki,

On 9/24/2026 8:52 AM, Suzuki K Poulose wrote:
> External email: Use caution opening links or attachments
>
>
> From: Steven Price <steven.price@arm.com>
>
> The RMM maintains the state of all the granules in the system to make
> sure that the host is abiding by the rules. This state can be maintained
> at different granularity, per page (TRACKING_FINE) or per region
> (TRACKING_COARSE or TRACKING_INTERMEDIATE). The region size depends on the
> underlying "RMI_GRANULE_SIZE". For a "coarse"/"intermediate" region,
> all pages in the region must be of the same state, this implies we need to
> have "fine" tracking for DRAM, so that we can delegate individual pages.
>
> For now we only support a statically carved out memory for tracking
> granules for the "fine" regions. This can be extended in the future to
> allow modifying the tracking granularity and remove the need for a
> static allocation by the firmware.
>
> Similarly, the firmware may create L0 GPT entries describing the total
> address space. But if we change the "PAS" (Physical Address Space) of a
> granule, then the firmware may need to create L1 tables to track the PAS
> at a finer granularity. Linux therefore checks if the platform firmware
> manages the PAR region. i.e., the firmware is in charge of managing the
> L1 GPTs (creation and the required memory for the GPT tables - via static
> carveouts) without host intervention. Support for dynamic GPT creation by
> the host will be added later.
>
> If the firmware requires us to manage the tracking or GPT memory,
> deactivate the RMM and reclaim any memory donated at RMM activation.
>
> Apply the same checks when hotplugged memory is brought online.
>
> Signed-off-by: Steven Price <steven.price@arm.com>
> [ Switch to RMI_GPT_L1_INFO for checking GPTs and deactivate RMM ]
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   Changes since v19:
>       * Avoid mixing gotos with __free cleanups for arm64_init_rmi()
>   Changes since v18:
>       * Handle buggy RMM to make forward progress for RMI_GPT_INFO and
>         RMI_GRANULE_TRACKING_GET
>       * Make sure the memory ranges are not inverted and reject such ranges.
>       * Move granule_tracking_get/gpt_info wrappers closer to the callers
>         Drop "inline", let the compiler do its job
>   Changes since v17:
>       * Move wrappers that may not be used elsewhere, out of arm-rmi-cmds.h
>   Changes since v16:
>       * Check fine tracking and create L1 GPTs for hotplug-added memory.
>       * Clarify the L1 GPT setup and move the explanatory comment.
>       * Switch to using RMI_GPT_INFO command for checking the GPTs.
>       * Deactivate the RMM and reclaim the memory if we can't proceed.
>   Changes since v15:
>       * Skip firmware-reserved NOMAP memory in rmi_init_metadata()
>       * Handle negative error codes from wrappers.
>   Changes since v14:
>       * Move the implementation into drivers/firmware/arm_rmm.
>   Changes since v13:
>       * Moved out of KVM
> ---
>   drivers/firmware/arm_rmm/rmi.c | 218 ++++++++++++++++++++++++++++++++-
>   include/linux/arm-rmi-cmds.h   |   2 +
>   2 files changed, 219 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> index 0859f256e192b..1a8f3debd844a 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -5,6 +5,7 @@
>
>   #include <linux/cpufeature.h>
>   #include <linux/memblock.h>
> +#include <linux/memory.h>
>   #include <linux/arm-rmi-cmds.h>
>   #include <linux/slab.h>
>
> @@ -13,6 +14,7 @@
>
>   /* RMM defines RmiFeatureRegister0 to RmiFeatureRegister5. */
>   static unsigned long rmi_feat_reg_cache[5] __ro_after_init;
> +static bool arm64_rmi_is_available;
>
>   /**
>    * rmi_granule_range_undelegate() - Undelegate a range of granules
> @@ -817,6 +819,210 @@ static int rmi_configure(void)
>          return ret;
>   }
>
> +/**
> + * rmi_granule_tracking_get() - Get configuration of a Granule tracking region
> + * @start: Base PA of the tracking region
> + * @end: End of the PA region
> + * @out_category: Memory category
> + * @out_state: Tracking region state
> + * @out_top: Top of the memory region
> + *
> + * Return: RMI return code
> + */
> +static int rmi_granule_tracking_get(unsigned long start,
> +                                   unsigned long end,
> +                                   unsigned long *out_category,
> +                                   unsigned long *out_state,
> +                                   unsigned long *out_top)
> +{
> +       struct arm_smccc_1_2_regs regs = {
> +               SMC_RMI_GRANULE_TRACKING_GET, start, end,
> +       };
> +
> +       rmi_smccc_invoke(&regs);
> +
> +       if (regs.a0 != RMI_SUCCESS)
> +               return regs.a0;
> +
> +       if (out_category)
> +               *out_category = regs.a1;
> +       if (out_state)
> +               *out_state = regs.a2;
> +       if (out_top)
> +               *out_top = regs.a3;
> +
> +       return RMI_SUCCESS;
> +}
> +
> +/*
> + * Make sure the area is tracked by RMM at FINE granularity.
> + * We do not support changing the tracking yet.
> + */
> +static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
> +{
> +       while (start < end) {
> +               unsigned long ret, category, state, next;
> +
> +               ret = rmi_granule_tracking_get(start, end, &category, &state, &next);
> +               if (ret != RMI_SUCCESS)
> +                       return -ENOMEM;
> +
> +               if (WARN_ON(next <= start))
> +                       return -ENXIO;
> +
> +               if (state != RMI_TRACKING_FINE ||
> +                   category != RMI_MEM_CATEGORY_CONVENTIONAL) {
> +                       /* TODO: Set granule tracking in this case */
> +                       pr_err("Granule tracking for region isn't fine/conventional: %llx-%lx\n",
> +                              start, next);
> +                       return -ENODEV;

This rejects any region the RMM does not already report as FINE,
but the initial tracking state is IMPLEMENTATION DEFINED, nothing
in DEN0137 Beta3 requires it to be FINE out of reset, and the full
RMI_TRACKING_* range is legal to observe here.

On NVIDIA platforms it is not FINE, so this path fails and CCA cannot
be enabled at all. The TODO above is therefore load-bearing rather than
an optimisation: the driver has to promote the region with
RMI_GRANULE_TRACKING_SET and re-query, not bail out.

-Shanker

> +               }
> +               start = next;
> +       }
> +
> +       return 0;
> +}
> +
> +/*
> + * rmi_gpt_info - Query the GPT info for the given PAR.
> + * @start: Base of the physical address region
> + * @end: Top of the physical address region
> + * @out_top: Top of the physical address region for which
> + *             the GPT @out_gpt_par_state is valid
> + * @out_gpt_par_state: State of the GPT covered by [start, out_top)
> + */
> +static long rmi_gpt_info(unsigned long start, unsigned long end,
> +                        unsigned long *out_top,
> +                        unsigned long *out_gpt_par_state)
> +{
> +       struct arm_smccc_1_2_regs regs = {
> +               SMC_RMI_GPT_INFO, start, end,
> +       };
> +
> +       rmi_smccc_invoke(&regs);
> +       if (regs.a0 != RMI_SUCCESS)
> +               return regs.a0;
> +
> +       if (out_top)
> +               *out_top = regs.a1;
> +       if (out_gpt_par_state)
> +               *out_gpt_par_state = regs.a2;
> +
> +       return RMI_SUCCESS;
> +}
> +
> +/*
> + * We do not support creating L1 GPTs yet. So, make sure that
> + * all the regions are managed by the firmware.
> + */
> +static int rmi_verify_gpt_firmware_managed(phys_addr_t start, phys_addr_t end)
> +{
> +       unsigned long l0gpt_sz;
> +       unsigned long next, par_state;
> +
> +       l0gpt_sz = 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
> +                                         rmi_feat_reg(1)));
> +       start = ALIGN_DOWN(start, l0gpt_sz);
> +       end = ALIGN(end, l0gpt_sz);
> +
> +       while (start < end) {
> +               long ret = rmi_gpt_info(start, end, &next, &par_state);
> +
> +               if (ret != RMI_SUCCESS)
> +                       return -ENOMEM;
> +
> +               if (WARN_ON(next <= start))
> +                       return -ENXIO;
> +
> +               if (par_state != RMI_GPT_PAR_PLAT) {
> +                       pr_err("GPT for the region is not managed by firmware %llx-%lx\n",
> +                               start, next);
> +                       return -ENOMEM;
> +               }
> +               start = next;
> +       }
> +
> +       return 0;
> +}
> +
> +static int rmi_prepare_memory(phys_addr_t start, phys_addr_t end)
> +{
> +       int ret;
> +
> +       if (start >= end)
> +               return -EINVAL;
> +
> +       ret = rmi_verify_memory_tracking(start, end);
> +       if (ret)
> +               return ret;
> +
> +       return rmi_verify_gpt_firmware_managed(start, end);
> +}
> +
> +static int rmi_init_metadata(void)
> +{
> +       phys_addr_t start, end;
> +       struct memblock_region *r;
> +
> +       for_each_mem_region(r) {
> +               int ret;
> +
> +               /* Firmware-reserved NOMAP regions are not usable system RAM */
> +               if (memblock_is_nomap(r))
> +                       continue;
> +
> +               start = PAGE_ALIGN(r->base);
> +               end = PAGE_ALIGN_DOWN(r->base + r->size);
> +               /* Too small ? */
> +               if (start >= end)
> +                       continue;
> +
> +               ret = rmi_prepare_memory(start, end);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static int rmi_memory_notifier(struct notifier_block *nb,
> +                              unsigned long action, void *data)
> +{
> +       struct memory_notify *arg = data;
> +       phys_addr_t start, end;
> +       int ret;
> +
> +       if (action != MEM_GOING_ONLINE)
> +               return NOTIFY_DONE;
> +
> +       start = PFN_PHYS(arg->start_pfn);
> +       end = PFN_PHYS(arg->start_pfn + arg->nr_pages);
> +       ret = rmi_prepare_memory(start, end);
> +
> +       return notifier_from_errno(ret);
> +}
> +
> +static struct notifier_block rmi_memory_nb = {
> +       .notifier_call = rmi_memory_notifier,
> +};
> +
> +bool is_rmi_available(void)
> +{
> +       return arm64_rmi_is_available;
> +}
> +EXPORT_SYMBOL_GPL(is_rmi_available);
> +
> +static int rmi_init_memory(void)
> +{
> +       int ret;
> +
> +       ret = rmi_init_metadata();
> +       if (ret)
> +               return ret;
> +
> +       return register_memory_notifier(&rmi_memory_nb);
> +}
> +
>   static int __init arm64_init_rmi(void)
>   {
>          int ret;
> @@ -843,9 +1049,19 @@ static int __init arm64_init_rmi(void)
>          if (ret) {
>                  pr_err("RMM activate failed (%d)\n", ret);
>                  ret = ret < 0 ? ret : -ENXIO;
> +               return ret;
>          }
>
> -       return ret;
> +       ret = rmi_init_memory();
> +       if (ret) {
> +               /* Deactivate the RMM */
> +               WARN_ON(rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_DEACTIVATE));
> +               return ret;
> +       }
> +
> +       arm64_rmi_is_available = true;
> +       pr_info("RMI configured\n");
> +       return 0;
>   }
>
>   /*
> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> index b03974fd8168c..5b177bb176326 100644
> --- a/include/linux/arm-rmi-cmds.h
> +++ b/include/linux/arm-rmi-cmds.h
> @@ -70,6 +70,8 @@ static inline int rmi_undelegate_page(phys_addr_t phys)
>          return rmi_undelegate_range(phys, PAGE_SIZE);
>   }
>
> +bool is_rmi_available(void);
> +
>   long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp);
>   void rmi_sro_free(struct rmi_sro_state *sro);
>   long rmi_sro_execute(struct arm_smccc_1_2_regs *regs);
> --
> 2.43.0
>

