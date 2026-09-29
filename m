Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012054.outbound.protection.outlook.com [52.101.48.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49B63CFF6A;
	Tue, 29 Sep 2026 22:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790720991; cv=fail; b=GaWSF0KYU+oFA5D0qly5dcKd0t7mR9QZ+jV6x3Wh8+We66F64NlhIYGkfnSreAugYaLS6+dYM4R6XIBeR7zNa9qNr7hwJKjND1Bk/eSWL7Z79cwATwscKdHpZqtT3B0+I7i2mSx1DLe+AoDE7ONbgF28Jyb972GnZSDVIMyH8X0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790720991; c=relaxed/simple;
	bh=K/r7EB1m+lPd0pcfW9V6CgyOa4YQwSc1RynghU2cuME=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nm3ZUbjsesgs+hF4xzHeT5hMPTJVkuSKiulIP1+fq2YU40IHnBGLmZjRPQBfoFjrtCM/8dERWA2xg78Rb0lpf49KKudtNKFoJo2stMu9BKaAdDVrfcvntfU7Om0lUYlBo2l6PQhhEg5jhqjrEPFCymC6LYUnrsobOksexRbINeI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pgC9evrr; arc=fail smtp.client-ip=52.101.48.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pgC9evrr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ad/XyJLOiH6SYJkMZ1XkUrJ78w34uKeiYdFAIuM0D6GmMfaPYAx/ocPLiIkb1ERRV/75pFsTAld2T6gUsNd4u6iHBi/6TlZjHIdArDSc4Wfoxw/XwpNCVnzY2HTb8jaYHF7ZHHX7s9jnbZgv7KgbRx9E375G0chog/UkgPqRwNB9tr+E7zYierO0ZN1D6+l4mMfFkDbMIe8d7+C2tAeQw8vSL4Zk/bUMqosog7hmZ0hrUehvBB0YX0mNtgZehcjDTdEaV3GozLaXTFbKi3Zmu9Qhvb63+u4bFfTp3XEW2YwR/6G4ifL3a5sKB5dJOIvbmt7F8NXKOEILlvTyi1o68A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DT6gKUqYDY146ITRHuwFaVewBUoLrzbC21f9UMH04tA=;
 b=JyL1GZ6Z/Nc8p/baUQpEZBHaDM6+55wj9OVNLtFi5KVSctVgzh/NSjG565VGo4XQeLnvrEHyQCTk+zLmnC+MS8hGjsPd5SZMlYY3sd6kXLvgLllJRuawJSAz3bMqNdlPh5SKWfK+oZ1eUezjfettf0Xigo+LQlYpNIwyI0kTEltJa6/JgDP8hmaFGjRLWby24ETTijvgeV0P/5+jSw7SOd/XsM+YMxoWW8AJ+gqz6rYCHXktMfM1Hv2W+SxDaCarfety/aj1zE+7KIxuCie58v2I9shgJ1OEHQm49fl/eLNLprmgUX4aYJ/Dr0yaJmPmw2w6H/b/KhEazcJ6ioeUoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DT6gKUqYDY146ITRHuwFaVewBUoLrzbC21f9UMH04tA=;
 b=pgC9evrrod1yysI7DoQYI5J9tgYJcrOi5121iUpRa5z+bZgLorvOi2Ab2LoEdX9/q7El7HKYCFji6aVM2h4nWWinrHsLgcx/WbzTtk6LxPcCbEFpzQNIvhArAd+CHw9qJEl0Y87CGMMn4qUGr1cdkK3VYrSyPtF/7mRXmEnp5cM+0+ti0SnixOvf6MgvuuRwjIOUWXh6GIlA1XvtX2f935aqaP1fSs0ZkGUr9jf2iY99TBPjaRR6Cvaq+jOmAvFQMc6fL6ve2Cz50OaropbXPnsZ+Q1HuM5Nme4jsC7XWPBdZ2Yn2xl7+7+/WKQkHV1RRa4l1Hi4TXZbCeIFQJVMzw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6089.namprd12.prod.outlook.com (2603:10b6:208:3ef::9)
 by SA1PR12MB8644.namprd12.prod.outlook.com (2603:10b6:806:384::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Tue, 29 Sep
 2026 22:29:44 +0000
Received: from IA1PR12MB6089.namprd12.prod.outlook.com
 ([fe80::abd0:32b3:6f57:1d3c]) by IA1PR12MB6089.namprd12.prod.outlook.com
 ([fe80::abd0:32b3:6f57:1d3c%6]) with mapi id 15.21.0428.018; Tue, 29 Sep 2026
 22:29:44 +0000
Message-ID: <a27970c6-a7d2-4abc-84c3-7e50225f0a1a@nvidia.com>
Date: Tue, 29 Sep 2026 17:29:41 -0500
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
X-ClientProxiedBy: BY3PR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:a03:254::26) To IA1PR12MB6089.namprd12.prod.outlook.com
 (2603:10b6:208:3ef::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6089:EE_|SA1PR12MB8644:EE_
X-MS-Office365-Filtering-Correlation-Id: c3755cc5-1310-4744-685e-08df1e7928ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|10067099003|56012099006|5023799004|11063799006|6133799003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4wZLxT1X8ZHnd7lL7EMncUciuEt24IA0CS11KtY7zA1wNMyGVSxcWoRU0VvDK/AXtv3g4VYdLTKDJwXc63kJebSzTDzN9JFDsdFCpnB4guBoVfJYZtsxpzcamIAgzKi1NFxteApVMDqT/ztCsWq9FSFucrYFJwA6nUYZyO382lxVjx9Pp2N2sqhe4qf3zNfnk8Oy7vtLuosKMbEYPDUAIs7UELuRtyRs9XpPTwpmiiEiCrascvdY930lGL3TaXvLQOXCvw4BsCygUFvKJzFdw+skW0OAZ3Vaa1fSgy9GGuRCOg6Dvsg58SxD2/kfTZIpc8Ts3ALMgrDUgJKYztvgsRPuTGr4OUNZCfgispG1xAgPX7bB84wbOAoPH/FVke9KXFRbWDU5+jKFARyPnFsPyhF7gxF88YXsWyqPDF8T68sxwlfAuZKTX50rmC4Jo/PsYxy5LI0U2i3xRjLMPQrq6EBa8KSuHPjIX67WmyExCNozv8PfxSPsi6PTvUsQBD9DdmGwziI5ZgmziLiGpYZ7VWLzwPOh3Y4C0wboz5kACneRxsMkpjW0vIYVQheHTSs6Za1vX4i89UB3vh/ovYDp7rolzgThS9MMxTeLJUN7yjqqm3bShUHydEoIIrJR3G7RMWxPAjnVI2NelHiIBIzyxvacP4Mf5hD+jAkCLpG81l8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6089.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(10067099003)(56012099006)(5023799004)(11063799006)(6133799003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVdCRG1BQVpUVWpOSUl4Z2U1cVpTY1lHUUJsSU9LVElUNFBWNmZJaGhQK1FR?=
 =?utf-8?B?Z0RBMWlaV0EzSXRxQXRjRHBZNkhQcEd1blM3TkU1am9veCtGQmlDUlBkZ0N5?=
 =?utf-8?B?ZDVsMnpPZmRXTTlzNXo1TmFzczF3UUhWSDI4Qm1uV080R1NQMHZjQUhDclND?=
 =?utf-8?B?U2pUNXdSZVBlWjRPNTI0cFQvMzRvWS9WdUt4OVNXWkZjLzl6YzFEbTNUWmNo?=
 =?utf-8?B?REk3QzVoR1hRMTlrT3gvYVo2cmw3VTdtbEZ3b3lmN1pqZUNsZUZ5eTc5TkJ5?=
 =?utf-8?B?clhEeXJ5aTBqNWxIZktsOHI5clA2aGdZVkFQZHZyQUE5aHNLUWhSTFpTRHFO?=
 =?utf-8?B?MmFsalNoZGhWdlB1Z1dlUmQyZTJUZUVML01UQ3I0RWVXQ2MwOGlydDVNNnFH?=
 =?utf-8?B?aGNDQk9LdVZDckpIcXVBTzJFWkZqT2toY1dKbEthY0dyQmZ4QklEMG9VQUpu?=
 =?utf-8?B?c2VpS1dhLzg2UGc0TE0rUDY3VEs3VjRHbjFHQ0Zxdjd4aGZxVndaTmg2Q0lQ?=
 =?utf-8?B?RUZadDVsMVpjcWZXL2xPaEhuSWNWYjdEeGFWOEpGUGV5TzU1OExabDhNMkxR?=
 =?utf-8?B?cG9vMmVrdVBRTUxPdmFlVEh4OG5BU1Z6ZUJzWjJkNUJab0RQU2IrbHk0a2hE?=
 =?utf-8?B?RVRueE1SSEo4NFpOeUcyWllTaGV1eTRadXVYbHRqRy9PVEZVNzFpU2NzZDRN?=
 =?utf-8?B?czVHYWMxRzJhcTVPV1JKUFY1QTRGdllWTmZhRFRNbVZ0dERLR0JVeXZweEtC?=
 =?utf-8?B?US9MLzdVSGlNTUFBMGpOSjlnRTZyczV5RDBTR3RHcEVaSnYxeFJNRVZqY0dB?=
 =?utf-8?B?NHp5aitjOC9nczR2dytEVVIrdnhrK3JzUHFzZUJ6ZVVqaElGS2FFaGJrdDVs?=
 =?utf-8?B?bmpSL0FQVTNGZmtteFBsWkdvUnFpVHA2QmJCQmNMVFU5ZGpJV1hoRVg5Y2th?=
 =?utf-8?B?MmdOU2RVa0ZkTmtPZGR2d2hWMGlUTFNvUStCYmJMc0wrbTEzZ3laVlB2SlBV?=
 =?utf-8?B?T2RVN05vSzY5WG5IZ28rcTQ5aUMrUUdFemI0MUptOEQ0WDZjZjNXeitvZjZo?=
 =?utf-8?B?RnpDb1N3ZGdXajdCUmxTS2RkZHZLa2tSYlFLUjFuZmxNeUdoTlJtd0ZMU012?=
 =?utf-8?B?UmdIdTNVZ3l1aEpnSzg5UXM1REpyTENpVmo1dFRFOGRWaEhzdU93NEZpM0o3?=
 =?utf-8?B?RngwM3JJMERETjVJRFZaa1JUeWIrY01kNlNlNEQ3ZnVkL2xlbHg4WWdSOWN4?=
 =?utf-8?B?V05yNDlhVUtWN0V6dDlxYmxoeldHeWxYRzl0d1J5UHBkUXgzTTlDMmNvKzZr?=
 =?utf-8?B?bDdsK2ErYi9Zd0JSNEo0Q0hicHVoZ1dvK1VsMVR2WHJxK3k1OFFhalR2L1BQ?=
 =?utf-8?B?LzNOUy80TTMxVFR3TFpvNVlGbDd2WVVQdDVpS21RcUVwaTZ4TkU2RlNyL2Rp?=
 =?utf-8?B?d1hzbnJHaTB4YjZpVkUxbTQ1MlZod3lIUkM5TE1iNEJDTURLTFRBU1BTVnVy?=
 =?utf-8?B?Wm5SREFid2VST1R2My9sTXcySC9RS1RQWWxFMzZWMnl0SGJXaUlqMFNEUmJF?=
 =?utf-8?B?WlByV2xRUmRZYnU5WUpqbjAyNWtoR0UvUURkQlQra1JmT1BDSzNUc1Z3UHcv?=
 =?utf-8?B?Zld0MnN4a1BlNUY0bkxIeGgyUzRsL0p1N2lPQWVvUy9ybW9WVFF1ditLRU9K?=
 =?utf-8?B?UHlrRmszaTJFUEk3SGNoRWhyTmZkOEF5cklDVHY4eHExcThhUm9WcmVFZFNX?=
 =?utf-8?B?UEg0RXNyUXd3NlRPTkxFbWRUUkwwMDEwUmpoUU4yOFdUMmMrc01aWkRXV0VG?=
 =?utf-8?B?SS9nYmFXVlY4MHNUSGkwaVR5Tlo4NFNlWGdMeTBtL2dGcUJwZ2VWTGt5bnhm?=
 =?utf-8?B?a3ozN1FGSk03WURJQUlGK3EwcnpvSVBUbzdNa09udVlwZWh1QjRGWGVMQ1Zy?=
 =?utf-8?B?YTRQUnVSaEVybVA1ZDZaY2MwTm1hWUtUUmFXSG1KK2M5ZzV2dnpIZWp5NFJK?=
 =?utf-8?B?bDliRmo2REVtZzZTLzdYRk1XcTBtK0RnbUxDbjdqVFZOVUdyaGF3RU4veDg5?=
 =?utf-8?B?SDhyRFVxWkhGa0kzd0JsNkdkL2JjU1FnKzBOM1gzNDZocUVMZVduNzYvODlS?=
 =?utf-8?B?SHBkZ1RPQWliYW9ZKzlFUUZTemt5eXBpeE1TR3RQdEFrSjJrcGNCb1I3ZXBB?=
 =?utf-8?B?K2lHaHJrWVpoSjZOeTVmeUo0YmNJbWV2bG1VNTlLRVM4c1gyV0JNZVQxeGtB?=
 =?utf-8?B?M3JZV1JOdUZ1U0ZMQ3VnYVRyWWZiSncvTm9relZRaXFJQWlScHFXVjB5TVhU?=
 =?utf-8?B?SW1QT0pweldXakV6SVBQR1R0RkdQNERwY09WdXZCL21oU29CMlNmQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3755cc5-1310-4744-685e-08df1e7928ed
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6089.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 22:29:43.9550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kMGlRYi77ETuBVA/Nrs0rSQ0JnTzNzlXyIRvG+Q/I7mWdt9J/Rz9deL86oDbvc0EN2ngYPH17bMW1kCNxbzEPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8644

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

Accepting only RMI_GPT_PAR_PLAT rules out the host ever creating its own
L1 GPTs. On NVIDIA platforms the PARs backing system RAM come up as
RMI_GPT_PAR_HOST_NOT_CREATED, so this returns -ENOMEM and CCA cannot be
enabled at all.

With local changes to promote granule tracking via RMI_GRANULE_TRACKING_SET
and to create the host L1 GPTs, I was able to boot a Realm with multiple
vCPUs and exercise basic boot functionality on NVIDIA silicon.

-Shanker

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

