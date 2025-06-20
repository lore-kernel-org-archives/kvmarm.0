Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B8128AB0B
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 12:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750421398; cv=fail; b=S/TqZDccDGeMaYlOXPJDsAp8J/5WoZJmk35XGISibEFpqCFTdYSvCENmEaljPU3puUI2NEuQf9upLfodREh9hW++nAxrxIqxvQsPZbbxDJfztG9wMGNNbRX/6sMpq7OAq6Ys4IgqISAZp4XV9NWUIR+sHtHUzdDvYVBncmEWMTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750421398; c=relaxed/simple;
	bh=K1A9meQeof9rBgV+v7BXlANJ8oaClq5ZlobMDdSaDH0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hDl5HY2M9gpQc/fuTU8ZnzX8q5qFVktbU7TGuJ8Du+k1TiWHrPhtaiQfk3HJaHri0Cfrgs0f9BJ7LvgI4CUsBcLZ/6Iwv3n1lxib6X55vNuKTB2XSGGWMsU4DnKVPL2M+0/x98GM8GD4pQgZDpk5Sszg69xozbBbkFA+Nuieomo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=r3MC6QS6; arc=fail smtp.client-ip=40.107.243.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r3MC6QS6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XdNWUfFaPj/sHLnSJT+0fTf2mGpX+59macNHyGSCbjalq6de8nk+KwS65RAxYaxU52gHUnWteuTC8kluwz73zrYEDxEc5riDHMiK9GZdv3C6cbJ5vREg+eOgTr3SumAY7OVVXL5LFWDOy9g6Bf8OzDGTRUkY9+6YZplqt3+r3xtNIoZTiy5DDV28cOvlc5BjzOFm4GPbHonqaYGavBmv87rWtmyx7SXywOPP34VFQwXDRarNmBs8s6L3W5meEmbL7fKPczI2guvSnudhgCtokHkDCdp3kd1PKiSxP4ZdWEEa8fgm3qjptzWOpAYdWUVLwPRUp4+DddR569t2ZPjMBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIQt+tY6R4HF3xyakMnOf2Mpw6CcfJPzeKMWV3H3vDk=;
 b=Qn2G3njLs/RVPeIJ1vK47Mv5i3PjPY3TnRd9a+6ljqCHA+wYU1q+1ED0yC+5NfyBikzInAgtfATzH76h4Y2edLw59avEubof8kHRJY7cdd+Z+Aa4rdXogsWHP+z3oGiFEH+KI4FIT0g8fc3XF+C8Y6PLQN2QX4q71F19m38Z+LWys7GC//jxz7MrRlF31puqMYY6BLGEV/XxUmS2mi+A2PQqiJQwVV9JO5JEmPpU0mYXgMhJvahd4Vznv53dQ4LoYnIWalIIWFm/9YGu5o9y0ti5NdsdlmBf9i14BEmN/ccTi9kFquKrd3G4Hi0OFApvnAg0SeG8axB6fTedP9eS6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIQt+tY6R4HF3xyakMnOf2Mpw6CcfJPzeKMWV3H3vDk=;
 b=r3MC6QS6mKXOq/knZ9+/jMUu8GN5jdY99O+l73ZeIXdixsg60eEgR4juam4Gz9xe1VyE7kmNz45cwlutm0qAm6+8lKRPomnBksVu11mlak1HJA2cq6U4wRCwBXkFJ4PXiPmwYN+ifamaErkEsN+sXP0Xq2qLVhmObQrNCyJwQl9s9ekoM4rivXtCAFlqmjnSaFn4jHju7nGarkvvk1cIlRaQzwa44REdfBnegrPKN3z7v4I/6MH00gYFyG30ZnE2AtVHQ9iq/hT2Yjm3Sdl/F4MG5TFBIziR9axcET7UHu87TLEDA78xHcnkbYD5PnjUeWwK/NCHe0yWaNeJOtRDFg==
Received: from BL1PR13CA0200.namprd13.prod.outlook.com (2603:10b6:208:2be::25)
 by DS7PR12MB6357.namprd12.prod.outlook.com (2603:10b6:8:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Fri, 20 Jun
 2025 12:09:51 +0000
Received: from BN1PEPF00005FFD.namprd05.prod.outlook.com
 (2603:10b6:208:2be:cafe::b4) by BL1PR13CA0200.outlook.office365.com
 (2603:10b6:208:2be::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.12 via Frontend Transport; Fri,
 20 Jun 2025 12:09:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF00005FFD.mail.protection.outlook.com (10.167.243.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Fri, 20 Jun 2025 12:09:51 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
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
Subject: [PATCH v8 3/6] KVM: arm64: Block cacheable PFNMAP mapping
Date: Fri, 20 Jun 2025 12:09:43 +0000
Message-ID: <20250620120946.2991-4-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFD:EE_|DS7PR12MB6357:EE_
X-MS-Office365-Filtering-Correlation-Id: 50ba483f-2142-41d7-bfe5-08ddaff35c40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IfXoQcM3SxaghGNuyGEP8i9bOrWVcEDGezmApEuyaOUBJEpdLF8CS4Be/bf9?=
 =?us-ascii?Q?f60uyMDZxusSFoiEsZ7kQBryMT8dvHQdt2BGlGhI3rFdPVUjW15mSUOJBTTj?=
 =?us-ascii?Q?yXLyazK/ljNAcWtZXQfcamco6rfBpI33WwPiAXOXILOhx75i/FqBNMOvnsYc?=
 =?us-ascii?Q?nwi/EOEWuGnaejOkZ4vYcZ8bUc4I9FPNbm7huhh1NQo0b4CciercOIAaZ/ko?=
 =?us-ascii?Q?EYKob80YRieC3rlaKERwhR/W3bJMXqRDoH8ZUZX3Bvih/9R26pgb2mNF02HJ?=
 =?us-ascii?Q?8sAJFxqB5CYSsG5kUvhw0iwokIFu4v3MTfOqyX/XuFoVDusbrFE751mCjLQx?=
 =?us-ascii?Q?1GGX3az0QeoAf6tfLAUa3XMACYP8Bxmkhn8l8k2FI2c8IN9RClIRwr0XygrG?=
 =?us-ascii?Q?IsTY9YYtHQIqwj9usS4+SOZW+LpZbtpgXDOPWG4VAJUqHWk1sHcydPfuIpwe?=
 =?us-ascii?Q?S98YHxA4eoGtJwd0/84MiglHztuqMSAPueBjLaF70YPQYyD8IFnwZIRMaZtt?=
 =?us-ascii?Q?zzmpdcMGNaWFPaoXymCuo+Q0CYteCkc8cuP47rjjbWa8FKfq+p2fwMPENlda?=
 =?us-ascii?Q?D/M64JvCny/fTGQXHchD4VP7aSk2PNG39+4nuKxD+1HdiOoytYOiNjDsZToD?=
 =?us-ascii?Q?Bl4IIYUPq8hD0rJwrGHPBSTjimhSIE1QPGm+mXDua2uXdlFbYAEQdGpnItz+?=
 =?us-ascii?Q?ajLUH5vqX/gk8lDqtVNOZix8QtqID00JO/8oO9uQVSiQhpDW2o5kLxecc6CW?=
 =?us-ascii?Q?4rp1az0MuF3sl0PtegtvqNy7QpwCEpbF2FcH65VP6+P8ndm62CMDwRiyJ7DQ?=
 =?us-ascii?Q?/fIcKtqbiEvHsUH5hfcNJa7dqibHjEMYOVVGyIt63F4qnp193bfqen1bqOC6?=
 =?us-ascii?Q?+BsEJWGaum2uvEJBdkbqZN7u1NA71EtlxHGViZt4TZuqgfN/LTz5qBMtg3eS?=
 =?us-ascii?Q?/daPBalkYx6J/6aAc06xdVxbU/I0yqE3LNqeTWbFP4njMpShmnM1yugzg9lc?=
 =?us-ascii?Q?lWJClfsCEKXP35+169q4qaSZG9WNUjAxMvUZWreVgrM9Q+Yp12bLUxKpty0/?=
 =?us-ascii?Q?jXc1ojYZcpwd5Cf9T5FIFRk5a6i9v9CSk4sSGq06Ya5zRe5BJG8QpAZBCrXc?=
 =?us-ascii?Q?xwu6yo9W+PjXoas8UKnKwJhth5f9cNxjDH/lrKvUMsTDZSz0uqqW2jn+/S1O?=
 =?us-ascii?Q?pU7W3ezKgezt7LhsomAoQ3bIwNyIk9xFGfNJ8TFriRzUuV/8hNe5usPVUBfH?=
 =?us-ascii?Q?7NSVLcM5f9mYvHiE03OdEtD0bmD6CWiF9tNjTlrcyKIPhVOKxH+IE7k/p1nM?=
 =?us-ascii?Q?dGxPWi0ngVGy2nb1MMO0O6L5u7ruDnPcV730pdzh/V6sK8Yy1PsgxxVIT9cm?=
 =?us-ascii?Q?/umTtUzI5HBaMVkkr8RVzb6OKihhA0JLxhs03wtimDNf5m3ahWVkIKP1j813?=
 =?us-ascii?Q?lhRjXw9n3CsM5EBCmXTb39vQKbUpsfdZlfCWpYju4k35LND/8vERyp2e0zcm?=
 =?us-ascii?Q?V9hdjDTtvg4B8T8Azxg6zVUCIppe90I2DOlvR7eajlGg7saovf4Nr3jnpQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 12:09:51.5315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50ba483f-2142-41d7-bfe5-08ddaff35c40
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6357

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
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Sean Christopherson <seanjc@google.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5fe24f30999d..68c0f1c25dec 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1465,6 +1465,22 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
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
@@ -1472,7 +1488,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 {
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
-	bool exec_fault, mte_allowed;
+	bool exec_fault, mte_allowed, is_vma_cacheable;
 	bool s2_force_noncacheable = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
@@ -1617,6 +1633,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	vm_flags = vma->vm_flags;
 
+	is_vma_cacheable = kvm_vma_is_cacheable(vma);
+
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
 
@@ -1660,6 +1678,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		writable = false;
 	}
 
+	/*
+	 * Prohibit a region to be mapped non cacheable in S2 and marked as
+	 * cacheabled in the userspace VMA. Such mismatched mapping is a
+	 * security risk.
+	 */
+	if (is_vma_cacheable && s2_force_noncacheable)
+		return -EINVAL;
+
 	if (exec_fault && s2_force_noncacheable)
 		return -ENOEXEC;
 
@@ -2219,6 +2245,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
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

