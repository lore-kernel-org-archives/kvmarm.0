Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012053.outbound.protection.outlook.com [52.101.43.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9748D560AA3;
	Tue, 22 Sep 2026 21:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790113718; cv=fail; b=rSKhQiEcc55C+3LdIOfX58Xf64obGiDEet5nUSiBa3EBf8/RuZsrEYQKQ2QoLVmbT9HuIZ4FLz31DyBBy5exvVSpQ1gHDfcHukfb0C60+iGTGzh7KaXMcTwi62IHNARdZpC8izFcKTCSz9suw7F7XriAiEHyIB9t4NXYturoHPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790113718; c=relaxed/simple;
	bh=LQ4ec0VAayNBtG3ug3oMCmNtg0EukNzf7c/106pdLPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BmH7MCDJQG7oVgu6rs1bO3BcB8wtSOdZGNIW5kPsjQ0OmE/qkCp4aDMZgop2NJI8V4C8MniySzt3bYsoogX+J3VRgRGLRvguFO3PWoUO3IXsodSRmWbvt49NQvWFcGMzpZLc82i5qIXly4QLoqwz05CoEkdMJ/z0rFsiS3LWi2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=T5Bret2U; arc=fail smtp.client-ip=52.101.43.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="T5Bret2U"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i6EtBEfwXX+ch6j/kw8c1haKax45/LAGwEp4YLnOApkHl+/ktlxXinRJWgySFnqpWfAKbJ4ajHWCRgPg1DIJILbjYVqy1AhkPS/B5Pj9oaRDzBkarp8JkeWPUyoJAtbo7qBEhqUG/7OXifMhVgOxpJ/hB7DqAkC+Z5z41uewVyHQApxCmvZ7VxIwOwGPjvhoMMPegmjzZCeZWyM2V6AIG480J+luLtkcTJ4g4x7hOXJQFaa1p0XlJzFsha8iS+q8inppD7DJkk84AIThsJRmUrGjThsHrnbcBolQqNSXFQc8Rylf4Nh10USzHY9h0juwEMgdmim6TPVDaMNBtOt10A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eu7Y5n4zuyCKR+jeCYxdl9aFJVXvKKXpXSxo02vSIYg=;
 b=L/oJhLCIx8XLHJnWxSSIpHmdPAPifj2jkRlF1+46aDAtDWMiSH+HTdD5TGDQGQ4oLu+GhG948mQsPDz6fHCiGLl0rE96vlZN8XZTD/7A4LxrjXrE4sXHRIFHm5j8jIVqw2kuVI6NQYzUmwtQFcB2/KeffYT2mLb1hMJZ/uUdlvqGO4Xm3HR6mKs023FbwxgPhxHGmZrMnytgvnm0oyoCHQoP1jJhcQ5LUO2mbTCz6mLXoQRIMrcs42oJOtsNhCF/eL7OkU5Sh2Sl0ytdAULYmNxLJMagUvVRIM/LdkpuEIZ9/PnIdKDpA2Myjq14hruwdHEezPaEnNBdTOA3FsYQgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eu7Y5n4zuyCKR+jeCYxdl9aFJVXvKKXpXSxo02vSIYg=;
 b=T5Bret2USO65f9YorCYQl0Jr/fCmvmme7LjQs5YXZv0mXAupgi+4fUdNcz3zrMOJeBqFzDesShCdt52HgBDe8zsuyDAV4SYza5dZgQlDT6NWy8MmHfsMSeYMXMX0zyB7zE5KAY1kIYkncLFibVGmTQsScz+2GW5wIxnRD5V+8NUXHeA2A/Lllf83UY2lXaeh4L7GlD5lLRCXTULL160iqzzH8nZmfs3vnuebY/unCQThSnkBVR7U07FoMC9nV0MZx422LZbS6b3EqNaSQU8C6lOlNCJqEnpGTzMF7svUwYxeWUJocUEqLs5kLNxb9pBPBQb3YWdfEHRlEJfG4l1SxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH0PR12MB7488.namprd12.prod.outlook.com
 (2603:10b6:510:1e9::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Tue, 22 Sep
 2026 21:48:20 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.012; Tue, 22 Sep 2026
 21:48:20 +0000
Date: Tue, 22 Sep 2026 18:48:18 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Mostafa Saleh <smostafa@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com, vdonnefort@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v8 04/25] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
Message-ID: <20260922214818.GA2545495@nvidia.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-5-smostafa@google.com>
 <arLa0E3xq5dGuPpd@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arLa0E3xq5dGuPpd@nvidia.com>
X-ClientProxiedBy: PH0PR07CA0063.namprd07.prod.outlook.com
 (2603:10b6:510:f::8) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH0PR12MB7488:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a88cdc9-907d-4bcc-bed0-08df18f337a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	jSTBoVgSB0yzI7duV/WvfX9tOj5loX94W6eKM1vkwTfgY1vY29g6Y/ckRg/Nm3tQtKUsI2ur+dewM3J+1lrsdTJg425Ob2QQkJxX2jbNT+khWXYW2C+tuc5CIr52TXdpKCybNj4MvICD+5rh1HL3HOFqUBpej/7EbSJDn9ET/Hu8WsehsnOu3C3xE9BUpFons69DaW6PUNvF0WdBBpP4+wuADqDxk6A9CPQURSywbbSg5dkh5k0Jjt0QBbsqo5g2jyYdPULx1fwosyZRc5tiZ964wX5rXIb8ZDlJB4aU7TlRAWud66JjZb56VyPZd2tsDrB3dRGeC2d+otlptBfdFaxtntX72ghDGwf7hQzYMkcb5CDyM7QMPJQUlTAv0xrlaScnzEZy1+KNanMND3qDlTG8K1VgaKKHdPWsOJeUWMMdwvZwih/PHWnRM0+gigxArEh2GrvQARpjc2APWkLmpP6ocKdBa0NwzfMHsL2mv5CmU0bS3PnJP2oxRNJBVqmrGgL5NtG9F7yf2+kWa4IfEBtiObjKrm0MiirEEgdx88+AR9j7P745K670wfY2i6pGu+BG9HFRoT9rVU5pMezXjVkXq3xLoTQvV8CNNPs3+HWB8hTG66zzPzV/+k0R+jbKL5GDs/Jjvh6DHnIVuDdjT89Gb5kxQ0m2o1COLVHT/FI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yPWTGrdjFrarr1KY83GnWnABbe+OfWsMCBolo1dOhoXQKMeciBtdYT9wN1Um?=
 =?us-ascii?Q?093oYlFRcmmgj0++zE84762tohw1uEH4USz+ehCijyEdXG2U6WWT2shUNf1C?=
 =?us-ascii?Q?FySax210NXhtVPMLuVtUcXJ6fun3Ds1/+cAaui9Tbr6nhl1vwvsbrG3PyVVf?=
 =?us-ascii?Q?PBIKcDGabHRGkgvEAzCiVX+Aeh/iSaYUWVVvHk2CrfcJebq3XFPrboIjWlOD?=
 =?us-ascii?Q?UhetSgMH8wCqGz3LlpkGf5BnQzlFyY083dOdgEJ+zUV7TaqSDcXNCp8Bek5U?=
 =?us-ascii?Q?Glf9JhyPM7Mn/ZhpnccZopnmYkidUEltQkvK/7qHASJ81BVnTsAnKtSLPXSS?=
 =?us-ascii?Q?Z4XUqq8U1oXaHKYd42vwksSKxuFyMxF5v/Sk5CqMN/tq7eA2oyWxXqcePIuz?=
 =?us-ascii?Q?Jw57jIfvXzktcIoUzFf1t2F//P2Bew2E4xC42XvpuxxRwwKM+EfRHw1/JXpc?=
 =?us-ascii?Q?A50T/m0ikYoI0i8RNvuiIs6fm5fbE1rwspa76i19yecTUKiWhDHvW89jFr4y?=
 =?us-ascii?Q?O56CkHu8vHgqKmRT6YP9pU/R1en9hO+xrJAV8kOOy9uyg/ri3c+OCBt5Dllx?=
 =?us-ascii?Q?I3y/BXCrM+4X8YiKqgJ6fK/HF0aUBexA7dmccIkatxIF8cdtF2DTQS1nq7xQ?=
 =?us-ascii?Q?IXv6nlQ7oYzq6ZQ74FT1BtXJFcZCbp8FHW+DNwFgwtMBZHrsu8pHp57hw3DP?=
 =?us-ascii?Q?lJ9GENDy0LS04OX1BgxS3Gyewcx1HcvIAPSyIeyIonfrAyqbo8zSLp3PDpLg?=
 =?us-ascii?Q?HdnK29Ia9Luil3QwVLxWjOKL0xGOVwz/cFGFa4NbFGtfdo6L9QrjwvDRHEPM?=
 =?us-ascii?Q?wX9jZ9s2UuTtnJSlfz+weXSqBpujIDcaPpXK829ed+EjSYSQLmmfzN9k7G+G?=
 =?us-ascii?Q?oA6SiP3zsKhzXQVbRRkeGZ5wFlCOSW12oEj9auBHLG6S1V+R6JvBlKWCULVC?=
 =?us-ascii?Q?zIMmu4Up7lJICes59pC043comMy8GnlINdVeO8z4Ba8CqdC23iJm8liDnX0I?=
 =?us-ascii?Q?3sjGRfEWzb6lNAUaF2LvB/8Bo5wC1HCMPHrC9AM51txmDn9LyRYyxhQ2dCOu?=
 =?us-ascii?Q?kNbE+wiR0lcqoMWe6MV+nJQGwQ+L6tq7w2rgiFGkn9TSIhwCQLoG3bSvihXv?=
 =?us-ascii?Q?J3t6HFZFST9x+etKY/ulEGvu5ndu7r8UppBTK1jJPWYzD9R7WltKMXEnhoX5?=
 =?us-ascii?Q?aUQs4Z1LDWWEgp6Hridtlm0bd2RKgWXjfKekmnUTMg4SQPPUoN5MZRvTrZbK?=
 =?us-ascii?Q?pCEeM7jD4LI5aW9KElGYuM5IUDOpGd4dHv1B/NjCyHJVo6yVLa4gZaRDJ2/v?=
 =?us-ascii?Q?PLx8IxueB4j5w2T6PIm1tBeQ11EBsx0T7wOBjGX4uUZ/189cg0P36e5OBxYm?=
 =?us-ascii?Q?peRMc/EXqDPxPE9xnm03J2k0dGWGwxIP640Wv/5Fg21oT7JipelulQxJa/2L?=
 =?us-ascii?Q?9HDzKOhctxtc8zJixhZFcIWBor8L00VKavs907iSy2Dm9/D/ORN/nL3GYBKO?=
 =?us-ascii?Q?P0ijn0pspmY6pNp3jHFwcJYd9a6pVf2ltqqa0ZO5OaqKO+8RcLYxVfLQs+XQ?=
 =?us-ascii?Q?mZ7ZF7LrEP/VAitqiPQ8cABldi4qkBIV77zk9dogQFy7gvqo+e9Khb+SjZAG?=
 =?us-ascii?Q?SGjmczue4Ju0Rz2rzd15X0WgYZLZRp5XUHo+ZV9UO1+txsGgSK6HMAu8Dyp8?=
 =?us-ascii?Q?xAP8lpCqcbWgMYkUPQbgFelMkGaLLLvtaSfmAwP4eV0ChSWy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a88cdc9-907d-4bcc-bed0-08df18f337a0
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 21:48:20.0141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oVh7GV1VDa7iEiSEuGL5FpwcLfI/xg7rYIDLDFzJDXVluFJ7mRQbBnoiXSJ4f9gp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7488

On Tue, Sep 22, 2026 at 12:45:20PM -0700, Nicolin Chen wrote:

> Also, Jason's suggestion in v7 was hyp_arm_smmu_v3_device, which
> looks nicer than ARM_SMMU_OBJ...

I guess the point is to emphasis the substition technique, I don't
mind.

> > +	if (coherent && !disable_msipolling &&
> > +	    smmu->features & ARM_SMMU_FEAT_MSI)
> > +		smmu->options |= ARM_SMMU_OPT_MSIPOLL;
> 
> Will pKVM ever use MSIPOLL?

Not sure I understood the approach in this patch, why was anything
left behind? I imagined everything would be moved?

Maybe a few more remarks in the commit message?

> > +	if (smmu->features & ARM_SMMU_FEAT_HYP &&
> > +	    cpus_have_cap(ARM64_HAS_VIRT_HOST_EXTN))
> > +		smmu->features |= ARM_SMMU_FEAT_E2H;
> 
> Why is ARM64_HAS_VIRT_HOST_EXTN left behind?

+1

And the TT_LE/BE and S1/S2 checks, and ...

If kvm doesn't want to dev_err log that's fine, we should able to
#define that away too shouldn't we? And maybe it does want to log?

This seems pretty close otherwise

Jason
