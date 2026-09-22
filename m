Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013023.outbound.protection.outlook.com [40.93.196.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233894AB3A7;
	Tue, 22 Sep 2026 20:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790107224; cv=fail; b=N/3/GpJCs90UgVUemH10ynUFByWdSEctW/T1mu4UdX75R37yhnIG+VaYMCQ2EKgfiu9iFKhK1OUL/0+ZaXNSnks1qTWNmvvQcuBbyugEWPpleY/iGScCf5iHyg48VkUebYPWVxumSaNGL+ssPJjARg1n0OyYsBPA6ji3a9j5ALQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790107224; c=relaxed/simple;
	bh=veb65Pn4CpmFEWTKSfNgpLdxKjg+fy5dHsFLVV0vopE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+S7wxS9YJo9fogS1eQiEUwDkHpKZKAYjdUFtpD1ZJoD95gNVEwmCWXX2p2DY/jS/PSg0a09G0UiSJx3FFLZX/aNt1NRkYxeHWcw7aDZc5Pp8Se3lpvVn/ttFEaO6zeLRhF6Oa+7seNnyjAnReP9NpdP4m/5o1Ur8+eDL49/MlY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RjjiTIby; arc=fail smtp.client-ip=40.93.196.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RjjiTIby"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CJpmkn94o/gBLWhxOrJqhg+P6d7wNufuPzaZbVxUTzBS2gDixo8GdgfNeCZjAKEwL23fEKEanUjS74PkNC0c+kjwWdZ1f7Wt9TwtIVFWFig4yt5WjG9PW99MKci30l5eANRkPAJy9gfbutvwjxxmc7120IB+tZmaxWubs/G2zlGLGJlDpeBvueoxay4PdjRrMLNQjqj7E9xFLgGnhq9iGRGJkKtnW7miMPVu1Ca8uMRuAX17UUuVYNPNRiDrC9sJ5h8/4rokKZ/FIkPOv9SwXF15RewyOO+HWWZpPppPu3/ipcFheO6vtZtd4E1ABW8iOsF7S8spcl2p7r2OPQevGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EbrL81ftez1/Lz+4iuhOw9CrE0nMBDsYDdSTGwWCIAA=;
 b=NDdz7iOXrNrXNz5fBKrPcTwdVT3Y950DQGT6QtJ5S4B/2HS+Q7vMn2jFEH0SqQV7bStLpZVDuSkaVscfLbaK7Ve9qTSmcvSQg4wituKKVVQvwAYwm+qLCUlDKExADeJvTpMGnDl5/1ue0GsCe3p8ycKCM89sNTXWEKdw0buSFnCSv3UPtQllGMxBgSD+RqRtY+fGsZcfnAhMOuxaUAOG9aNVq1QQzy3TMojyJEK42A6AF+buwvKAT2K6Rx0bnIz9lUt3c6TvTdhJC5ekx8uuCIfLXPagH96mk8iWByAKuICyptsunOXXmYu8wsjhlrAIUoGQD9yJghycLghE5xFcLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EbrL81ftez1/Lz+4iuhOw9CrE0nMBDsYDdSTGwWCIAA=;
 b=RjjiTIby+IHrtgLpu0ss8D4aOW6HByz87grc4D5KIOAwBbMLxjXayZtV+REh7KPB0wg+fYN5sjUNxaPTxL18MrGjrcmEszDhqe7irx/mC2HaFWnhBUW5EZQA7lk4h7nBtVHR2gqSoHptwtH14iiqpBtLEQF6xsFxNsfCSWlULNjUgoespdDNJD96bWKXYh6zN9NsAgVjg9Uh9MSZtx3oL+QCBMg1ulFNBmCP97eukmPuirzmVhVQhjzLtWM0xDO55Um7HKlJLpZvGuf+rMo3HFnx306CkgTup3pqccxbR7PMngWIUEqIDS5VFPz5JCMgnVeMVt1TE/4t4eAuUZz8nA==
Received: from BN9PR03CA0138.namprd03.prod.outlook.com (2603:10b6:408:fe::23)
 by PH0PR12MB8052.namprd12.prod.outlook.com (2603:10b6:510:28b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 22 Sep
 2026 20:00:02 +0000
Received: from BN3PEPF00022BD4.namprd03.prod.outlook.com
 (2603:10b6:408:fe:cafe::5e) by BN9PR03CA0138.outlook.office365.com
 (2603:10b6:408:fe::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.13 via Frontend Transport; Tue,
 22 Sep 2026 20:00:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF00022BD4.mail.protection.outlook.com (10.167.248.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Tue, 22 Sep 2026 20:00:01 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 12:59:32 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 22 Sep 2026 12:59:31 -0700
Received: from nvidia.com (10.127.8.12) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Tue, 22 Sep 2026 12:59:30 -0700
Date: Tue, 22 Sep 2026 12:59:28 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>,
	<sebastianene@google.com>, <keirf@google.com>
Subject: Re: [PATCH v8 05/25] iommu/arm-smmu-v3: Move hitless machinery to
 common code
Message-ID: <arLeIO20VQZD80nr@nvidia.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-6-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260922131259.2975334-6-smostafa@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD4:EE_|PH0PR12MB8052:EE_
X-MS-Office365-Filtering-Correlation-Id: b37b01eb-ad8a-4211-8f2a-08df18e41685
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|23010399003|82310400026|1800799024|4143699003|56012099006|11063799006|10067099003|22082099003|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+Vyl0+Ll5m9qQLnbap8TAnXhQhqjO12SETJgCw/8PjwK+UGunwwwRIl3rqi15cOkIOI5EKYb4DIbbNho+cJ8pVSGnXUjWy58sIM5om8pUSBisfk7eyVTjy66Q8GOCFGsgXQnsOmUGAN8rwpWV+0CHSBekfsWSw0a4ALFGZBxgXYBQMQA/BwCrgVHvO6DdyN++01UAhjo6QoNcuSWLuqvVq/+EaCz+HpIy8KdpqWGnmNvn2YcG6P8QQGtO1DuoZVHVDQmIFjp8ayY50xFA2KsE6IpNgm1Gc/9J5jFVsqJxzHRVP6LmPSWvNFABv/Q7Agl5JDIjg9hs6OxxmtyqKA8gpn6Ag2qzjM9eTwTS+JaLGMbQIeaCzLox4JrTYjST4G9jqUzVcVfwOx341Y39GAJgr6Pz2mJ3ahbbYduD5M3jBQo02boQInQKAsvP1i9HQlKWC8Vjxal+if/WXv0E9OoXNx9CaonRUMYws6iRq2XKon+26Qn4Rd7QUwxG+YaEcOqJwWKjMDSMvyFHMhi8vReVNbujZzCxqS5xiuVWuBF0oO6IlkLayYjbNijfnJQDOwyj+dEYNRX+OJcKSoEasRiTcYUyChmtUB6X5JPh2PohV70n6+FOCxJX4Qy3if3KUmLnuvEYvx+PmfOUUlB3Liph7MaG9fZzFJuN8AG7whBhl/2i7cwkwCD0ms/5YoQK3MZUv3CeyMt2KW+T033f8UFCw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(23010399003)(82310400026)(1800799024)(4143699003)(56012099006)(11063799006)(10067099003)(22082099003)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/4LW693ggD79JcwClr+vnytb4k9cVToN9OwKaPfgoPLjoAY8EBagnBbpQ30Gr+JIg6YoaaveN1GP6MZ3s18oXFE9SumxsJWV08seuSRYMPlGiuRurjJ+1ATQuuajvjAVDc+wHhoN5RClAMSmgHf4HTdkv/scCzGrvfNGOv8/CXrvxQGv3N3NmIsSnOVVVH0LvorSt3nvWp6/yC5qAeJhIt4qgfYCLFvg4vnIz5S7Jp9jhxmsKMOBrqJKojuhcOZoZuzVU5mR09gDKo5RyD9Z8XrNE+j9855tcjSvN01m/a/bZi1U9OhCEwoDSDNG8VOui8aUd0zjIv4Kgj++BAi2Ut3jGtXU5K7po80Mplp+t/mD1eF+e0qCOtGtV+Naxf19ogKUFQdgS+YRMAT8Skzf6iKoOAWC3/d/9H0KD4XyP8b+0+uSCtawWffKkCYwEbgA
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 20:00:01.7616
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b37b01eb-ad8a-4211-8f2a-08df18e41685
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8052

On Tue, Sep 22, 2026 at 01:12:38PM +0000, Mostafa Saleh wrote:
> Move the hitless STE functions to the common file so it can be
> reused by the hypervisor.

s/it/they

> No functional change.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

With some nits:

> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -59,10 +59,8 @@ enum arm_smmu_msi_index {
>  	ARM_SMMU_MAX_MSIS,
>  };
>  
> -#define NUM_ENTRY_QWORDS 8
>  static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
>  static_assert(sizeof(struct arm_smmu_cd) == NUM_ENTRY_QWORDS * sizeof(u64));
> -
>  static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {

This line removal seems unnecessary.

> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -1321,6 +1316,8 @@ static inline u64 arm_smmu_tlb_inv_range_enc(u8 num, u8 scale)
>  		FIELD_PREP(CMDQ_TLBI_0_SCALE, scale & 0x1f);
>  }
>  
> +#define NUM_ENTRY_QWORDS 8
> +

Maybe we should drop the duplicated define in arm-smmu-v3-test.c?

Nicolin
