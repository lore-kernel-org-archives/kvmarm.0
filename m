Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010035.outbound.protection.outlook.com [52.101.61.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5A51A9FAF
	for <kvmarm@lists.linux.dev>; Sun,  1 Mar 2026 17:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772386092; cv=fail; b=iRL0tmoEzGEoZiZREKknmCF5F76HZfEr7MJiOMttj5feKGomfP9i8xyBdhcliVr/lmyywAvJ9bXTz8GbprPHX4XQtYDZDuncSnqLrAEJbWHk7Bk+AcLee4645iaVOQpJwZQXq5jUXp/mT4crh8ez3nuhv477Sk3zONroFc3l/kM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772386092; c=relaxed/simple;
	bh=h6Rxv6GIisuKVjMe8fYMXpDFCCriXI0yVcOyxWUv6oA=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nVAaW9Dh9qo7eQmFsDzMlOGbjoH5bz3T1u5VWTrTCmlDIh6pp1yOm3tgZDEMA8M9XsZR5MDlKqJyNWJ7c7/OEBinQTfD4DiLBV0csR8nGVW1EpUWXF2Id8zpJn2sggWMXMgCQ4zP34Oi0BtuGN2twihSI6KUyplpysGAsuJWCyA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DN9vrBHo; arc=fail smtp.client-ip=52.101.61.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DN9vrBHo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UTH6sUihP/x0gI4/e/+xmsB5XPWdAVC+9eUoDYRcZC1pUuv2RHiUZeQO5nI2qmgZISisUXMkglIvwynie9dk0Dc9PxBp/tNGVaFgEejHhn+sepym072Fiy+CX16+PP27QmO9gfWYvRhbSw1OouZHMfuG2iG9iBoKZUnRQ+GYonjjaFVJRggIGhyCkq7ordbzwY+YIm2SyIMxfzkOzYQOaUfKsXmzcEaahqpAr6yE7si9EdFjXjEEqhQUEMQ32hTN4ALOSuvl7WBFDOC2jss9H+ZYaHj1Rs6WQamL3Hk8+4nx/nfqzYN+gKLVB+HM0RLf/eUHVu7J+X3F4JuINoe1Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZI125X0pZl7T949TApLwpJTaH2w7GzEKniWauhLrgoM=;
 b=RTneajgsPwMZFyDi4rwdfdw9/FGSa53D8of9aRC00yiAcABRMwAUxGhw2vNOi4NKEM7PUFBmckKUz/0KYNwiUpgsloUAxrNOHe4vPgccqNE1bsdslms6JMuYqQzpdbstVpd+yYz/hyNQAEJTjRNO/Twr+jUkAaZk2RJUrjWrFzMqDCIEtEEFxKPE9QIWk6LLza2PLHPmAxxNmRF3deyXVzjVhCEBWtsVt5voHeR4lmH5Q9DsiBNuWV+p5ViCzZkaOzdVPNGaCEEX18hFoFKuoveeqi3U5g8orUJnbyFR/gl4in1nJi7LtBdeBzWzHBwuqHqDgnuGAgj+I4tlTXXRSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZI125X0pZl7T949TApLwpJTaH2w7GzEKniWauhLrgoM=;
 b=DN9vrBHotOMXATlfd/4yzPXPZ10XmmLGHtjexhSWFfdfXImP1tkxGbb23gOGTfcKQ91j0OMOEzNvv9vpmO8lKQ+/9t71WMrf6ow9GNJB03MWS8w/LOul15klcOq/bmhC8UWSgWQaR3xE8w/7xeXEy4BoIV8TVTG8SjjuJ3Kc8YiaebQSwycY/GN4MPQQZ617ZA0ZSVVaGlfCrwxGoSesNA0AQsDkY+7EzcAbItW1tkyBMFKub+01dZP+MfNu1dxoFbkwVLsCQinDMoNCbrcMShZhKi4EhgKuePt51SRneIvi6G7qAWiJwv2CZRsLtn9kggH/23xNaS0tsiogufBDcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 MN0PR12MB6296.namprd12.prod.outlook.com (2603:10b6:208:3d3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.20; Sun, 1 Mar 2026 17:28:05 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::aa9a:b827:90c6:506b]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::aa9a:b827:90c6:506b%6]) with mapi id 15.20.9654.007; Sun, 1 Mar 2026
 17:28:05 +0000
Message-ID: <7e496cb6-ab31-4a89-9630-0fa2e6b3607b@nvidia.com>
Date: Sun, 1 Mar 2026 09:28:02 -0800
User-Agent: Mozilla Thunderbird
From: Fenghua Yu <fenghuay@nvidia.com>
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
Content-Language: en-US
In-Reply-To: <20260224175720.2663924-39-ben.horgan@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0099.namprd05.prod.outlook.com
 (2603:10b6:a03:334::14) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|MN0PR12MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: cf21f09b-e786-4247-9833-08de77b7e5e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	3vGlHHxxo2VO057uAViPI/0Iq4jgqEhLaKSSbhC3UJ32lSaV4Fe+xR7iLTQQIh0j2BK3ljY/pyowQp7xdIyV4lxrWAopfIU9b5CQXgw7N41/GSO4alG9tYZY5M0Ugqm2mmv5SioiFel8iM1TS8HMuvxdLz78oUtcIdNkQyQtW9sGquVMm2vv5mO9m5Q7KAJ69BWiNVvmW5couDNjMhEZIaFtfMkrx0bwz66hPEc5gvi3D4k3yeZo7qfsfrKir+Vcyh8nxWSqbYCZ4c2Yz6oMJihH30fYBv1XFof13c7wst+sldpokQpKx3/dLL5vQtcsQgA8cP94Xifd7sXxCQuzCQUZV6euF9bxAIqzh+i1aN+eIifPl5VZkHRlN8mNE3xjWVlZJe62261gOvBJq7E0r71SA0zBefJ9oMT+B7K9BOxppOf2Kv/5z1rVD1nDUZ+3KqZ29iLWty6mCn/GaRPwlZoeV9Ku0IRXT9d/gbYV2o1+Exm3y96gPKrJzpLsCd7Sp08lhRG6+2x5aXR02DohAr6JOmvzoxJLPAKowjtd56wqNupIlxzhSkySEWeePXuRdlrn5XJULJnjn9N9hQq4Re5PGJo+20q55EsmTgAUo536xth4MQ5oJthaH39WRcgELAkBXWfmsW4ouvyqt2oDj7DnbY77CsIQqUnEV1vDg5QurgLPFzAklwCIIN29aEiW08O31e5urcQBvAYEnJchlQeY8bgubriDqC4ECvf8BSs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OG45L3BxdGthMjUvUDBFY1ZYbVdXRkgzVjZTYzZ2ZGFMbk9rUnJaZGxKUHlz?=
 =?utf-8?B?eTEyTHBqZCtSYmlneE4wcnZncE4vOGVBeTFPazZlelpMM1ZWTzZLQk0yNzFI?=
 =?utf-8?B?VTBSN0U2L20vd0hmVU8xRDU5WTV6YjNLQmVaa2llTXNmejhKNFdoWTFjb3hs?=
 =?utf-8?B?elVvQVE3T1ZOaW1qR2ZDTVlaZnovSElrd2t2N1NmdDEzSWx1MXVJT1JJUGxl?=
 =?utf-8?B?eE9SeStaeU5CbHQ4Z2NtUkdTSWNBbzFLd0pkQWJHdktSUUdRVzlwODhLTVlZ?=
 =?utf-8?B?dkZROUg2cXVCekc3MkJ2N0VSWnlxTXJUckFpRVhkQkVmeFpQcFZJYUNINTQ1?=
 =?utf-8?B?MTBlZStmbGFjK0FrSURhNmlRUzNlK2RuYXpyRVU3MVdaaTdDWUMwajJPMitM?=
 =?utf-8?B?UkZCM1JLZ2FkNVlQdXNhRHdEdWZydnpuWmNUNk9CZWRsL1JDRzIyM0FiSElX?=
 =?utf-8?B?RTk0VXR5Z2ovTHpzN3gwRUttcGYybTkzOUFrV0JHTkZLandPRGRpMXFrbUxG?=
 =?utf-8?B?Syt6bTFpOWhSOG4xUy9vcUZZUGtZMkc2ZGd4S1NGeDlsOUtuYk5wTWJRcUJV?=
 =?utf-8?B?RnZNakc3NXJVRDlDNk5YVEdCQzZxMHJUelIzMnd5RGhrQU9IdGxESzNjMW11?=
 =?utf-8?B?b2Y2M1FvcnpaQnFCUCtqenRrZlU1dnFQT1FwZGNPd09wblNxRDcyZzUzQXB1?=
 =?utf-8?B?SFZ4ZHRUS2h2NlI4REFOakJZejhMZ1dTZnVtZk5IVENtTWdrcFRkald3TU5S?=
 =?utf-8?B?UndmRStlV2FxUitUOHQvcWNCVkJocjdVMzZ2MlJ3Z1J4aStJWE9MNkpobkZ1?=
 =?utf-8?B?QnJpOUE0eStQNjNqUzhlUXJ3L2pIbE5FVko0QmZobGUybE5OQWZTVEkyWXAz?=
 =?utf-8?B?QVVpTUY5MjhoY090NFhXZFhja2ZWL01DRFdTbEpva0tiN0xrUXJuUDRrV1Vm?=
 =?utf-8?B?MlZ6L2h6eVJqcDlNa2pSZFc3RFV0N2JIaWhBSTgwNXduelFYY2htaCtDTk5L?=
 =?utf-8?B?emdLd3ptSXRCL3N2MzhoaVplbStUcnliSTFpZ3dodVhEcWFFL25YNkQ0TElS?=
 =?utf-8?B?ZnNNVFhtdEpKbWcvaTcwRFdhWjJOaTNqNmhSL3BYSzZ4RW5vNC9GbHU4aXpJ?=
 =?utf-8?B?THFvc1RNc0RQMWJYQ05WT2xEaUpFSGx6MmpNVGV0ZEl2akc5cCtVakE3OWlu?=
 =?utf-8?B?eWJ0cjB1b1F5QVU5S0RBWUQxOHJaVnJ6NGwvSmcxUlA0VXVzbkwyNDJOQlZi?=
 =?utf-8?B?QjE0QVNzNWVQS1ZZaVJDc29qS0twYXdaeXFJZkNrcFk3em9WRmVTZ1NsSlBv?=
 =?utf-8?B?dHh6VmRwelFGWVNBak5SaUVndXpMZUhMUHZzUGVBczh6MVR4dktHdTh6d1N4?=
 =?utf-8?B?dUhYbHA0UUIxVzFMYnRMbE12WFhrZERkdEMrdlZvVnMvNEVFS3JVNjZNdk5r?=
 =?utf-8?B?eUNUemtIVEc4TUlVTUVVN0YwMzBKVjFjWkFneVZJWTdrY3ArMDE4NGNYekFF?=
 =?utf-8?B?UkxFUjVUZ3ZQNWpyZGxSemVGdEZBYStIcjNXRllrK0I1VkxaWWtqcUJjRXVS?=
 =?utf-8?B?alBVWXhxdkowY3NINnFhTjluT01vdE1NaHVocS9qc0Ftd292TXY4MXljNnpl?=
 =?utf-8?B?azUzbXdhd0p2ek5HTUZTcWxOMFYrQnUrTVZpR0VLRDhxcWlWTEhEOUQ5VFg3?=
 =?utf-8?B?TjRJQ3hOZ1pQSmFXa1dQT2lNKzFQMTY1Nngyc2k2dmtRaTI5MEQ3M0w4Ukt0?=
 =?utf-8?B?VmcyUTlubzZEenpmMjB1c1I2VGpMa1RTL2tGSUFTbVd5YWhHRnFESmtHTHpr?=
 =?utf-8?B?a21Sa01wWUU2N1RxTVFySHdmb1gvT0I2Y0QweFJma1ZpYjgrczNrNzJxRUZ4?=
 =?utf-8?B?WkxEalM2d1dzTko2eWFqUWs0VUxFcDMxV1FtREVpSFVjdm50U25PZUh6TUxP?=
 =?utf-8?B?d05qWFZiVThxUUVWOFZKblMvbmVNQ3FlRFhEY1JndnBia3RnSlVXc09DZjVL?=
 =?utf-8?B?d1VZYzNKNlBZVDhna0sxejQ5TmswNksrSFdpTkVLbTJwVXdxdHVHV28xVEJU?=
 =?utf-8?B?ZGRvbi9rSGIvVzUySDZjTENUOTNxL2tFQU9oSXFNd3l0SWZYb1NlRTJ2dExI?=
 =?utf-8?B?Z3hzaTZ4dWkrdFlWT0Y2V2RpWmY1aTFPWnI2aUV4Vm5pMGlNWTN5MERxMTll?=
 =?utf-8?B?a1JtUmFpdVYrMGJ5S3pvSDVSSjY4OUMxK3E0WkdqeSsyRjloZ2Y3YkdXLzBM?=
 =?utf-8?B?V3RiU0c5Z2VINFlyNU8vOW9ydUZIT2xMY2RDbEpWSXppR2lLZ2FFR01SQS9G?=
 =?utf-8?B?WC9RWm5kZW1WR2tSOFpnYWJTVy9HK0lqUXFkY20veFRTTnVzR00wQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf21f09b-e786-4247-9833-08de77b7e5e3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2026 17:28:05.4808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DHJzutU0fBSgAd7vZy/5b+839vFfQvNM17yiEnHTAUsTtyyKgW9ZHXR76amLR8sWw3VTJ57ujE1OSbMA/tGEbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6296

Hi, Ben,

On 2/24/26 09:57, Ben Horgan wrote:
> From: Shanker Donthineni <sdonthineni@nvidia.com>
> 
> In the T241 implementation of memory-bandwidth partitioning, in the absence
> of contention for bandwidth, the minimum bandwidth setting can affect the
> amount of achieved bandwidth. Specifically, the achieved bandwidth in the
> absence of contention can settle to any value between the values of
> MPAMCFG_MBW_MIN and MPAMCFG_MBW_MAX.  Also, if MPAMCFG_MBW_MIN is set
> zero (below 0.78125%), once a core enters a throttled state, it will never
> leave that state.
> 
> The first issue is not a concern if the MPAM software allows to program
> MPAMCFG_MBW_MIN through the sysfs interface. This patch ensures program
> MBW_MIN=1 (0.78125%) whenever MPAMCFG_MBW_MIN=0 is programmed.
> 
> In the scenario where the resctrl doesn't support the MBW_MIN interface via
> sysfs, to achieve bandwidth closer to MBW_MAX in the absence of contention,
> software should configure a relatively narrow gap between MBW_MIN and
> MBW_MAX. The recommendation is to use a 5% gap to mitigate the problem.
> 
> Clear the feature MBW_MIN feature from the class to ensure we don't
> accidentally change behaviour when resctrl adds support for a MBW_MIN
> interface.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>

This patch itself is good.

Please check the following comments.

> ---
> [ morse: Added as second quirk, adapted to use the new intermediate values
> in mpam_extend_config() ]
> 
> Changes since rfc:
> MPAM_IIDR_NVIDIA_T421 -> MPAM_IIDR_NVIDIA_T241
> Handling when reset_mbw_min is set
> 
> Changes since v3:
> Move the 5% gap policy back here
> Clear mbw_min feature in class
> ---
>   Documentation/arch/arm64/silicon-errata.rst |  2 +
>   drivers/resctrl/mpam_devices.c              | 50 +++++++++++++++++++--
>   drivers/resctrl/mpam_internal.h             |  1 +
>   3 files changed, 50 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
> index a65620f98e3a..a4b246655e37 100644
> --- a/Documentation/arch/arm64/silicon-errata.rst
> +++ b/Documentation/arch/arm64/silicon-errata.rst
> @@ -249,6 +249,8 @@ stable kernels.
>   +----------------+-----------------+-----------------+-----------------------------+
>   | NVIDIA         | T241 MPAM       | T241-MPAM-1     | N/A                         |
>   +----------------+-----------------+-----------------+-----------------------------+
> +| NVIDIA         | T241 MPAM       | T241-MPAM-4     | N/A                         |
> ++----------------+-----------------+-----------------+-----------------------------+
>   +----------------+-----------------+-----------------+-----------------------------+
>   | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585         |
>   +----------------+-----------------+-----------------+-----------------------------+
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index 08cb080592d9..8f44e9dee207 100644
> --- a/drivers/resctrl/mpam_devices.c
> +++ b/drivers/resctrl/mpam_devices.c
> @@ -679,6 +679,12 @@ static const struct mpam_quirk mpam_quirks[] = {
>   	.iidr_mask  = MPAM_IIDR_MATCH_ONE,
>   	.workaround = T241_SCRUB_SHADOW_REGS,
>   	},
> +	{
> +	/* NVIDIA t241 erratum T241-MPAM-4 */
> +	.iidr       = MPAM_IIDR_NVIDIA_T241,
> +	.iidr_mask  = MPAM_IIDR_MATCH_ONE,
> +	.workaround = T241_FORCE_MBW_MIN_TO_ONE,
> +	},
>   	{ NULL } /* Sentinel */
>   };
>   
> @@ -1464,6 +1470,31 @@ static void mpam_quirk_post_config_change(struct mpam_msc_ris *ris, u16 partid,
>   		mpam_apply_t241_erratum(ris, partid);
>   }
>   
> +static u16 mpam_wa_t241_force_mbw_min_to_one(struct mpam_props *props)
> +{
> +	u16 max_hw_value, min_hw_granule, res0_bits;
> +
> +	res0_bits = 16 - props->bwa_wd;
> +	max_hw_value = ((1 << props->bwa_wd) - 1) << res0_bits;
> +	min_hw_granule = ~max_hw_value;
> +
> +	return min_hw_granule + 1;
> +}
> +
> +static u16 mpam_wa_t241_calc_min_from_max(struct mpam_config *cfg)
> +{
> +	u16 val = 0;
> +
> +	if (mpam_has_feature(mpam_feat_mbw_max, cfg)) {

But the problem is mpam_feat_mbw_max feature is NOT set in cfg.

> +		u16 delta = ((5 * MPAMCFG_MBW_MAX_MAX) / 100) - 1;
> +
> +		if (cfg->mbw_max > delta)
> +			val = cfg->mbw_max - delta;
> +	}
> +
> +	return val;

So 0 is always returned.

The workaround will set mbw_min as 1% which is too small and will cause 
performance degradation, e.g. about 20% degradation on some benchmarks.

This patch itself doesn't have any issue.

The issue is the mbw_max feature bit in cfg is not set.
This is a legacy issue, not introduced by this patch set.

Here is a fix patch for the issue:
https://lore.kernel.org/lkml/20260301171829.1357886-1-fenghuay@nvidia.com/T/#u

If the fix patch is good, could you please add it into the next version 
of this series?

Thanks.

-Fenghua
