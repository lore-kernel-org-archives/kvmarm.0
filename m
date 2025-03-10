Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D57718E764
	for <kvmarm@lists.linux.dev>; Mon, 10 Mar 2025 10:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741602627; cv=fail; b=YTH1PtDXIa5komj6ZGIZ8yBX8CZjQT/s/fkfyPsEfc5poxxckJ5Kk3+3H+plvQi608+8IhX2Qneu4MPbiivV+7LM2OWR+N/mCFgb7spIAe/RhOYDJw+QgZ4DNnK2+UCrl5afq8lS8/vj7E+6nuewAOJeHHz2zxnr5NM3/tRM1rs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741602627; c=relaxed/simple;
	bh=WZjiw3dZ+pkYPrE/wo+k7uaVasZkFF66MDohxrP4yIM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aumZXtKXQw0DVLWgUX9L/r79g+Seewtq7lFSgGicv/uGW9P0SFHwxVJDUTAsJHt2+hYK8jiyXRIdk8kAjSwjY8MwKBWW1POaCpAVjPKe02tRnq8/s1P7ItNAHFWe4NkCJV4/wXdiJ4Fw8cgFOGwOvpwEGdC73Kx4itjyQhrsLWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xx/exrR+; arc=fail smtp.client-ip=40.107.92.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xx/exrR+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M4xwXYtkskwh26NEl+JOQj8+mbwaZT0Y+Ka/ExL+eN/YJb3Za6O29bz53SHpU1BEvCYlNedomC4RdoJRVGApTfStVsVunsfftKLxKqEch0HEhPEvjTAgB5d2+6YqUuwPrV+PixCSeXfMvr15T1lzamIoHCu8xif2q+R9yln24e5zVyCnbzH6zB0378B84pv8MT4wbJOfvDOLhEWpODJKpuKtJkjcyUP18rTO+I/nnCerJcopFzRKK2sUQSwD50v7jVhx2UXLLz3iG/EdpQeIj+Ap0FS5FVQOyCN2Qw5+vwQH7Gf2kL5Jz8swlNTy8trivn5Kw6csP1SQYMw5F7vhTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sGLync5IsiOXIhEqPqacU8GgIi8JKeU5Rg37CDn0uI0=;
 b=ahGAcSgG2StuTwnCmBCj+wUPW5k0jhLT6h9wc8fDtPiHmmt9RFDze5tLIM+suAE+OViwA+y7G0dbe07QhFvpeCc3QLj/zg9UTvAZFBskapKRyKetXfW7yH/Qu5+IF1fI165mJSK7SSfSsiH5fzoAC+ivHJN0XNkec2h5fvKk6NTk2dXmff8SUmEgPOHJfOO9kbEgfXZ+rYUQM00i9AZKNQRKV26cf5gigdbqMV3Jip0gO4ZFDigQtC2oUqpKafalGPNhFr3v3lWD1SMhFO7RLwS9DccCxh4xK+teHHVE6M6DVft/uIjjV8MJQu+etCXVlgroMlSpRiacczwQvFzPPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sGLync5IsiOXIhEqPqacU8GgIi8JKeU5Rg37CDn0uI0=;
 b=Xx/exrR+Lwgdq3Nr363lFmK0/071gzTRjeDn4AKUx7ZyjP5uo3muxKkO34SXK9WwC18V+B+2ekwIRcCzwb8cQ+ZXFHdHP3sKZctRzIB4eWJV5MKKGsnZXK1Pm9ykgZ4E+wYQ/O3ArL7gcgsAvFYBRiT5H2noPJzYqFq8jYPdYy9+xWpqnR2XZ9tSfoU2T9WqNThPHHt0HEjktpKDcFZedJtImlSaVEI3HEvkqs2UBdH78u3qF9yAH8FgRETpKw57d1dexmzozbEt0NlWTyCfyQ+ANLde8loPeuWCZB0M5Rk7kj0Gi7urFMr5Y4uG5TgFvgvq2cMuD3N14wUfDx9x2A==
Received: from SN4PR0501CA0107.namprd05.prod.outlook.com
 (2603:10b6:803:42::24) by SA1PR12MB8144.namprd12.prod.outlook.com
 (2603:10b6:806:337::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Mon, 10 Mar
 2025 10:30:20 +0000
Received: from SN1PEPF00036F41.namprd05.prod.outlook.com
 (2603:10b6:803:42:cafe::1a) by SN4PR0501CA0107.outlook.office365.com
 (2603:10b6:803:42::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.15 via Frontend Transport; Mon,
 10 Mar 2025 10:30:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SN1PEPF00036F41.mail.protection.outlook.com (10.167.248.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Mon, 10 Mar 2025 10:30:20 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Mar
 2025 03:30:09 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 10 Mar 2025 03:30:09 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 10 Mar 2025 03:30:09 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<ryan.roberts@arm.com>, <shahuang@redhat.com>, <lpieralisi@kernel.org>,
	<david@redhat.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<zhiw@nvidia.com>, <mochs@nvidia.com>, <udhoke@nvidia.com>,
	<dnigam@nvidia.com>, <alex.williamson@redhat.com>, <sebastianene@google.com>,
	<coltonlewis@google.com>, <kevin.tian@intel.com>, <yi.l.liu@intel.com>,
	<ardb@kernel.org>, <akpm@linux-foundation.org>, <gshan@redhat.com>,
	<linux-mm@kvack.org>, <ddutile@redhat.com>, <tabba@google.com>,
	<qperret@google.com>, <seanjc@google.com>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
Date: Mon, 10 Mar 2025 10:30:08 +0000
Message-ID: <20250310103008.3471-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250310103008.3471-1-ankita@nvidia.com>
References: <20250310103008.3471-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F41:EE_|SA1PR12MB8144:EE_
X-MS-Office365-Filtering-Correlation-Id: 62704551-7e7d-4a5f-ced4-08dd5fbe8f08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f2s50DvKZrNckES72ZFVAcvL5xor6NFrQY+4H1MHeBklhcLZpP0plGjKqsV8?=
 =?us-ascii?Q?9TVqmialL82L88M3tZaLpe3KR5pVshIzUjf+blqMkInWyn/nWIq8DhcFwAzv?=
 =?us-ascii?Q?UOV/zw6COx5tC9CVazf4NjOPNBSHuYmB7Y3GE/GRDUoyEeh029RPn0oFR3eH?=
 =?us-ascii?Q?3JAkd+ku4u5cxAW6/P5fM4LIfR1h0E8cPfEAyviXyVqEFJ7Ak9qXuorWTmHw?=
 =?us-ascii?Q?fcI0Eso8agyWGzpw/cSO9yW/oncnoZfTZ5fdAwUfaqKlodfScIStBFUxlxDB?=
 =?us-ascii?Q?dVYZqTL/8qqB9Znt614qd36SzobsR1TgB2KiewNuB26P+SOlq5EOR8AzT4NC?=
 =?us-ascii?Q?UBdFPBkobIWRI4tbkt9uWTJg983pfxLiYO9I1RoqjrC+2b4HyWmP2FWvzDmz?=
 =?us-ascii?Q?4CvlS7OdJl2zDBiP5lNV54RUu58PR+8i4IS4obj0aUX80Kutjc6raMEljpyk?=
 =?us-ascii?Q?5AobxqXqPYB4LxoSSlyJFvklzJ8Wngx04zoM5muHP3yZn/X+OPuWzkp6Lnz0?=
 =?us-ascii?Q?93E+woQXmzDEWiEn5Bb6bUZZMTw0zqidqdusgalZb0IjCBZwb5NwfxPWp2iO?=
 =?us-ascii?Q?pL8NEbxTw9oVHwzCtz4Fwoy5ud4EKo7hmipg8v70qS19hzBW1fYkrMyGiBc7?=
 =?us-ascii?Q?dQ4stXJwU/A2gJ6yVABLzHjFES1atr8ehn1o/fz5qVsJJz62toIzhNNCI/1x?=
 =?us-ascii?Q?zRufP4rHGdQzDFuwjk08309KhvfsycpB0zYd0rSkOzAcOMreUS0xsLz1cJ8b?=
 =?us-ascii?Q?gpS2v1SrPSZ40Mn6s7zG4OkjQ4QeWkGS6R52mMZBHhCtjxzz8bHYudNeaN72?=
 =?us-ascii?Q?NrdNdHHeGlmnZnETLJa+g+WULo+hN6/6ZTZuq4px+mzikhM+zSfm3MgOcRT4?=
 =?us-ascii?Q?VTGywetQxYOBnKdvC9iyOvLC6dev5F86HAxlf7u+XEznrgA7bsllDsMAVrVb?=
 =?us-ascii?Q?AVWh3Gs5+FGwmiZjdoMN+chwdBxnq5VFWDWwymtMbQIl0er2k39Qk+1AgfBz?=
 =?us-ascii?Q?YTJq5cPnGpK9bxSnM3I75qYP/VyMpK1Ap6eKbWsl4SvOp2v05Fqn641dHS8U?=
 =?us-ascii?Q?lb0CU5vxJvUzT8P3XXdJQGmk9OdzXv6Y9N/bfiiXm24khmopB3mT6TgaFx2N?=
 =?us-ascii?Q?vvECHJAQe4C03Fn0J9p+ciRWarvn7W+2Q5owg6tS9eVKzx/D7GPx7GhR89Ps?=
 =?us-ascii?Q?84HU449MOQ+fLvmvGzQp7FDbCftcyTUEnuEu3fs+H/HuCydTdHmpTpl0y/M0?=
 =?us-ascii?Q?O4SUfTr0md+qNHoTaEsgaQ25TtXbaicWGG2JUylfbmw3RPfdOFvJi5rohJpW?=
 =?us-ascii?Q?nGNwi+b3Xi+ilv1vFS7zgELx/zyRHamMKe2tLBcF146W9YK5RdHP6dntbHjt?=
 =?us-ascii?Q?V4/bNWIVfs1CZeIzIOK5Brv13jRc7EWyGxJpmgBbW+YX3qf20EJGCy0Xk/ch?=
 =?us-ascii?Q?cws24fiYdzfxLVBq6rrDroPEEnwKjxqLoeuamwTg7i073wnSiuGDH7pQ2O5a?=
 =?us-ascii?Q?EC2cw+v6yBg5sIY=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 10:30:20.3372
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62704551-7e7d-4a5f-ced4-08dd5fbe8f08
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F41.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8144

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

A cachebility check is made if the VM_PFNMAP is set in VMA flags by
consulting the VMA pgprot value. If the pgprot mapping type is MT_NORMAL,
it is safe to be mapped cacheable as the KVM S2 will have the same
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

Note when FWB is not enabled, the kernel expects to trivially do
cache management by flushing the memory by linearly converting a
kvm_pte to phys_addr to a KVA, see kvm_flush_dcache_to_poc(). The
cache management thus relies on memory being mapped. So do not allow
!FWB.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  8 ++++++
 arch/arm64/kvm/hyp/pgtable.c         |  2 +-
 arch/arm64/kvm/mmu.c                 | 43 +++++++++++++++++++++++++++-
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 6b9d274052c7..f21e2fae2bfe 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -507,6 +507,14 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
  */
 u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
 
+/**
+ * stage2_has_fwb() - Determine whether FWB is supported
+ * @pgt:    Page-table structure initialised by kvm_pgtable_stage2_init*()
+ *
+ * Return: True if FWB is supported.
+ */
+bool stage2_has_fwb(struct kvm_pgtable *pgt);
+
 /**
  * kvm_pgtable_stage2_pgd_size() - Helper to compute size of a stage-2 PGD
  * @vtcr:	Content of the VTCR register.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index df5cc74a7dd0..ee6b98fefd61 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -637,7 +637,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	return vtcr;
 }
 
-static bool stage2_has_fwb(struct kvm_pgtable *pgt)
+bool stage2_has_fwb(struct kvm_pgtable *pgt)
 {
 	if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
 		return false;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1f55b0c7b11d..4b3a03c9d700 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1454,6 +1454,15 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
+/*
+ * Determine the memory region cacheability from VMA's pgprot. This
+ * is used to set the stage 2 PTEs.
+ */
+static unsigned long mapping_type(pgprot_t page_prot)
+{
+	return FIELD_GET(PTE_ATTRINDX_MASK, pgprot_val(page_prot));
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1463,6 +1472,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault, mte_allowed;
 	bool device = false, vfio_allow_any_uc = false;
+	bool cacheable_devmem = false;
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
 	struct kvm *kvm = vcpu->kvm;
@@ -1600,6 +1610,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
 
+	if (vma->vm_flags & VM_PFNMAP) {
+		/* Reject COW VM_PFNMAP */
+		if (is_cow_mapping(vma->vm_flags))
+			return -EINVAL;
+		/*
+		 * If the VM_PFNMAP is set in VMA flags, do a KVM sanity
+		 * check to see if pgprot mapping type is MT_NORMAL and a
+		 * safely cacheable device memory.
+		 */
+		if (mapping_type(vma->vm_page_prot) == MT_NORMAL)
+			cacheable_devmem = true;
+	}
+
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
 
@@ -1633,8 +1656,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 *
 		 * In both cases, we don't let transparent_hugepage_adjust()
 		 * change things at the last minute.
+		 *
+		 * Do not set device as the device memory is cacheable. Note
+		 * that such mapping is safe as the KVM S2 will have the same
+		 * Normal memory type as the VMA has in the S1.
 		 */
-		device = true;
+		if (!cacheable_devmem)
+			device = true;
 	} else if (logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write
@@ -1716,6 +1744,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
+	if (cacheable_devmem && !stage2_has_fwb(pgt)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
 	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
-- 
2.34.1

