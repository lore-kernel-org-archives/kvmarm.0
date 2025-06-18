Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA672580F2
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 06:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750229775; cv=fail; b=NIWIZz4TDX/GXdEPhZtZGP5spOweQqdBnLIxY9+3b/f0htI1hNCUPqlB3MH2uKD1o/Szk83ZQDcH3SQN9kdGZwDuOuSnJgqj1McDDEowGHXMIEz+PxNS+doS9JsEQaXXikdv6PlbOEMqKEYADDoniClhjwwoR7ffsLJLjQOzOZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750229775; c=relaxed/simple;
	bh=PUf5xxUlMPLk10Hr9bQhidj+22898dKKyoPbPmjwRCE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=teqGcNuoWreuHdUZ8NtJDaOGv1TRd77LjYnxW6LUardf4lGWIyPCDsw0Xhaq2btMg4DySv69M7ut1lGqoorfuGi0KnK83HYyN2QcITbX9lQJSducRc6yTyAFHlG4vfu6O7J9g9dSfY25I8qDoRiQjiiMlY9ZUXu4chAIXtbgd+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MMZxd5Pr; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MMZxd5Pr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pNKD24fLFUVBM4d6U7FSFa3ST4KCEkDGugtdfDAwGRY6XcehSQ9E5pXFi8lwf4BacVlfVHGckrDFr2Q+9pvQWOwGfjMKpIXrZFEoDa3lf3/x0W9LbJYY4mnKbbuNUysl6yla6xm6OZHnGzmxNEHA+4fD4on5vPz8YvVORwPCas5ef0uGP8XsE1BJJErbFKcaw8KZ4aMCh2KiWfOcOC8I6ree0PVmgdubFInu047THLNvDWxjDRAAr40FH2slNGOltnfTyWDuyA0UyyCaEUYi1kpa31T4x2DAIDtgWhkzMgifKvfDZY/Dpzr/KOwcPm4nG5NfCmOYoICyrzOWM3PAPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MesUWoiAZo2LyHB6wUWcW9RdXMbvgLXxTKGSdwx+U48=;
 b=m+6j83CEd6VNSjNzoDnfhgGR2X29fOBNKD/egB0F9eC/1sxAocVrLfInGFV7UTUEIHcp7n++dt5OHTXkGBb2nIYdkYum+4JB/l8rcdPpFHZI7HmigOnq3ghFB3D7QCd9tm8XHvLahhnVdSFiY8OuwQZmHO8RoncMAtU4sIsRC613ixFirNYGY5KT+LHG1f3YP+NkZ02AQjIME6arEZV2JzpHVmydK1GYvOjBz754J/V52/cLmBJz7BGvyNl5I13ewUCuaRZy7rDPtV56lTGfGAc7Lkuw/JrvB6AIzFnhLzmrbRZvdLd2uwHpipC8AqAUqdT8lRsHxJupOrOvYfKHyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MesUWoiAZo2LyHB6wUWcW9RdXMbvgLXxTKGSdwx+U48=;
 b=MMZxd5PrZv34yRi6f0oiXYiFsd06y0rcRuh5XNLJu9BnFH5tBNIFykt1BpeCqaPvdbFy276yPJbcsfmF7MymAUUFgdMwSS+n/X98S7aHRtklLJDTNZ3VB2w5OXdkxfm16JS4iWCOnbXXOIbkuL6R5Km2aM/103EYRIA86AAbjZqTWAVusgX7Ex23ba2X4KMvfTzSi37g6GtjXRKGmct3HNdjRXQkawBopxKY1m9eIthna5nspe2+abutv9fflgm8j80ESctFx4iunN+fyWRr41OseAKynWpdZe6EKlKJndUEr+sGZHffVenQIBKWwASmGTvuuoIOJjzWG9qP6ScEQg==
Received: from PH8PR02CA0009.namprd02.prod.outlook.com (2603:10b6:510:2d0::22)
 by DM6PR12MB4481.namprd12.prod.outlook.com (2603:10b6:5:2af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Wed, 18 Jun
 2025 06:56:07 +0000
Received: from CO1PEPF000044F6.namprd21.prod.outlook.com
 (2603:10b6:510:2d0:cafe::5a) by PH8PR02CA0009.outlook.office365.com
 (2603:10b6:510:2d0::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.33 via Frontend Transport; Wed,
 18 Jun 2025 06:56:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044F6.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.0 via Frontend Transport; Wed, 18 Jun 2025 06:56:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Jun
 2025 23:55:49 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 17 Jun
 2025 23:55:49 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 17 Jun 2025 23:55:47 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<ryan.roberts@arm.com>, <shahuang@redhat.com>, <lpieralisi@kernel.org>,
	<david@redhat.com>, <ddutile@redhat.com>, <seanjc@google.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<kjaju@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
	<acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
	<danw@nvidia.com>, <zhiw@nvidia.com>, <mochs@nvidia.com>,
	<udhoke@nvidia.com>, <dnigam@nvidia.com>, <alex.williamson@redhat.com>,
	<sebastianene@google.com>, <coltonlewis@google.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <ardb@kernel.org>, <akpm@linux-foundation.org>,
	<gshan@redhat.com>, <linux-mm@kvack.org>, <tabba@google.com>,
	<qperret@google.com>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<maobibo@loongson.cn>
Subject: [PATCH v7 4/5] KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
Date: Wed, 18 Jun 2025 06:55:40 +0000
Message-ID: <20250618065541.50049-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250618065541.50049-1-ankita@nvidia.com>
References: <20250618065541.50049-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F6:EE_|DM6PR12MB4481:EE_
X-MS-Office365-Filtering-Correlation-Id: 775cec07-d50f-4102-b06e-08ddae35334f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kyFiEKxCLFMtscrUCiJpMozUd6VglBaFN5hpBInbwMr0OxtHx3bTW4gOCbGR?=
 =?us-ascii?Q?WnF2ahfq0RNQ8TZSRDOWWUHo2LCCyRb2C5sUOYg9UNYQdQljzRsH4NGP4IXI?=
 =?us-ascii?Q?pO4NWqPNMQsjgH4cHMu8sTe43Bpsam1qexSlhaNYcrMTvfvL6yxzWPoz+/HV?=
 =?us-ascii?Q?lyO0TWxhpRzTOl3QtDIRnefQQffoNdFAJ18MkbNC37sL0KmC+yXKk6lAugOu?=
 =?us-ascii?Q?SJ0+cz7fhwiqbI74cLfmF9DjD8/n57pxCw/wNdZ0//66674q9WQ7y57NJ8T9?=
 =?us-ascii?Q?vsXldz59RzwEbWq6CstuMbWnbP5inpRhXl5HxmnXBgcldO6T1vsQfkfQLVDN?=
 =?us-ascii?Q?HqS3QehFnu8QZEDUPpp6jXUvFoNr0f6EtKQk0StaAXUjBEZSjwY+gs9ffUs/?=
 =?us-ascii?Q?/XBjbyrNzQU9O98oCPGxz2AF89kdth3GGahXc83Th4WX4astP1PfbDYcV+Np?=
 =?us-ascii?Q?9rfnsI7aRTqu11SbNJVx94dH/m9mYkl1Tdz1qJabGFehgU+xJThhnXFE2AsD?=
 =?us-ascii?Q?B6kOiQlWBvqGgYYybWcKqw1KFTLxtYxRalgJqch2FJ5RjpedFyv1BSz3gGa5?=
 =?us-ascii?Q?Lz9xr+KhYunziBScdvdodCZsiMSDnoneQ8UwbaGEHuRIhu4lDMcU9n00hHwm?=
 =?us-ascii?Q?TpouiSJi5Ipa/L1LDmI8/Z9a0k76uBhmKVcde7gsIE0CZ7+sxaXLTlhAloSS?=
 =?us-ascii?Q?6k9/nXITax5cQX15MtVDlEKtD8U473YFuRsb+9cnmN45tm5eMWP4FsFksnYI?=
 =?us-ascii?Q?I7yCa9CCAI7QMCr64xKc77LRVR3N6sR3XLIOyML4zMTd1GkUwGeJeH/67sox?=
 =?us-ascii?Q?aIDl3iBh+THdFldfgjb1mUZBkAWaimGw+peUTMavn5mc34ftTDySbvGjpZal?=
 =?us-ascii?Q?KtaRfqZK7coCpi8XuqV2yXVw2GR/ZJFofFi8dPH/PEGSshfS6h86coYzJe6v?=
 =?us-ascii?Q?/f4RBaqHXdOwGGlGABDY30xrdEwsMqMgSz3yCTGNvp7myR+PV1ovHYRLqWT/?=
 =?us-ascii?Q?Csei+Mvzp1ophTOoQRpMSRVqJM+g+d+GFWVIqYCnmjBeVpFZnTxsDPjIQtX/?=
 =?us-ascii?Q?zkFdZniFtl4eG9Z5J7AuQWLp6EaO5+3mHf8oZWd2tJU5/XMbSCZ5D0aBlZ50?=
 =?us-ascii?Q?jSir1LFvikTyGsjAoZ3E0cw7O4oPgSU/QD1OWXI4fq39eNqCBfDzsjJLvC6o?=
 =?us-ascii?Q?lxYevvRz59TmhnLRk/e1JrDsQoSOtPprj9cnnYM1HHwVyZvXIcccQvjWiK0t?=
 =?us-ascii?Q?Ptc0flMmUj3DTu6UAPK5FvprKeUNlgv+PR68ZqXY5yR5grNyHWVek+JjQ22z?=
 =?us-ascii?Q?85EH7eQytDoMvPFq9F4Zg8Sf0egaw63WlUAdzHobhVCAwAxS4IxHhoUlH8H1?=
 =?us-ascii?Q?BoB/3gq5i1yO6XxBc53VSTQBk+20MpVUa8m19jtZ6fd+FuITvu1AwlX/gWbJ?=
 =?us-ascii?Q?WNC+yNBJUd3E+KNR4f+FDzE4rmQs7ku3NqYny+f1NOsIODTUXIWKnGhDm9Mu?=
 =?us-ascii?Q?R1Vzwj0/sckhX8KnYBJ8cUAvvJCGRKHRxlwyCJcVyo6KC/hrt2lwZj93LQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 06:56:07.3237
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 775cec07-d50f-4102-b06e-08ddae35334f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F6.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4481

From: Ankit Agrawal <ankita@nvidia.com>

Today KVM forces the memory to either NORMAL or DEVICE_nGnRE
based on pfn_is_map_memory (which tracks whether the device memory
is in the kernel map) and ignores the per-VMA flags that indicates the
memory attributes. The KVM code is thus restrictive and allows only for
the memory that is added to the kernel to be marked as cacheable.

The device memory such as on the Grace Hopper/Blackwell systems
is interchangeable with DDR memory and retains properties such as
cacheability, unaligned accesses, atomics and handling of executable
faults. This requires the device memory to be mapped as NORMAL in
stage-2.

Given that the GPU device memory is not added to the kernel (but is rather
VMA mapped through remap_pfn_range() in nvgrace-gpu module which sets
VM_PFNMAP), pfn_is_map_memory() is false and thus KVM prevents such memory
to be mapped Normal cacheable. The patch aims to solve this use case.

Note when FWB is not enabled, the kernel expects to trivially do
cache management by flushing the memory by linearly converting a
kvm_pte to phys_addr to a KVA, see kvm_flush_dcache_to_poc(). The
cache management thus relies on memory being mapped. Moreover
ARM64_HAS_CACHE_DIC CPU cap allows KVM to avoid flushing the icache
and turns icache_inval_pou() into a NOP. These two capabilities
are thus a requirement of the cacheable PFNMAP feature. Make use of
kvm_arch_supports_cacheable_pfnmap() to check them.

A cachebility check is made by consulting the VMA pgprot value.
If the pgprot mapping type is cacheable, it is safe to be mapped S2
cacheable as the KVM S2 will have the same Normal memory type as the
VMA has in the S1 and KVM has no additional responsibility for safety.
Checking pgprot as NORMAL is thus a KVM sanity check.

Add check for COW VM_PFNMAP and refuse such mapping.

No additional checks for MTE are needed as kvm_arch_prepare_memory_region()
already tests it at an early stage during memslot creation. There would
not even be a fault if the memslot is not created.

CC: Oliver Upton <oliver.upton@linux.dev>
CC: Sean Christopherson <seanjc@google.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a71b77df7c96..6a3955e07b5e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1660,6 +1660,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	is_vma_cacheable = kvm_vma_is_cacheable(vma);
 
+	/* Reject COW VM_PFNMAP */
+	if ((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags))
+		return -EINVAL;
+
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
 
@@ -1684,9 +1688,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 
 	if (!kvm_can_use_cmo_pfn(pfn)) {
-		if (is_vma_cacheable)
-			return -EINVAL;
-
 		/*
 		 * If the page was identified as device early by looking at
 		 * the VMA flags, vma_pagesize is already representing the
@@ -1696,8 +1697,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 *
 		 * In both cases, we don't let transparent_hugepage_adjust()
 		 * change things at the last minute.
+		 *
+		 * Do not set device as the device memory is cacheable. Note
+		 * that such mapping is safe as the KVM S2 will have the same
+		 * Normal memory type as the VMA has in the S1.
 		 */
-		disable_cmo = true;
+		if (!is_vma_cacheable)
+			disable_cmo = true;
 	} else if (logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write
@@ -1784,6 +1790,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		prot |= KVM_PGTABLE_PROT_X;
 	}
 
+	/*
+	 *  When FWB is unsupported KVM needs to do cache flushes
+	 *  (via dcache_clean_inval_poc()) of the underlying memory. This is
+	 *  only possible if the memory is already mapped into the kernel map.
+	 *
+	 *  Outright reject as the cacheable device memory is not present in
+	 *  the kernel map and not suitable for cache management.
+	 */
+	if (is_vma_cacheable && !kvm_arch_supports_cacheable_pfnmap()) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
 	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
@@ -2271,8 +2290,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				break;
 			}
 
-			/* Cacheable PFNMAP is not allowed */
-			if (kvm_vma_is_cacheable(vma)) {
+			/*
+			 * Cacheable PFNMAP is allowed only if the hardware
+			 * supports it.
+			 */
+			if (kvm_vma_is_cacheable(vma) &&
+			    !kvm_arch_supports_cacheable_pfnmap()) {
 				ret = -EINVAL;
 				break;
 			}
-- 
2.34.1

