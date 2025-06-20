Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2053.outbound.protection.outlook.com [40.107.96.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AB328AB03
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 12:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750421398; cv=fail; b=cw89f8RpX9sx4e9ZgUv3w0dfZO6LY1bTBapnloe+Y8Nrh3db1YTynfD4AzY+bKlbvR34ENIA9ZFVnHMZw0sn5DWzfSNXOoarbCwLOLVW2Ln8CBSmCUbh/T63Oe7nc5qlwvyJW3GAKWRkXi2XInxP4Y2P8KADUoUmk1EuKTH0ztY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750421398; c=relaxed/simple;
	bh=bpP9rW3lvV9nr/dSewocHmVkezFfLIi1Hd+YohIapqU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j8fNYq/hbNzyYgnd8VXVTvvlDA2ZWfpSHYHNejIrpgW9g4O6HRmW0hfxTpujV3QN6AHR/9tk7RUme8jgj9oEeSn1qX0pvaLuMDtYcOkWHRIHY1KvnPEmDHC1bBNOxnm8k7WZXBLIbWXEiWSZtXLUZE0cdiThDr9NHcwF70BTPEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GQ1i70nR; arc=fail smtp.client-ip=40.107.96.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GQ1i70nR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zSeUOGbbcEqhGFEi9mQzNkohTOoizUAaofR9Ag44xgvnO9073ZvRtcnPPfEtocmu4u0DNf2m+HJ9nt3yn7kPTOuB2yqs7YnzDaaY/vT2ymoD10qyEH4oBWMedVkcm06izSzCzDHFjag0Wv7cm9GwBCkbujlz0HO/YCPcesJEzImqphOBvEQ1NnAcNCsY136KwAueC3lNdOMF/Ovc8A4JfvMhZJE568JnRPquQ4WiZCmPEmyq933PoYo6qAr+WzDtjOiScuRKKf7go6Ru/gyGSyGsa+jI72JYm+nIrcpI55MqWWHkuBb6NZjobweXZ+Fb4vBPcxTxE71lzDBJbHC/lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GkCBJLwsMBLjSVGWzfhuFJx+agdzxNGx1pRR5Z/t82s=;
 b=f6aK5j0iZp4DfHfViIBRA42LvLBZyyFh7j4RRe20YH5Di8pJ7jgaTSTLpKziEYTbk2wueXdYTrfQP5FUsMeFyUUbuRehkl5xJd/S4IuOnUc6bmNZ5CjhJis6j3VAaXIFXC5Y769HvPIl8lREMC0p0RoIR76UC4HRimcalyTSt7IxH6bVmGDfnfdyvPIBcTA32XkX600URyUQvu6YGaI8VvQQtVgtl7mIUC+9m4tR+IWy8XHoWoIOiekPoqfkamlfV5Mc9J9nZaIkfyD/JkIaZXdm/lW2KMHJsb8AnMiVabjUqUuW2RMaxb30lLwSJiXshjPbqY0J86hDj93c/pKm6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkCBJLwsMBLjSVGWzfhuFJx+agdzxNGx1pRR5Z/t82s=;
 b=GQ1i70nR5BW08VDgpdeLk2A8YKSOzeijXhjsnreKDfG1sp4Ya1hf5krmOPBd94sIbQIMQWTLfoza/5woUVtVXoUt1CVXe517RXzsrviLejCrj6jXIujUJstP2sUKSKBJ3H7CvVVlL9fLbxBq/SX5v9F8Yhky8W1QCyA9acoNF/1EzesBgw/PsfkiBra/Ag/iG7c/vTAszCFfu9ufs2fw7YinY+VRYtuouoi5eimgKpMqc9zPfUJaqa2FUQmJG8ukeo6jlnyE8iSZ8/z7EJSmRaBEYD5tfeo/VnwziHz5J/0QD4dXwm52SP6bkPV555Mt3NlDgxjt864+5HoPVHEGTA==
Received: from MW2PR16CA0049.namprd16.prod.outlook.com (2603:10b6:907:1::26)
 by BL3PR12MB6619.namprd12.prod.outlook.com (2603:10b6:208:38e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Fri, 20 Jun
 2025 12:09:52 +0000
Received: from SJ1PEPF00002312.namprd03.prod.outlook.com
 (2603:10b6:907:1:cafe::7b) by MW2PR16CA0049.outlook.office365.com
 (2603:10b6:907:1::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.23 via Frontend Transport; Fri,
 20 Jun 2025 12:09:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002312.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Fri, 20 Jun 2025 12:09:51 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Jun
 2025 05:09:49 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 20 Jun 2025 05:09:48 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 20 Jun 2025 05:09:48 -0700
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
Subject: [PATCH v8 4/6] KVM: arm64: New function to determine hardware cache management support
Date: Fri, 20 Jun 2025 12:09:44 +0000
Message-ID: <20250620120946.2991-5-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002312:EE_|BL3PR12MB6619:EE_
X-MS-Office365-Filtering-Correlation-Id: e30ebbf5-877f-4d29-1a74-08ddaff35c65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W/rqfMEVvat58rC49Jc5neWLbNdXg1sqczX9WJ6CD5d2SKEItEBOHy6L/psY?=
 =?us-ascii?Q?H05l542Vb4ZDEikwVRGuD/lCT32JTA66ao4tqcdufxfvVw07kWbGICgwnmTw?=
 =?us-ascii?Q?1qG4qyOOPBw7xNxCG8x5TzXTvf7dgvnhDUxqA6nocQDp/10CQ8nPc0j0kztt?=
 =?us-ascii?Q?cnyPG9ffypgEma0Irf5oS/fAaZIQOaV2jv9QDhuQp7AL4oqT067besbOUuR6?=
 =?us-ascii?Q?Rx9jgTvZdIui00+637n8gFxOpd3+a8nl5RsYY7fkJWFXPxExel7DxIRrilvt?=
 =?us-ascii?Q?2z7OfVaBUwv92tHZB2iwWisGBjOfk+KNrfp4aTXeBQIrmE7/Icz6gO4QbF/n?=
 =?us-ascii?Q?XzDRGwqVuWQGB1aR3/cndI9hkiE0tOck4Ve5+0iQgdmyWfrGDVJMAbJkq5XE?=
 =?us-ascii?Q?c+6hS+xgdC4fTNodi5vPIOMYpVKwKRXUUx2BzOXcsmJWGhs0qaBsMUtofqJA?=
 =?us-ascii?Q?p2i2CmgzoxNhX0vuimDGBGWE+6GDewEtnopz3PCHEV8Hfa2FhWvQFDu2rc76?=
 =?us-ascii?Q?4AXbltvUwO7YhopX3UNU6YtJndepbIyRZKJJbKwATYn2ZaF4BXlngOefxmZi?=
 =?us-ascii?Q?Wq0KlPeLHe6b6Btgv94LmGi2nNjoINQq7EX1kdIvZXU9tyJhh42TxthuaJeO?=
 =?us-ascii?Q?NY6EZN97p0Q16jTQEFTpudLi0ZMFtSdTn/Ia7eGDo16vBCMfvddeW2VE2VS2?=
 =?us-ascii?Q?oVw4e+pftdrs3I3IUMj+kXNMIuIr895di574a8Y3AEnFUvy2ppgFAmPPhvTk?=
 =?us-ascii?Q?s8G5zka56HlMGkjqmNUFOUNR8nmvuptyx3hTsS823th04lDVvSAzh4d2NmzI?=
 =?us-ascii?Q?L3D7I1eUYasAFoKVg/IDuYIquaMhYdOmxhWJRogIgq3yfPA3ATQRtCM1+crN?=
 =?us-ascii?Q?AiIALTK27x9Z+Dsxm7jBHl07ZERQ5Kf1zJBVq7OxuuBMDiGKoSrpj5Uz1c+m?=
 =?us-ascii?Q?9MNCwWwXICt+fyHL5d6usCmjglFTZkb83P4YaRdbnadM5g4+Q+ox/WMuu/oo?=
 =?us-ascii?Q?2tPKCBIP28ZRXRLEts6v2riZPUJhkOpYEI2Bg85qOefEJo0URW8fttDuVp/5?=
 =?us-ascii?Q?6WjhoWEO5o4XLPnP6kcKIRprYFVhOSIOEJPiwvA3tM6S098AN9m8EIDeo5gv?=
 =?us-ascii?Q?JJ0qLxNDVOStrTpaJAgaMOCrLHth6hNMbiZJBSBAofjP3+szto/uZZrR2PVu?=
 =?us-ascii?Q?w1G6kbhgRV1MXv17wmzplmeFXYdpCjL9PvknI8vxluN2wYDGmX8f2CMkjfI7?=
 =?us-ascii?Q?fSuest67FBrtCsFKQTVYBhMYuwfQRfLIszIgRPud1RbQLhjy4pUlaQQZQ3pP?=
 =?us-ascii?Q?lE+BWMfggiXva47C5bPVYZwk3+nhePsDjMv707m+k/7awqmXCvejlVyXHXG9?=
 =?us-ascii?Q?+Ume8wX8Dad7GqGsXsQTnzR0v4qfFPKSp5lilTTzzlJDLB4Rtiwd9y2e1vw6?=
 =?us-ascii?Q?geZzVG+GtVoPMkBAV+oDRjZu+1S5/XXTpq9oYlhYfTOlSkt1xYlzBN6PCfrN?=
 =?us-ascii?Q?p2xuOkkSuxSqAqOG57CB2fKkMa0I0dLxWTaTC2dKzcmxe86LCw6n9lL6ng?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 12:09:51.8363
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e30ebbf5-877f-4d29-1a74-08ddaff35c65
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002312.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6619

From: Ankit Agrawal <ankita@nvidia.com>

VM_PFNMAP VMA's are allowed to contain PTE's which point to physical
addresses that does not have a struct page and may not be in the kernel
direct map.

However ARM64 KVM relies on a simple conversion from physaddr to a
kernel virtual address when it does cache maintenance as the CMO
instructions work on virtual addresses. This simple approach does not
work for physical addresses from VM_PFNMAP since those addresses may
not have a kernel virtual address, or it may be difficult to find it.

Fortunately if the ARM64 CPU has two features, S2FWB and CACHE DIC,
then KVM no longer needs to do cache flushing and NOP's all the
CMOs. This has the effect of no longer requiring a KVA for addresses
mapped into the S2.

Add a new function, kvm_arch_supports_cacheable_pfnmap(), to report
this capability. From a core prespective it means the arch can accept
a cachable VM_PFNMAP as a memslot. From an ARM64 perspective it means
that no KVA is required.

CC: Jason Gunthorpe <jgg@nvidia.com>
CC: David Hildenbrand <david@redhat.com>
CC: Donald Dutile <ddutile@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c     | 23 +++++++++++++++++++++++
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      |  5 +++++
 3 files changed, 30 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 68c0f1c25dec..d8d2eb8a409e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1282,6 +1282,29 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	kvm_nested_s2_wp(kvm);
 }
 
+/**
+ * kvm_arch_supports_cacheable_pfnmap() - Determine whether hardware
+ *      supports cache management.
+ *
+ * ARM64 KVM relies on a simple conversion from physaddr to a kernel
+ * virtual address (KVA) when it does cache maintenance as the CMO
+ * instructions work on virtual addresses. This is incompatible with
+ * VM_PFNMAP VMAs which may not have a kernel direct mapping to a
+ * virtual address.
+ *
+ * With S2FWB and CACHE DIC features, KVM need not do cache flushing
+ * and CMOs are NOP'd. This has the effect of no longer requiring a
+ * KVA for addresses mapped into the S2. The presence of these features
+ * are thus necessary to support cacheable S2 mapping of VM_PFNMAP.
+ *
+ * Return: True if FWB and DIC is supported.
+ */
+bool kvm_arch_supports_cacheable_pfnmap(void)
+{
+	return cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) &&
+	       cpus_have_final_cap(ARM64_HAS_CACHE_DIC);
+}
+
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 {
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3bde4fb5c6aa..c91d5b5f8c39 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1235,6 +1235,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm);
 /* flush memory translations pointing to 'slot' */
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot);
+/* hardware supports cache management */
+bool kvm_arch_supports_cacheable_pfnmap(void);
 
 int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
 		       struct page **pages, int nr_pages);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eec82775c5bf..feacfb203a70 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1583,6 +1583,11 @@ static void kvm_replace_memslot(struct kvm *kvm,
 #define KVM_SET_USER_MEMORY_REGION_V1_FLAGS \
 	(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)
 
+bool __weak kvm_arch_supports_cacheable_pfnmap(void)
+{
+	return false;
+}
+
 static int check_memory_region_flags(struct kvm *kvm,
 				     const struct kvm_userspace_memory_region2 *mem)
 {
-- 
2.34.1

