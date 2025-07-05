Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B878128A410
	for <kvmarm@lists.linux.dev>; Sat,  5 Jul 2025 07:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751699868; cv=fail; b=LWji65iDN1Rm9uTHhitU5LBeH2d5s08KQ/usiMXxKENm3ZL8fygKOqk3bD5L3XNreMUwCeVfyTbTL0TAC5EQbjURL5/FCn0LFWAdcv1FZ9N/HMpQhRF3vupmb+zk16EsyaGo+u1WjUD7oyb9InT0GTR6qpCQAazCnTbMoyZquXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751699868; c=relaxed/simple;
	bh=caAI5RvBrpCbzu5oifxN1D6XhDhiMDImLC4X82fvg60=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l8Kw01VGELiPQmV2FmhHNTIO1aB6nPZKGMzlNhCjnE200kTV2efQNJ0LtiEt4cPfMZ3f339iG0mc3gma3VLUDCnWyY0aDmAMAsGzhxmqa2Jvn9Y9jhtBK30RFZTJoAxyHCsdD/aInyX9Ps5jp6KE+bgeMH4j4CO9h1iGPk85kaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JcD8Jkyt; arc=fail smtp.client-ip=40.107.220.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JcD8Jkyt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W7Is6OZx2Ty0bnZJ51atR1CO69DN7IwstiCXYwfSMgROXLOG2a+SowW/ODbOFgLqpbz3ZZT52R8/sOOx3H+JjrOXJB4HNwkT/mqJbidqVd5h39vMnhUQaYcJ7J2IsNvMeaMznZkdAIVOuwr1x/Z8O+mO6mAtWEYv6AGG/KuKVSuAfBO+9h9AI6Nrr4n3MHHJigRipqGWIMY83dy9MkT7Q3ljTwUUezqJBWUiCdLeBBBsdO4NGWzfdFrU5WU6L1me9MiDHWTxTrdOLqV9tqkzobE3SyMy8U86/5sW7VCkEklAxp3EJVgacHrUZXZEs/5RgJyMlKe3i7EWPxtYWNwkAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uhyk0WS7NJEGskL2nmwEjBuVp3P+Ge77e5+erWJeAeY=;
 b=C/9+55yYZNjMVCFmhe8vQbmlkw1VNTWNkkqCiQIEgFmkGiZ6GAT7sOg/dGV3YxGZoF28UkwVGEXvLEisMx/7xFa1odkdLQKSOikTa9YbLhcMVgCqu5PigrkibareEHuNuoFNFpToD95rt70wsZyTE4tpI2EU3gKHN/4bHEeGpyMcRNUBdU2O9VACV8FeJFC6z+06+BD6+bA5QVgDALK53yIR85O8bTvo+23NLnHtAGpgazenLzMSdPfYE7s5yoTAyZaYzKj+6d8VuL8OCR+BvNYbYkUOTY52b1a0uRWPvf2vAUuLHvgRmYKr553J1ZD9QclsvrPecjurzD8kBUADqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uhyk0WS7NJEGskL2nmwEjBuVp3P+Ge77e5+erWJeAeY=;
 b=JcD8JkytsWzqLuG+SwTyBu7nht+bOLAtxDZOlYWC0YMtD9J4pPIZFT01lw1Dh9eQCLpoGQaADLTZn6yk2KLa5t6ejU4xlvvkthCY770hgBAbo1Xi098PT49JEW/XXCXQLdKh+yFeVvbCVulGxUs/tiqyKBWiqi9GdeSqClj4DrDJEFakqs7sW1mUduDm6LIl4JfP0hkoOw7P0cQT/KflfACKK2aeHrPgnqNtLW39pWL19RlCSgveoDLOT67tonZnCaM+azPkLhBMYKx+Mevd6idwbR7vrAFm22bXAgqONwbI0v8iCJ0GErVTyR6sdQI8j/i4u0XoRREt7H00NfcZBg==
Received: from PH7P222CA0024.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:33a::24)
 by IA0PPF12042BF6F.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bc8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Sat, 5 Jul
 2025 07:17:39 +0000
Received: from CY4PEPF0000FCC1.namprd03.prod.outlook.com
 (2603:10b6:510:33a:cafe::e0) by PH7P222CA0024.outlook.office365.com
 (2603:10b6:510:33a::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.24 via Frontend Transport; Sat,
 5 Jul 2025 07:17:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000FCC1.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.15 via Frontend Transport; Sat, 5 Jul 2025 07:17:38 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 5 Jul 2025
 00:17:25 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 5 Jul
 2025 00:17:24 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 5 Jul 2025 00:17:23 -0700
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
Subject: [PATCH v10 4/6] KVM: arm64: New function to determine hardware cache management support
Date: Sat, 5 Jul 2025 07:17:15 +0000
Message-ID: <20250705071717.5062-5-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC1:EE_|IA0PPF12042BF6F:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b3353f2-8691-43b7-9329-08ddbb9405d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3i3dsep6nqb/EzRuB/Zzkko2A2eq5TUe5bVmthox8QsX9kLYmF7bfXN9P/kl?=
 =?us-ascii?Q?Ak8nne2GhyW/vxQ2KNLkzRpzWTv5do8+rLohRTephi0apvpXE2mukeO4xVVu?=
 =?us-ascii?Q?pl1FMFNjBWgtc9G1he6oRXqCXWC3I08MjSN+N5ZHqyH6rzIJo+8L/L3lo3Q+?=
 =?us-ascii?Q?sKmlMlUMfEhOTmHwU2ZbMIid552Jdwz9RVzjhb1ifOxTWc9/dw4lgnNGXG3I?=
 =?us-ascii?Q?Wxyezhf8hbRaDUBqSd+1zxu43pmKYpp5UWr5pJ6twH4dSdAm0h9tdaPy7a5C?=
 =?us-ascii?Q?4wJ1u//Xm6KDxavG+dfyVnLDW7wF/p8wxiUeusFOhKLVepYx/+VM2/B8FI3I?=
 =?us-ascii?Q?nUuWIF+vmHUh2dEgkhjE8mN8x5gNMJYC+cjbRI4rkRd/0Uj6F1/6E06/MrOb?=
 =?us-ascii?Q?cSEUcorjjnkV22aKHz1QmuqBe9j6PXXV3+TY+i2DO50kvsKQBdUJEoer8V9J?=
 =?us-ascii?Q?gC79n9o/78t/JS2TFAq3kqMl5A4NM3Ts987ZZ+Xq6Qd8JH/ft9Mu9TxvpuBG?=
 =?us-ascii?Q?3N9RVQR8JK/4GBH2JCVy8YpeiSerfZa6QI1ozcbyvwnTfcOMSggDAqgo7HxP?=
 =?us-ascii?Q?vyAZAEEpQjnR3kzHm9H3DvXKDjz/69qmYgxqPHz8Wsm/vP0dwCLMFai45V/V?=
 =?us-ascii?Q?RcTWfPpgji4rjptXwqXFZVCKCcDyM6sKs+Si2dsUrHCMMkCXffRaX+KyItj7?=
 =?us-ascii?Q?FWgiE/e8EY+5DL/RYeCvfng+0xOetxvNRouA14XiUs84ucTr3D0aGsoEDAz4?=
 =?us-ascii?Q?AhKkruWqcPtR5cIS+MMJjsMCQJxEj41CukJ65nRE3LgaVtIerW9xdtJTl/8Y?=
 =?us-ascii?Q?hLZO3hesOLxrf50DAcMA6lmiood6+dMbx37niMEX8DXQnwOAnw8tEoYkwaI7?=
 =?us-ascii?Q?ReHqwReEpQ6RMfcfQM6o7P9BbiRM+BJAgM7xwu1fhddUXogmr+SaNV12A7/X?=
 =?us-ascii?Q?J+bbnWA+C6z6Fx8QfrGPCWXjG+BPzvfKOQ7t8wncglj8+gj+vmI9uIZJGRPT?=
 =?us-ascii?Q?iIF00nnXLRdHq9x1IWKQ5G67e2k23/aQmBRiIo3ylQw/e5mQ7j132cvTZ2fg?=
 =?us-ascii?Q?GhoZLqrP4G926kQlR8qXYMYA2QPVtbeRHb2lBb6My2sNnHbHfa88CXvbwymi?=
 =?us-ascii?Q?Z+d824zqnXRKR6ZNjwLRJFX4lqaByNWAfL61nAXAj6zg4Hu0TZIoJCVGrw5N?=
 =?us-ascii?Q?fYpw69d96CiSKC+83ld1a11+g56ScjXphmq9cKYVIhxvaESpWdhu7BfAdMNg?=
 =?us-ascii?Q?4K/icCGBKGTvhTlYKxouK9qXE29gSJEmRe3J5faoXbrB1JErTtHne8l+erBd?=
 =?us-ascii?Q?dtaUsq3M0TW+3ziHps++iabTAoUBJmmV/98yiBeVccq1loY30P3Q6gyG7Xdy?=
 =?us-ascii?Q?/CZdh5XlVB/aWfKyxMIeFAc+IFFAkBhL6YzoLIhnriLIh0iX5jex7w9weozh?=
 =?us-ascii?Q?VBp9e0JSMYl9N4tByReLV1HFBYz0uhxyPvltyKroX1dH19TwzwfxJUZbHL0y?=
 =?us-ascii?Q?qL0u6PH6uDgCuqe6W+pn1O0QWNiQHgV8yaCWHiIlA+3aIgruEyT689/1ew?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2025 07:17:38.3418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b3353f2-8691-43b7-9329-08ddbb9405d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF12042BF6F

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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Donald Dutile <ddutile@redhat.com>
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

