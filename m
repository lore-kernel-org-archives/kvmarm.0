Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011054.outbound.protection.outlook.com [40.107.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D3C481672;
	Tue,  1 Sep 2026 17:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788282837; cv=fail; b=FIrcyXlg9cSV5s1Pb1lll1sf5NUbDT1VEO54sMfJNkcgNI40WJK/GUdrH89clxKwCxXmu9hkUsZo8ixzZSDCtKOzyzPmIiJpCz3tjkjxFwNdCRrpZ0s8hHf0JDCH22XrNE0FdYsZ7cuZ/X4Dls0x9o1KPNAw6YPPFNni6VpMbT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788282837; c=relaxed/simple;
	bh=b2jM+Jj01irI1QATB6FjO/FOAWVyyGz0X5HOoP9kWJw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=an2nA7yMo3N+yXwpv8i87EjTgOwcL7AShOlzil14f8BMI7cFkT8TX5g/+5v+/6p5tHs+9lqYQwLzT62ucYBNZbq1lbctYXSttb0CVuYkSCPYq8ZUVX9XxajhE6dWODTslrsIIELpLmfGAUtTcszTgZQ8KVpQPnCJwxGxihzWpOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=irl1Dqnz; arc=fail smtp.client-ip=40.107.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="irl1Dqnz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jxdePTz0uwF+cVxC3ljfvb3P99pwCiyT9YBUW9vfPLadCZQIQ4CDnIPyLpuUmGbo1U69gnj5tkJf4oh8t+IoX+/2Zh63GPtbdErZOPJbn5Xdw4Q1SyWZDafEUhvptqpElzQfsdMzHEdf3pGjdNdV2737wmu6ol1kXUU3A9mBW3MEtqj2/wkNYicsHmdvb0TjqtyRehx7eozKePUkBtGtfi19cLecX0JZNcAPmUsWL4V21NdZ0buP+MYBp0goC9QjU6IYtoAbAdXE6cwV+LZLxxZmZYCLCKF0RhUR7FLShFS9U0FwVb5EtC1ef1Nhtcc4BwDP2g/pWjXXVCpTRqv+eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uG7i5QwUOaLOklcylctfw26uRdi4EgStfwzNBzXlZAM=;
 b=UgZM+5luTGrf+4MV24Ui4BxlCHzrntlr6SDoyWB4uWFaxDfI7Mp0FlUwbm6OsvdDHX9tRl+vB8t3zMhUCLvXB2W4Bo/u2jkCA0L0KqO6gb8lezZfTaF8D3vNtyxkq5qcYrv9HgYni7yq3hu4BDgjw48NT95dXqV/lTByOzTmw6hSu4/Z/TXHnIMjfVcIEq1O51fhTMaWfxIz87j6Oexk0RKuSYxgeR6ouS+1dT3xtL+1S/rhSOpLWYw/0MRshPk9EaRwpkuie1aCRoC+4zuUU86Dvh3Csxen5QXjZkv+pKYSZvncPtlbQqJ3pPr7tbpkZuHhVV1Wte7FkDj1gUWl2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uG7i5QwUOaLOklcylctfw26uRdi4EgStfwzNBzXlZAM=;
 b=irl1DqnzuNT5Wdas9ENwewR6RPMyp7TYrkcACMN7ajwjjgRCqPM9+8xXNWDU1v+2X2pza7pCCJJDpsARXHvxfkaW27N9oo5lAx5fGHuMsj9TRchPyTQj0oN2iDF78mWCWhqV5xhPdHyhopY7mogvn6yeN6xQfIduAhfokA5Qe76ggOc40q4CxqyXBOMFTVMwZGm78/yKMZEanVn0VTBjhSsDc7+ZOKDH/Ny0RHjCjx9Xlo4HlodBBUHwotSzxYcG57jpxsNjAZJgGawnt1EgAxv0ukwpoHOLLzVg0gNH0hxCOyVI6PH2VG6GhZc6nY4oLofK/7xwbCn5LfsBaRyhFw==
Received: from CH0PR08CA0017.namprd08.prod.outlook.com (2603:10b6:610:33::22)
 by IA1PR12MB7517.namprd12.prod.outlook.com (2603:10b6:208:41a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.9; Tue, 1 Sep 2026
 17:13:47 +0000
Received: from LV8PEPF0000005C.namprd02.prod.outlook.com
 (2603:10b6:610:33:cafe::29) by CH0PR08CA0017.outlook.office365.com
 (2603:10b6:610:33::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.10 via Frontend Transport; Tue, 1
 Sep 2026 17:13:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 LV8PEPF0000005C.mail.protection.outlook.com (10.167.245.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Tue, 1 Sep 2026 17:13:47 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 1 Sep
 2026 10:13:07 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 1 Sep
 2026 10:13:07 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46 via Frontend
 Transport; Tue, 1 Sep 2026 10:13:05 -0700
Date: Tue, 1 Sep 2026 10:13:04 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Aneesh Kumar K.V <aneesh.kumar@kernel.org>, <linux-coco@lists.linux.dev>,
	<kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, Alexey Kardashevskiy <aik@amd.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, Dan Williams <dan.j.williams@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, Pranjal Shrivastava <praan@google.com>, "Robin
 Murphy" <robin.murphy@arm.com>, Samuel Ortiz <sameo@rivosinc.com>, "Steven
 Price" <steven.price@arm.com>, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	"Will Deacon" <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Message-ID: <apcHoHKGoI7WNFXp@nvidia.com>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com>
 <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org>
 <20260901143445.GC56830@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260901143445.GC56830@ziepe.ca>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PEPF0000005C:EE_|IA1PR12MB7517:EE_
X-MS-Office365-Filtering-Correlation-Id: f86e19ae-e8e1-44c4-7390-08df084c62a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|376014|7416014|36860700016|10067099003|56012099006|3023799007|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JNq6FSEmbckf4pSDNVxWSsxrnGh7VHtXT7HJf8ujQAZJIukaYGEYzpIM/0IfhFD3mXH9JeJ4njyNtDmv9euMCCROnUyb+C27DTQGSWB7JsH4j2rULDOSplJeOQAATmnk9m/WgWMCztVLMGNYkn+QNjFW9CJgBD07SYwY0ilbJ9o8ei99Kd6N+rFeK9G8StJymYroaqNjeE8OlgQnspnwPTYHbabImhZE1UiSnVf99mXQXqEXjy4tGHD+HCJe0+NvM3Di/0OoXLBz3FonapSOFg2knW1naHfBeCmz5czU1ZMnnGrRR5/s9lGRgLef9y8eOXzTB1Ex8rLglymh/QPTIs8o8GN7ZSigKGwq6vE22MhTJOhD5CyIVyo/IWWiWR38Q5ocj1FyH63+PYY3vBuTlkH0miyZ+tEGZb38/YW4gKA8+PeOuIep6CYjCe5Jf7g5rdSi1sjwAAckS85G9nw1Vn4gFq8Mrm85OOz9i9Ge2XmWgolVdINfvNf1TijX8QJx10OYHuzmAnVXQ7eBYnoJgw7Fz4RBeRi58/VGX2wURNiOq6RY+RFzZjWco1Yisb/LvlUY1daPQQfoo+xwB6H/p5eXmRar6VR2zT6zMc8NI3AG7cxq8NDD51mxdrRfUbVCp0BpvEP8dwR4XYebRhDjKzPBoseCsR7RPLaxLsuqI7qFWA9IgAszbwKkcpE4zZRhL1TFB0+ZGDHn2cSmhYKJHA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(376014)(7416014)(36860700016)(10067099003)(56012099006)(3023799007)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NaZGZeMGM4XaM6BzKPntuEnRGqY4BbbN0ArU0LWOJYjxvKRiXoCu8J4bMou75knRJKwn7wYuR0mWFo0BFqQAYsRiOxUS+qlmThlZQsfrg+sEh5Ba0goWh/i8AnU5vLKb3WhqQ7t98XwfhDBb7NobUx3BdL7YyJ2daNSphLOhm67Z+urioJKV7cir5HRMsu/u4iQrI1uLz5Eo1Bhr0Xb7XxxRGD8sNf4Ipt8WLVzOKgZBF7mGYGvO+lxS8on+D9OXJ86m1ldRdS6HloyFwTVoYVbMnu6GFun5PrJngSvQQ7rettlQaGtDyos0wk0gLmeYGxBhJKW4q26ozysvqhOgxDqHypIOBfhIEdSp/Gj8N2U+V4L1qartLgyufyZvAqkBuAoVVAhgXFHeLPzVRMTRE31GHTxhHRu3rmY1OBjxwzMf/3NRs/UcVIGftkZYNX2j
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 17:13:47.3739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f86e19ae-e8e1-44c4-7390-08df084c62a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000005C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7517

On Tue, Sep 01, 2026 at 11:34:45AM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 01, 2026 at 03:36:37PM +0530, Aneesh Kumar K.V wrote:
> 
> > @@ -463,14 +460,13 @@
> >  	vsmmu->vmid = s2_parent->s2_cfg.vmid;
> >  
> >  	if (viommu->type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3) {
> > +		if (arm_smmu_is_realm_viommu(viommu))
> > +			return arm_realm_smmu_v3_init(viommu, user_data);
> > +
> 
> I think the realm vsmmu is going to require a different info struct
> than the normal psmmu case, isn't it?
> 
> If so it needs its own enum value.
> 
> It would be nice to see a draft patch showing how the real vsmmu works
> on top of the RMM spec for it. If we are using a viommu object then
> non-vsmmu case should be identical just with an option in the info
> struct to not create the vsmmu object.

Actually, the PSMMU-only viommu object in this series only adds a
type with no viommu data structure.

I've drafted the vsmmu case on top of the series, so it would add
a structure reusing the same IOMMU_VIOMMU_TYPE_ARM_SMMUV3 with a
flag:

+/**
+ * enum iommu_viommu_arm_realm_vsmmuv3_flags - Flags for ARM SMMUv3 Realm
+ * @IOMMU_VIOMMU_ARM_REALM_SMMUV3_FLAGS_VSMMU: Indicates whether the Realm has
+ *                                             a guest-visible VSMMU instance
+ */
+enum iommu_viommu_arm_realm_vsmmuv3_flags {
+	IOMMU_VIOMMU_ARM_REALM_SMMUV3_FLAGS_VSMMU = 1 << 0,
+};
+
+/**
+ * struct iommu_viommu_arm_realm_vsmmuv3 - ARM Realm VSMMUv3 parameters
+ *                                         (IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3)
+ * @flags: Combination of enum iommu_viommu_arm_realm_vsmmuv3_flags
+ * @reg_base: MMIO base address of the VSMMU in the guest VM
+ * @reg_top: MMIO top address of the VSMMU in the guest VM
+ * @aidr: AIDR register value of the VSMMU in the guest VM
+ * @idr: IDR register values of the VSMMU in the guest VM
+ */
+struct iommu_viommu_arm_realm_vsmmuv3 {
+	__aligned_u64 flags;
+	__aligned_le64 reg_base;
+	__aligned_le64 reg_top;
+	__aligned_le64 aidr;
+	__aligned_le64 idr[7];
+};

I think this should work. But I still feel awkward that a non-vsmmu
case has to allocate a viommu object for a set of RMI commands that
don't need an Realm Descriptor. Things could be cleaner if we allow
RMI_PSMMU_ACTIVATE and RMI_PSMMU_ST_L2_CREATE to be independent on
a viommu; then leave IOMMU_VIOMMU_TYPE_ARM_SMMUV3 to vsmmu-visiable
case.

Nicolin
