Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D7228C02F
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 12:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750421403; cv=fail; b=RmW1x6JwAJlWbbIH/T95WucgGdHoRIlKoXkwT50xmZgfHtWJ53fBSPukPrCUZaUl/gQT6yUkrAg/oYU4P3MdIl0sEw4875uNG8iGAQZ4Cev1WwwyIyefstLRK+/yI3nCCUswKC0/OQLS4R7ec/NSM8dRlyKjUaHriBaZnn12oYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750421403; c=relaxed/simple;
	bh=xQtWaLqT7m+Q33PmngF2bY5X9w8czn93etFnYQ5ZTpo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jg+t3RjAQ08dv1Y2C4zHaGbaaRPYUmrr8HXWOef9ihkm0cPasv+PrGJ9IPaCVsF63AZWDITiX20q3SPgkE83dAFgnc5S/chjiEwQtKuCDXslewKbR200Bql0eJ9jPPL+on/ePG97zEq9D7FGoFbPs1LIgY3AiTQOUKuztgkytrk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fzAPobze; arc=fail smtp.client-ip=40.107.94.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fzAPobze"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HoWwHdBXdOV1GKOlik71MH0EWvWgKVQbJoqTNtEzX5K9s7lPviKKRGRHe1suYepNdhRR4BYRi201ae9KFsQRwN39G3gMcwvPOKwaoh3ZVhXt4VmbsWPMbt5lZH7ySUUMEnytq0c57RZBFuNdu1wak4LB+iITx7ButGMud3WkS0d8C5UyRtjG5b9umbAsBf/IUGIMlsWlcg/8W4S766tsxLkPk4yFGei0+E/jrOw34vUgn+NBfYLDciTEWtLERznvXqv9rB9/osBZ6/q5z40CYLCVXDzsuR6EUUY1Y/o/UQ8DFiVBaMxA8pPTO+D2cpj6kl2e4VtuXsh+oE+WaAOLwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GeO1OofPBuJlhjgwqspQbmzENux1wEuN7VaB61dV6uE=;
 b=e3T4Z5uUusy+y7kSu8OEmq0dzJ5S0BbAQ/ShHTGE0/HyTpLdOGfQLni32bi+FG7916p6yI6PiutNUeSfBSJ11kzELCH3goeXCSMFBey+lVf8034gxXVvh6urfwxMAenDaaK2sMWigXuACNlwPaeI9f0nY45lMmtwYBwXu4yeIM+Bp14/FRiQB/sqy59nyUAd9p7Iebl/qT7XKTb57wBm5UvKsH5TySCsE3kMKW7Yx7KH2oWhmmDPYwygVE+P8KxtAiSww+yzY01YgAzMeX1SJmDpyvlL6dsieN2YCuqr2A/l8e4L9o9Of4SvP128BJhNBPBqkXcsKwcaymeqRNXRug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GeO1OofPBuJlhjgwqspQbmzENux1wEuN7VaB61dV6uE=;
 b=fzAPobzevhRJHain0GHhVQGISkJopMDF3D3/s3U/idsObqcfWiEyzXhYHGxL5kDsTSXA6RV6kc85tU5QCsq8UTkDw/oF6Ly1UfhFr8ZcnFUaz9wDA2u2sK0t8+rpQGQlsGLOsw+FFwdBiMv6VkojZCDqxvt+e70WdLFlsbp9dsDGw5qtw002vIn0Sjq1PfWbkDu4FKqdFoTGAgsOXuvsUx6mSq1IlgdJLT2TBSAADmrOJH+kShCScPl4Qbl0W4oraisAeaXOBM93DpYnE8gG9dbl1J+0keMFC9nTpxhXDQ45xVcpnafVG/x6fSD5tNT7LPaz9AqXTUsRR1lZmzyyug==
Received: from BL1PR13CA0206.namprd13.prod.outlook.com (2603:10b6:208:2be::31)
 by DS2PR12MB9591.namprd12.prod.outlook.com (2603:10b6:8:27c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Fri, 20 Jun
 2025 12:09:54 +0000
Received: from BN1PEPF00005FFD.namprd05.prod.outlook.com
 (2603:10b6:208:2be:cafe::1b) by BL1PR13CA0206.outlook.office365.com
 (2603:10b6:208:2be::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.12 via Frontend Transport; Fri,
 20 Jun 2025 12:09:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF00005FFD.mail.protection.outlook.com (10.167.243.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Fri, 20 Jun 2025 12:09:53 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Jun
 2025 05:09:49 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 20 Jun 2025 05:09:49 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 20 Jun 2025 05:09:49 -0700
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
Subject: [PATCH v8 5/6] KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
Date: Fri, 20 Jun 2025 12:09:45 +0000
Message-ID: <20250620120946.2991-6-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250620120946.2991-1-ankita@nvidia.com>
References: <20250620120946.2991-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFD:EE_|DS2PR12MB9591:EE_
X-MS-Office365-Filtering-Correlation-Id: acea66cf-62ca-4e6f-cdd4-08ddaff35da1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SwaUy8YWtnuwGYmySTX4ZBPk6XUBD7nvFAwJPzjPYR7RDwFraZ/r62Z2zyu+?=
 =?us-ascii?Q?rT3Nbb1hAfDQP6JqwWZ8GGtZ5ckqyIV1upXpiTdMguzlckYEwzQPeA/8XthW?=
 =?us-ascii?Q?SknvXa/1Qvt/G1j2MBa/1Eh5o5M4hg7BUehPW9dJM1XyHTrtYzSX39vFy6do?=
 =?us-ascii?Q?0HE098EipOhV/pCxdexdc3XHzHT+VCLiKVN1pPptSnsUtU8GRCcMc5/WpGdM?=
 =?us-ascii?Q?HCIVSNBg74xnRb5kHmm0WzWXYazwlsIP90IcbkVTNFGFZOGcu/zKksPe/fwI?=
 =?us-ascii?Q?zmC2r9TumBj+UpB9XIaxphZuWoQpRcjJkfWA/P+2gsAJSCm4It3EhGEJnOEW?=
 =?us-ascii?Q?Cq6ttKfQ5gSPGSUAVisQq/9tehJC3FSKBH+C+gVCry5ZppB8UEEP/P8pxlmt?=
 =?us-ascii?Q?uliz146dDqT9o4P3UEGgRl8yoPrz32K3XJXmrBTCxuQuY90U0yjbdBx5/vim?=
 =?us-ascii?Q?yi06ojdgVKpDNxKSQyC7bAX+QSA11Wt15jdbfkgFofRbsbG5hQ/OzrDyHl5C?=
 =?us-ascii?Q?U79n+bIujf6FgeJESLoxamw3/wzSm7wFPz/KLQkXvNTQLsom4o5iwCipuKlU?=
 =?us-ascii?Q?8ereA8/0PJPSVmk1aMiKPcu82kec/dDPmehdAftjUi72neDbrsVhvDBOOrJ7?=
 =?us-ascii?Q?h16SZO4QE8A/kEEsNRPH4Bv9GmX8OQLJZlOWkqNhkEotHcOjztxaE/vyAWuV?=
 =?us-ascii?Q?hTB2tuvrtNlRduLY7SFhbiJSw/rKo6a1ThiSIzuw8eh1kbt0KF8opw15HxyU?=
 =?us-ascii?Q?Di0jTE9epPzvhcbP3s0GlBhYgsxxW4rcLL/X30Y63nvcjW4Dd3rAJ/Pq01Y9?=
 =?us-ascii?Q?tRo9C+y5Ra4XHz0aqFNZrwrFpoJGXCZTq0gfi+LibPKWQsQMK8dgLvkBWosP?=
 =?us-ascii?Q?mA87m0x5CW4cdvcfeHdy8hT6s2SA/+gHCZxFLWuK91CGAmwoeWlUo2mDWTET?=
 =?us-ascii?Q?VY1aW4QZ+uJ7veXw0QYkPcF0qkAuMY3xZ18+KJ7BHbvVctNrHSfanmIQt8wM?=
 =?us-ascii?Q?kdQbaUsgCPWWnTVR8WFe+4ON5s2J7chF8xJd7ymL8n9gyN+ZZnzJzgibLnhz?=
 =?us-ascii?Q?mBITCY5x66/7tR36VayFBeO+MJvzA/oOR6AobUBtYin3/C433oKeGLBdXSgH?=
 =?us-ascii?Q?SXrKkQnYVbKq1XtSGCC9/Zu/hItfrNy9VxiBQqKMYgY88G8fmlU0oiTvjQur?=
 =?us-ascii?Q?6eDFZX6Zvm7N83egYTVaYCkOndNr1ty0kKLJD/kTSaMUM8O5IY2IcmOjpkRv?=
 =?us-ascii?Q?NSI3VFfXhRqJiYRQ26rSVi8EqhrcMiiX82BioPBDBK36TwE4alH6b9ysvhNM?=
 =?us-ascii?Q?5EKQKTxQ0S4WluPBby1HH7+jIPX8RLidDhObkVvd6IBz196d3RF7Ojt88f1l?=
 =?us-ascii?Q?pp9000CvBbOvw8K2aZbVFtGohAg++udVCj14OtQvulJOYYaZmd9oLi6lbD1X?=
 =?us-ascii?Q?Cbrbl49mQT3xc+mDhvEbnPwc3FU7HXFnpARO1mpDPFZGAM1DVLF2vbvFcNAY?=
 =?us-ascii?Q?lEVLVX+hrYA2c/5jNclzAtdcaJoFj9+1QQWelFciKS7qdJnEnKQecCZ6eQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 12:09:53.8440
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acea66cf-62ca-4e6f-cdd4-08ddaff35da1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9591

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

It is possible to have COW VM_PFNMAP when doing a MAP_PRIVATE
/dev/mem mapping on systems that allow such mapping. Add check for
COW VM_PFNMAP and refuse such mapping.

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
 arch/arm64/kvm/mmu.c | 72 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 61 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d8d2eb8a409e..48a5402706c3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1683,16 +1683,62 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(pfn)) {
 		/*
-		 * If the page was identified as device early by looking at
-		 * the VMA flags, vma_pagesize is already representing the
-		 * largest quantity we can map.  If instead it was mapped
-		 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
-		 * and must not be upgraded.
-		 *
-		 * In both cases, we don't let transparent_hugepage_adjust()
-		 * change things at the last minute.
+		 * This is non-struct page memory PFN, and cannot support
+		 * CMOs. It could potentially be unsafe to access as cachable.
 		 */
-		s2_force_noncacheable = true;
+		bool cacheable_pfnmap = false;
+
+		if (vm_flags & VM_PFNMAP) {
+			/*
+			 * COW VM_PFNMAP is possible when doing a MAP_PRIVATE
+			 * /dev/mem mapping on systems that allow such mapping.
+			 * Reject such case.
+			 */
+			if (is_cow_mapping(vm_flags))
+				return -EINVAL;
+
+			/*
+			 * Check if the VMA owner considers the physical address
+			 * safe to be mapped cacheable.
+			 */
+			if (is_vma_cacheable)
+				cacheable_pfnmap = true;
+		}
+
+		if (cacheable_pfnmap) {
+			/*
+			 * Whilst the VMA owner expects cacheable mapping to this
+			 * PFN, hardware also has to support the FWB and CACHE DIC
+			 * features.
+			 *
+			 * ARM64 KVM relies on kernel VA mapping to the PFN to
+			 * perform cache maintenance as the CMO instructions work on
+			 * virtual addresses. VM_PFNMAP region are not necessarily
+			 * mapped to a KVA and hence the presence of hardware features
+			 * S2FWB and CACHE DIC is mandatory for cache maintenance.
+			 *
+			 * Check if the hardware supports it before allowing the VMA
+			 * owner request for cacheable mapping.
+			 */
+			if (!kvm_arch_supports_cacheable_pfnmap())
+				return -EFAULT;
+
+			/* Cannot degrade cachable to non cachable */
+			if (s2_force_noncacheable)
+				return -EINVAL;
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
@@ -2269,8 +2315,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
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

