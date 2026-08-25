Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010040.outbound.protection.outlook.com [52.101.56.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0A135AC37;
	Tue, 25 Aug 2026 21:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787691624; cv=fail; b=pAinaBwdMDw2Jiu8st87X6CmLbjB6Ij/7FlSLOdh1GSK5Ur0lHU2looLKLX7hi3Uo7eQiVe8OSHMEzFPLcRcpMwjoZVqfhKzg06yzaSnKaFhEgDAFASSQWfGtP3XxJcGcGW+ZsF/9ocTDoxztiGYw9JijwCWe7UBTA/xUEcPSes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787691624; c=relaxed/simple;
	bh=70t4Ry8XrPQoznK0Gj/ZOSMMiwcXINFz0PhCbd8vzok=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=eBySVEJZ7q6HgA8VLV37laHGFbOgbrL4t7J71Rvh8oyLFwVscJW304KRrIVCEk8mRgt/HpXYKJ/buPhIAVjVpDvGIJZ6NvH4Ivshy+HVfeEaRLdKc8MPuS1/82KHEGxcLrGeeJD/l+Nlrm0m6YeN57qnBfw/Ih5UsIWSow/Dd/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mMB8xeaq; arc=fail smtp.client-ip=52.101.56.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mMB8xeaq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vsIy+r8v6zYAIJuLWtbZ/QRQGTFh4ByuDobubj8G1v+YiRWFJDhb0tEFWu31mE4R60c+ovD9lIBwvHouptwpWSMypbf+BNAd7/RrOXayASS4q+fkYNDfnAY/mmKz0lPrmpNNq8P7XuZITFF3wCaba7cZs3TPgpIzHPq/LSUyIHKVYyifg21+/t6qe9U2aWmUXMPcFHcjFkwnXAuFuCITK+BATfiMa5cRju/Z9RAxXYYDK2ZLu1M4staF4Kd4xq4GD2EkPj9MKsRJ13qLsbq7uMwevtEs/gbgm0Nit3P07F/qNGDDqhHqTiMH2gFDdj1w0LXAIow0X+v2OJtlH8yjVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sjq6pRRY1QJJLNzKU4SeLQ7Lw7JfcEqzjHLp8O2VRSU=;
 b=dQ0dLFDQKl3cN8+TgLRfupe3/0TLmgvSmovXA/uAsCV+V6mK/9d1dVUWwuYFE6Co3Ha+MN5Z4hWHIVU85clTigsczu0jozwj8Hc8/VNSTEYIEM8Ze2Zno06McxIBOOWQPHE3Gu2r75MJ0sQ6nuDkwvx+NXkjxG/w287VltXSDwa0feSC/kPYTcyn8kMzOfiSQUvNWrgTn2fG5zINFrMj2+QbUXFQOX/qmSdgsspMHCdICX8gkxuM2OZVX/TGUZYXPL+7JZ2LklXsU1FeW94rJJYTaFnDupN6t8ECjbtbyx1QZTHQFe3CROzQdRJDYWU3syeiHdK14ixdisJIvJ912w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sjq6pRRY1QJJLNzKU4SeLQ7Lw7JfcEqzjHLp8O2VRSU=;
 b=mMB8xeaqLDleQUb5C+FBIqPZYFJhvcv3LIo23P99ILJ0VALZftU0kRSQC9eGeeNtU1DA92K9j6AovuZSFnNYGNvlKaIFwX/D36BaOckrmXLxMlDosqF8QYx0pGm7xpC5kbTj9sVs7gcUOnhfa0RSxM457NYDkySogNQ8nMTzv6XKMoFiFfg4+4C7ombmRWS8VtGaqRDQg+rq7+qOyJmgKIVVkhWvcfCBJ/nP7oqh2nwdD2AGEfj3U9C6/Vc+AUfXWqWo1xXXmJRGlXmMAX1DE2fl/d0D2gyMeeFJ9yjPw4f1XHHkt95Q8WoXrKJd5zYYAF2WO+wly/z7gQ+rzFJ2NQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY8PR12MB8215.namprd12.prod.outlook.com (2603:10b6:930:77::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Tue, 25 Aug
 2026 20:59:53 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0339.012; Tue, 25 Aug 2026
 20:59:53 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 05/24] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, iommu@lists.linux.dev, catalin.marinas@arm.com, 
 will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
 suzuki.poulose@arm.com, yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, 
 mark.rutland@arm.com, qperret@google.com, tabba@google.com, 
 vdonnefort@google.com, sebastianene@google.com, keirf@google.com
In-Reply-To: <20260715115906.2664882-6-smostafa@google.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <20260715115906.2664882-6-smostafa@google.com>
Date: Tue, 25 Aug 2026 17:59:50 -0300
Message-Id: <178769159057.3356902.8176677714818911833.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: BN9P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY8PR12MB8215:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ca59891-4cb6-4eac-19ae-08df02ebcf70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|23010399003|11063799006|10067099003|4143699003|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	1VFzlhDlfif10ZgDieiZj8yRKZoOaC/chJht4Rnyl2WsX2ELH5Nn25pnxF2m++4rqMyXPb81GFjDzu8GOW9kOiu4otSktHI0ozIIGbqDQMXpMZwalOYUj2/ecY0+Ac9iefhWnN5Q0VUHOAtprJ7v+0F7nV9YdmoNybUDRDvKmQJlx/kQpLWAbCTEujQSmEAK8KFFQ8SaksJAVbeikm3UI19A1nQ3GsNh+XchPOwYx9n1MgF7NMNLQxOQdhOyRaxKMbIPE0Yr6pdBXlKZkudt0UxThdW6djvNqa4dy3o3/GgDizC5UMoyPLfF3J90bOhanGr6b9sAdN35Phw/S8PZ42lskPw7rEXunu55KZ8YA79LrRI75f0rgrwpGrmrP6gNj3STn9lUlw0z1rb4ArVLGPR8JjT99UE4VgVADCvmw9XXS1V20d2ByENnS4P7jCiLlujqgg2WDo8njSsgO9VGOIp2gjfD9vh8b6BndlROWO5pAszWBzn1Tjo70xVinDAH1EmJx/ILB01EdXXkU5zLJKYejJzvDVOK0x5P8tK9uOTS8100/FM27YbYOYbH1NeVa2bAcp486ozw2Yxwult2AIvwugBlnwuXA4CCVY1oy8f5FrbL251+1/xD8Sw8T+mLt9i8jcmn+mlar/JmbkfO2r2SIvpGmbtgUPdguOaXwI8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(23010399003)(11063799006)(10067099003)(4143699003)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlV5TEl2MWMzYWFGejdxd1FQWldsVWtjeVd0TGhQSG9Ic2RselQ0VHVMUlVL?=
 =?utf-8?B?djRWZm92Y0VaS0QvMTlVNVZVOVJhNjVCZnc1V0NOWkQ5S3AvRCtsMUhsMWNX?=
 =?utf-8?B?ZjdxdFNReUxRUzVNeVl3TnBwOVJnRGIvR2ZPQ3U4Ylptd0RjQlYvaXVDNUNX?=
 =?utf-8?B?K3I0N0RTRUlKUTNNN1ZqNGhFajBURHA1Z2FWbjB6aXBPcStDMGRIRksvaVJR?=
 =?utf-8?B?alhGcFJCSVl1OSt3T0NpL2NUS2R6TXUrUjdKbDhoWThvLzVwMHVocEsxbGgx?=
 =?utf-8?B?Mmxod0cwMVAwQndhWHRHMklhZ2lQdDZreGxWWkNxVmNhR2JoNHU5MzVGTi9J?=
 =?utf-8?B?dVdBZkRhK0hZckpOZG94SVdIWUFUN3NHS3pSRWF4NitjY3B6WVVDL0xUc1dB?=
 =?utf-8?B?WXZEaGlCNlJaQnZRbGMwd2tFcXdidUdyUTFYdGplMFlYTU16YXFVR3YrMVBt?=
 =?utf-8?B?NjQzZTRqNGZUSGQ5Z2NQZ29mdUdyY0R2b3pQQjBNMjNNYlh5QnVUR3doOGow?=
 =?utf-8?B?Mjl3MjUxQmYvUWcveDlTM0xYWHhVbEMyUmkxWU10YzdiYTc0RWU2ajV0RWpp?=
 =?utf-8?B?OWVZRFlZQ1ZsMno1dzE2OTN3UUgwcllTK1FTK1RMRlJHcDRCSENFeWVTZFpP?=
 =?utf-8?B?U0xPMklvV0ZwYUlCZDhpeEpsZ1pIdGFtRFVHMCttdjRlV3Bha3IzWlpOOWpF?=
 =?utf-8?B?cE5sc1g2ekxVS01BU3UvQzdGSWpBLzk1OWl2OUUyeHc2Y0swSHI3NFZzYVNX?=
 =?utf-8?B?bElMUEJkdmNqZlM3WDlSY2k4dXA1SlFEUGtNN0lLcU0waWRxdFdYVk0vZTAy?=
 =?utf-8?B?bUliUjgyajRlc1ExQ2dqMWM3N1doMTVteDFyL3hpN21xRW4wSFZUVGpaNk0z?=
 =?utf-8?B?Z0RuM2oveThPMzZhVko1Y1JvdXl3aWhXa1FvczVpOHdUalhVQnFMRnJ4U01T?=
 =?utf-8?B?YlZUTG9vSWoxRHhDd0p3Y2xaS21sNnUzUFkzcWtQeE9zNkFUamQ5Q3l6Wkph?=
 =?utf-8?B?UC8rWDYvdllsZzZ1VWRORzRwVXltRjdzU281M0hKUXJYVnJsOEk4b3FvdFhI?=
 =?utf-8?B?RGpkQktCaTZEcWx6YzlvYnFRM3Zia2hYdit2ZnhpUU1INmxic01IRUU5SmVj?=
 =?utf-8?B?dmtiQWd5VGI3UVF2cm4xaEh2MG02amVXdUFOVUluZzRNRUd4Nm9XK28xVXRF?=
 =?utf-8?B?Wms2K0pSK0M5Q0d6czFTS1BOWEF6TWZQZ2loN1FsRGQ1Si9NZDR1L3F3anR5?=
 =?utf-8?B?dGk4YkJuZjl4RTE0M2VUTDRhUmNlL3F0V09PWnFWbkJzMDhFd3NVWnRHK29R?=
 =?utf-8?B?U09XYlA4aURCQ0lFM3NVL3poRlJsNUt3WjRYSEdaTmhldmFXWFNZM3pjS1Jo?=
 =?utf-8?B?UjR3TzNwTkZuYnc5WWRqWnhiallPcVY5OURMQXJUdm1ZakZzUlVoWWEvc3Zn?=
 =?utf-8?B?bEdiSWVwL3ZkcG9RVnFGend3ajBHS3BGbDA2QVNwcXNLNjR3SXRsV2piN3lK?=
 =?utf-8?B?MkVQbFRXeHRjNmltRDlHajVuMVpqY2duVmFveTNTZHUwaFFkOGRBVFFIbjZ0?=
 =?utf-8?B?ekpGNW16WFRhSmNGdHJOZ0JHSFh0dUVxSXBaR25XbXlLWVh6dWFXSHQ0ZlFj?=
 =?utf-8?B?YkMwaDRVRWhYZXRjSTFMR2JDbXJ4NTl2aEhWSjluOXpxUUVKaG9wRVl3RG9C?=
 =?utf-8?B?c0tJNkV6MDdOd25QSVZ1OHNCeHBhSmtBamZDcE0ybGYvSC9RZk5XalA1M3J4?=
 =?utf-8?B?djE2NFh2SVdZQUJFRkl4cFBTSTZwU2E3eVh1eXp1MVZBOTRsQm5wV0FBTSsy?=
 =?utf-8?B?eDBnQTVhWithajVzWnYxcmVXRzBONmZyZERTQjIxMHhTZlE0S3doSGl6emRP?=
 =?utf-8?B?OWlDalExTVI4TWpHOWlrVDRYTzJHK0hDbXVEWi9YWlNMTUQyMmJWcWRmZVVX?=
 =?utf-8?B?aTZaREd0WlpFSHQzWUxHYkJmZ1hQdVVKbkVtc2VnL2pSS0NtckczT0ZDK3R0?=
 =?utf-8?B?dTlZSVJ6UE9xVWMrMW93cVZ2MnE4VkN6RWpWSi9OWVB2cjg0R1lzR2Q1QWZl?=
 =?utf-8?B?WG93S2ZqWExZb2hJKzZkR2xrMjNJVDdPWHBuUm1lYk9zTWVRUnA5ajREanlq?=
 =?utf-8?B?YTh0YjlxUkdKZjFTOXZleUR0c1dKYTlKd2JKdE0zNnYzM2pRTVRiQUdZdXky?=
 =?utf-8?B?ZDllZDd0aWQ0b1VEdDltU25zbG11T2l3MjlVK0Mya2oxa2xPN3BSN0Q5MTdX?=
 =?utf-8?B?cWNGbS95TFgxaDNZOXJUV1hZKy9BS0NRMWx0cWdPb3BrcmVFd2l2bVlFb2xh?=
 =?utf-8?Q?gSKQZ3F6rU8O0DodUk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca59891-4cb6-4eac-19ae-08df02ebcf70
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 20:59:53.2779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zCZOBzJU1e8dW6JvxxeBmLOc8+layVsxGuFksGJ9WiKP2hdAZyu+SNcmiKy67AmC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8215

> [ ... 21 lines skipped ... ]
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
> @@ -0,0 +1,184 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2015 ARM Limited
> + *
> + * Author: Will Deacon <will.deacon@arm.com>
> + * Arm SMMUv3 driver functions shared with hypervisor.
> + */
> +
> +#include "arm-smmu-v3.h"
> +#include <asm-generic/errno-base.h>
> +
> +#include <linux/string.h>
> +
> +u32 smmu_idr0_features(u32 reg)
> +{

I think you should do more to make this shared C file usable by both
compiles with more of the infrastructure available.

For instance, something like this at the top:

 #ifdef __KVM_NVHE_HYPERVISOR__
 #include "pkvm/arm_smmu_v3.h"
 #define arm_smmu_device  hyp_arm_smmu_v3_device
 #else
 #include "arm-smmu-v3.h"
 #endif

(heh you used _ and the driver uses - in file names)

Then the existing code using 'arm_smmu_device' just works fine since
the hyp version has the same structure members. Now just move the code
as-is.

Otherwise we still have alot of cut and paste duplication:

	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR0);

	smmu->features |= smmu_idr0_features(reg);
	if (!(smmu->features & (ARM_SMMU_FEAT_TT_LE | ARM_SMMU_FEAT_TT_BE))) {
		dev_err(smmu->dev, "unknown/unsupported TT endianness!\n");
		return -ENXIO;
	}

vs

	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR0);

	smmu->features |= smmu_idr0_features(reg);
	if (!(smmu->features & (ARM_SMMU_FEAT_TT_LE | ARM_SMMU_FEAT_TT_BE)))
		return -ENXIO;

Then you can put the prior patches tlbi stuff here instead of the
header file, which is important because after I get the CONT and
errata stuff worked in it becomes really quite big.

-- 
Jason
