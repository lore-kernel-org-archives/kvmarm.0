Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2071.outbound.protection.outlook.com [40.107.100.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0FB18C933
	for <kvmarm@lists.linux.dev>; Sat, 24 May 2025 01:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748050809; cv=fail; b=N/JV7O7duWZ+8XwmWKHdqbafsm2W6jjm6D32lzU5FBQwBkhbyfp2SNvR4Qs16SPAQRHyrV8/v4qm+1WgEqpHgDbIGedf1GWlAf1guikj6eYNjvj0osSkhpVl3kXwb1bQw7DJ84b8xLaMqt4u8SbXDHbIh7JDT4WhQqTfAHQa/kM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748050809; c=relaxed/simple;
	bh=PScVZb5Li2+3sGUOzEKWv7W1U5SNVz3ZXMI5Gz9ayDk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ks5GbaAp+EzowgXVhp2Wbte5oDlbixmB9+NqkdAyx7o2t65FIYKtOVo7VXmFVDz97NJfQEQmLphAxRpHmX2xAbZDppwqFYEuCQEcrYNRMowogDyYSZei4LUjrK1yghxCAj7G+gm4AEL+v7laG430NPXgURTpBERIvNbUejslaW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TY/o1zdP; arc=fail smtp.client-ip=40.107.100.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TY/o1zdP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n3j4vxjDnTr7xaP4AZrPJfsej6n0mne62UnDookUDqlKeRXFNv6pJH8ixxuLUUheu9S8SDX+gO84/mNYC8fr0Q/vMeICCEt6LMSJM/CKUG3OkH+DOqWsXQnC0HNhmq5ibP0Qq+5Flpb0mLSlTL9sw+dtDHD8q+PbHL5FOLzM5/xgzio/eaGRa6NFAgqKDzmsb9lNIg+TtnE4EUdokUd9z0+V6utGeYpOiFAdtSgmuPO2u76IM4/f5Yv47m/b2LeSEjc+c5kA2F1L6zoMxQoxT5bO/eFZ6x16vlTGYbfoSEPUWDbWYyAWpVibPIHiYJ+GWrnWdz9iz3pyjI96bS6v2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7vkRhP7k7egvZOR1R5uTRDuY/BUzUt8q/kleOEO+po=;
 b=qGY2lZB8Rozp1RSxeWQQUV70QYPRYui5tAxc3JHKyXzzM+fjsA6eqjCDKcP+IEEHFEegz/ejClY2CbGiC885HjX/NiqqUiWuYXDeN9UW0h63ARSA91u2Z76C0w6SWsvg4G9Rwpf8pB3Q+Im8nkk1ErmUVn8Q7sAPq7byl/SOSekh5y6TG444XCKMXEb6BD2jeTPDH5xBtSUcr1sHKqEB624dIrr0vT5OheKlkY16hO28HHClgk/wP/VXkXmCmldOm3OvneS2yGJXbrEtqVq3jriV8UFyoywFRUmiNDBci5MFpIAL8a/yWLpISpPraBpcTHMPfaeSwE7sLDz9HV0jwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7vkRhP7k7egvZOR1R5uTRDuY/BUzUt8q/kleOEO+po=;
 b=TY/o1zdPw+dTCqj7QFvxsSMi9X8yFLOqEYS9RnF7wwang3uyHDH5TmsZXe3VDyi9SCDl5lZsyq4scg1Nu0Tl681L1V4nIytTX63BOmaGCNk4UgNhgR5d03AxJL/FnQv5M7YCvlE+qv2c8ZPnfvktwn896PA560bjhlNasZKB0uh5ZLjBzqJ894Qy++v1Rzqc0p5LDZKhxrvZ74MnpD6NIeo9twPjqPpDIqnDKVgjHJnUdaae+sFxNBwI3sKwaPlBorqOW4c9ND4Y6dUGsviOrCHbsN1jcPu055kiqvJwfYYpkbsaHOhseDqNKcPLEltv04/+rGnXoGGUIqcnt2TPVw==
Received: from PH7PR17CA0008.namprd17.prod.outlook.com (2603:10b6:510:324::8)
 by PH8PR12MB6721.namprd12.prod.outlook.com (2603:10b6:510:1cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.23; Sat, 24 May
 2025 01:39:59 +0000
Received: from CY4PEPF0000EE31.namprd05.prod.outlook.com
 (2603:10b6:510:324:cafe::8f) by PH7PR17CA0008.outlook.office365.com
 (2603:10b6:510:324::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.34 via Frontend Transport; Sat,
 24 May 2025 01:39:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE31.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Sat, 24 May 2025 01:39:59 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 23 May
 2025 18:39:49 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 23 May
 2025 18:39:48 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 23 May 2025 18:39:47 -0700
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
Subject: [PATCH v6 2/5] KVM: arm64: New function to determine hardware cache management support
Date: Sat, 24 May 2025 01:39:40 +0000
Message-ID: <20250524013943.2832-3-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE31:EE_|PH8PR12MB6721:EE_
X-MS-Office365-Filtering-Correlation-Id: ebee399a-347f-45db-0c5c-08dd9a63e51a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?knPaP35MvItE4kuQ1s400w0cJnJL81ccxOU9dD/JsB1wn5heRBDRtccHvcOc?=
 =?us-ascii?Q?hP88ULLtcdZMqhnHE/AtGU9YveeMu7urIi4yaLJC09hXh+3FYC461Ywibkz0?=
 =?us-ascii?Q?VdaMc4aROFprlh1Wseirx5mB/az7sj929TwQ+xyfe7XbO4qvt6j5wKS3aT0U?=
 =?us-ascii?Q?nIRSsZv4SDHpwx4WRnOkKnN0QMOMpKUtXwGNNIuN7yFVrwZbkPcTAPTrhkh4?=
 =?us-ascii?Q?orBm7d6VMRolVUhGblbqnur5a1+Kqr+DktkZYX7DfwC0r4n7PSLWAZ1M6CiV?=
 =?us-ascii?Q?xr5YyppQQUV95V00D3sN+fsRuxFZrwI0syMiKOqP1Fp1xnXjUWGBD+b80pLM?=
 =?us-ascii?Q?U7VHqE4fCd2+pmIxlYqGFYEGX3cHAK7vmZkZl08/TEMBNBD8ZZ1n1fmBX4N6?=
 =?us-ascii?Q?F/TAjvIngdsfnMQvV9rdvifAPrgXcElvDkisbi/4K0Avc/8ubuFzfqDq2uG2?=
 =?us-ascii?Q?3X8F7Y5sT5xEK1eWygjuBl7y8NC8uDjaeu9QYvV+v0jE4/sGTrvXPFHB5f9h?=
 =?us-ascii?Q?URtYO5jU9wZcFq92RTYGFtz+q1NSjq0NSnBfpGuU8XBftffL4AFCg3AS6Ayo?=
 =?us-ascii?Q?2670IffMv7Zim7f77rNTJpb4p2kq8hnN7rZMmKyRu40MlfUh5dyByuh+IQsn?=
 =?us-ascii?Q?5XatYFcYb38cLgpflD3L0gCT9536VDZLyFZvHQqmz68tbYmGJJsrI91FRMe0?=
 =?us-ascii?Q?gGS0j8JN04iRd0MSmv1ybj4Z1a4oxW/oA8wi8sAYSG0U34+O89DVIypOJuft?=
 =?us-ascii?Q?5Ixiyip2hmeo5EYmI1jbfz+ftSg3YvXpYpeLv3wb5xtEo2wXmgyjlo9Wl9Oh?=
 =?us-ascii?Q?WLDHYlzwZWcGET4ZfiFOKoZggYoZcjD49QTBymghjUy2BV6K2Zv5p3wIa3dM?=
 =?us-ascii?Q?TQHaynREhO5N+n8wDyR9zcb5e1h8OCSyLz6y763KKibbqS7/3YU0EgSagrje?=
 =?us-ascii?Q?PWT9jD9PLYKcEhnBq0DpggtKeCIFNDAurnoQF4M5cSrVoBo0WTbfYqdLchVZ?=
 =?us-ascii?Q?POYQPo/KrDHC13il+YREeG488Mxl/ZmmpyyCj19yS8RIcP/KREogKh9ivv8d?=
 =?us-ascii?Q?h8LHT1ecaTiJ8LRClvHce7Sr8T0bhUXqxvmJougu17eFW1g6es6NZjUKMx6p?=
 =?us-ascii?Q?WQVi7RCfF9q+odZKBYo+1gQi4A6xXyvSM5qtIZuwtpzJaCpcDWab11cMd81j?=
 =?us-ascii?Q?WK0rNIsUU2q7KzLePBxeqn7tRvksu7OWyVulqCkpJQpMpPOQ0ZxbtOXNSekj?=
 =?us-ascii?Q?YWGqv55fY8GNi5MGSxgdd9qXi+H3ND8dRxyxFJ1kzFHLD1uRx2NLNwda3ioE?=
 =?us-ascii?Q?QkCJtMbGdNlOVn0P9QziYZ9JFd6Rancf3WdP676CaIWORHBAChsLx7zKujHr?=
 =?us-ascii?Q?Uhs8zqo3vqgqMeecypZaOxljhDtY6WwvYxYYnQo6LmY50ca9PRe4t3aDgTCg?=
 =?us-ascii?Q?90/Qxw9wvOkJArOlZ/qzE9uoz+azs6uyqiq3JT4HOzqUFgtkMBVubbTmk0eY?=
 =?us-ascii?Q?+nGyEtwV4bbcEy5KbtW+R9TzMTLlusLIVmjzVOxHVqlCC+OLgjkvY8bmIA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2025 01:39:59.2044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebee399a-347f-45db-0c5c-08dd9a63e51a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE31.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6721

From: Ankit Agrawal <ankita@nvidia.com>

The hardware supports safely mapping PFNMAP as cacheable if it
is capable of managing cache. This can be determined by the presence
of FWB (Force Write Back) and CACHE_DIC feature.

When FWB is not enabled, the kernel expects to trivially do cache
management by flushing the memory by linearly converting a kvm_pte to
phys_addr to a KVA. The cache management thus relies on memory being
mapped. Since the GPU device memory is not kernel mapped, exit when
the FWB is not supported. Similarly, ARM64_HAS_CACHE_DIC allows KVM
to avoid flushing the icache and turns icache_inval_pou() into a NOP.
So the cacheable PFNMAP is contingent on these two hardware features.

Introduce a new function to make the check for presence of those
features.

CC: David Hildenbrand <david@redhat.com>
CC: Donald Dutile <ddutile@redhat.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c     | 12 ++++++++++++
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      |  5 +++++
 3 files changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 305a0e054f81..124655da02ca 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1287,6 +1287,18 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	kvm_nested_s2_wp(kvm);
 }
 
+/**
+ * kvm_arch_supports_cacheable_pfnmap() - Determine whether hardware
+ *      supports cache management.
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
index 291d49b9bf05..390f147d8f31 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1231,6 +1231,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm);
 /* flush memory translations pointing to 'slot' */
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot);
+/* hardware supports cache management */
+bool kvm_arch_supports_cacheable_pfnmap(void);
 
 int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
 		       struct page **pages, int nr_pages);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e85b33a92624..c7ecca504cdd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1526,6 +1526,11 @@ static void kvm_replace_memslot(struct kvm *kvm,
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

