Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010066.outbound.protection.outlook.com [40.93.198.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92D6368D77;
	Tue,  1 Sep 2026 19:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788289771; cv=fail; b=agpq+TNkKhMvjQIQcwno7xf2kXQJdEJEkTlzLgI6QzPC3jXSmEv716J/1TS5178toqk0dIWbDrXotbVc35cKiFAGQk0RytYmAqr3ihf8QovlJpAtdrs3uxhQMoJkpRSBkwAenpgMVBz99Pe3xqouDoI8FGy0i+MNOdaj+4AFgAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788289771; c=relaxed/simple;
	bh=lgn2+SWeVWvmnKkGS4cF2sE8Iq3FjVXJef4aNtLXOIA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k4Ww2QopAoAWb7eoZRBCmGjkPaaHgvbYBs8BVIq7E2wI4bPVBkW3PDBMuRuL86b572RcFwbwB6azct5sxARXF5UMFB+yzusmiedJI4S5dm5TpvLERGJ9By6VvQri5n9DB4fxYF9UCIRM4m7a9YbGBnaTJG4z3jj3Fcu0vqzTr1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PrMNUi7z; arc=fail smtp.client-ip=40.93.198.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PrMNUi7z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dvX2XmVhQCS8BJ9h+KyBlqwM1gDrInuBy+ex3y3eEJeDjPG3pTrj8sN/69CqCp0tE6mQ3fXJNIf+QEr2mR1cnk6PFWzxRGAwnSECCWIHZlHeS/QNdWguUkCLILr7IDFRBu7TJ7uEH/U7YTACMHvDP2+vxQlYJ+B6IKbqKh4BSkORZdPNMSXh2Xqt4RniuGnI1o88mBHKVa6oL7jdISorWaxwB01Sr7/ytVqR4Ox9/iN/sUMl33IL93inwEFeRRiq6vJzy3sGdwYC88jnToNolkH/qHNXGFYpM7WXlFera2iiA7HK06wZL9l7pTr3VV+jmSY8OOYkzAwMI8NClH3zjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7uW5KskTS4dXl+SOZwtRz5cWx2MZfZbWxPzt/1WPV0=;
 b=Gtzo1PNDcFGf5FBl7GZbHQJOcGZwzrwww3TAXfE1cHHbOs3WmdvU91Te4CQQOEwhQM709LTZR2xs6EeWxl97WfrggiX5PQe2PZ+hxFbDGQvkzEkVquFrnPrRMAsK+legCi9nsroZol969Ne6SRVYS0z1uqi1aa/JjkX5MgQLjmRkNAR+YvrFkaLznQRA23a5ofUJGZqrC446SO5Q+7muzlvPJVR6bC2aEjwqyoygwXuhWh2uggKzu2Xfk4DIhbkJRYbd2FgwV6hYxUsv6yLeLCbA8Vz5psq7dqN3/x0eqcJ2wrnF6OrOawQL3r6QWjWvzIlq2GccRfeo13GiKJb+SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7uW5KskTS4dXl+SOZwtRz5cWx2MZfZbWxPzt/1WPV0=;
 b=PrMNUi7z8X3l2rz/4gTenHqFOS/V6pGIKoK92ineeXr3N2Lfmzzkc0Qgte2cfS5XGH/xJGb/kfxUgkUMqq6jdKyKoB0P+ZZiuHMIKDd93xb6emvZopj5arsDWzmvUyyKFLwxAxzS7E0mAMW7RKINZUQTpbc+4IGXLpzbfgNV4kSS25uWlf2ZuQSSqpqOluSI2HRMVy7L3sG+pNZ1EQ6Y0SgqYZJvq11DZ0XllYR3EHT8wqA9M4Zmx0Aw8b8s2liWhh/O8co8WzZGjto6c3E4659sqv1nln8fSFLXo6Hb11MsPYe8VNIJTSQtL2f4+Hzo8TC0kq9rfSw8nsDxzEDoeA==
Received: from BY3PR03CA0025.namprd03.prod.outlook.com (2603:10b6:a03:39a::30)
 by SJ2PR12MB8718.namprd12.prod.outlook.com (2603:10b6:a03:540::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 19:09:04 +0000
Received: from SJ1PEPF000026C8.namprd04.prod.outlook.com
 (2603:10b6:a03:39a:cafe::7f) by BY3PR03CA0025.outlook.office365.com
 (2603:10b6:a03:39a::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.13 via Frontend Transport; Tue, 1
 Sep 2026 19:09:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF000026C8.mail.protection.outlook.com (10.167.244.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Tue, 1 Sep 2026 19:09:04 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 1 Sep
 2026 12:08:41 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 1 Sep 2026 12:08:40 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46 via Frontend
 Transport; Tue, 1 Sep 2026 12:08:39 -0700
Date: Tue, 1 Sep 2026 12:08:38 -0700
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
Message-ID: <apcitkpASOREamQs@nvidia.com>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com>
 <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org>
 <20260901143445.GC56830@ziepe.ca>
 <apcHoHKGoI7WNFXp@nvidia.com>
 <20260901174230.GA2847102@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260901174230.GA2847102@ziepe.ca>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C8:EE_|SJ2PR12MB8718:EE_
X-MS-Office365-Filtering-Correlation-Id: b94e85a9-e126-4c95-5ad5-08df085c7d5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|1800799024|7416014|376014|6133799003|10067099003|4143699003|56012099006|11063799006|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	mzhxmUjEwmpKKkqjSA6VsVXyfOIBeFR0r3as9S3p3Sd0x0oqEex/Huj65UKNKH1fX+o2sLMvxUAMVRgxAATMYAoGaPBs/gjN/tHzq4lntdRrjasRgIG7nZFyVPzT2Czjwtjj7JRJCJBHWjfUiWSliBt0QbXExZdbqwU6ZH1TbpqOGx7HamlW5IUXqCDjq7j2rzD+7viZpvZtLVEbgGc96DuERGpUTyj1DD840MIaa9dpV2oFqAS/NpAst7D1CkJdlbqWFNnEKdEhzMTwW31CR5AVy/JfWHpnZ9+ZHu+1+oGG36VbmepT1HoNEnJb3sp16dyZ2HG8zYoiJSLkxzhVhakVEdsi70uP63pwD/XRnDAd89x0KbTkCWc+51MdSdrW8mJZ0aiF+hO8TgR3uDNwBrp8FwqUeD2AEmf081l//0M5l0k2JO9Fa/r8313NW/rFKSbztPv/1s0hb+fVJE1RawbKbrWS3/cMsQSrOezP12lRNuABvNTfCJPwNJ8VPkXu8iX8glyCYoSHmKqELoOsgde0s6mPMLF1Xt+o7geZWUsfydy8qwlBPjeqvhMbPAGokG0m+38bOBWuPu/OGCO6TEvxHKdkBuzL7jgjvJjWl8AZXqGo3mfeljkK5+soiNO087xPGJnscrzjhvihR1QH4srntOwF4qfOTisTrS4xBiSNKKVlHEHPMI9W/R3WFMgGhPblGqnKGBofG5N89wIWEg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(1800799024)(7416014)(376014)(6133799003)(10067099003)(4143699003)(56012099006)(11063799006)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sIkvFzOkPF46m21AYRbJR5jPxvHhoc7/1WnOwzmGr9vs31wQkley/YMhqrm9sdcOo8As9WU1Kb8Kd/cn106k2w3Cs8656o+BR+yq9GbC1ARKoQPKkgCNT4xhusKZgxbuCtel3D6NX5f5Ci5RI2gEWqFp3wCtJSv0FgwOrQwbrnPWb2eyigVUBpJluBvBH4A50YbuWTiIyyUJ24J2eNlvs+boDnKV6twD4hHkr6AsQtstq8S82U8xIwO4Aun8W/edFpkVWSYq7iPyDSbVQb7X2V+DzdbQGO9VQMidBPc31NCvUK3vBEjmOLm4O5th5pH3YDzw0Iz8d9w8lrruXZtcVUOSJNCdTvuw9xUtIwVLqyastMpWx6ZjYZTeHPqzjnh0FASqCIBelgFQWRwY7GnKIASFG/HegPiT5tpd8Gq6cfUDw7U/Gh3v7QJuU7u56uLo
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 19:09:04.2982
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b94e85a9-e126-4c95-5ad5-08df085c7d5e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8718

On Tue, Sep 01, 2026 at 02:42:30PM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 01, 2026 at 10:13:04AM -0700, Nicolin Chen wrote:
> 
> > +/**
> > + * enum iommu_viommu_arm_realm_vsmmuv3_flags - Flags for ARM SMMUv3 Realm
> > + * @IOMMU_VIOMMU_ARM_REALM_SMMUV3_FLAGS_VSMMU: Indicates whether the Realm has
> > + *                                             a guest-visible VSMMU instance
> > + */
> > +enum iommu_viommu_arm_realm_vsmmuv3_flags {
> > +	IOMMU_VIOMMU_ARM_REALM_SMMUV3_FLAGS_VSMMU = 1 << 0,
> > +};
> > +
> > +/**
> > + * struct iommu_viommu_arm_realm_vsmmuv3 - ARM Realm VSMMUv3 parameters
> > + *                                         (IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3)
> > + * @flags: Combination of enum iommu_viommu_arm_realm_vsmmuv3_flags
> > + * @reg_base: MMIO base address of the VSMMU in the guest VM
> > + * @reg_top: MMIO top address of the VSMMU in the guest VM
> > + * @aidr: AIDR register value of the VSMMU in the guest VM
> > + * @idr: IDR register values of the VSMMU in the guest VM
> > + */
> > +struct iommu_viommu_arm_realm_vsmmuv3 {
> > +	__aligned_u64 flags;
> > +	__aligned_le64 reg_base;
> > +	__aligned_le64 reg_top;
> > +	__aligned_le64 aidr;
> > +	__aligned_le64 idr[7];
> > +};
> 
> Yeah, broadly what I would expect. Pass everything needed to execute
> RMI_VSMMU_CREATE through this struct.
> 
> Is there anything more than RMI_VSMMU_CREATE needed from a RMM
> perspective? What about that dpt/ats stuff?

DPT is a bit hacky currently..

Prior to RMM v2.0 ABI, DPT was allocated statically in RMM; there
was no RMI command for DPT allocations.

Now, with RMM v2.0 ABI, DPT can be managed via RMIs. I am making
it follow GPT at this point, similar to the static idea. But, in
the long run, I will think of decoupling, but I haven't looked at
that closely.
 
> > I think this should work. But I still feel awkward that a non-vsmmu
> > case has to allocate a viommu object for a set of RMI commands that
> > don't need an Realm Descriptor.
> 
> It is for the RMI_VDEV_CREATE which needs the RD:
> 
> 	case IOMMU_VDEVICE_TSM_BIND:
> 		rc = tsm_bind(vdev->idev->dev, kvm, vdev->virt_id);
> 		break;
> 
> It has to be tied to a vdevice on a viommu to pick up the kvm and
> vSID.
> 
> If we don't do that we need a new way to get the virt_id and kvm into
> the flow, which doesn't really seem worthwhile to me.

Okay. I see the gap now...

For tsm_bind: idev has dev, idev has kvm, but idev has no vBDF.

Maybe we could allow vdevice to have no viommu? In which way, VMM
can forward vBDF independently. If VMM has a vsmmu instance, then
it can allocate vdevice in the traditional way.

The viommu object here is an empty vehicle that almost has no use
but to allow another vehicle (vdevice) on top to forward vBDF. It
makes VMM code a bit awkward: there is no iommu instance, so VMM
doesn't enable iommu driver, then there is no good place to alloc
the viomu object for VIOMMU_TYPE_ARM_REALM_SMMUV3.

> > Things could be cleaner if we allow RMI_PSMMU_ACTIVATE and
> > RMI_PSMMU_ST_L2_CREATE to be independent on a viommu; then leave
> > IOMMU_VIOMMU_TYPE_ARM_SMMUV3 to vsmmu-visiable case.
> 
> This is why I asked in the other message if RMM spec is clear that
> PSMMU and STE are not required for anything but VDEV_CREATE. If so,
> the PDEV create and SPDM stuff is fuly independent.

I think the spec is clear. And you are right PDEV is independent,
only linked to PSMMU when VDEV is created.

> Which is why I'm saying the split doesn't make sense. PSMMU,
> interrupts, STE, VDEV are all related objects that should be managed
> together by the SMMUv3 driver. You need a PDEV to create a STE, and
> you need a STE to create a VDEV.
> 
> PDEV is the SPDM channel and should be managed by the TSM driver.
>
> So, I think the IOMMU_VDEVICE_TSM_BIND is not justified. "BIND" should
> happen when the SMMUv3 realm viommu ops create the vdevice. The same
> way the vcmdq sets up the VSID tables when the vdevice is created. Is
> there a reason to have it in its own command?
> 
> Further the implementation of IOMMU_VDEVICE_TSM_BIND in this series
> *requires* a viommu to work. So OK, let's lean into that. (to be clear
> I am saying delete tsm_bind)

Yea, IOMMU_VDEVICE_TSM_BIND feels redundant..

Thanks
Nicolin
