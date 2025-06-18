Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CA5259C93
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 06:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750229770; cv=fail; b=g/FOAsGgIR0spqxz0Vb9oLNGHVhSO1LuOm6OfYwFJyYv+jOr1MBDWLTqM9rNLkn04qbI3MJ00j5tgT7Mm68KGJ7zSC4OwY2ZE0wQB6zMH8cZgWHkBR7dfQ+NA082uT45wh8qQyrrn6ZHlNqMatSLwsi3K5kWJlNEPlASieP/xnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750229770; c=relaxed/simple;
	bh=SHgHZcN45Gc6gIaI10XcGWdMjRxVH6QvOlM4A3I9KsY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PuzZi60exl4MhbtCMP7WNscWSMlF9lfJC9dj5q+RBmWdq7Qf/9wQGvbDzJGcpkeA1tRCot1iANxn/llbSN1C0C8+bzOb/nwpj/UQ16bN28u8r6E0NXujABNK12TNS+b89qG1/3L7CZqU5pIPkzImN2r32ILVAAmA1CibdelsdnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CJG1KySl; arc=fail smtp.client-ip=40.107.92.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CJG1KySl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yefCzuiWl+k9bnBTYVmNZp+39F9i7LwMjod2QB79PjNBKmBjI207lzqT2xIv7ay+GGyA4U9iFUyCx/AwV8lQm5cHDPKnaDUMAn1PCfdcdIr4qXxm4mw3J38aVk71jdsJYtAQ45RGZ0yp+nsFbhbkhW7P+qCgNEUzggYV9k0aj5EjpWHYBFYu99IhskLIQT5H+MXeQ8jFyFQo+k3n1NyyHsSa+CKAgeWSJiJIoEKN4vUftRyZDlkRwCfO6vtLhj6hbv6AAsKRY77m9V7JXQjhmIb+pCEHPwXLjznS+6rb5hdQtnG1+lWf6hXo7kXG8JHz8SRxGtM0S142UQc7NQNcfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CmNnoDHEy3oCujdj/7roP8gzTonpT1hAxLjXgm95ghU=;
 b=Zchvc0UuiF5CQxHiZAijl7FTJq33v2jdUMnORtrx7oodb8iJjO3ZalIYWJX63Dha0FJIFY1Si3IJVVUzZ1uO1kKaqkkcm5LqsdrGtdc/XoLtNF+WYfUuLfDxYmrL3J9QnTXUtb+b2yXyvNebG/OEq0rSh7EqlWpMiHj6eyVbd9dVVzl792oOH+PJT4vY+gzOyZpzp4kgfv/nWhKXS5bu7EP36rqp8ra5nNd0tCL0gr+apCUiR3/tQbCTR5yhChtc+5i+nL5jpCDWwjKDS9LYUIofoUHtehE4zBs2HzWybWSgt9L630q/u9YAEExLigFlpiOQFdullGeMqXUjX8yBFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CmNnoDHEy3oCujdj/7roP8gzTonpT1hAxLjXgm95ghU=;
 b=CJG1KySlqxoOPFdytgbwJBRARc6wu9TIhfoe7vMsREAlh9Qlg5eyAWiP/c3nu5boXrF8wg0qGXqy2R3C4ulFe+tUeQTg/kn6J3ivJvYNhaqEIIyho1Dt/CuMftSHXmmo38hqcNI1o8+uWWwhQzStwMnZYVyZmGzAAVhpPiQuhG1hhsXPfpAr0XfdMwNoZc3yveZRDug42fVoA6qgvDXeYD97FKghMfgdrsQoGAwGbyLaGvlcK33f3jXqrP4EgZAfzxsWckkC71XFNZBNkKHfT8zExRJ1TxUJG8BGAYeQoJcohlSExvGv2/LHTddtbnQLaWTGfCjUFcy+oNYh9jViog==
Received: from PH0PR07CA0034.namprd07.prod.outlook.com (2603:10b6:510:e::9) by
 CH1PR12MB9597.namprd12.prod.outlook.com (2603:10b6:610:2ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 06:56:03 +0000
Received: from CO1PEPF000044F9.namprd21.prod.outlook.com
 (2603:10b6:510:e:cafe::a9) by PH0PR07CA0034.outlook.office365.com
 (2603:10b6:510:e::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.19 via Frontend Transport; Wed,
 18 Jun 2025 06:56:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044F9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.0 via Frontend Transport; Wed, 18 Jun 2025 06:56:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Jun
 2025 23:55:46 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 17 Jun
 2025 23:55:45 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 17 Jun 2025 23:55:44 -0700
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
Subject: [PATCH v7 2/5] KVM: arm64: Block cacheable PFNMAP mapping
Date: Wed, 18 Jun 2025 06:55:38 +0000
Message-ID: <20250618065541.50049-3-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F9:EE_|CH1PR12MB9597:EE_
X-MS-Office365-Filtering-Correlation-Id: e9239471-1f9b-47d4-91b1-08ddae3530e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CLLrqwV95X2RoN2lUIEzvhEoh/fSo4wHhFvGMTEMClpCz4+RSnjvwvGzbkF5?=
 =?us-ascii?Q?fHql4uHD4WOgRtgjxrbnZDL6xrn2upijEM85Nhzp0fJ6PA7aH5iAzmpeweni?=
 =?us-ascii?Q?A25aH/acqveYTx2X9YWtmdghuId7bNk+LCalqcVi5JnEWxt0bOM3DJAxnnd2?=
 =?us-ascii?Q?WCymUFR4vQzZTi1FbUTk6BihBPNgWPAwFrtwL3meAiVm6OBoguV/10+XB+/V?=
 =?us-ascii?Q?KRz4wM68RsvkG0K8/daSseFodniSbwFoswIuKQIpsAjApW2np2BgAfE79u/9?=
 =?us-ascii?Q?4NRqd5INJOgiGSu7KRq3lw7kRpIb1q9wPiCfKxkiXezjCJYhSPrsDr/EHmKs?=
 =?us-ascii?Q?CTnJmP4LsxeRuiMFUeVA09az2QkwUKETEwEqzwmEcdhhHNPEClhj6OVfC4vN?=
 =?us-ascii?Q?REN8xuLRoVSPAuz53DtIniQckFAB4uPvJ4DYKrQ8L9lJWFHhBJmhKWIChagI?=
 =?us-ascii?Q?fKO+fiF3qJTLSLjRlf/72XxdIRX5hUJ5sKSBWnaJYtnTExpc+h6C/QXQSt8+?=
 =?us-ascii?Q?oke77EwQQVBOXIx9B17i9daLl1+z4WNRUDjshDSpRYWz9aEBb3LS6c2uXY+d?=
 =?us-ascii?Q?H+qWKbTtK5NyDEJL4+ginFn5thZz7vXN6aFdAtZ/ZT+1ddFNAg2ySmoXw4Mp?=
 =?us-ascii?Q?7H+t/qagz4O9V7JgBbR9S5Vy9esNb7nuRc4J6JMRejYV3J/adPnr6Fp8Xnr1?=
 =?us-ascii?Q?akMQhUa1pJz1zgGuL3fkDC+lr0sqitkF2wVG71shWk517XdSxbxkUnjjaExL?=
 =?us-ascii?Q?nzALrOyOyrQqUA254wnlaL+PQlScFsMmOsSaRSQhpbe9s4GgDcVzMYqcQAP/?=
 =?us-ascii?Q?d8zJ+8RhL+LBjqA++NQcgvGOaPiCkQA95j07uqM2GXmP1jdjU4d3JnRax0H3?=
 =?us-ascii?Q?2iuORjrBIeUUq5A0EZoJBEx5hW+Saip9ontggM4bHCPcq2KV9+363z4fO51w?=
 =?us-ascii?Q?uvI7Z9szF2VfYSUQjkqTnDqzv1W9aAxlotqnnukeDJu/iDEinHpSdrzMgH4O?=
 =?us-ascii?Q?RteSsoQWyk5f3q+gp6g3CwrdRnV5tus6q/OkDYiQxOTrREiSxj1dpP/RmbkP?=
 =?us-ascii?Q?D1+IeCx2NDLrMDOIXF60ZmcUnqUpPWpLLpQ5DUdvhiBiWGni6X5PzvbpYXkI?=
 =?us-ascii?Q?t2wfEJBSLw2OGyThJGQMmHfUCTn4kpKHMe84jQgYpxocSkXqhww7VpjfEVgB?=
 =?us-ascii?Q?l+wXWtw7j9VYwlM3pg6SwaRTVbUjXuJAufh+XUZoltuy1cNzo6QNjT3s+4g1?=
 =?us-ascii?Q?6EA5j7H719eyhZa8Qcr4uh5LsFJ1nCXg2TTppKCvBAVngOFiMNIVtZ+8zUIc?=
 =?us-ascii?Q?jfQ5IsoFetHtS06tcxumYgGbhbh7dAgCBGoWGL/cy0o2bzWmTewjjom7sGT3?=
 =?us-ascii?Q?zqM9xt3jRbKE9gLyqYqtpw01hB2XmN8OWeKRUod27xhkyh5egrqd2AUsboa1?=
 =?us-ascii?Q?8L4IqBSfVi01FbJTLgMr/RXfq677sY/Tm2XfQzg8yie8owkJpk720ddn40qo?=
 =?us-ascii?Q?RuAqTXmB36Y0OflGw4TrUNyTvxnFkWYrPiRVUSJs/wQOEwOYfyvhKmT4CA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 06:56:03.2400
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9239471-1f9b-47d4-91b1-08ddae3530e0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F9.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9597

From: Ankit Agrawal <ankita@nvidia.com>

Fixes a security bug due to mismatched attributes between S1 and
S2 mapping.

Currently, it is possible for a region to be cacheable in the userspace
VMA, but mapped non cached in S2. This creates a potential issue where
the VMM may sanitize cacheable memory across VMs using cacheable stores,
ensuring it is zeroed. However, if KVM subsequently assigns this memory
to a VM as uncached, the VM could end up accessing stale, non-zeroed data
from a previous VM, leading to unintended data exposure. This is a security
risk.

Block such mismatch attributes case by returning EINVAL when userspace
try to map PFNMAP cacheable. Only allow NORMAL_NC and DEVICE_*.

CC: Oliver Upton <oliver.upton@linux.dev>
CC: Sean Christopherson <seanjc@google.com>
CC: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3d77a278fc4f..d6e0d5f46b45 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1470,6 +1470,22 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
+/*
+ * Determine the memory region cacheability from VMA's pgprot. This
+ * is used to set the stage 2 PTEs.
+ */
+static bool kvm_vma_is_cacheable(struct vm_area_struct *vma)
+{
+	switch (FIELD_GET(PTE_ATTRINDX_MASK, pgprot_val(vma->vm_page_prot))) {
+	case MT_NORMAL_NC:
+	case MT_DEVICE_nGnRnE:
+	case MT_DEVICE_nGnRE:
+		return false;
+	default:
+		return true;
+	}
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1477,7 +1493,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 {
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
-	bool exec_fault, mte_allowed;
+	bool exec_fault, mte_allowed, is_vma_cacheable = false;
 	bool disable_cmo = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
@@ -1619,6 +1635,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
 
+	is_vma_cacheable = kvm_vma_is_cacheable(vma);
+
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
 
@@ -1643,6 +1661,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 
 	if (!kvm_can_use_cmo_pfn(pfn)) {
+		if (is_vma_cacheable)
+			return -EINVAL;
+
 		/*
 		 * If the page was identified as device early by looking at
 		 * the VMA flags, vma_pagesize is already representing the
@@ -1726,6 +1747,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		prot |= KVM_PGTABLE_PROT_X;
 
 	if (disable_cmo) {
+		if (is_vma_cacheable) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+
 		if (vfio_allow_any_uc)
 			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
 		else
@@ -2221,6 +2247,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				ret = -EINVAL;
 				break;
 			}
+
+			/* Cacheable PFNMAP is not allowed */
+			if (kvm_vma_is_cacheable(vma)) {
+				ret = -EINVAL;
+				break;
+			}
 		}
 		hva = min(reg_end, vma->vm_end);
 	} while (hva < reg_end);
-- 
2.34.1

