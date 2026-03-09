Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011001.outbound.protection.outlook.com [40.107.208.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719E5259C84
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 17:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773078005; cv=fail; b=llyTmDGHCCa3d1MzPhZWGwADmhLHO5E1ouptiMLIvhCeIGQdjHitbxQIKlM1Xnzqph3mcqhiBAWAyK78JXcL20Wu/Nf2boHfX9hS+Bk7Hbt7KfQy/No8DQwWnqyQc1kvmhdXbG+aS6x398aQnBDRpVqRQrM3Ff+Prr0gpFG+y/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773078005; c=relaxed/simple;
	bh=mDPFEdW9GL3T3CY7t+sWxLYXqBMDtM3Omn0xEaaEqww=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hBAXPNbzAYpOxAaHsRjYW/8i2KfmDVNb19Bvf26gqxEXvasy1Y2V0NYUxHadbNx7uUcTziM2x8/Xlc3bSNhzwdnEtbmLvf30EhlRZhUGWhEZBosJIc0s6DWmPjr7s87lv0zBmckCXzUoQRfukYJckjX2Zefn1zKuXkOvVRVSufQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hVsR2tD/; arc=fail smtp.client-ip=40.107.208.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hVsR2tD/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D5z8LjEtMlcVkH6qJZ0bbUFN55Ayndkev0Wnpjpfp6i+VlFPSoAcYZamWe/GOLfNqRaL6NixTQ2aJRTikQAKFAeTCWcvwGCI5cIl9Dy+XXQ0jAthIzK4Ct8nOh6drbVLpak9Q8nCSOJuImi+QjankK8JCcqw1yZClr+J9eqbjC8251iISudhjApQD/24JmZB1tzqNbzMsnkwf/lk5DVVaxph5C7biLKGmILEawFXav1RWFh7JHIAq1hspl5be4THZwn4pmGIXaN5ZoCRrlH7wwzU6fSo3j3gw2D0WqZIiVRYpQUr6rPZVjlngLUYuIJkpIdiOw/iMvF1RrXyIWVITw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PcZNQmhEAI3AimluuekZJDm0V90HEjjw2VLGZA0wNqY=;
 b=VB29PeDhciW/fbNztgMSsemrcMBVpny4qWxuL1Rd03JQ5zc0NGpLtYa+txPqy7GsY+Nt1VHbvYeeBNkL1FKyuGwYC+f3UxwmffY4KlfOf08BbB5w6rl3QNMEVcbKNY4rrkC3+y2UqrRpF6CjpWUBN1jaocOTb6X+IF6mTQEAPUPikXkFxvzJAnRWen4gIcgNKtUaQoJursYFrcgVtUP5gOcxmjlw7aRC0FTXKDXN4YF3t+ghq96j1a3V/iDd0GBXqo9d4gdRtaKIgc6hew8fJ1h6blPrWryn091ApCVmwrHIKjl/gpQL73xFi2kc4e5+2W+t4V7lZ6GwCeThcyAI+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcZNQmhEAI3AimluuekZJDm0V90HEjjw2VLGZA0wNqY=;
 b=hVsR2tD/Utgsh7JNrUGMIpbSKpVkTkVUbinJMY6MgX1bz8PwdnJIxbWvBzuyRNzpQHfguR0WrkyJPoexCWcFsPd5GareHSMZtpcufS0g4q43ch0Afbm4EHcmlwTTZYwU0W/07bWCpWXP6tCmNsjcrWPOK5PgxotZ+CxigmR78mTBjp0u0EWxT9Fvs0h4iyYM0zrznBO1kWu3n+MtjArtlQ8gEsgviiXHrdz7vj9LEU6epU76n+r7BIJnwZZP4JKiJ6CUZs0RqgDxs90zDmcXvfP+coFBEhnaoKD1zbRKnpeY8B35DkqYAP1subbF6JqAKVsQ4uTwZ8XUCVbazoSQrg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 DS0PR12MB6560.namprd12.prod.outlook.com (2603:10b6:8:d0::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.11; Mon, 9 Mar 2026 17:39:57 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::aa9a:b827:90c6:506b]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::aa9a:b827:90c6:506b%6]) with mapi id 15.20.9700.006; Mon, 9 Mar 2026
 17:39:56 +0000
Message-ID: <2aa90f15-f2f0-45d7-9161-2ab08b4d00d4@nvidia.com>
Date: Mon, 9 Mar 2026 10:39:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 38/41] arm_mpam: Add workaround for T241-MPAM-4
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 gshan@redhat.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org,
 Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260224175720.2663924-1-ben.horgan@arm.com>
 <20260224175720.2663924-39-ben.horgan@arm.com>
 <7e496cb6-ab31-4a89-9630-0fa2e6b3607b@nvidia.com>
 <3e26371d-21b5-435e-9f31-7187466c57a2@arm.com>
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <3e26371d-21b5-435e-9f31-7187466c57a2@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0185.namprd05.prod.outlook.com
 (2603:10b6:a03:330::10) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|DS0PR12MB6560:EE_
X-MS-Office365-Filtering-Correlation-Id: 307b7fba-d654-4124-0d83-08de7e02e139
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	pAOO2GeNAHng71SROgtxDW3J36l9exbk8yzibvUEVeLoB7wZGzJsvEgab40GWfR5sd6EncT/SODE3fzrc92WoR6kAjTSILZpx2W3kodcGkYLi9oacvfLBv1T253ELRBVUd9zMn63uVb7YXmJNDtxa8SrByMHIXvQvixIwKYe1myzOdqeidat9Uqph7OO98kmvNymOuPdJSDaCNskVH6otNi4K8JyF30pnCX63X2HxNFv9TdFrJzVpelm2tJffb6GDR4uw4VbWpY+wPpkuhiC6sAgLQZaiEcVoT48+dtgfRYXqdAoWzn2/I0XxMM5NaBbrCZ4xvVh/if9hJ4qf7btzacRcJbjYN4MDJqSPTZ/V0g/uuLS1cJpfoenAYqTDYjb+RdxkBLc7qt9ZHi+P7yE2ONthYCJqxlU5IllWXNEZzSRSyR1HLNxLaQyXly/wmyOk2PYxp74BZC+xp2yaLzUN6khSGnGrRXLNzc8ZrXuQGiK565NtWxOioNAsmbCYy/xgPmqWXsa3jg+w4OjlPafJh4lvMBERHih+sU0ZQSEI3AXdXjAd58xc1oNOiTyjlR1p3ODgjtv5EUEDIUg3Mt8B8ISe7RWXvO2p3BiHnD9CXxL6Ka7QX8c4SQ/LucAmbKUDRZFEn7SHCwJidr3TL/+wzJU3nekG9UNgWouHhV5LynEJ8X8ynCHX2t6LXSNbTdCn0jnNR/6EBt58Y1DQoNXOPQYXDE9jl3/QFXx8rv52Vg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ek9lMkIzMkR5aVVBQlVpc1BMOVVFZ1R4S205RHdMVkxWR2Q5UmpPQ0RMczBi?=
 =?utf-8?B?RjZPZFJIeUFxeHpTOUJab3ZzamZJN0Q3Z053WTRUc1U5N3pnSW14K2Jpamhu?=
 =?utf-8?B?ZVk4NGRzYVlBa0xxNy9nWkltczEzWjllTVE2VDQ1WU0zbDVsV0ZOSVRwMTNH?=
 =?utf-8?B?TVIyTHV2b2M1OFI2R1hGeWw1c0RWNG5mWGpMTkI0QUMxdXN1NmZNaUdPV2VR?=
 =?utf-8?B?YzVyRlFqVDZPNVRwcUJwOHZLcGt4T0twMUtRN2tJdVplcHV2ZllWMmNZRzZY?=
 =?utf-8?B?bWhBS1JITjg5c1ZzOHE3d1N2cjNpMjhQcG82RXlDVDFHRnZCZTV6YlB6a01N?=
 =?utf-8?B?aTZhOE1pSFpIV3d2TDd2VlNlbVVsMWZRc3Nuc1REcHlJQmRlR1p4MWRUWGdO?=
 =?utf-8?B?YW5ZaS9jUnN4K0tKczNXTzE4RWdaREYrRjFwenRsdGpWLzJNYU45bEJQME9I?=
 =?utf-8?B?Q0FTWmJrWGlxa21JYXZGY0hSa29yaXhVZnJVaUlXb2hQT2NCc3k3TkYyelhw?=
 =?utf-8?B?Rzh2K0VrR3VWZmhCd0w5bWZ0NTZjL2wvUyswVUVrUVVPQXQzOXBGazNVOG1H?=
 =?utf-8?B?bGhDendIbHFlN0JaNklPZTEwOC81QVhwZ21HZytOQWl2eGFrVzJWQTdnRUE5?=
 =?utf-8?B?Ui9OZkVJRHFNc3Fpb1gxYmVxSEV1eDc5RW5RZVNUZzVKQXhUNEF2MUFmTnFG?=
 =?utf-8?B?aFZSanZhNlY2TWlnRmRsckxFWkFRWEc5MUJPR3Rmd2Zkc0tiUE1yNUlTbmIy?=
 =?utf-8?B?ZUY4OFlsdSsxeFVUdUhQVDA4dlhtS3E2aWZ5eHJUNktDYVppMDd3eXhZREl0?=
 =?utf-8?B?ejIrS3JTR2pVMU96cmpJcTFrSFh0MWlzdTRnbGNpN0QxNW4xUzlnN0FScmZ6?=
 =?utf-8?B?VExzcjNLOGlRdDhEVERjTDBSREtLU0xCZDJJcGlBRm9xTnJadVA5WXpPT2ZY?=
 =?utf-8?B?aE45OHpCTXg2OVVmZnpFVVBuVURsYldXZWh4Sk5Ic0I2a2dva0l5V3BRNlR6?=
 =?utf-8?B?MlpKLzRWR3JZNkxaWjQvZUJmWWsyU0VpVG0xYUtiRDNKV096bDZGVUFUMUls?=
 =?utf-8?B?UnpBaDFDa3pSeFlta3dSZFRpejFGVjJqbThnOHFwKy9sZVQyZmZ1UG5KOE42?=
 =?utf-8?B?dW1WUk43WnJ5NjB2bkJWQlEzUjQ1WmpCYXQ0WXBGcWEvTldtazNPWUVsUkNJ?=
 =?utf-8?B?bEhyazhLRDRCZitTMm9aWitSTEVqS3NGdEhJZ0dSWTl5MDVLU3JDSGUrVXlI?=
 =?utf-8?B?MnhFU2pxTzFITWphNmt2eldTakJrWkxYZWd5ZEd0d05yZjFNQVdnT0FzdkVH?=
 =?utf-8?B?ZElPLzgzSnQ3UUMwMlVVMnBYak8wdmtFOU9KbEt3RGt2TmFVTXI1REpGakds?=
 =?utf-8?B?MnpTeUhaa1l1NkFjTFprM0cweFhHSW1BYUM2cjlGUmJaVnJPN3FndkxYT3Yy?=
 =?utf-8?B?VmE3TWpQWjRIWWxXVHpOL2ZMaDhxdEw5MFdkU3paUnEwZW5HUEp2QzV5WWM2?=
 =?utf-8?B?d2xUK0dDbE9Db0M4SVV4eTZQOERkU0ppU3dnZUxJTUY0M0s3ekhOWlRldHZC?=
 =?utf-8?B?bWNnM0tSWVkwZFh2dmtqM2EycS9ncCs0dUVkTUxlSkJXY0JYUTY5MEJGNUVP?=
 =?utf-8?B?dWgrTC9iVDhZOHV6VmJ3UHpNTFliRlpYd3ZBMTZieDVucHNaZm5qNzhZZEJG?=
 =?utf-8?B?dU52VGh0d29yaVJRdWxGT1RkUWVFc0d3TFU5UGY5bHFXeTA3UEQ4d0srQ01i?=
 =?utf-8?B?TFJ3V1RTZE50V1JTMWFwcjNyZzdSWnliTnN5ek4xb1FRY2p6bS9ya0E4MG5w?=
 =?utf-8?B?Q01Rc2plZkF0VjlINCtuNGV3KzdneURLazFiU0pCMTdBRm5QRjlsYlIxem1Q?=
 =?utf-8?B?WkdYVnRJQTA5TzhadjdWZHNFNlJtZjd6RE9qMVB6cVNaM0FkV3I4M0pydlMr?=
 =?utf-8?B?b3hEbXhLRi8wVE90UUo5QjFWR25ka0pYQW5LNnB3VjhTRTBxejhsM2dRKzNs?=
 =?utf-8?B?RzAwV010QUNaY1g1RHJmVzJPR3A2OUVxUVdZYnY2cFI3UkVVR2RINk5jTFNB?=
 =?utf-8?B?U2ZEQm92cnpBaFdXWVdzYVZGNjlRRzRhWUplVUZpWWM4MlAxRXpqaWRRN2Uy?=
 =?utf-8?B?S1BQUFZDb2xUcGRuNUNzb1dvYkF4cHZmbGJFVGwza00yNzhPZ0laZHB2U0U0?=
 =?utf-8?B?OFFyV2F2cXhkeEx0NVVIUFpzcHduNEE5V0hPaVFCNzBoSTVLRU1QOExIb2Mx?=
 =?utf-8?B?K2xWWnpaR0pmT1pzYzlZTTIrMlpBbnJ6U0JRdmxLZXVZK2RGRkllTEFJTy94?=
 =?utf-8?B?c2ZVSWVRNmpzOGJOQ0JoRWszTzUxeUZTY3BGcEE2UUovL2MxaVJTZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 307b7fba-d654-4124-0d83-08de7e02e139
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 17:39:56.8523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fCo0aCElr6ISevvFrfRIyYPywaou79lAIjP3+L0pBY0v3G1CU01Zg8i+Z2EI/zLCRvsts9awUgj8Xpygjo2Fjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6560

Hi, Ben,

On 3/2/26 09:11, Ben Horgan wrote:
> Hi Fenghua,
> 
> On 3/1/26 17:28, Fenghua Yu wrote:
>> Hi, Ben,
>>
>> On 2/24/26 09:57, Ben Horgan wrote:
>>> From: Shanker Donthineni <sdonthineni@nvidia.com>
>>>
>>> In the T241 implementation of memory-bandwidth partitioning, in the
>>> absence
>>> of contention for bandwidth, the minimum bandwidth setting can affect the
>>> amount of achieved bandwidth. Specifically, the achieved bandwidth in the
>>> absence of contention can settle to any value between the values of
>>> MPAMCFG_MBW_MIN and MPAMCFG_MBW_MAX.  Also, if MPAMCFG_MBW_MIN is set
>>> zero (below 0.78125%), once a core enters a throttled state, it will
>>> never
>>> leave that state.
>>>
>>> The first issue is not a concern if the MPAM software allows to program
>>> MPAMCFG_MBW_MIN through the sysfs interface. This patch ensures program
>>> MBW_MIN=1 (0.78125%) whenever MPAMCFG_MBW_MIN=0 is programmed.
>>>
>>> In the scenario where the resctrl doesn't support the MBW_MIN
>>> interface via
>>> sysfs, to achieve bandwidth closer to MBW_MAX in the absence of
>>> contention,
>>> software should configure a relatively narrow gap between MBW_MIN and
>>> MBW_MAX. The recommendation is to use a 5% gap to mitigate the problem.
>>>
>>> Clear the feature MBW_MIN feature from the class to ensure we don't
>>> accidentally change behaviour when resctrl adds support for a MBW_MIN
>>> interface.
>>>
>>> Tested-by: Gavin Shan <gshan@redhat.com>
>>> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
>>> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
>>> Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
>>> Signed-off-by: James Morse <james.morse@arm.com>
>>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>>
>> Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
>>
>> This patch itself is good.
>>
>> Please check the following comments.
>>
>>> ---
>>> [ morse: Added as second quirk, adapted to use the new intermediate
>>> values
>>> in mpam_extend_config() ]
>>>
>>> Changes since rfc:
>>> MPAM_IIDR_NVIDIA_T421 -> MPAM_IIDR_NVIDIA_T241
>>> Handling when reset_mbw_min is set
>>>
>>> Changes since v3:
>>> Move the 5% gap policy back here
>>> Clear mbw_min feature in class
>>> ---
>>>    Documentation/arch/arm64/silicon-errata.rst |  2 +
>>>    drivers/resctrl/mpam_devices.c              | 50 +++++++++++++++++++--
>>>    drivers/resctrl/mpam_internal.h             |  1 +
>>>    3 files changed, 50 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Documentation/arch/arm64/silicon-errata.rst b/
>>> Documentation/arch/arm64/silicon-errata.rst
>>> index a65620f98e3a..a4b246655e37 100644
>>> --- a/Documentation/arch/arm64/silicon-errata.rst
>>> +++ b/Documentation/arch/arm64/silicon-errata.rst
>>> @@ -249,6 +249,8 @@ stable kernels.
>>>    +----------------+-----------------+-----------------
>>> +-----------------------------+
>>>    | NVIDIA         | T241 MPAM       | T241-MPAM-1     | N/
>>> A                         |
>>>    +----------------+-----------------+-----------------
>>> +-----------------------------+
>>> +| NVIDIA         | T241 MPAM       | T241-MPAM-4     | N/
>>> A                         |
>>> ++----------------+-----------------+-----------------
>>> +-----------------------------+
>>>    +----------------+-----------------+-----------------
>>> +-----------------------------+
>>>    | Freescale/NXP  | LS2080A/LS1043A | A-008585        |
>>> FSL_ERRATUM_A008585         |
>>>    +----------------+-----------------+-----------------
>>> +-----------------------------+
>>> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/
>>> mpam_devices.c
>>> index 08cb080592d9..8f44e9dee207 100644
>>> --- a/drivers/resctrl/mpam_devices.c
>>> +++ b/drivers/resctrl/mpam_devices.c
>>> @@ -679,6 +679,12 @@ static const struct mpam_quirk mpam_quirks[] = {
>>>        .iidr_mask  = MPAM_IIDR_MATCH_ONE,
>>>        .workaround = T241_SCRUB_SHADOW_REGS,
>>>        },
>>> +    {
>>> +    /* NVIDIA t241 erratum T241-MPAM-4 */
>>> +    .iidr       = MPAM_IIDR_NVIDIA_T241,
>>> +    .iidr_mask  = MPAM_IIDR_MATCH_ONE,
>>> +    .workaround = T241_FORCE_MBW_MIN_TO_ONE,
>>> +    },
>>>        { NULL } /* Sentinel */
>>>    };
>>>    @@ -1464,6 +1470,31 @@ static void
>>> mpam_quirk_post_config_change(struct mpam_msc_ris *ris, u16 partid,
>>>            mpam_apply_t241_erratum(ris, partid);
>>>    }
>>>    +static u16 mpam_wa_t241_force_mbw_min_to_one(struct mpam_props *props)
>>> +{
>>> +    u16 max_hw_value, min_hw_granule, res0_bits;
>>> +
>>> +    res0_bits = 16 - props->bwa_wd;
>>> +    max_hw_value = ((1 << props->bwa_wd) - 1) << res0_bits;
>>> +    min_hw_granule = ~max_hw_value;
>>> +
>>> +    return min_hw_granule + 1;
>>> +}
>>> +
>>> +static u16 mpam_wa_t241_calc_min_from_max(struct mpam_config *cfg)
>>> +{
>>> +    u16 val = 0;
>>> +
>>> +    if (mpam_has_feature(mpam_feat_mbw_max, cfg)) {
>>
>> But the problem is mpam_feat_mbw_max feature is NOT set in cfg.
>>
>>> +        u16 delta = ((5 * MPAMCFG_MBW_MAX_MAX) / 100) - 1;
>>> +
>>> +        if (cfg->mbw_max > delta)
>>> +            val = cfg->mbw_max - delta;
>>> +    }
>>> +
>>> +    return val;
>>
>> So 0 is always returned.
>>
>> The workaround will set mbw_min as 1% which is too small and will cause
>> performance degradation, e.g. about 20% degradation on some benchmarks.
>>
>> This patch itself doesn't have any issue.
>>
>> The issue is the mbw_max feature bit in cfg is not set.
> 
> This is intended behaviour as the reset is done independently
> from the value set in the config. The value is there so that
> resctrl can display the expected values.
> 
>> This is a legacy issue, not introduced by this patch set.
>>> Here is a fix patch for the issue:
>> https://lore.kernel.org/lkml/20260301171829.1357886-1-
>> fenghuay@nvidia.com/T/#u
> 
> I've commented on that patch. I think it's best to fix it in the context
> of the erratum.
> 
> Does the below solve your performance problems?
> 
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index 236f78ab9163..60d3d3e2193f 100644
> --- a/drivers/resctrl/mpam_devices.c
> +++ b/drivers/resctrl/mpam_devices.c
> @@ -1515,16 +1515,20 @@ static u16 mpam_wa_t241_force_mbw_min_to_one(struct mpam_props *props)
>          return min_hw_granule + 1;
>   }
>   
> -static u16 mpam_wa_t241_calc_min_from_max(struct mpam_config *cfg)
> +static u16 mpam_wa_t241_calc_min_from_max(struct mpam_props *props,
> +                                         struct mpam_config *cfg)
>   {
>          u16 val = 0;
> +       u16 max;
> +       u16 delta = ((5 * MPAMCFG_MBW_MAX_MAX) / 100) - 1;
>   
> -       if (mpam_has_feature(mpam_feat_mbw_max, cfg)) {
> -               u16 delta = ((5 * MPAMCFG_MBW_MAX_MAX) / 100) - 1;
> +       if (mpam_has_feature(mpam_feat_mbw_max, cfg))
> +               max = cfg->mbw_max;
> +       else
> +               max = GENMASK(15, 16 - cprops->bwa_wd);
>   
> -               if (cfg->mbw_max > delta)
> -                       val = cfg->mbw_max - delta;
> -       }

Could you please add some comments on this piece of code? It's worth to 
comment on why there are different values on cfg and props.
> +       if (max > delta)
> +               val = max - delta;
>   
>          return val;
>   }
> @@ -1577,9 +1581,8 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
>                  if (mpam_has_quirk(T241_FORCE_MBW_MIN_TO_ONE, msc)) {
>                          u16 min = mpam_wa_t241_force_mbw_min_to_one(rprops);
>   
> -                       val = mpam_wa_t241_calc_min_from_max(cfg);
> -                       if (val < min)
> -                               val = min;
> +                       val = mpam_wa_t241_calc_min_from_max(rprops, cfg);
> +                       val = max(val, min);
>                  }
>   
>                  mpam_write_partsel_reg(msc, MBW_MIN, val);
> 

Otherwise, this change looks good to me.

Thanks.

-Fenghua
