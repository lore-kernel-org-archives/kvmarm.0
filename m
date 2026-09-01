Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012022.outbound.protection.outlook.com [52.101.48.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A0648986D;
	Tue,  1 Sep 2026 17:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788284196; cv=fail; b=C0xF2S/yREIwgJsDaFhwmbHuPJ1PBTIHcbFVXq0NQi22nxZUWWLwrpYNUaerPmd5zLvkCDfDXUylozJ724Tn8+jkv0MdbJxhiS3t63SFRuSfd5KnCBUk/xrMOp8LKOmUsLUW5EApv/HKj8w0ZPIENAKdFDpJr/ns9hMsxWlarhY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788284196; c=relaxed/simple;
	bh=vu815QnnM+gjdu9fzolcZEElCGkmmuh/XpQc9f4b30U=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NgFa1PuV27Cjn3c+IIKLP25fvZFITjJQtbEPf8BShPnY1zgGX9HEVTfsDvaprrYLoSRTHQMTCYYhpLysp3cx/1ZIpv6b0BnXm8B4TPwNNoPe7/NQE/REzKJ1wQ//nGI/oXkNrV3xPyC9MpVI0Q1kYfAwRJQKoFN3VXDDaS6HAD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NSrMK6k5; arc=fail smtp.client-ip=52.101.48.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NSrMK6k5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HH/9qMm6bTns2tr3Wujd6NGQl9NWscZLQY6Ee2E6+xrddLirWDbKMKDA3it2NW7LUMMepPR5po4xKBbXzCPVKQOIQN/+K7/6U6ozz0o1s5WOH3wCpK5UseJZJVBmar8L/W5WpdFozCd1AQu1FPYTyx/H+9R6t0oaC4OW5M9SSrYqj8y1QdHARQWDV1cGd8dT7P8+k5OG69hwRLCb5jUU0kaykELdMH1LW7lppuFH3CCHwfvoWt9tYSVE9Y07M8oC3FgdC9pi1luqTnaiOym3hijIUbpYh3leJHHMhxlmgZeAuhbkE2DXd9wRIzXFiuWmzkXK5zD1hSogjPcArzx8Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hno+TQ63egrzVyTXxBZVzKgqkjJHSL//1OGCbnphbys=;
 b=EcsJt78V1DOM7nOHS8ItDQvoArbtxjCE8YoM2zfa5wU5tNY1ZRv4xTadloy3ctSN2NjA210/hKr6CatgLm3RJo2V/2SjKdJXF2jQpvMRm7PFXZx7clXFTqAJqo9kQlwPJkwsVMmTBkbxHeuXiUa0N4PMykatSjriMwFrYsmjNk/DlpPwiz6qcB6Mkq8e4O959FZhKrhYzFOeKFVpR0/+dUh82Ef/mYUPnxH6Nz/ZB2UDY9gWUs1sS1lLn1VCgIeBXmO5Aghh20UD/EcMLrx5EdzsEv+kC66P9sZ7BpqsoUv5RZB7WsNtjVAFvyDGOBsDZXr6Pk2a9xiivqjbLlexvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hno+TQ63egrzVyTXxBZVzKgqkjJHSL//1OGCbnphbys=;
 b=NSrMK6k5IgKTUErwJkovsC2si5/QOYglFqMqpTY2wiAd7EX5DygKKN2JuZ5w0+mnWZ+qNVL2xFNIP/VP0Q9FbZcntXzHPlts68AIURqbOmcegmhuinC11yhpDHI+VyTo57lOqmWIuU6Vh/Q9Soohiz98uAEo7mpljquPfpPFYF12CeHSXiWAmvBSZtKx54Gt8yAfLga1GqqfMAk4Sl5oD6O7bdeKVWDGvrZohKdlM5nqYy/VOm3OzfwbQN8s41XiGC7KfjB6V4raa2JoYBMj0rOOmi7OPpUheTGLoCX2jePz+yrw6E1Z0ywuqCACuTVvUYeB5BwvHYL+p5jzQ4jBsg==
Received: from BY5PR03CA0026.namprd03.prod.outlook.com (2603:10b6:a03:1e0::36)
 by SA1PR12MB9548.namprd12.prod.outlook.com (2603:10b6:806:458::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 17:36:28 +0000
Received: from SJ5PEPF00000203.namprd05.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::32) by BY5PR03CA0026.outlook.office365.com
 (2603:10b6:a03:1e0::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.10 via Frontend Transport; Tue, 1
 Sep 2026 17:36:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ5PEPF00000203.mail.protection.outlook.com (10.167.244.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Tue, 1 Sep 2026 17:36:28 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 1 Sep
 2026 10:36:09 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 1 Sep 2026 10:36:08 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46 via Frontend
 Transport; Tue, 1 Sep 2026 10:36:07 -0700
Date: Tue, 1 Sep 2026 10:36:06 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
CC: <linux-coco@lists.linux.dev>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Dan Williams <dan.j.williams@intel.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>, Jonathan Cameron
	<jic23@kernel.org>, Marc Zyngier <maz@kernel.org>, Pranjal Shrivastava
	<praan@google.com>, Robin Murphy <robin.murphy@arm.com>, Samuel Ortiz
	<sameo@rivosinc.com>, Steven Price <steven.price@arm.com>, Suzuki K Poulose
	<Suzuki.Poulose@arm.com>, Will Deacon <will@kernel.org>, Xu Yilun
	<yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Message-ID: <apcNBiTK15/3+4b/@nvidia.com>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com>
 <yq5a8q5lz5yn.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <yq5a8q5lz5yn.fsf@kernel.org>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000203:EE_|SA1PR12MB9548:EE_
X-MS-Office365-Filtering-Correlation-Id: 893bb952-a558-4599-280f-08df084f8def
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|23010399003|36860700016|6133799003|3023799007|10067099003|11063799006|5023799004|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	DPYGL/ctZQGDl9Zvhx/xAhg5MkF46Q2dToNRFjHK4B+7HROlyBfhOqXmbjV3Ev1TVlvAxObtX8jM07f3W8P758N2J/NQYBWnF2vGSbLvp3NydilB7aIcRXul8oYj6NhIgczDfssRsgMFYLuTPp0hHieBveOEfVWyd5T32GKqYkOOVrH4pbAu/h6pLryl3cRSEclg5aqnrCrJl8UxypnOo1L8Zttd3Bwh7ys4Wa4iUKX4CEg6Brzaf60I5YdbhkL+pkF7mptY+xChkiIUPB0oWPgUlRmUlMe3WZC3Qlia7c1Y/yAkqoqN658H1w/BHA/ets/bJYZu/ky1hybptKMbvfic6R/PxDxGjf9QY8BB9rfrAgIvYzJ6Drtg08MV5tZ88H1E7XHo3s6Ty7vr2VDc2d+1CROg6Kti6pW8LiRPysXxzSjMasWzUB6td8gVaExpUwVIsZIEkNvsiB57SqjgqV35ULWArQ6FHuwuWdTf3tIS/Wskv4Qx5TowFa8P6mu22PWTvdUJR/4iQ5y6oQhJEsqEHPju18+xUF8UuEAI0GVsTgx2QmLVdTSF06ss1mAsafA0YgFR3XSgFUwnK93cm09ot9gQZtgimcZHGeng1lcxGCEgv1Z0BgurquSPVCMCg/Q79DD4YI/Eyl+uNnn8HNhEQab2ykzDE/rgx0iRRHtoR234cW2C7A8epFNBVm41Fxfi7/DRWL52WVD1EX8WbA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(23010399003)(36860700016)(6133799003)(3023799007)(10067099003)(11063799006)(5023799004)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LcWiNv1Rt3t/GEW26HTyypHg+wNB9bvTBhl3Gf4GYcC9x0IQk5lG+nJEO1zsY42NCWdjywmL1Ag+/sw4p3dleJGTXARjPVi2tq5a8wBSMLPZvbu1RKgrMpymM/0T3adg067bUQrVBQP6gXXmehx8FQS9HKVMZ3rfH8IhdqYhMHFenikxFjGqc3UdKXAhQRWq6LBgYouWwyYAaE8PgM64E8s/XPmmnGMzvT32sxz+dmn5fHGw6UFy2tbl66mGdu5a84BqURi8IhCX0ytRUdZdnt/3delUJ8y3Pc7Akc7/bXs6rTy9gUCyTfqdY8JlCTcrH4yPKKzxUSAD4cgTkwrOdicaVPYE5wnKKDR4LZC1u2ejNEVjHvcINR4NpGnV9vHxniD5vV/Kw74GAiWxwTsiSmdLdDOWmlbZ/JwIiuWCl3dmDpQ6chi1fg+m6w76psdZ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 17:36:28.6394
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 893bb952-a558-4599-280f-08df084f8def
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000203.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9548

On Tue, Sep 01, 2026 at 02:47:04PM +0530, Aneesh Kumar K.V wrote:
> Nicolin Chen <nicolinc@nvidia.com> writes:
> > But, on the other hand, I can imagine that a Realm VSMMU would add
> > a new flag with a user_data to this VIOMMU. Then, this flow would
> > give some troubles to VMM (QEMU for example):
> >
> >  - For VM with a guest-level SMMU, QEMU creates a realm instance
> >    where IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3 (with vsmmu) can be
> >    allocated.
> >  - For VM w/o a guest-level SMMU, QEMU won't create such a realm
> >    instance, while still required to invoke the ioctl (w/o vsmmu). 
> >
> > Taking a step back, I wonder if we really need to use iommufd for
> > PSMMU activation and its stream table allocations?
> >
> > Here are some facts:
> >   - An iommufd has a ctx, that's one per VM. Similarly, a Realm
> >     has an RD.
> >   - For an RMI command that needs an RD, it makes sense to be per
> >     iommufd ctx, e.g. RMI_VSMMU_* or RMI_VDEV_* commands.
> >   - PSMMU commands are global; they don't need RD. So they don't
> >     seem necessary to tie to an iommufd ctx.
> >
> > Instead, could the PSMMU activation be done after RMI_PSMMU_INFO
> > check? Is there any reason not to do that? A safer timing might
> > be at the device assignment stage?
> >
> 
> One of the reasons I added IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3 was to
> avoid creating a psmmu object when we are not using a PCI passthrough
> VM. That is also the reason for all the refcounting around the psmmu
> objects.
> 
> If we are okay with creating psmmu objects early, then I guess we can go
> with the above approach.

Do you see any trouble if we implement in this way:
 - Add "struct arm_smmu_realm *psmmu" in struct arm_smmu_device
 - RMI_PSMMU_INFO in probe():
   + allocate a smmu->psmmu on success
   + keep smmu->psmmu->users = 0; psmmu is not activated
 - Device binds to iommufd, creating idev
   + invoke an iommu op to a driver-level callback:
	psmmu = smmu->psmmu;
	if (!psmmu)
		return 0;
	guard(mutex)(&psmmu->mutex);
	if (!smmu->psmmu->users)
		rmi_psmmu_activate();
	psmmu->users++;
	rmi_psmmu_st_l2_create();
?

Nicolin
