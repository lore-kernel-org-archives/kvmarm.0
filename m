Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2054.outbound.protection.outlook.com [40.107.95.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8675B21767A
	for <kvmarm@lists.linux.dev>; Sat,  5 Jul 2025 07:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751699861; cv=fail; b=JHVa/mm+pZBw+ojU6mlk0ZospxysJG1UrBhbXpKM5WoCFUmslKGj5VpHbplPouUd25f9MDXrtjdGI223zz082uCk3oX4d2GD54dLQyEgUhZ1EvgA1n+XWNGgOea5tDf+YBAmJXxnlm+2vpWG4kKAuoHZgjrVDNkv+7B5snzusog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751699861; c=relaxed/simple;
	bh=2pCrzMcCdN5phsPFBwyEDw71xHT5h9bzVvbwiqu030E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DjHgJ/gBjF2FW6jhD/vj5ZbObkciKtfcTdq6YifjNXlYKj2kk73DcIIEbujACk0yt2hQoaZjTWZCT3aHHVH5a6CmkJoID6rGyYMtfRe7xOkhN0VTiqIhnJrKy9VYXO+0svherbnJYWmK/nELm0E7Pe/aHno6yoUPsCZMZa1h6r8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jhry3IhW; arc=fail smtp.client-ip=40.107.95.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jhry3IhW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M1AnEL3CRfMQIDq3dh0ZneU31ZtV16YYLovD8e8RM/jgj5bsQzqUvrnkWisQ0F4z2+44TXqyLhLE5TrO/sRKtvAOAna7Xq1v/+a8e59nEzQcNzWN0k6af73wLsqsVMRNwbvWqtQkTkTaPZg7M36nOUNchfmLvPTKpKlzx+IagXGCqWD/6OkgB1avYejDn1A7fhZP4petMejWRTbmsR5msF0WGa6FMCRMDZkF8uzJnvm25d5SEECNzi5bp076jvKGrZBMknqeRn0wKtDCDd1sHAxQap3isfmJG0Tp4/37RetGJHoaa1mjroYbzkMsBxfKCvMT/NUddTd17QNxj8RvgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FBmnrsp6+8doKQaEX8/P420Kb2au+JtSOIq0MVEuhI8=;
 b=mjdXcCDz5KD9jrgtFjNDYIyIkv0khRfZSMRLl+a1nwBfr/9RZQX09zeK9dCfRIwpCWvfsEBeMUJBkhnyy1+rw+uW1uecbG4nIVGXEqblmvPtBwf57/wKhkArk3N+VdBX4LSJnXhjDEA4XYF1s1Ht2dPIatJ2ORj4aH7iiLLmZJXluVH4IFKsvE5zBvv5JLzRu8luIaVcTJqXv7PzHmmL0oKAU4HbEL3kwrmsJHz1KKWWMKIjYazFSHOePPT7PDYBNJqf9iMcy6wsOoTUKipylHiu6XtFgjcEZ7HvcoLTy3/uZOmXzYM0dbEm6ZDJk5xY6ye4j5R6j/vcl20Fwbh+zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBmnrsp6+8doKQaEX8/P420Kb2au+JtSOIq0MVEuhI8=;
 b=jhry3IhWCncQmYh72EiqRaVS9vkVt74Kt6dCmDxlHJFUWWbXNCDHtvnaeU/OEox/hRGdztrxoS+6rl2JgffyggydbBtRtyGXqZQ+3Ek9CFAkZhdlfe4lIxn+RQ+RlQAPlsfqVUnxrWGPMUh4xLcznc3URgqoheJDrHHkUIgwDVhqGE4aJ57naHZWP2Q3WnlYsIdjSwPeuY8+1ZrE0DROdtzukB/2Sqw8zp+R6/6KEgIZIyw6Wk+WLXl98GIzskGkFaT2ez26HNvQsIzwsG75C8nEcq608iPQ+VXzTOqKYK22QZQRHKzoKtUTjZwG5lE2x0od8KmICzEeeikrhFz5aA==
Received: from SN1PR12CA0063.namprd12.prod.outlook.com (2603:10b6:802:20::34)
 by CH3PR12MB8877.namprd12.prod.outlook.com (2603:10b6:610:170::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.29; Sat, 5 Jul
 2025 07:17:35 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com (2603:10b6:802:20::4)
 by SN1PR12CA0063.outlook.office365.com (2603:10b6:802:20::34) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.23
 via Frontend Transport; Sat, 5 Jul 2025 07:17:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.15 via Frontend Transport; Sat, 5 Jul 2025 07:17:35 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 5 Jul 2025
 00:17:26 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 5 Jul
 2025 00:17:25 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 5 Jul 2025 00:17:24 -0700
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
Subject: [PATCH v10 5/6] KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
Date: Sat, 5 Jul 2025 07:17:16 +0000
Message-ID: <20250705071717.5062-6-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250705071717.5062-1-ankita@nvidia.com>
References: <20250705071717.5062-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|CH3PR12MB8877:EE_
X-MS-Office365-Filtering-Correlation-Id: 079ba6f3-b99a-4735-4ebf-08ddbb940425
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|36860700013|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vnW4WbQoss3Qsk+Q3H9BjVgxYhW+Wh8rv/Eh7osuIvnw4vaw5l5lWvkxYO2M?=
 =?us-ascii?Q?0UW24DderNX3OPUQE+1Fse6QKkW0XOBwJI6bazCEY7hpBEjv4Bqa0fbBzAk8?=
 =?us-ascii?Q?vY9MwCY02oz2ULa2ZQIaIUkLybDp8yLbtppKgcjzNom3PtBDi/1ysDdPuHHj?=
 =?us-ascii?Q?fQfvB7TWFoib1dXPcn3gb7AWGl57jBwq+GheaB10OujIlzS3qoJaeR5J6Aey?=
 =?us-ascii?Q?j3k3hgK93x9Q/BEsnmeXJhNhtys3hJodmnnJB/0/OMZ7cgUQK2jrD/CLODVE?=
 =?us-ascii?Q?D3pffbL7TnWbRlfppR3mohs6j1xbYcnNjjnkQmfKPgfDiAbHzKkj5MNn87kq?=
 =?us-ascii?Q?7qMwb3dBoQPrT3mXEwg+6cdRSnDogn2ELXPK/v628r3tq9HV2rQf0wxNy8XX?=
 =?us-ascii?Q?St0IMJaiZRPjyjcggCa8q2Tizu5JHBywRE8yC4+nhOdkNQCnmPwvF8jd5GWf?=
 =?us-ascii?Q?hJrcYnzNBgcHt8z7MBfez0IC4TbBRNX9Ku1YMOwAKB4ybCjp+FSe/0xAr3bm?=
 =?us-ascii?Q?GNApmYHbx18W1q4hAnxtZ5cj9J3gHwQvgz+pbT24pCkr+UEpRAmgIeY9JsIq?=
 =?us-ascii?Q?jEhfDONkQRHKcJJ1rWwaxycVmiyjDIwmNlKMcgt9ImXRZy1an0oolZo3H6P9?=
 =?us-ascii?Q?kAJeVJeduLgkFa7xZNuXnq3wDSUZ4HXrP+pMkWiRmmh1NHxi4z20Qlx0BGDJ?=
 =?us-ascii?Q?9dmVpkqqxF5eVh3bRQykqMpYjHAYyDjtyHAHrn+3WMJKyuFhFeSIPFYecRMn?=
 =?us-ascii?Q?nUC+/3W5HfLlOLsYHhURuXzdMAn+rd/ZYbfCHgB2VdL4qoeJyQsoDu4EVXax?=
 =?us-ascii?Q?OyCozrHT4LjcCNc5uhQQjotuey8v3SofMIuOB70b6c4T3UnIx3nf5MYXVYT/?=
 =?us-ascii?Q?q6Y6QINf7b5urQ/qXCJz1ciWIdP+vn9Hkx2tGTjo/2ebF9c9yx4OWAAg1xKB?=
 =?us-ascii?Q?j4kF10YhOJqg+DxauioB705JlaiAEu+ujm1FPmpnzBnoiuwGHEoI0zrZtyKc?=
 =?us-ascii?Q?+Qd1fmi6j7TYUh8KVsz52+YEG30DfUgQXBzSzjRfSv+DSMNcuRxKR00gHZdJ?=
 =?us-ascii?Q?8mTsrcsQfuGx30tZFv6gUdEleHo0yGs1jVV4w2rnwK7sl9UpBgzJ/2TIhYni?=
 =?us-ascii?Q?MJtqkd+L1vKlOeYYZ2G/Yt6QeWF2yo2AThdspw2ivsdqPIQ2GddJCxPCIW78?=
 =?us-ascii?Q?wWflPw6Qq0mZr1y/hky+GGquUy6kL4TbsgOyTBSJbyJK6R7TFgSs2IZn4XO6?=
 =?us-ascii?Q?Q7OZO3+lTLphcgUZIFL2N2SOJxRNO9arDjOOHhEd6vLhQtFfsXh1bulUXUah?=
 =?us-ascii?Q?hEeJwl97daqKbT2m/djV/rqM7QMOvZ6oB66QnJIczk7O33XsthvdOYfL2tAu?=
 =?us-ascii?Q?X4rvr2JmkhHmH8h7xwyiuMplQcJqglitPzAQZpaLTgrS5ATB2ugCoP46bYeJ?=
 =?us-ascii?Q?xtJO+AzSxMtK2RwJtPtJNDnH3G3wwt0UYpFIGAAVAIvXeKXtTg1C4cxSAszl?=
 =?us-ascii?Q?MTtAcsimzVscYSuvGzzOjwkoFx5F1GtPJA0JvR/tnmmd96uGndiQmVWUSg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(36860700013)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2025 07:17:35.4943
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 079ba6f3-b99a-4735-4ebf-08ddbb940425
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8877

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

No additional checks for MTE are needed as kvm_arch_prepare_memory_region()
already tests it at an early stage during memslot creation. There would
not even be a fault if the memslot is not created.

CC: Oliver Upton <oliver.upton@linux.dev>
CC: Sean Christopherson <seanjc@google.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Tested-by: Donald Dutile <ddutile@redhat.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 61 +++++++++++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d8d2eb8a409e..ded8a5d11fd3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1681,18 +1681,41 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (is_error_noslot_pfn(pfn))
 		return -EFAULT;
 
+	/*
+	 * Check if this is non-struct page memory PFN, and cannot support
+	 * CMOs. It could potentially be unsafe to access as cachable.
+	 */
 	if (vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(pfn)) {
-		/*
-		 * If the page was identified as device early by looking at
-		 * the VMA flags, vma_pagesize is already representing the
-		 * largest quantity we can map.  If instead it was mapped
-		 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
-		 * and must not be upgraded.
-		 *
-		 * In both cases, we don't let transparent_hugepage_adjust()
-		 * change things at the last minute.
-		 */
-		s2_force_noncacheable = true;
+		if (is_vma_cacheable) {
+			/*
+			 * Whilst the VMA owner expects cacheable mapping to this
+			 * PFN, hardware also has to support the FWB and CACHE DIC
+			 * features.
+			 *
+			 * ARM64 KVM relies on kernel VA mapping to the PFN to
+			 * perform cache maintenance as the CMO instructions work on
+			 * virtual addresses. VM_PFNMAP region are not necessarily
+			 * mapped to a KVA and hence the presence of hardware features
+			 * S2FWB and CACHE DIC are mandatory for cache maintenance.
+			 *
+			 * Check if the hardware supports it before allowing the VMA
+			 * owner request for cacheable mapping.
+			 */
+			if (!kvm_arch_supports_cacheable_pfnmap())
+				return -EFAULT;
+		} else {
+			/*
+			 * If the page was identified as device early by looking at
+			 * the VMA flags, vma_pagesize is already representing the
+			 * largest quantity we can map.  If instead it was mapped
+			 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
+			 * and must not be upgraded.
+			 *
+			 * In both cases, we don't let transparent_hugepage_adjust()
+			 * change things at the last minute.
+			 */
+			s2_force_noncacheable = true;
+		}
 	} else if (logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write
@@ -1701,14 +1724,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		writable = false;
 	}
 
-	/*
-	 * Prohibit a region to be mapped non cacheable in S2 and marked as
-	 * cacheabled in the userspace VMA. Such mismatched mapping is a
-	 * security risk.
-	 */
-	if (is_vma_cacheable && s2_force_noncacheable)
-		return -EINVAL;
-
 	if (exec_fault && s2_force_noncacheable)
 		return -ENOEXEC;
 
@@ -2269,8 +2284,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
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

