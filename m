Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011064.outbound.protection.outlook.com [40.93.194.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACA93DA5C7;
	Wed, 26 Aug 2026 12:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787748103; cv=fail; b=sNJDVwh35lTF2r7tTyfV3tH9u4oOFlUWs2NT/dD82tvFjGS9d/haWheHdYPu4RButgXKPzXwcqKaerngq7OA0aTthTk0Q75y9s7B3h729ibm4E0LGjsv40oL0AWHeb1G1d4dNiFEjA3YiaAFvP52u3Ouu/FdRoIfLKQRPrZ2fko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787748103; c=relaxed/simple;
	bh=yowYr9k+Bl4H808ArsRFA6JqeWJLU72wyjdzXm7noG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iQ2T0CtaqGjE8b77619KqdduYdJbushn09rNcu1Qgk+PK1Vft5j2xsB+QjnJ+TOIB515nC58dZaok4RZ6LNlLhXN1+CYdfavEBPze5mJ2v329jaG9wZMpVhEn24JlbEJW4q7fniHTcLlpsnFjJCnG/E652RUQBhuDsvTwIKcQqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YnjUNj5E; arc=fail smtp.client-ip=40.93.194.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YnjUNj5E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rRNhGvxPpOSfN/cvQ91z9Mx5HmD+ke44LvEzjDGM4o3E1GvCDUecyGCLL96UXg/ainAN/2AQEQbVFvWD7QDUgLs8Rp8nKEpmgrPT18rnpNRufYfO21EHRQxlcdHbxpuvW9kjxSS2FKpNmCW3jaRAwgWIwx5kERptUAuWtHYJhOKnNiFxF6Tj9q1aI5Ucyuk2wrphderce5sCAHscquFv+qsInepe31CTUcv/gUwj9S3Yyo+DKuCxN0I8aHuC6Yhl87V6pimRq0ZVC9rU1x90KVCMmo3cYj632jGitRWHV5FLdXlGh5eBkxHhRYsNxZSAPsC7j0DPqjj+ogI1+Cl87Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/53OmgzGsGsMjKKQ3xr0euphLmvikeoi+uxK1h6/uxc=;
 b=AzjjNbSFLdRQ3BfymazXSHPKQOWV9IrVo9yv9xe2R4p16gvPmswekt88A3DGsPJ+MsMVrOFMLIlRaetElHTjkncU9Xi6M4vt0i6jJ115VjgYtkJsZARYSAjjNdsN+uDrbjAZNCf4c0fNQFqv8KcpgVGCWb6mhkzBs5CWOjcb2f/53WsQw3pLW3cCOq63rxpKj77c6N6WOayUC+dwAq81DdQCPu/CbyH7w5WCXUFFLqrEMQfhFAe5qbKEV7kvD4WDl3Q/MljJkPPuPTT+EeQxjqZvzIBELXErr+8Ty7M/VlFDD3bVtKA/kxfWOn/Wo6T20yF/O4QEcQoW1rKxbQYD1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/53OmgzGsGsMjKKQ3xr0euphLmvikeoi+uxK1h6/uxc=;
 b=YnjUNj5EFsNvFuCsCuLRlwZj6fibFzeP+1NZ6eH8eCg9cJScX6tMD6e9u7+8VMC79Q6dzoStIIuXsTFvD/iKqrCFb3QQQLLRaZZVth4ablnwi+9pE3nyJo+6m0u2Pi9s6dyNkhyH6P6dzNfr2tRrWLz2HAptKdioVEew9rHjCNXN6lg10fGy4S4aumVmDsNOYH7W+dWjWGDGn7z0OYmQ+ENNZbYq/4nU027nbKU5uQZNBsq3hR8DKyV9XIemrUSQda/ncmmnKwERXQ+bJoOsiYZiotR3WtM/+iKoc3b3nHXWEvJ/DsNRQGy69NWTGQ62ozDCFOqjZfAR3dagAdj0Wg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM6PR12MB4481.namprd12.prod.outlook.com (2603:10b6:5:2af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Wed, 26 Aug
 2026 12:41:36 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 12:41:36 +0000
Date: Wed, 26 Aug 2026 09:41:34 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com, vdonnefort@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v7 05/24] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
Message-ID: <20260826124134.GJ3325090@nvidia.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <20260715115906.2664882-6-smostafa@google.com>
 <178769159057.3356902.8176677714818911833.b4-review@b4>
 <ao61dMZqUEgC7huD@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao61dMZqUEgC7huD@google.com>
X-ClientProxiedBy: BY3PR10CA0024.namprd10.prod.outlook.com
 (2603:10b6:a03:255::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM6PR12MB4481:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ee03e45-1435-4b76-c1c7-08df036f5db8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|10067099003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	CMCerXzv0o7ee5kXdJEawZDuIXiw916X5UvU2/EWJVneajXyHEjZSGRaFzmx1SW0OAjEXuf5t+vxU6uYjF1bS/XsQmbzsVsxNq6THmCkKDk4XrvizpKJnlpC+X/AYy4wiPNTA36JdX0kcxtWEE/BphZztGp8ql3LtidnOcnkUrAiebiifbjUPg6nHLUXQdVUtNH85eymigs1wf4YzcTH9SIpWvaZt29Fq93AXneyJKuAn1oyc4nhXVbYU76emhPYPnVkY4jS5X3blLue4UDG0k31k5CudsPtmk4qdKgjURvQxq8eFy2R83illMlf78bAsd9pWBZAm0aYnIi7AN5z4TxdkdQQxC4H2hXa6UFiSEeg4LZjsbQPviH4q+RmXwrfr7hd3VnlU2S8/pMR8oiwGrT/89cTERMcswAzfliz1kwakFdIt7XiZRR8uF+kh4LJl8Zvn5I6Xd+MH7MOOCBtTl0T0AweyYLitLYQbIoJlofICXVNFhoItaYdZ8U4cdiwPIG0cAxxs2sw67L+2Ea6+VNQufc7qlxNoLRZcHBa408dWZmDTkLEJrn+vrcYpaoAKsBsQW2X7bhqZTBYD3ikXARCNtwKamNcVPHQLQ4umBOD8J3yKd7tS6yQgYQpe+dTXxbdgIrJr/lqVzNrnZpXCmKAurgH0oafL4pS9sj02XM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TqKOH29n7ctZfUU7QogBUmJr6izI9Jft9BYlChqBvfU43AhouK9cr2ABLlTm?=
 =?us-ascii?Q?bXU19NWj2hz1IhQiF/RAS6RjYOf819sPQkxy7Qm3Hc5lEQysegF3a9pmqnOo?=
 =?us-ascii?Q?eMAFjii3bbp8XJoLL36VrJElb/7mYvograLb26AeY6uJ8Gsax337uTUF1zdJ?=
 =?us-ascii?Q?3UeHuV3QJOL9HaYXNAB95zfLsHN8jS2Fbegm/81XYMrnIRuVfDrokVK6yEHD?=
 =?us-ascii?Q?HoPoD6P/5Z1KJe+WitGjnC1BYVNJfgWCBgPhb/e/9h2/H96T2cP3G7MH0IVZ?=
 =?us-ascii?Q?+59yd2R4+aD2KYcMyRhnWJrdGjlBNRZIN1x7vdNK63g6cEMXn+4E7Zsv0wHa?=
 =?us-ascii?Q?uMr25ddU8/0rHZubYMqM/5jK6UkzePT9klVnUWluidYVHwZwqMPBmPAr6j5p?=
 =?us-ascii?Q?5RlnDMRFCXZcTvXaJCd0sKK84kBieeqveUw2w4qcajzuLBoFN5pKN7O9ihMh?=
 =?us-ascii?Q?/92NU7XugAfKfWImN8th9Ww1LVD0tX6eiZ08Z2jXtyyFnjXw6BcHOILUo0NH?=
 =?us-ascii?Q?pLrR3iQ5rlKlD7sI11Kwh42XYTu5/nZxR7Up9c5PTP20BL/lgF5zh6Nme7Rx?=
 =?us-ascii?Q?5qId00TEoKTDZuN7BvHpWoR5NETCBX/BYaKHFEXasCtYiDww+ylfZfPg9d4R?=
 =?us-ascii?Q?19/DPT92W2cFY0hL+pEieqbUOoM7mrGFYqverjaKyJYi8kynjTgaWsR+vNjj?=
 =?us-ascii?Q?bYKFN/B8m5/jkbd106ICHxZicfrLWAcNyrsTcP9bIxQCWE8WEjifHm6N0ocU?=
 =?us-ascii?Q?3g9LI8Krka9iRxRbzdKppQS+1QXScDQmJ8GME08cziAiL3ODuQRm0BHj2g/Y?=
 =?us-ascii?Q?16UeFIF42pjyNJ2OO5ib2HDIG/1XxnnzD446nUTrv4IPbz0HMfl3p/0Ig3E9?=
 =?us-ascii?Q?lnKFYeFt10yXZigGijrKVUTYbPIiuPqR/gsKsCT1LRKVrguu6vL8WpXadxHP?=
 =?us-ascii?Q?OJF+2kVnqSPY4DQoWk2tcd+lxuRFZWgpZU5GXZtB68m5ccoDO6Zvs2EfklcE?=
 =?us-ascii?Q?YCnc2ofN3mugnuYvk0b9dAdOnG0cK++tU72vqaKG2Qa4yE553mj9MHh3L8+Y?=
 =?us-ascii?Q?rhKx0ZuSlF8rHItOKFyrd6zM89hjTrEm14sQU3y1iisLGE8G/Gmzk0h3S0rP?=
 =?us-ascii?Q?sniij5fJKaImxIbCNq08+MTIKH2SDMHMldEBuw54miZ+QmEvCo6ExgKUtrrM?=
 =?us-ascii?Q?4HLc6Q6WAail+OOSA8IYvYgO15HObUQ3ib/SrZvk1eSGqnSlogV20mzk5W6e?=
 =?us-ascii?Q?Jjpybu7dVvXWOi4OsUmZos7ErqD9ZZuNKZuYS17Vk44hFp5GohnKOt6ANFVl?=
 =?us-ascii?Q?ORIb+MYslbiQatPKEXqUj29toPJabd7c4bzIWGSTCtD0EH1GyV0LGQk+dRWl?=
 =?us-ascii?Q?ZWAl8p36VqrP5ZUKZi1k5gaQA99J8Larfz4YKiyZGjJ5qxnkSyrEBqZSV8wD?=
 =?us-ascii?Q?0cpjf/RkWbXpNbIIs5uF3fQGvzvySUePGBdRcXlJaseO7szaMlQGSaZ+KbTf?=
 =?us-ascii?Q?fO1DGyEWpzdPD8R4sfV2tQa5lTXYTdyLN73vV8u6w8Ko7mrZagQB5xuHiAQW?=
 =?us-ascii?Q?9o4z37+NDx8CXAaILCZudoN60BdhlDfikBxDmreZf9xbh1PEzdol0oSfbxdh?=
 =?us-ascii?Q?Exj+JXFBLLVtJk1QrGZEwSWSFDY45VwrmUIoRWhmVpl69WBCh6/jS3rKNZRs?=
 =?us-ascii?Q?BGVo1Zn/8YENJ/UbXYmUXXGY9FEuXoXz3Nl7bGtfGgwe8PIq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ee03e45-1435-4b76-c1c7-08df036f5db8
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 12:41:36.2065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GXiBawmjU7RbWgl9RSIhG8ogy0ubjIfkLCQzSdvLtNBu7KTM5nte04hnsS8VJMHw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4481

On Wed, Aug 26, 2026 at 09:44:20AM +0000, Mostafa Saleh wrote:
> > 
> > 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR0);
> > 
> > 	smmu->features |= smmu_idr0_features(reg);
> > 	if (!(smmu->features & (ARM_SMMU_FEAT_TT_LE | ARM_SMMU_FEAT_TT_BE))) {
> > 		dev_err(smmu->dev, "unknown/unsupported TT endianness!\n");
> > 		return -ENXIO;
> > 	}
> > 
> > vs
> > 
> > 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR0);
> > 
> > 	smmu->features |= smmu_idr0_features(reg);
> > 	if (!(smmu->features & (ARM_SMMU_FEAT_TT_LE | ARM_SMMU_FEAT_TT_BE)))
> > 		return -ENXIO;
> 
> I am not sure I get this, the only difference is the printk?

My point is there is alot of lines that only differ by a prinkt or
something minor like that.

> We can do more with that, but as discussed last time, I am worried that
> re-defining structs using macros just makes things harder for
> maintenance and more fragile to changes, causing build failures,
> and mismatch in types between the 2 structs.

It looks easy to build test with pkvm enabled in the build, I don't
see an issue. It signficantly simplifies things going forward if we
don't have to have these careful break ups and splits of everything
that doesn't need it.

I prefer to see pkvm use the driver code unmodified as much as
possible, that will be easier to keep together long term, I think.

Jason
