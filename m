Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012059.outbound.protection.outlook.com [40.107.200.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6014F49DB99;
	Wed, 23 Sep 2026 11:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790164398; cv=fail; b=YkJuN3YUQKJYoB/TMNHhCD7UB+yDxI5rydxVeVo/pIWrcRR/WcPO1mvuXgeXuZwvoIFLNICs2gumhQH7u2vnxNaU4hdVkzjtBh1XYF2JMruxgZefhxC6F5TDuw41HPpF6lx9/LBWkidXdLowBOW1+XGBhwZVWR3s3YJ5EjQ0RMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790164398; c=relaxed/simple;
	bh=0k4koSQWSjXRe0A88ACiIwd9sz1EfRBEv4H3A636P1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QGn1kM6jAcQfhnj/jPDJGp6b8ZWuijbL4Alof2LvZNmWgoIkEQVOAXHWan5JetJJUtlTcncBRLEP0rjfcoZwx2+fpJShm4CrtE3pf7JZDLC1/qGlBQ7UUHwppaLCM+kG1gZOqj1aw5sw+4jAvBensCx4+4I08Qh3iE8ztQ0Ykvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q6CJ096J; arc=fail smtp.client-ip=40.107.200.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q6CJ096J"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HcCfrbX/29Z2A/Vm4jH6jeqo5vftqnkgl9876Pq02fphXl0UPc+uQqBFhoAsumv6714au8oTHzf0y6ZT0fbJeWT1uJ/PA29m8xSMcDnHRY0tprr67zIzBPDKzOtC7FKB6JybT2qKLAxcf94BG4Vb5rjryNeyympv1mVwMosPdvXTXObn4P+WWLojBu6EHGsMnBzcPQhCv7rzENyKxFMWEtmNAjo2azaJxqmoiI6b0G8p1v5H8A1V3VlIoHjoNn1bg8aFGt9mDut6ukwo1DO/pycRhSK8LzySQ+VWVMZ1I2uAcIjnZJ6/suFCJzXP77Bp2ylWeDf4GLVmjylMI9Ta+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oYBp6D6TDMW18ZbwW43p34grXxlgHzROKFo5Z8cTBak=;
 b=oXtv8o0oMpphLqh60DIRIhuR2QiM4DsWLRq0OmtUh0Fz1ETVWs3KRDlb5ciEUmnJHIvsyLWP7OP04IHCVwNJQQUy5Jiq99nCf4TDW03ejXnUikOeuCpEG55mOr55pRVPSwNDubeJmZhATcTwgQL+YvuINYjAKL5opDrkqleDljAXr+zLYrFXzUNdrUZpzaAHT3B2aMGWNC9dw00vs4mqN0kMq3lyhnigj1KzSYpJbyP9hvinW6nU5F4KqlkLJKU3cprmFM/ONexpPYGDFxZs4oi/pYVvNdPeguRn7fSil4A9xVqA8nEMN9tfpEqb+PnURsEtX680x+Kr3gvj+3tqsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYBp6D6TDMW18ZbwW43p34grXxlgHzROKFo5Z8cTBak=;
 b=Q6CJ096Jtnv+3Qs/CfYrIiWzaA17FiXyzmyfAhLXQBJcJmntb+iqz0lfKoHMiZfiXukm90ohe1HT4HtK1NzCRH3V+0Dtlm2I7qeCK8z6QQPxTXjUyoVjhFTA9NJrohbKVztMfC+okTy2WlxDL6CqFQ9t2cjxIQXLeZJ6JW/6zarocNlYyslnD6Ub3v3uhJqc6/k6+ngDIhDDvkAHD2OxOss1IaIFXseSYQjxBqOoUKWAQ6ZUvsczHp6ygvT3+UPX4MZ0LzBmYmAewEyvjTW8BRE1ZOz/KMqr9Mkve3CTExQhDLiMh/3akCFnJr8KsRPHpEhDQlYV9QAq58t+/GI4mg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS6PR12MB152050.namprd12.prod.outlook.com
 (2603:10b6:8:410::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.16; Wed, 23 Sep
 2026 11:52:59 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 11:52:59 +0000
Date: Wed, 23 Sep 2026 08:52:57 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com, vdonnefort@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v8 04/25] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
Message-ID: <20260923115257.GC2545495@nvidia.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-5-smostafa@google.com>
 <arLa0E3xq5dGuPpd@nvidia.com>
 <arOlQtPYzF5yT8fP@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arOlQtPYzF5yT8fP@google.com>
X-ClientProxiedBy: SA0PR11CA0073.namprd11.prod.outlook.com
 (2603:10b6:806:d2::18) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS6PR12MB152050:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e2ac26b-81ed-4e7e-3628-08df196936ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|10067099003|56012099006|18002099003|22082099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	TTzODnzv5H4zcxVCu+PmP9Ma1Cf2uXhRbq92LLJENZbkikCJYtFKUm2CXVaEWIj4ixWC1KLksdKbsGSWJML+mN0d1kzhfh1fX4bvcJUnNAvd79DzzRopAG+YpDBTSPiF0zilKE/hrjmFSARWNnZkePaD+KmcWTV4WwX0Vl6W/Rxfgri9xFwgcgRdwRNGf4QHF8kAe3ZMMYYIcKTUrVYeFgkC8K0UZIFkDPvxsSUyrPNJhGTFKsz/fEiZOvqc/lnJx9r3RwIMzeM+mVkcrobkvMjuwcUxejSr52h0X2HwI89p46Z0wL+0T8pqipHB40zap9B3Kh2GRFWiqZbEbfR7lnIE6VE/Npj5mfU6w000uwt1dbJkLMbKoKQP3SK+2d5EJzaLHyqPz0E1AosKGQMVaFdpyAFdGVvy4iLuzZiYn41vyseyUz7sJlgCQ2YOJ7Y33zI7MkRg0+FtLNr87bViSDHKtNGj+MnW0OE3s8rTs2feIS1i2a54lfEB72cbvLGKrutSIII60PAoweMtZ1yWwA81yfqYYTl9/jsVAPeOxwcQDlYuDwXSVblAn8JzT9Xd1OoaN3cwjPORaShD4QBXc9GepFjIV6CCkC6FhAlFHdR9zYmlk/8r/0p8NqqahFy4Uj3PufmUBp8TfkKoAEclfpRSRM24xCsYuqXtXJnIrOs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(10067099003)(56012099006)(18002099003)(22082099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2Egr3nTpyGpq3ROS+4CNOaP7vOTUD2nYL03VY4gsYtkJAzOaioOIzITvOcF8?=
 =?us-ascii?Q?iMiwr6gTKRyBuroPkATu08jumnpaXQNUnHy7fWM4TONh/bIgB8CKS7UwS2Oz?=
 =?us-ascii?Q?XVynxC2uqXgYd7i5K1j3xd4GVr915V0rRW5AhxnKrxYo3tuvUvsMk1n7QeSL?=
 =?us-ascii?Q?xsRYRVj8VfJ5m43xdj8fpyqrJC/ETwdNVR/5ZL6PqVo62vlUbaxXqolQj9vq?=
 =?us-ascii?Q?bUYhDSBjuqteip7JrzK+06mLSkAAszlW/ahyx6xUoflzXb3O9S0WlWkCCsHu?=
 =?us-ascii?Q?yZdqSySKpNsgn0laaIYJ/Fw11B/bT68NTvIcnfIIKZOpPPzT2OFicWlxs/3l?=
 =?us-ascii?Q?xXvqL557BvUo54rODwad+dorDqB6wtOU/+ldNiHw6MyruxS9I1/ZPOGELEot?=
 =?us-ascii?Q?J9pOrWdbZPM4fUXn+PFX/3EebWhjbdY9QiQ1M7XcwQf2nsN8CK9MCSJ9avM5?=
 =?us-ascii?Q?6h0gcGA801XVZ4HpvQPvA9TYn038r8g94jTiUzCSEzqaTxKv/0656eEjfJ3v?=
 =?us-ascii?Q?FKZOzE7/8OaJbDwWPFXMm+kqYSXpg4d94TSz1ow1VLLKy44PHaQFSL8Xaei4?=
 =?us-ascii?Q?LAwj5KS2usO1XFmndSpwTwqtLOwnZEosdlsjVJT/kTeOTYhaSERi0aXhJvtZ?=
 =?us-ascii?Q?bAh4yGljs5c56OR2wS+d4Rr8UKl4c3p7NkVWoAj5nNGGMJceRGYRZqTRcQEx?=
 =?us-ascii?Q?rwVOsUMeIFy1YpH2aV5UC7ew/ozVgt1gsHoDLJappKeinIswlvLwsTasXT9Y?=
 =?us-ascii?Q?JByA5kj7s8vwpvGMoJWVQVlBtb3R3MMixgHU6c4CWs2T4B2vafcMWxbFS5SE?=
 =?us-ascii?Q?CuSt84hjOY1P0AqMe/iI8dy+d1AmIgxfYmEXyd/TOv/0zTTy71MYMQW5jTwt?=
 =?us-ascii?Q?8LVB5iTunszBYWIV861FXH5cYJ0r+7v5wjodfHdC01H78UDl6E859kNzsnEp?=
 =?us-ascii?Q?3gRXQR1SMhIWnk1uU4GKwcNTALVPTWVgt1xZi2IGPBZTfCgQ6XPWDMdFfY3b?=
 =?us-ascii?Q?E1vo16NOGRkF5HqNzq5lCq3G9qyekn8bbjKeHuQ9XxqavYQGHa1bYeMVaKV6?=
 =?us-ascii?Q?kHk6Tf9WLM62LHz9xUyjVY9CclqlakHuSA601WSxdAnh64RetmEcmjLKveMR?=
 =?us-ascii?Q?l+hd5wRqN0MMyn/PoKNAgvlUBDej4GFIz2m1em3uaG8pOfQ4PKG/yhzsotgN?=
 =?us-ascii?Q?5/HANC91ZoHRzKhmnUg8UgPY0Zwg5TCTr2bSqJNQWQzeQf0GHXvfj4y5q/Nq?=
 =?us-ascii?Q?IS/0CZ4XQkWdQgTHL7q4ZKMnjrVzfeKzihVUzCTKZBa+dqwTEPDQSkYBBKKr?=
 =?us-ascii?Q?gS9gm/H7rZgzH3V+xZNX7c5DYbpoMdO5FcsKReMiLu3OGOwFLCtA4H0hSuhd?=
 =?us-ascii?Q?OxVPi5enmqAms1xzWZbCtSMygn7vJOE5ofIEwGQ0AbPOnfxMrRBcl9GcsOFb?=
 =?us-ascii?Q?eUJlV6RemuRAr6/PGYq5g8hRBNvNuOZo/RCkJ2Msk7Htm/6+p4txV3GGJWq/?=
 =?us-ascii?Q?q5R1jYTsgg/9IIRSBmI+aGxM+7gNE2BEtUrBWQLvAxm4N7hJ/uo3P/IfNZW+?=
 =?us-ascii?Q?aaBew7f/UyXHg8mXZuAf425J+edxFGOUkG9l+jVcpfQ9V1axW/lUBlM8l7p3?=
 =?us-ascii?Q?pfpuaaZA+VjQ2aRhanGRLBnhlu4BtQt2y5bZMnj9rNqkjk7MWwQqN1TzijiT?=
 =?us-ascii?Q?lPf2D9R6+r9E5CjpTkOE5TsXiHANZMzlBnkeKmURyAmmx72x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e2ac26b-81ed-4e7e-3628-08df196936ae
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 11:52:59.0370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r/XPVRlQ22B5sTn7jpaJcLUCtfUnob8mfHM5wv2wll6SAs3/0xVuRpLW6S53jLo5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB152050

On Wed, Sep 23, 2026 at 10:09:06AM +0000, Mostafa Saleh wrote:
> > > +	if (coherent && !disable_msipolling &&
> > > +	    smmu->features & ARM_SMMU_FEAT_MSI)
> > > +		smmu->options |= ARM_SMMU_OPT_MSIPOLL;
> > 
> > Will pKVM ever use MSIPOLL?
> 
> No, this version does not support MSI and hides it.
> And this check can not be moved because disable_msipolling is a
> module_param.

Could you move the above if into the shared area and have the callers
mask off options if they don't want it?

> > > +	if (smmu->features & ARM_SMMU_FEAT_HYP &&
> > > +	    cpus_have_cap(ARM64_HAS_VIRT_HOST_EXTN))
> > > +		smmu->features |= ARM_SMMU_FEAT_E2H;
> > 
> > Why is ARM64_HAS_VIRT_HOST_EXTN left behind?
> > 
> 
> cpus_have_cap() can not be used in the hypervisor.
> Also, ARM_SMMU_FEAT_E2H is not exactly FEAT_HYP. As it defines the
> world the translation lives in based on the kernel EL.

But don't you need this FEAT to issue invalidations correctly?
pkvm never issues a S1 invalidation?

> With pKVM at EL2 ARM64_HAS_VIRT_HOST_EXTN is always true anyway.

> And the hypervisor never owns a page table itself, so it never
> checks this feature.

? I thought the whole point of this was for pkvm to own a S2?

Maybe same as I suggested for MSIPOLL, set the FEAT and mask it later
if it can't be used. If KVM implicitly knows it has
ARM64_HAS_VIRT_HOST_EXTN then it should operate with ARM_SMMU_FEAT_E2H
set.

> Otherwise, I think we can move this check and use cpus_have_final_cap()
> instead as it can be used in the hypervisor.

Or that, I don't know the difference

Jason
