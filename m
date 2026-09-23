Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010059.outbound.protection.outlook.com [52.101.85.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EC11474CC;
	Wed, 23 Sep 2026 00:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790122973; cv=fail; b=p9j7qXbWIBo0UD+dM0b0YhM4Emt75sMEYWu4zCGteV8Xwr4V9GzcxOIhfnWF0Vhn+UsEHcgI8cJCFDzw38mjiOof+BmOS6w2pKbVwfe+kiaqokEg476Neun8cA39gWE1M0dHTLnuIq7rSDQcFS1GgT44zBgbl7Lc30hEvkYqPxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790122973; c=relaxed/simple;
	bh=5Kep7gKx3wQQqCAlLuW9ddw/76VckqY4nJki8s+ygSs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QyYG+LfoYmnw6oS1uU1GODapEfavtKQOXYO0EqaU2zlR6vV3+6JIGMBSvVLj16wl9GvYMRuJFYamwHorn1Fk1HQLN5ECVz8qC8znMc8owYnM6Xj6qcFKlZ21lEQ/uMOZdgdJn8PzfNZlEPzYRA/CFTbFDlEz16gH/dYVaIewD5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KmkM5Bu/; arc=fail smtp.client-ip=52.101.85.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KmkM5Bu/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ID7aG3ke63t2YCfTHqK3ClFA/a5nQDd0nH/PTLJoXRWCUJTTcSXLvmifxsrdhqRV4LqvlG/WxINQq215ByS7lYfONtEXVGZRZwFJWW37gDK3Lbtyn8rf0eW6Li8oowO/hh0bsth/Ufxkg3pE+gRfSIgGJasm1mFG/MXiaW3d50qBzVHxYr8Pzbzuw6sSYehbJiwqEHZcgry85W7P8kSUsUkcnVcKZbtfSk+7RiSYOzz2cIax5O0pzNGTQW9a6gjgoy0Qsacn/NPCASzGnFS9bWN9CPx3Y+akQHnYfTGmE1V0H4U3bnpKqtBzWIHQmuWUgxUgihBTSwwdXZ3+PSBEXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3JnjXoIdNWNF3OnAMaYfFI4dk90X2HMnX3WQrc2OLHY=;
 b=je6KaMw3flf+pzKs+2WucEwYCHWvzDO2998j5Ll5uGMZ6LWZP5rc0wj/iaM+GkVp8BjP5ibM2NhAgbKAzC4gvpFzcW708lzWPFxRv0hbI7UIeH9RFa2/wRvKa+Yh1BBtEnpEplxhsE3+axRjSEM4FSak7D5jdGq2P5jh5aHTmYlWd+vmK02csEPo9fofHc3yBNFf4OfmV3lBlUWh3/O66xoY3H+QG54ijXdUNDrHZyWowF3Wxi9XXvFspQnDFL3arXuECmznU99Mwp9cS59vr/TJe0plwPMVMw0wHOp29OAcMNOplhOXaixtWzUX09H/skXnnarzI3KHvntvM4brtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3JnjXoIdNWNF3OnAMaYfFI4dk90X2HMnX3WQrc2OLHY=;
 b=KmkM5Bu/uLsMwzOlBKoaymR/rhJqAGyJ9Vu6bTv8dStk/6K6q96tfPFbmorbh+mawzuFVspjWDa0QVDPTniI7aOHToNgG0WB7f1enQxfOw0K87wFeJOhBPZmGjcCCrSkZsEEv5a6urE67g9OeEgtoaAIKeFu+X99XFVKrnKLvRQhAeGDAyk+JXbfmpdh5kkPhSU3lUJMtf6TNcNkd7Yr02p6FAyhu8wizGxYbjLsQPWYs3QtQ9P5hzI2b4dLKREwPceFzqb7hS7L+j1HeC5ff7+W3Io8R017FaF64mE0nMQI44eDOenn/L/BEgn/BTt0mCxNFNFzdL/4ExQkXfqBog==
Received: from MW4PR03CA0114.namprd03.prod.outlook.com (2603:10b6:303:b7::29)
 by CYYPR12MB8961.namprd12.prod.outlook.com (2603:10b6:930:bf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Wed, 23 Sep
 2026 00:22:44 +0000
Received: from MWH0EPF000C618B.namprd02.prod.outlook.com
 (2603:10b6:303:b7:cafe::3c) by MW4PR03CA0114.outlook.office365.com
 (2603:10b6:303:b7::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.16 via Frontend Transport; Wed,
 23 Sep 2026 00:22:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000C618B.mail.protection.outlook.com (10.167.249.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Wed, 23 Sep 2026 00:22:44 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 17:22:32 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 22 Sep 2026 17:22:32 -0700
Received: from nvidia.com (10.127.8.12) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Tue, 22 Sep 2026 17:22:30 -0700
Date: Tue, 22 Sep 2026 17:22:29 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>,
	<sebastianene@google.com>, <keirf@google.com>
Subject: Re: [PATCH v8 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
Message-ID: <arMbxX+sqTS3gByB@nvidia.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-12-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260922131259.2975334-12-smostafa@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C618B:EE_|CYYPR12MB8961:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b40ff26-b286-44e5-830b-08df1908c9b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|82310400026|36860700016|10067099003|56012099006|11063799006|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	T54lo+E8+h+kllgJ77z4VQiTywocu1KZPaWn60+VPE2DUXZxRTJvtRaoIz2cmNGz3rZmdzI23+t4u+mev33uS+b7qfXtfeYWQcCxgTPBrAiuv1YNF+gIZlkFGSSJpHofxfbO9oUEiVAKs2NOs12z4gA2uUYJaMEbscaRU9aZp2Pjjht8PeqbSvoNmwkAQle4eNXnoiWWVYkwLfzFPsIvlHUZKjtYy6h63y4k4tPT6m9BUQTpuF60pjfoiJ9rvdm2OsbrKfGQWInbKQomwR2ANXWaz6ay14XF6KE5NTEhghiHJpSni8aDgQfJYS2OUr/v3nWwuOo2ptgwXPt8WE1uWhEEwhgIMkhyVMZtLbHnmCnYw85uZvImcVxRVVitIbs3XRk6tcZjso1eeQ0wF2Eh/Dp4q/Zclq17h2EqyVzei2mHs2sfAxcheQk13DfNXwMHb1SRh2SJMfBeFztShgMWizkUj8/efOES6ohsnoN91O8jV2pb/U4atIsExREkEfjeWs5RbN/OrYrxFCifKCXSOZJijfF2CcLIcCUo8JTIQaABqAsBhVqI05KCF6lBFShLQozby98w+7KXI7TL8WzBihx2/vOr215RuS1pS9zMrVaP0O6glYhlq+7g0o4dJSx/oiUG21pctnQx8uN9EzZJXYGiLs/HG9ZGE+Gqey12VGfUqehvA9cfiMI4h2WCmB/Mk0fSrWBrB3ZZQIpaOeD1AA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(82310400026)(36860700016)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HO2j50IbMbpDfVw4facSHHroXtssXJDPXDHIdkOdQb/uHgVMQMdPUwpkSeCX0Agn4KuqKabjVGPbIh7PKElVNTqSRKRn9Z99kgIcxCCQqkBfL6PGJquojRUxSsQ4+MKIISDTdoYzobfvMZWCiRMnHqvrg1jWmvaWsS/pYiJUaZdciuwwWQSkLgMDCg+f71sQ49HNEh81EjphibAJ2ZcnOq/9mufik4FiQ4qBiuPZf94YidB7/nqAv/ygszM3OEHdR4CkVT8SVcK843fhiGl/r00knD09pQKtQMEXmk5zcneElk3VT+bhCKhbz+dEgTT9TgodQoLgoCwOaoDfyxoLYMJ6bLkPI+52ULDKtU25h5eKZiUYptJx9L+A5RMvbDcqvpIw8Di4N+TzmGhGGPWXIhhBRNvuj9O4OLGY6XMNdFax2l1WJiUoMwiXPKak5mJG
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 00:22:44.3251
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b40ff26-b286-44e5-830b-08df1908c9b1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C618B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8961

On Tue, Sep 22, 2026 at 01:12:44PM +0000, Mostafa Saleh wrote:
> When KVM runs in protected mode, and CONFIG_ARM_SMMU_V3_PKVM
> is enabled, it will manage the SMMUv3 HW using trap and emulate
> and present emulated SMMUs to the host kernel.
> 
> In that case, those SMMUs will be on the aux bus, so make it
> possible to the driver to probe those devices.
> 
> Otherwise, everything else is the same, as the KVM emulation
> complies with the architecture,so the driver doesn't need

Missing space before "so".

> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
> @@ -0,0 +1,187 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * pKVM host driver for the Arm SMMUv3

I am a bit confused by pkvm/arm-smmu-v3.c and arm-smmu-v3-kvm.c

It would be nicer to have a design doc or diagram here and the
other place to show their relationships (with host and KVM too).

Naming-wise, could it be arm-smmu-v3-pkvm? I also wonder if we
could move it into the pkvm folder:
  pkvm/arm-smmu-v3-hyp.c
  pkvm/arm-smmu-v3.c

> + *
> + * Copyright (C) 2022 Linaro Ltd.
> + */
> +#include <asm/kvm_mmu.h>
> +#include <asm/kvm_pkvm.h>
> +
> +#include <linux/auxiliary_bus.h>
> +#include <linux/of_address.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +
> +#include "arm-smmu-v3.h"
> +#include "pkvm/arm-smmu-v3-hyp.h"
> +
> +extern struct pkvm_iommu_ops kvm_nvhe_sym(smmu_ops);
> +
> +static size_t				kvm_arm_smmu_count;
> +static struct hyp_arm_smmu_v3_device	*kvm_arm_smmu_array;
> +static size_t				kvm_arm_smmu_cur;

That spaces/tabs in those two lines look a bit odd..

> +static unsigned int smmu_hyp_pgt_pages(void)
> +{
> +	struct device_node *np = of_find_compatible_node(NULL, NULL, "arm,smmu-v3");
> +
> +	/*
> +	 * SMMUv3 uses the same format as the CPU stage-2 and hence have the same memory
> +	 * requirements, we add extra 500 pages for L2 STEs.
> +	 * Only one set of memory is allocated as the page table is shared between all
> +	 * the SMMUs.

Mind briefly elaborate the 500 pages in this notes? Why pick 500?

Also, there is no hard requirement, but the main driver still wraps
inline comments at 80 cols. So, it would be nicer for this driver to
follow that.

> +	 */
> +	if (np) {
> +		of_node_put(np);
> +		return host_s2_pgtable_pages() + 500;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct platform_driver smmuv3_nesting_driver;
> +static int smmuv3_nesting_probe(struct platform_device *pdev)
> +{
> +	struct hyp_arm_smmu_v3_device *smmu = &kvm_arm_smmu_array[kvm_arm_smmu_cur];
> +	struct device *dev = &pdev->dev;
> +	struct resource *res;
> +
> +	/* Only device tree, ACPI not supported. */
> +	if (!dev->of_node)
> +		return -EINVAL;

Sashiko reported a critical finding, which sounds plausible to me:
"
Can an adversary bypass pKVM stage-2 memory protections here?
If an SMMU fails to bind to the hypervisor due to early returns in this
probe function (like missing a device tree node or hitting the cavium
erratum below), it is excluded from kvm_arm_smmu_array and the hypervisor
does not trap its MMIO.
When the native host arm_smmu_driver registers at device_initcall, it can
successfully bind to this unbound SMMU. Does this allow an adversary host
kernel at EL1 to natively program this untrapped SMMU to perform arbitrary
DMA into hypervisor or guest memory?
"

Would you please justify?

> +	if (kvm_arm_smmu_cur >= kvm_arm_smmu_count)
> +		return -ENOSPC;

Both counts and probe() are coming from Device Tree. So, it doesn't
seem possible unless a kernel bug. Should it WARN_ON?

> +	smmu->mmio_addr = res->start;
> +	smmu->mmio_size = resource_size(res);
> +	if (smmu->mmio_size < SZ_128K) {
> +		dev_err(dev, "MMIO region too small(%pr)\n", res);
> +		return -EINVAL;
> +	}

Should it reject !PAGE_ALIGNED(addr|size) like the other driver?

> +static int __init kvm_arm_smmu_v3_register(void)
> +{
[...]
> +out_err:
> +	kvm_arm_smmu_count = 0;
> +	kvm_arm_smmu_array = NULL;
> +	return ret;
> +};

No ';' after '}'.

> +static int kvm_arm_smmu_v3_post_init(void)

__init?

> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -5203,6 +5204,72 @@ static struct platform_driver arm_smmu_driver = {
>  module_driver(arm_smmu_driver, platform_driver_register,
>  	      arm_smmu_driver_unregister);
>  
> +#ifdef CONFIG_ARM_SMMU_V3_PKVM
> +/*
> + * Now we have 2 devices, the aux device bound to this driver, and pdev
> + * which is the physical platform device bound to the KVM driver but not used.
> + * However, this driver keeps using the platform device for 2 reasons:
> + * 1) Simplicity: Avoiding changing big parts of the code assuming
> + *    the underlying device is a platform device.
> + * 2) Dealing with DMA-API, irqs(MSIs), RPM... requires the physical device.
> + *
> + * That means arm_smmu_device_probe() allocates its devm resources on the
> + * platform device, where they are not freed when the aux device unbinds.
> + * The devres group bounds them to the lifetime of this binding instead.

There is an "unbinds", so I assume it should be:

s/bounds/binds

?

Nicolin
