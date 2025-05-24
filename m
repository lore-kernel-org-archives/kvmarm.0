Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2071.outbound.protection.outlook.com [40.107.212.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6E61946C8
	for <kvmarm@lists.linux.dev>; Sat, 24 May 2025 01:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748050811; cv=fail; b=N9smIb7IA1743kVMGhq0jkjqr9U+R70Xita8LraAbGXKLFsYspPM6/mmhke2fgobzBeq2YaniPwCLjpDce9NCjr7FilRIM+3Ym+Ehfq10p9YgFNXhwrfgnaC9JexNfI1veCZI+ptn/o/0lkj9Xmw2xyZnneU4lrMd984EoMrUHI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748050811; c=relaxed/simple;
	bh=cam65h2eSzybfKW2JS4kICdDcD8NFjqqtEkTEoc5kg0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FHAkmmZwp4jmFiugY3e2rbgfagsH8A7WB/yqxe/YleLde5xET10GjunKhmEDA5+A3FHvVFiS4zIUPxqSZyYH7HMKqLf8rEUTMwgOV756uclBThCqczoYFHxrCKfrSdZ7G4Sto2eXENzoUEQrkU82uZPD6FlB92oB47cxnlbJR3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vt5cdeaI; arc=fail smtp.client-ip=40.107.212.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vt5cdeaI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hvIFqneWf5VWLQgyQkk8nK9rwM86mC8nMZvUypfc7M1zka3SSPI45cqxZFksQH8jYGucbFa/swP8xpDmE81gkIUUf//P64jzL50Fk0cGFBTSU0aobAnwSMUDGVwUZNNKr4PgQq+lqNEvQRpXWRvM0MV9AvzMdUL/jFEvj5f0WraFY4zSWPrzg5Wny+aydtf8cmHKLG0EA5XtwwZl/pafH/YVAqfQSidI/o963Vvy2cRna1AFxnK4x1/CkOvaWKryXtCWy7Iw0HBS2EvNlIMCys0G03UaPdukPvxEyymlwCBT0RgU9LxusNL73HBHwEwXWZ6QdQMrthDmdvH2qOUo+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wNm5I7I6CYILmyn8GPEX+GWP30RzjTDi9t+YdQ+Let8=;
 b=U3mqiNRjXaLpUEbwZ7T9Axe1QJ40cEgvP2H95wV7T+RbWrGpD5ClyCFLryxkBYvmkqoXyexG3Uw3o/eYJr91U46507Asi1u4poQtUXZwLc/2CMbTvxRaqtjAqMxUL8y+2M2JVBC9b/YdJsEHeYV2HxrkPnN3+FFHGptiIF3fIFq59capWqT6gpJd0PaMuOtQxx2uy+bkU+wOUbPa7NkdwC5oZIzWZLgRtLnpfyW7Hc3NGvl4ys0fUrheCUdXAg00Dvw1EaVoJ8uzRqmmD+sQq4LUl/CndvKy6tOVY/bEfd6wcHSBgCpudZFN9gh8K5Hii7NFT9FK/nUSvvNWXvOBHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNm5I7I6CYILmyn8GPEX+GWP30RzjTDi9t+YdQ+Let8=;
 b=Vt5cdeaI7nDO+Y2PypXHVI2ILH9KMn8uPMdzVMWSqgzntxH2ysKdd5LI1ygngaX8zQZyReqPV/1lwdOg9RB1BL5/LSrHSFwp7ZAP5VEfyIzNn7Xjpvo/5iOROclNEI+3ttk4qkLnfFPpDzPte0earnErQvRpIjD9VEmnUylMhdvDhc6smM8M5PDGj/8cvckePD0JUcwJE+QBiBBOwaOb9GfxrfCD0AmsAB660j6F/n0DRkpEOLN8TAYwPyhrX97WRHKgO4Y89AxBYqy7YmmeR16aWMMxzC/u1ZSWZD5HKV+rE368VyHHHeGUxlWjPHVQUPhI9ZqzRli4mZ99uPgEmw==
Received: from BLAPR03CA0166.namprd03.prod.outlook.com (2603:10b6:208:32f::18)
 by DS0PR12MB8479.namprd12.prod.outlook.com (2603:10b6:8:155::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.36; Sat, 24 May
 2025 01:40:05 +0000
Received: from BL6PEPF0001AB75.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::80) by BLAPR03CA0166.outlook.office365.com
 (2603:10b6:208:32f::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.21 via Frontend Transport; Sat,
 24 May 2025 01:40:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB75.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Sat, 24 May 2025 01:40:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 23 May
 2025 18:39:52 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 23 May
 2025 18:39:51 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 23 May 2025 18:39:50 -0700
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
Subject: [PATCH v6 4/5] KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
Date: Sat, 24 May 2025 01:39:42 +0000
Message-ID: <20250524013943.2832-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250524013943.2832-1-ankita@nvidia.com>
References: <20250524013943.2832-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB75:EE_|DS0PR12MB8479:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cbc70dc-aec5-436b-b206-08dd9a63e866
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LurLSBOgIv1eb5Guss8l4fOiBIJsN2INjIev+ROC6x2lZNas2HxLhG5e8vVj?=
 =?us-ascii?Q?an+ezCy3OgMrFN3FzVmFm9qRQRuudA+EuvassuPHYIlH76aMtcQmQMh9OA5y?=
 =?us-ascii?Q?xJLkVKYYId0DSwGSAFLTYlcf79BUgtK+j3ehGj2tQxyILJOV3ubV3uAfo/kB?=
 =?us-ascii?Q?93AMIWDmPME8jh58noFb5Ap8Ya41EafUZjGl/ZMg6yafuhKKSKzjYDxjUP1E?=
 =?us-ascii?Q?r+Z6HBTaXQqoJk225NZM6wHBXA0Qn5JPe6ssLaZozfcWoBg6AI8wshVVtET1?=
 =?us-ascii?Q?dDhB1asNypeomXt6b7WMoS8chP3okny6RVREDcxRjKma2gFcK4VG4xqTliGR?=
 =?us-ascii?Q?TqgwG3nbIW242UkF1NnG+2naJeorOurUmvXU/b1XgzgPcpvBEAFv6Xu01CaT?=
 =?us-ascii?Q?hPrLMF9AyzUfwrpYWCwNTR1C4oUg1VsV/lo8k8TtwrzhUQRv2MssZY+pxf6V?=
 =?us-ascii?Q?kTJcrJfAzMBGk25PZd7hBfTW2IYUcoQ8NJ7vjwubVxAap5+MD8lt55jOupQ2?=
 =?us-ascii?Q?cfZgLhWVZj98PfnL4ri5FR7o6h+RwY9OUfhT+TED6v1Gj+zqMLk1s5EEVQgy?=
 =?us-ascii?Q?+VHnf0/fMnA3QRNonggULXcFfXy+d6VDK/N+P6WqTj0X0N/dCWhBsDL/+TP8?=
 =?us-ascii?Q?/e8S0Vl1LuLag0Ogh0vqtrgSuQPnLL+3dqprvIWxC/sN9yUsg1rmX/FJIkyX?=
 =?us-ascii?Q?yWdi5SYCQZ9UlZxqNJDnmw7MryLAcPRXcpWhbEVE/1cBwY60fyUq6EV+ehga?=
 =?us-ascii?Q?8gdeRWV567D0WIxdAA1+Nk+arPctq0OwOddJWdPQyqSloDYmvwTrEphb+nXM?=
 =?us-ascii?Q?IbMFXnSbjB/B55ou2VKCL3ZWmxrATMGjMlbrn/+X6MERNDrMpIy2DHvGXGID?=
 =?us-ascii?Q?1WmsX7BmSvoV+wWWegFENDxkZFWeTRSePpbLmqR1vkx6QZ3v+yRV8jZoD/Vq?=
 =?us-ascii?Q?yPOivtUXnhTG9j8AzmV71w3SkUR2hr7Blfzr1UGCgTGsJW2U3p6uAIwja2OT?=
 =?us-ascii?Q?BiAdz8a/Q1IwYvFIUPXG8drVJ2tFHTZLgMETUMENeoI/pIFN9Qf0bwlfBeIL?=
 =?us-ascii?Q?irreJ22ef6mjyINQyzMfsLzrinGYzcmXfZkAxQr6DMLWgQrjaYqUVnQYsjdd?=
 =?us-ascii?Q?H8JHjlwa02svYyrrNxABTVyOVUCEF6+tBg1Fn5UMgyGCjCXGdnNNqsl3kZhd?=
 =?us-ascii?Q?nQ1VlSzdXiYdSW8bm1bWrPR2ZmvkEKekH2K7Pjce3B6ADnAh7W3r5Ijf85x2?=
 =?us-ascii?Q?Ll4gfsteu0mXL/wfAfYr3Nr+HuzYlNP/6bsPkokQ8XJhEyezaAPHiYprZrWb?=
 =?us-ascii?Q?hp7bdRi8QWh+VJSyoMKFovXQUUGmCdOVMQX+0CIsznoOX4fc6PHpfnzXnbNG?=
 =?us-ascii?Q?J7lheu/PJBYagnf563M0S/0ByhYFWeANTqgRFWDdzkbZJxLnByMPGMDnSoN5?=
 =?us-ascii?Q?D8s/S7bF7hb7xgYB+QrEqIXNBbp4dFV8qNjKqEoTMrazhcSdtYYRag6xLuXF?=
 =?us-ascii?Q?cDNGttOiC1AuNBF0IDKuUuTdSHc3GNYLOdpUK4rxZo9fk7LGqspWWnJ73Q?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2025 01:40:04.7007
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cbc70dc-aec5-436b-b206-08dd9a63e866
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB75.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8479

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

