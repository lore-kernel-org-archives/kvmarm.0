Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CDD1F1905
	for <kvmarm@lists.linux.dev>; Sun, 18 May 2025 05:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747547300; cv=fail; b=Drq3Jd2dpQgNAuxl4CpRwf1OGeRIcWJNlGKX6Gex2G7/tVafxg02EDgpISYngr2ou1H1G705FEmH2lV2icGZGYoa1bvnRYGsUyO6efgdoASiXr5KcT2N4LWX0Hq/z+QSD+Ljfxw/psbya5M6B95l4vZ7zFVV6/uvxkUsu0obi0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747547300; c=relaxed/simple;
	bh=9im7mqyZf0QHBSNRa7sJnz8RKjfRbRA1DpRwDr7Pb8M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aUp1nrq8nDyMiiQsnkmyT3n1eUdpCWLPt0BZ2RIszTVwsxSqiiF82KlZnGkRwe2OEnVTav67l7E5Qcb5hzocEJEVriw9kvVkOGqVcvlxcO1grfhqiX4ZZ6FrY2o01a8pVhMgFcU8JJ9mOfoaGh1vLwWqJiaeUSDqNlx2Ok6yGeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lpMZqNMX; arc=fail smtp.client-ip=40.107.92.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lpMZqNMX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t/cm8Dkn5qGBl17z2T8elXkl+c6m0f9KkgSKHgHyCyxDiAAclcAVze+mHnuF8BfIF4ONMAGI56ps/8KNrGJP39PdO+fZ1iz0PzxyY7RaN/4uiZi0yXVmJtBZ1knJK2/X5cmZQxpKZpXLCcBLkl+9cFWIb4Eq1INFsn4LtegHBbNcsaQpg8fhib/6IrL+SokTFz+nV7HNis10M91ta4ssq+5fEwTEpb02qt3jdIgkszG8k9rl/vAefDWHe5sziyOTOJ+TvzSg2MU/x9GbQTr49LHorUPxZb4LTQpfKHQLpfXgGnkb7BNS9iqDvDOkejJqgmMStda8XO4D1ESK6l7p5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lONuBH6uvONGdr1qu+/HpFaO5zzJ7sCk/TE04Tkn44=;
 b=okTp1jXU0RgC3ZBbC8ZsJ7/zBQSA3evNkiJJRdvX4bh5iHQOjWe0Nnpfj/NUThLuMFFy554922fW6otEI/S0BlLMqqwEXMhaIxM0l9Wi8bD88AJl0i14PkUuVq7WQzTf9lhVTy5Lzd/4zgHECDuXlaAYkcLDNu1T8d8Kxz5sMURro4zI14JzUK0Lry+foNOy9LdUOXP8LSsMQZi9H2S3wGD3VbH9CqU/zwU+cinMq3ejVn1gqYwCuSFYewi8M0GVcBhn6vnJJqKqMy8efK6CJ69trlMTP9kOeWeZVwG/WsW0UHKQlAT8DNOfymsh3fAEj13DM5Flo2wowy4OUecAVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6lONuBH6uvONGdr1qu+/HpFaO5zzJ7sCk/TE04Tkn44=;
 b=lpMZqNMX+7BxVjdabRQwEAGnHwhqYm7fgH9DUDIXO6YYcdCu78Dxio22gklE7UE1CG04ak4AEFUXBh+8HBxve+UR1FlTcItUfGUgdOZl6IhB1T7w79YK1DE9i6UGCYrAFqNUKj/qnHCvKt+s6tuVbDbLzjl1qxNlZaIuf25aCH/3eAlrXua4X7dQaiWgo9bPvQTWjz4HtT4es9NDgx03rNezvhGOZJya4Tjk1FXK1YU/keFHNnlg2D9xc0/eLEKVkxXqfEv8VCzkSwoxLiFlqu5Al+CEWmHH4CUYNtmp5YTS+h90vM3LSpFBsb7KmCoFEAzsrwZ6wr2/MIb5+bwngg==
Received: from CH2PR03CA0004.namprd03.prod.outlook.com (2603:10b6:610:59::14)
 by SN7PR12MB6689.namprd12.prod.outlook.com (2603:10b6:806:273::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Sun, 18 May
 2025 05:48:12 +0000
Received: from DS3PEPF0000C37D.namprd04.prod.outlook.com
 (2603:10b6:610:59:cafe::c2) by CH2PR03CA0004.outlook.office365.com
 (2603:10b6:610:59::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.18 via Frontend Transport; Sun,
 18 May 2025 05:48:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF0000C37D.mail.protection.outlook.com (10.167.23.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.27 via Frontend Transport; Sun, 18 May 2025 05:48:11 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 17 May
 2025 22:48:03 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 17 May
 2025 22:48:02 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 17 May 2025 22:48:01 -0700
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
Subject: [PATCH v4 4/5] KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
Date: Sun, 18 May 2025 05:47:53 +0000
Message-ID: <20250518054754.5345-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250518054754.5345-1-ankita@nvidia.com>
References: <20250518054754.5345-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37D:EE_|SN7PR12MB6689:EE_
X-MS-Office365-Filtering-Correlation-Id: ed51a05a-ae2f-47b5-6a48-08dd95cf935d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KAygwbBh/5adTnqnsqkbbItnLiUfOZwGacx/o6RgVPL/YosU7c7OQuwyQ1gQ?=
 =?us-ascii?Q?TCXwdSZTxJZhpgQFqpUMALxilHsoYExtaFemoWZmr+zRS7iUYo9+dWK/gUWK?=
 =?us-ascii?Q?zXrmQQotnZZeXn59ZD948xMAeBiKoP/AYCEWyimWyk9oPsRj+1UILTt0uqEc?=
 =?us-ascii?Q?SHl47hvr75X5+a/b4uqzty3ekDgerw7Cg8SXT5hU0zVUxrR1PDHkgz32FvFi?=
 =?us-ascii?Q?XEkaS2DvKoioXd2QKFQHPChgdL/bT0tDJ21wWkioGOabiV/zg0cPO79sDcwI?=
 =?us-ascii?Q?BnQh+ca0SSUVrgz9OcRJUhHzRBHO+J6mEmPwHRD7GqS6oWW/THZrW+55ONJx?=
 =?us-ascii?Q?uHG3t2UgTALsEwCPlIxLVb+WeTw2gW0rUH8Jt40Ul6+IKtmQ106wnrxpHnpd?=
 =?us-ascii?Q?hy2G7UFxLceNQX2j3U2UEaEV2RYhjEMFXyzf+5l7GfK+r9ffAZB9F3HV/wYh?=
 =?us-ascii?Q?5NYrWu8VOBEtlPkdzjw7sheCd0QRwq4RJs0pwuM8GUvbHLHj4vWTY8Fe7M4g?=
 =?us-ascii?Q?gZMkrBtCTIXx5UQ8FR+HcEaHWEd/Ml31UZY9gtS7MT74B2u+2Q+dL0BbMLYE?=
 =?us-ascii?Q?+CbRQFPSbvH8FhJKydjY3HqkwPdSesx/FfIgGnk4D04GBu2y22gO8kmtIZzt?=
 =?us-ascii?Q?WPrXepS+OYFjjMRhoL4OjN2lOvL+MPCdicbwBfpPyTCc7jkf5n2Fc2JADS/q?=
 =?us-ascii?Q?OBSDS2RuU7o3G/m37Lt7EkT7cF3j6WKE7npHUcK2axkrRlw73QK8fDuGMwh1?=
 =?us-ascii?Q?x2So9b31Ks2VJWcjR+lUgb6dMCfRisaa3OybZLfRVpCIPFCRYdh6K70PlUWy?=
 =?us-ascii?Q?m0G2O+/NSr6bD9uu8N8qSU5qNdPaftN0h7rWFkGviqRKVtAfL3T+3YbB3mAH?=
 =?us-ascii?Q?mGci64cAbgHJYnSKb2qCTvZJKJVk9zcqr/tYNMn2RB5Xrqp4/JdmFZDV6iza?=
 =?us-ascii?Q?AYZKMyLnBJoY43/3PsORTvKlmEJ9E9ve+sWp4lLfTTtzsebHMBF2krINDoMU?=
 =?us-ascii?Q?ObeBG6jQRC3UD1g5cVR50e568yZTGAzhqUVmlBootvIbZ/UDBjRVn3FcRvfW?=
 =?us-ascii?Q?ehJca/S7BCmyjyv5q+VMkTGzn09Sfl5pGE53QwjG8qnV40X7vk7AS7irYY48?=
 =?us-ascii?Q?Vw9VOw9l5GiRGDLurytvc6MmQfaBW7dG1iCt5s1TP0rgxQd5oLYntKvYgUQV?=
 =?us-ascii?Q?3+anpeNe9kR7Vznqb8wb9wn+6u2ZzDybLlX6a+NNZmPZUHRQxOjmmyjyednt?=
 =?us-ascii?Q?6ylmSao2myyX7wXaT9hmfc4v4YG3bAuzlZQffBXvmCaZ1zTFrhRr7Ur7dnZU?=
 =?us-ascii?Q?lN1V8UY1dsLbFnagrUje05flMPzKDnrRw4Ljneck2fG/Z5vBo7w4INxGwjO2?=
 =?us-ascii?Q?Yx+MwfEljnIoKJp9DPkiRo7aMh3MRP4njChRUrsziM4EyAkv3DWs5XKvp6cw?=
 =?us-ascii?Q?mrZNH59Q2g1H4WWujPGHYPfVYsj5GeUgvVXj89FLbHhspaHhlnQGeIn2CuLt?=
 =?us-ascii?Q?G2oH13YQ0+/oGycVS0asNAeWgkGR/yyJRn2YlXF7xYT/6TtJ+GJauX4k1w?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2025 05:48:11.9040
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed51a05a-ae2f-47b5-6a48-08dd95cf935d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6689

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

Lastly ARM64_HAS_CACHE_DIC CPU cap allows KVM to avoid flushing the
icache and turns icache_inval_pou() into a NOP. This is also thus a
requirement of the cacheable PFNMAP feature. Disallow cacheable PFNMAP
on hardware with no ARM64_HAS_CACHE_DIC.

CC: Oliver Upton <oliver.upton@linux.dev>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index eaac4db61828..3ee2691466fa 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1484,6 +1484,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault, mte_allowed;
 	bool device = false, vfio_allow_any_uc = false;
+	bool cacheable_devmem = false;
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
 	struct kvm *kvm = vcpu->kvm;
@@ -1621,9 +1622,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
 
-	if ((vma->vm_flags & VM_PFNMAP) &&
-	    mapping_type(vma->vm_page_prot) == MT_NORMAL)
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
+		if (mapping_type(vma->vm_page_prot) == MT_NORMAL)
+			cacheable_devmem = true;
+	}
 
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
@@ -1656,10 +1667,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
@@ -1741,6 +1755,20 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
+	if (cacheable_devmem && (!cpus_have_final_cap(ARM64_HAS_CACHE_DIC) ||
+				 !stage2_has_fwb(pgt))) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
 	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
@@ -2222,7 +2250,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 			}
 
 			/* Cacheable PFNMAP is not allowed */
-			if (mapping_type(vma->vm_page_prot) == MT_NORMAL) {
+			if (mapping_type(vma->vm_page_prot) == MT_NORMAL &&
+			    (!(new->flags & KVM_MEM_ENABLE_CACHEABLE_PFNMAP) ||
+			     !stage2_has_fwb(kvm->arch.mmu.pgt) ||
+			     !cpus_have_final_cap(ARM64_HAS_CACHE_DIC))) {
 				ret = -EINVAL;
 				break;
 			}
-- 
2.34.1

