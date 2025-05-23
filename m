Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D1E295DBC
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 15:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748015117; cv=fail; b=uu/JLLIszT1ytw3U9jNq0jKKI/fIqyP2Hd/FHZO7/1+lq3p9B5qVRajs7MNCGh9tgTompz81Tb0TCaVWn94VvN5AKOEOu7T8NMNDmabu40nBRrILLeh0/zqH1+GbaTF4Zx6uikWrCnHNnnkPrTDezPqMpqY/PYctxGpttvNGhd8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748015117; c=relaxed/simple;
	bh=cam65h2eSzybfKW2JS4kICdDcD8NFjqqtEkTEoc5kg0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W2j7AstGDvoi/W2LkPHKJvRl3lApELXSxxuA44w2iSy48H64LmfnIpzTDiCzxG4Z/W4SvANA+7PGSMKB1z/LAOVSY/2ywBeEearnbc1fcXxkrHPDvSMiy/MIX5yUL3mD55aZTaR116tTQh86mYUewBukWpqzRHAxPCzh30QM9qQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D7yh6zpS; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D7yh6zpS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mt4tO68ldDeguWYJ1xo7GOcyC+wMsyLEMXsYmVMqC7MduX9NPlcjgxRty5JBQJOAr8hBqvtIkMwd9DMv7TblxkPw5l/CqDg53ERWyy3XnKkd2EPkBexhdyeDGi/wyIU6D0Bv2p646sZixOYWPJgTVspnRCXXVI6gwQCuo5WO5mtAdDdfd20ltGVWL3pWRc448lO0CDQkFjx/908fCuByr2NwJUvxwaYZZgK86LBIU1eKtVwVtqB0fw9XjVDwRKNxxZwLiAB88tRwmtalPDlQqT3NhlgDqsvmKSjtXDbMePyXtDm6ZPvmjIqma7c0hChpI0utQCUKQb51bLz1SmejqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wNm5I7I6CYILmyn8GPEX+GWP30RzjTDi9t+YdQ+Let8=;
 b=qKJR/Q728dvvRGa18CIovIV1OHAd8zwg6tKItgdwo1t7g2BMEJTyZYYE5bDyrn8LbtjjNSS3E+/XjTxOQq4+wV/4IJclqeQAeFqfn5/jhAqmkRHE+BxLV7Sjjna37wY8L6K9FeXlHhh2udsNKKEcQF+8de1oRvSeiZA6+Q65CmsBLytfATkev44UD6jGakC3mKkgnxBg3V0BLayjOyBc8mzLGrr6W5PWxB82lh9JRBAgHDcBbUqT8rdxq437Z7bqjs65ecqFdFlsJiiw4eqN9EUHw0UnI8oB4dDWbZne8/vxyGcq3db4xfa+j2GkNv6ScBpiM1fqrL+ycqJ6EzLIYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNm5I7I6CYILmyn8GPEX+GWP30RzjTDi9t+YdQ+Let8=;
 b=D7yh6zpSfDYMh32yz5lOaks2W7vnnluId8mM4CeQkKa7+S95XrIhwgE7WynfmvRSN1oh4tYqBWFBQ4Sn7G29UEMt2dcXVNAsFmMdYnp/S7Q6OO0mUMjWnq7lINdxWJ9/aSa5gnrT8LI8EEDxkmjlKZo3Mb52HaEG9uX4JF4e5HH6zX6gRQFVg25itJOFMy+aiy8D8U4I8OEZybPh3tf8LX9m6CZtQPXUhzIKPh+VB8sodSG4Q4ujp2lgX/GC3DrB172yuwq5D1GL4/tZLLORJmAJ/7B2YcSJEE5xDwIr3Y8gVf+Cw8L2Ig/CgabF8vyHm1gKDWAvNHGSaG9xW8cv8Q==
Received: from BN9PR03CA0442.namprd03.prod.outlook.com (2603:10b6:408:113::27)
 by CY5PR12MB6084.namprd12.prod.outlook.com (2603:10b6:930:28::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.20; Fri, 23 May
 2025 15:45:11 +0000
Received: from BN1PEPF00004685.namprd03.prod.outlook.com
 (2603:10b6:408:113:cafe::e9) by BN9PR03CA0442.outlook.office365.com
 (2603:10b6:408:113::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.18 via Frontend Transport; Fri,
 23 May 2025 15:45:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF00004685.mail.protection.outlook.com (10.167.243.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Fri, 23 May 2025 15:45:11 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 23 May
 2025 08:44:47 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 23 May 2025 08:44:47 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 23 May 2025 08:44:46 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<ryan.roberts@arm.com>, <shahuang@redhat.com>, <lpieralisi@kernel.org>,
	<david@redhat.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<kjaju@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
	<acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
	<danw@nvidia.com>, <zhiw@nvidia.com>, <mochs@nvidia.com>,
	<udhoke@nvidia.com>, <dnigam@nvidia.com>, <alex.williamson@redhat.com>,
	<sebastianene@google.com>, <coltonlewis@google.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <ardb@kernel.org>, <akpm@linux-foundation.org>,
	<gshan@redhat.com>, <linux-mm@kvack.org>, <ddutile@redhat.com>,
	<tabba@google.com>, <qperret@google.com>, <seanjc@google.com>,
	<kvmarm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <maobibo@loongson.cn>
Subject: [PATCH v5 4/5] KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
Date: Fri, 23 May 2025 15:44:44 +0000
Message-ID: <20250523154445.3779-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250523154445.3779-1-ankita@nvidia.com>
References: <20250523154445.3779-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004685:EE_|CY5PR12MB6084:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bd68431-40c6-4646-e56b-08dd9a10cdb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700013|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D+BakqhInwRfeiIT5B9Pqm2L+wtzROm1zIfdKJgIthu23acxn3l2MyLly9rl?=
 =?us-ascii?Q?dThk9Z2xSMFDmkM4X1DqheJ4QJk2K8eZYd5hD5hygmQ1pZ78klDTsyCJtpnp?=
 =?us-ascii?Q?9EqSGu+XQ7w4ZQHYFy7Ao/7au4XOxSOQHnd4Y6j7WMvO+XVGEZPBX9tLqB3l?=
 =?us-ascii?Q?aIdTrykLtar6DeVA1Nu5rQOcTRKEIQWZL/a8nR4VTlHEdcnqUl8v+W5kY0ao?=
 =?us-ascii?Q?LBFWEo/XnGJxFvuuqTdUwz0WW3+Gyv4exLhUJB+yj9UG7F/NBK1k+bVbm9Ip?=
 =?us-ascii?Q?2oCvRbEECFxkx7Oi/tJVCTFw70SP+THiIJ3VIU0XnJ8zZKTtQiYA/MRrpH4w?=
 =?us-ascii?Q?ev3fD2qT4rvtWSK0/ERaUtlLGw93TFJGsJqWoPnu5tmeYmER+nAWWJpfmhb+?=
 =?us-ascii?Q?ODxF7BbbV4xC9aYx6hDCnQ6zkgJVF0taZmDyEXEOe7S5dXubxqsqI52+rr/9?=
 =?us-ascii?Q?76zZg6kjKo3++Zwy6MziO1VHobDiZ3E+0NM8WwWfdCHoTpn/+9h/ETVyzc77?=
 =?us-ascii?Q?jl0rUb+5gVkJM9Kx7LXd3QzXgCge41xxkFnV3MTcMZp6ZcyEQkVVI0PkX7PH?=
 =?us-ascii?Q?nEtO8nKaGC/iHRrXQoG2pZAVb0AOZOzzHlsnrHHnaxvMMV3HVwtEPiOSp5nV?=
 =?us-ascii?Q?+WTY5qneUSSKFMWqW9pGdqt1JxG6EFjrZdg+7PVH1YZwTJ8TWldzW8FMd07M?=
 =?us-ascii?Q?O70pPXvz6DBR1v9v339YhCwQvaA0LXXJFmC+QVJsZkyS3HPhQdzidMo7cVYM?=
 =?us-ascii?Q?UhTLDvr2UXC8JeVcDl6FANrpLO1U4mdsXK1/+A1gToa94r7yEiZRYWHg04dz?=
 =?us-ascii?Q?JosGRqEA9Rs90Ca7xdfI62a/asTHfkFa0onJ4f7RrrlLEqA/3cx9jdM6ByoB?=
 =?us-ascii?Q?7iLQBpKlDQfKxZzNDQrfuYGOYako9VAC6D48FMSlK6jCYSKbj3nHnZhR2cWt?=
 =?us-ascii?Q?nCQhzNfzM45Z/BgllYf4wSVMo6FgdrrG5r43BhR2Dol1X+l8Rdt34Nx9g15W?=
 =?us-ascii?Q?qfwNwCc7MTLdS8qbX6049NLmtfJZIjJmZdEvLs5aWuFUFmvsuscsrI1X2cPm?=
 =?us-ascii?Q?Huwv947Sl0wQK1tSXjU6cLj/CZRcpU7Y8UKZ/5Q/p08ytV5FxptlhoHNni37?=
 =?us-ascii?Q?NN4UMKV6lSW3JF7a30aN2BYGl5JPZcwDnrdzlMiKV2SL7r6FvY6jHpEm8eGi?=
 =?us-ascii?Q?vLPFBL5qEFLrdmpHjnlb3Y0G0/MJrmQFfwGRU17rw2p1Ep1Wd56G1ZoOVniG?=
 =?us-ascii?Q?cm8kH7jmJFIZyqItWN4PjgObVEFM0F98p1jpNCkvQroYn5m6Q7ADDdJl+Ie2?=
 =?us-ascii?Q?0eIFw5/r4W7pNC15H/6pxAiMYJ4uLfMYd89MiJkPOveY2ZIWNG4uUMzci8JP?=
 =?us-ascii?Q?T7KJQWWdrmo3bWW8QFMj7Y/zY2qy9FbOTyLk9Z9EueH4jnMqwvA1Me+j4ycX?=
 =?us-ascii?Q?Ue4onkHWVZqbkgQq80eS/hM0j934hnrD63HAjO7slt8lpLrGtjnxAlmf3vYn?=
 =?us-ascii?Q?7xdB1qbzfKeUaAL18iQAt/zf2KzsIXL7j7FypVbb84eS3NI1DxLBri5zDQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700013)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2025 15:45:11.6879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bd68431-40c6-4646-e56b-08dd9a10cdb3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004685.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6084

From: Ankit Agrawal <ankita@nvidia.com>

Today KVM forces the memory to either NORMAL or DEVICE_nGnRE
based on pfn_is_map_memory (which tracks whether the device memory
is added to the kernel) and ignores the per-VMA flags that indicates the
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

A cachebility check is made if the VM_PFNMAP is set in VMA flags by
consulting the VMA pgprot value. If the pgprot mapping type is cacheable,
it is safe to be mapped S2 cacheable as the KVM S2 will have the same
Normal memory type as the VMA has in the S1 and KVM has no additional
responsibility for safety. Checking pgprot as NORMAL is thus a KVM
sanity check.

Introduce a new variable cacheable_devmem to indicate a safely
cacheable mapping. Do not set the device variable when cacheable_devmem
is true. This essentially have the effect of setting stage-2 mapping
as NORMAL through kvm_pgtable_stage2_map.

Add check for COW VM_PFNMAP and refuse such mapping.

No additional checks for MTE are needed as kvm_arch_prepare_memory_region()
already tests it at an early stage during memslot creation. There would
not even be a fault if the memslot is not created.

CC: Oliver Upton <oliver.upton@linux.dev>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 46 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 124655da02ca..c505efc4d174 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1499,6 +1499,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault, mte_allowed;
 	bool device = false, vfio_allow_any_uc = false;
+	bool cacheable_devmem = false;
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
 	struct kvm *kvm = vcpu->kvm;
@@ -1636,9 +1637,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
 
-	if ((vma->vm_flags & VM_PFNMAP) &&
-	    !mapping_type_noncacheable(vma->vm_page_prot))
-		return -EINVAL;
+	if (vma->vm_flags & VM_PFNMAP) {
+		/* Reject COW VM_PFNMAP */
+		if (is_cow_mapping(vma->vm_flags))
+			return -EINVAL;
+
+		/*
+		 * If the VM_PFNMAP is set in VMA flags, do a KVM sanity
+		 * check to see if pgprot mapping type is MT_NORMAL and a
+		 * safely cacheable device memory.
+		 */
+		if (!mapping_type_noncacheable(vma->vm_page_prot))
+			cacheable_devmem = true;
+	}
 
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
@@ -1671,10 +1682,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
 		 * and must not be upgraded.
 		 *
-		 * In both cases, we don't let transparent_hugepage_adjust()
+		 * Do not set device as the device memory is cacheable. Note
+		 * that such mapping is safe as the KVM S2 will have the same
+		 * Normal memory type as the VMA has in the S1.
 		 * change things at the last minute.
 		 */
-		device = true;
+		if (!cacheable_devmem)
+			device = true;
 	} else if (logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write
@@ -1756,6 +1770,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
+	if (cacheable_devmem && !kvm_arch_supports_cacheable_pfnmap()) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
 	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
@@ -2236,8 +2263,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				break;
 			}
 
-			/* Cacheable PFNMAP is not allowed */
-			if (!mapping_type_noncacheable(vma->vm_page_prot)) {
+			/*
+			 * Cacheable PFNMAP is allowed only if the hardware
+			 * supports it and userspace asks for it.
+			 */
+			if (!mapping_type_noncacheable(vma->vm_page_prot) &&
+			    (!(new->flags & KVM_MEM_ENABLE_CACHEABLE_PFNMAP) ||
+			     !kvm_arch_supports_cacheable_pfnmap())) {
 				ret = -EINVAL;
 				break;
 			}
-- 
2.34.1

