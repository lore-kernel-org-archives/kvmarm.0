Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010045.outbound.protection.outlook.com [52.101.56.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C6D79CD;
	Sat, 29 Aug 2026 18:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788027744; cv=fail; b=aE/eKoLu8LVj5cOxXMp3aulCQrjt7HYPjbxY/2NuyG5YR+85oJuovKY92/FyPlzql4ksxKXMahh2N6JnC89N0QOoaaNQW6qEdmtz+mb8Ls7in3WghXlr5mvprVXEK1G/GcNGU9OnfNthHVu57JBpW9kYRO6XeA+Wy4o2c2k7tD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788027744; c=relaxed/simple;
	bh=zINxc7FFcdGgovKApvH5+8T1ZgidzaSDf06JHYmmi2s=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iTDJqEQj6xZyOXu7UAfMq54MBvXuR1Dwqw3WVux5TWmesP4+Tpzewm2r9Akuu1IqUZ+kNj8QhiOoI5d7N/ybw2QS8oQxypXGvLXbZB4BPKgKvgCHoyYRMU6m9SCLXrGk18Uh+GBSHpmbGTx/FfcrnFuRuWx/BC2352m4BYur9xw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RSRVTQbs; arc=fail smtp.client-ip=52.101.56.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RSRVTQbs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OA9aZTlUsLW12KmEwzpZdeL3XlWZi2f+HCJ121pgD+XSQ3+H1YsMKD98k/lKnRMLd8gz7rBi0rkMg2oHCXXnfWxsdqO02SFLHd3M6Q/KHqr/zbVmKtLd64+akj3vj09w+rNmwji/Z8uhxQ9dcX9hVfmBroiVMwG+obA6nA7JwC1iJk7XBXNAutNkrkyv4oOkoftjYaXQnytrOsyyqCQMKnEeTf3Mlqfc0fu/D6jtFAo+FoRN8KEngNGZNz0yfW51CEblhiJ+SDDAE25Wxjk3H4TWSZNTenrDscjki7CcVFuNTkQpZ1sNmTMP2GV3OA18qW7MKSwV/P5+LVuGtdzcvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4TOxm/EjdQ4sLGsI4PX3BcNlLNgsTi2DIFAs4AYkqvs=;
 b=KPmMgbsqjaPV2sobwCt3SnzWED5VziApZSk9jJDOq4Opv00GaR4SfQ13bRg8wh0+YgKoKxW3K6DkkM/+NX8WlKgkvM4KjpQe6Guhq0SHv8y78oSCs9sGEJWLmPfxHJUuZPCXvzzefoB/kgXD331l94LKhDniit/GNOeHzXOJN8uz8d1UT6umoBIEL1kpvzeftmAxQAPFXLL20u21Hx4XHMsXQ1Z7R6paHrkF293p1zsNJq7c+iUrP7i+uJtRFysnGw4B1WQS1W7MMgyzhu7NdF+gerKFmpfrg6stw4kzWwpgX0sr7xlW26emdiyTKSNYMNKXX7p7O2yoJqaNad7zlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TOxm/EjdQ4sLGsI4PX3BcNlLNgsTi2DIFAs4AYkqvs=;
 b=RSRVTQbsTJsp+3J0Nw4vUBe340XRccQODl5ThSFPudKQSMCjYYmAmKYKDyF7VlzHC679tOG5wZEiYvX23y4fwu1basaxwQe3Kmmq+gy9s3lezCBcR/NyOo8UGKBtUZqq58lZsRr73Kw6OxniJ8E73pLYOfNs7xS178DXfyOO93VadcD68xKE82zjMi+RBAOTE2DTq8TESuaDJdtvJInp8LMY0SnVv535m4uZVMWb72Vm8KAX6G0+qDj3oeGC8AY0j/qGr7BbiN2nMH4/uU/SoMEzE3Yrn5OIcY5FlCR1NiWk+fuKKi/YxhbjPvdxspObbz9XCcrHQb0qrsn85ndISw==
Received: from CH2PR19CA0012.namprd19.prod.outlook.com (2603:10b6:610:4d::22)
 by PH7PR12MB5711.namprd12.prod.outlook.com (2603:10b6:510:1e2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Sat, 29 Aug
 2026 18:22:16 +0000
Received: from MN1PEPF0000ECD9.namprd02.prod.outlook.com
 (2603:10b6:610:4d:cafe::d) by CH2PR19CA0012.outlook.office365.com
 (2603:10b6:610:4d::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.12 via Frontend Transport; Sat,
 29 Aug 2026 18:22:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MN1PEPF0000ECD9.mail.protection.outlook.com (10.167.242.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Sat, 29 Aug 2026 18:22:16 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sat, 29 Aug
 2026 11:22:12 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sat, 29 Aug 2026 11:22:11 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46 via Frontend
 Transport; Sat, 29 Aug 2026 11:22:10 -0700
Date: Sat, 29 Aug 2026 11:22:09 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
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
Subject: Re: [RFC PATCH v4 01/16] iommu/arm-smmu-v3: Discover RME support and
 realm IRQ topology
Message-ID: <apMjUSbxcnlAKjks@nvidia.com>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-2-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260427085344.941627-2-aneesh.kumar@kernel.org>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD9:EE_|PH7PR12MB5711:EE_
X-MS-Office365-Filtering-Correlation-Id: c01f161a-66a5-42ff-3b63-08df05fa74a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|7416014|376014|22082099003|18002099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	gYGGoOz/yPH6ypA6BBTqcUhL4gci7n4GnxlySarNAc79PC/SBo0UXQ5sZ7sKnx7GPxvbh90IN2Hff2Ue1cZAolU995kM27m1cShPIUymmLJmV1cZev5PjUOepJcHnC2rAfAGe4oc+kdZko/PM3DfaLnN3amgyLoLucbm8aGXrBrsRk1Go6XmkmyiusSHxw7LSq7KfCPXemWeRHNHjTktM5fNMPQGp1X493AoOhm+XA4JC3Y2rueFntw9A/fy06H5UBMhdNGcavqM9pCIHeeXsbALtiExb71dmVmRK7gRc+vP2lM82L/WYost0ozN3011m5yvXVD+2CenL9M0PbpS2Fn++R+EoUuupM7j29TSPuDDiucknKByWhwxmVAnWcK36f8ycz5VFPZS1DGE4sd9QxCPHy9Ng7tg69XybmhpaVGrjPRjlUpFFm38P/HH2o2VrvZUPupU5URnCOarmUZWmoy9uolNIMjH8LV/diRMmSGckCVGIovGMlk60CrU1BV4+72KFqmlftiOzKyviZqtfOOSZKmC8SZjC5SmbYT61kvCklLJjOtyWRTLIF53EhjP9lUzjZqJlKLGRELT2tk5p8ShWx5ckV/wET+rU5hzGt6AfB6u+tn4BAkTDusnylZGUMppwZzfVjV+7e0Gz6t1EELXrs5Vx4JZrWMtTHuU4VLT+KkYYAFFDwQcyMtmm3kQlV+Xj2h0Y8TvG5MLzxrPbg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(7416014)(376014)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sCsc+0kxK69zsufTPcnVlAYvvv/Q80k/YYL+Q/epGYA5LcyO++w3wovt3qKfbQyUiJiz0s7ekCpNAYQUo7EjnD3xoBVC5MC4WRo/RTol/7rQMGFvunTTGzH6Ii+RqY2O6kyDDtv8KQXhfLmxV4uxGVcVAhva/zKV1PKf59WFAKuSAvyALq00wQkpxjuHSr5vNHSFybZxHLcpvGBQgqYKKQC8IMfE81cX0viI3AGwwjNlMzQ44SbV3m4Gtbz2TvRsyjYo1vLISlTP3NxDO7SCSBtiF0Qtev1uBQvC5z2AofIlXCrF/VO9gGYcTS2hqbfa4gCYl2JCyXSLj7RmT9QbLxoZayeLuXamO2oxteUEtMZzdcrXkUQvfgOj1+AaSYbEvd9BgwqTAJ8CNu93GDDoGpT1XOoRHi2Ln6ST2fFRBOuRChY6XCnrhXsor3uLVIB5
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 18:22:16.4844
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c01f161a-66a5-42ff-3b63-08df05fa74a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5711

On Mon, Apr 27, 2026 at 02:23:29PM +0530, Aneesh Kumar K.V (Arm) wrote:
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-realm.c
> @@ -0,0 +1,124 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2026 ARM Ltd.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <asm/rmi_smc.h>
> +#include <asm/rmi_cmds.h>
> +
> +#include "arm-smmu-v3.h"
> +
> +#define	RMI_PSMMU_IRQ_GERROR	BIT(0)
> +#define	RMI_PSMMU_IRQ_EVENTQ	BIT(1)
> +#define	RMI_PSMMU_IRQ_PRIQ	BIT(2)
> +#define	RMI_PSMMU_IRQ_CMDQ	BIT(3)
[...]
> +	if (irq == smmu->realm_evtq_irq)
> +		notify_flags =  RMI_PSMMU_IRQ_EVENTQ;
> +	else if (irq == smmu->realm_gerr_irq)
> +		notify_flags =  RMI_PSMMU_IRQ_GERROR;
> +	else if (irq == smmu->realm_pri_irq)
> +		notify_flags =  RMI_PSMMU_IRQ_PRIQ;

These are defined as BIT(x)...

> +		if (rmi_psmmu_irq_notify(smmu->base_phys,
> +					 notify_flags, &event)) {
[...]
> +			rmi_psmmu_event_consume(smmu->base_phys, notify_flags);

.. and passed to RMI_PSMMU_IRQ_NOTIFY and RMI_PSMMU_EVENT_CONSUME.

RMI_PSMMU_IRQ_NOTIFY takes RmiPsmmuIrqSet type, which is a 4-bit
field that has a range of [BIT(0), BIT(3)]. So this is correct.

However, RMI_PSMMU_EVENT_CONSUME takes RmiPsmmuIrq type, which is
a 2-bit field that has a range of [0x0, 0x3]. So this seems wrong.

> +void arm_smmu_setup_realm_irqs(struct arm_smmu_device *smmu)
> +{
> +	int irq, ret;
> +
> +	irq = smmu->realm_evtq_irq;
> +	if (irq) {
> +		ret = devm_request_threaded_irq(smmu->dev, irq, NULL,
> +						arm_smmu_realm_notify_thread,
> +						IRQF_ONESHOT,
> +						"arm-smmu-v3-realm-evtq",
> +						smmu);

These IRQ numbers are raw numbers forwarded by firmware and then
returned by RMI_PSMMU_INFO:

+		if ((psmmu_info->flags & RMI_PSMMU_IRQCFG_MASK) ==
+		    RMI_PSMMU_IRQCFG_IRQ_WIRED) {
+			smmu->realm_gerr_irq = psmmu_info->gerror_intr_num;
+			smmu->realm_evtq_irq = psmmu_info->eventq_intr_num;
+			smmu->realm_pri_irq = psmmu_info->priq_intr_num;

Should they be converted to Linux IRQ numbers before forwarded to
devm_request_threaded_irq?

> @@ -782,6 +787,9 @@ struct arm_smmu_device {
>  
>  	int				gerr_irq;
>  	int				combined_irq;
> +	int				realm_gerr_irq;
> +	int				realm_evtq_irq;
> +	int				realm_pri_irq;

Nit: this series adds a few realm-specific things in the top SMMU
structure. Maybe a "struct arm_realm_psmmu" can make them clearer.

Thanks
Nicolin
