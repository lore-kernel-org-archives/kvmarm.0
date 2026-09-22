Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010035.outbound.protection.outlook.com [52.101.201.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0547452B1F4;
	Tue, 22 Sep 2026 22:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790116788; cv=fail; b=gZt+R4Wp54Z3rl2paR23eDmpvNH+rzeTLY7GT3jjyfLo1keKRKEQVgOtcSH9qdgSgyrmjPhihrv0wo8CKub8DBqWMrKRo4LQk5WnHn+V6oIp+O2CexkesTA59nN0uHCQpZn8gKTnDJalqLOarqx5szqIDtuUTIJ6//BhWmeMAc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790116788; c=relaxed/simple;
	bh=0AdOGd9KKCDWEWJs0VDm/dX4F7aONiFYK/Nf9DKXzP4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZsRdJmzcEYn0UYsgfn3W1ATneKQuSPCRzcL0fR16iiDQ7o7qniiNEPgXc8sGYUhP88hx9U8YaVqRwPCuHPQ4kbwF65dyvq0FslOKJVWTltpfac2z3tRZz3wM5x+WoE8xz2lDLVPuOD8JghPxFMB4yfHbXdg+d0vB7dTJedYoWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ONOsVIAT; arc=fail smtp.client-ip=52.101.201.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ONOsVIAT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cOeSuYAeJOllcskoJVx17HDD1Iv1HhdRCxMJGo3wueNc2qAzCE7WaFdfMjGUgucIGXEgnRg/w5lIR3G6635xzdoBLsmrDXgDE4rUx4yHvAmtrAoMU0nLmS070bYXozeRYUnpnp/Uo5+6vZ2sekE3ZVDpuuy8h9TBC6GZ/O0T4w9tADQ0Hcby4ga+ougWP7TmltINnWbm9i6+9J61hra/yUPQYESgT5FIBd0dV2aPbKZ22HHa0NqUZrGZABu6eGcec1dJy1EB7oHzMe2EBqehnLzX+5nGiGJiTEUxuM0zQDUg5TKWS7rppRNGdQIkp6E/q1MeM9C26JsfxY7gw25prg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O/9BGW/xnK94pJuq2EdJbER8yTbRXmGlKEp6TiS1lsk=;
 b=c14ytp6eawvNOTyy3cZsUslvXw1BehRMpS/6owsRjikP2fw37ny/oWv8wm5zu+k6BzBZdERgWFQ5HlxmhMaU6AA2qmu3k52zoiQrDVcvUW8qaB5B2WgJuOO8kFcF0IBiKsm3DYeZShnxlQRTHYM2KP1CzNiGMh8i/MqouHIDgVjC0BlixGtdih0acZUZTaZp44C6iHufczBs4BPXHurZQ8sqkk1mr/1Nl9KKXS3Mi27583h8/rTv4DSynePHRO7WrrnRxHddKZ9PbCvaEmVDwamyd1lFCtd/dZdfiLuBuqMLiE+BOlE2oLAjPUMccrZKUmEbtQA5SuxFoi9yeWsJXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O/9BGW/xnK94pJuq2EdJbER8yTbRXmGlKEp6TiS1lsk=;
 b=ONOsVIAT/A3l2BtnjQnQlB52L0aU4KD5sw5v/LqEUT9tbQ7cpAh5G51AH2h7s5f9plhJDzAQ4hw9iYgvnA05l5nijoNd3XqcsRJ6dnLqBdWpcpAkyKeSH8sGOD1MMHJsAMrGuYZOwLvPhAYIj1GfCxIyA8+J4CcDjoTLqELTg3NwhUp4thzgS7kGI1V2JJOQ4va6VPxcGlkfBdFyJC0nmaipxgxWSSfUT6kFIKUCs9hrTKSjexZg2GnQGZH6Ipiiz7AVlkWv+VLQ/wxYkkwQY9k0w/ReIG8GJKfQ7T+7w1p7ilIpK6Q4+471lugXLaGmpXODOZHBNWx8zayqVzHfoQ==
Received: from CH2PR17CA0019.namprd17.prod.outlook.com (2603:10b6:610:53::29)
 by CY5PR12MB6384.namprd12.prod.outlook.com (2603:10b6:930:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Tue, 22 Sep
 2026 22:39:31 +0000
Received: from CH2PEPF0000013C.namprd02.prod.outlook.com
 (2603:10b6:610:53:cafe::6c) by CH2PR17CA0019.outlook.office365.com
 (2603:10b6:610:53::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.14 via Frontend Transport; Tue,
 22 Sep 2026 22:39:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF0000013C.mail.protection.outlook.com (10.167.244.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Tue, 22 Sep 2026 22:39:31 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 15:39:08 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 15:39:07 -0700
Received: from nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Tue, 22 Sep 2026 15:39:06 -0700
Date: Tue, 22 Sep 2026 15:39:04 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>,
	<sebastianene@google.com>, <keirf@google.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>
Subject: Re: [PATCH v8 10/25] iommu/arm-smmu-v3-kvm: Add SMMUv3 driver
Message-ID: <arMDiPHiMvHVHsBr@nvidia.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-11-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260922131259.2975334-11-smostafa@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013C:EE_|CY5PR12MB6384:EE_
X-MS-Office365-Filtering-Correlation-Id: f1d5748e-ea1e-4efa-d00e-08df18fa5e5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|376014|7416014|23010399003|6133799003|22082099003|18002099003|3023799007|11063799006|10067099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	fATAxxF4Wko01zPMWe6J8TuQAW8jb4UZaLk6UsHnkC6U5gZcU+FmoOed9MFs5x/CZgjdmvqO3oscigsbWcW1HYLuUmh4FpCxZhoJxK/qPZXDShAWUeJMqEzDFz0nnVJH4T1fZf2EYDy6eb4o8PRHJZb5cqOXFX8aaolnfIA60T9dyChjpZs7ySTobRToJ0sEOqWts8Bf1tRgxUPugwr4Vf781UxsNngvTF1QAOOc2pogPx1H78DD8ESmiNbLB+VOASpQIXGLsF8biQTHKwvHCKlnAtQc2v1DPzZ+32xWjIRxDvzAz2wk7VVhwFOgUF7Ar+c4qntym5AUQnvGhaMoZwrRLmYItjz5U0mHeDYJ3cfLGA8pszXA+/8LkfJlLhSs55rJd2c5W5AGfEmKw20xmuG1L2CzFJZ/FQAGjZbo5K4NpYa/wqL3utois2NF2S32e4pZsBOAdNYmNNYgI6zJC46Who16WOFgVF00ymL3z9wNSbFKSVAETx2/4S6sCeGbG9+Qfy0F+T1S+Muk4ePdjgopHEq9T0BgNhCgNZ386NVdtDujkIvweyHrVhPEkNsGc5JycMbHinJVOTwu8t7n3DO1209XwsbObpzHNOnKHpFwlaX/UCR8Kyjl34RJ2ez1N40x1/qNeSWAV0DMe7iEXyzMPkZbLmyWwNeExA+dbvHVaIP8KD4zOrikSMvXGrluJyEHcWQk0E1mzj0Ao3pCdQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(376014)(7416014)(23010399003)(6133799003)(22082099003)(18002099003)(3023799007)(11063799006)(10067099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	juHhOFJJ+oEyFzZtJn95p2InWRJLJlsMoDHNif/X6Lu77tPLd26UWTX0jzElus2r0nUtNS6NhxJNiCOQ9vmOkREtmbVbIq7TRQPZEepaB/TQGeV0OGsxM33M7UNNxwhh36EnJ36IS/FN5cszx/m0hDWQFEDWERwhP4tMuUdXAYcWPGixfctc2ATAt7cQBSWhss5otOQ8CQKKP1BEDA5ZQSiosimTS86arJ9OnILiJ7eE0HCArziDoKRcfOPpLdW3cBKZ/qA1OCSvKjllyfkjwMxPZzHdEQZo5Qm+rZD76mkSi+9WB1REc2WQaUPGH6lTAxvo8JWoDgT5xIWJyRBvojRx69hTy/H+8jReUPvgifxsGbBuAxMt/86qade5lAK0L/5jjjnP400TyOArUlSlgcRY3FCaUVin0pRti8Vhachg3jQaZuNnJYnC9EddWmzn
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 22:39:31.2389
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1d5748e-ea1e-4efa-d00e-08df18fa5e5e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6384

On Tue, Sep 22, 2026 at 01:12:43PM +0000, Mostafa Saleh wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Add the skeleton for an Arm SMMUv3 driver at EL2.
> 
> The driver rely on an array of SMMUv3s on the system, where at

s/rely/relies

> +++ b/drivers/iommu/arm/Kconfig
> @@ -141,3 +141,15 @@ config QCOM_IOMMU
>  	select ARM_DMA_USE_IOMMU
>  	help
>  	  Support for IOMMU on certain Qualcomm SoCs.
> +
> +config ARM_SMMU_V3_PKVM
> +	bool "ARM SMMUv3 support for protected Virtual Machines"
> +	depends on KVM && ARM_SMMU_V3=y

Should it depend on OF?

> +	help
> +	  Enable a SMMUv3 driver in the KVM hypervisor, to protect VMs against

s/a SMMUv3/an SMMUv3

> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
> @@ -0,0 +1,31 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __KVM_ARM_SMMU_V3_HYP_H
> +#define __KVM_ARM_SMMU_V3_HYP_H
> +
> +#include <asm/kvm_asm.h>
> +
> +/*
> + * Parameters from the trusted host:
> + * @mmio_addr		base address of the SMMU registers
> + * @mmio_size		size of the registers resource

Are these still in the host's physical address space or guest's?

If it's still "host" (though trusted), what's different from the
ioaddr in the main driver?

> +size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
> +struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;

Should kvm_hyp_arm_smmu_v3_smmus be __ro_after_init as well?

> +
> +#define for_each_smmu(smmu) \
> +	for ((smmu) = kvm_hyp_arm_smmu_v3_smmus; \
> +	     (smmu) != &kvm_hyp_arm_smmu_v3_smmus[kvm_hyp_arm_smmu_v3_count]; \
> +	     (smmu)++)

"smmu" sounds too generic. Maybe for_each_pkvm_smmu?

> +/* Called while is the host is still trusted. */
> +static int smmu_init(void)

s/while is/while

> +/* Shared with the kernel driver in EL1 */
> +struct pkvm_iommu_ops smmu_ops = {
> +	.init				= smmu_init,
> +	.host_stage2_idmap		= smmu_host_stage2_idmap,

Can we add a "pvkm_arm_smmu_" prefix for the ops and functions here?

Nicolin
