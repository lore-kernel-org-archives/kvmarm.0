Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4F3274FF7
	for <kvmarm@lists.linux.dev>; Sat,  5 Jul 2025 07:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751699858; cv=fail; b=VCFpVVAIHhVK3mjwMqhz3rTbDEBkqyMM1ndGtp8C4NusiHEAqVsP7vdFigfgyGv5t2bqRflqcUdRulzyUtac0tju/VdMAi03fa6q1vpLQgD0onj3iWkQFmiRaNew7EJFXjW7jRYQDroxfs6BLYhrkXTGXcRW4eHzI0zrPpUhtXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751699858; c=relaxed/simple;
	bh=FH2JLqejtFxeqB7YVRoihcKTXyT3fOxNyWQDQ87oHm0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qUxQrIQrNG4xjDSBMIIk4d+RExNtOaTBDqnSAyESwjm/l9ewNK7aqCWKCx0fYWSYjNdFXTNgVzElKPGyNAM4lHB18ynxNfkKOSaBBJIngBPZZYXRzvU1dlyP5mVqdFC6i9yGS8zR79qAsjHsFCH38HhANwzg9GeAyOhuSle0HPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hAHS5QY/; arc=fail smtp.client-ip=40.107.223.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hAHS5QY/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r3ArfPyVtS1l0P0zwFNlbFZ02gntYSsx1ftaag9shu+efqXO4dQjfEmAUqrK0xGeNCku9RCemK5HXJ8CoU8ACCmi2CeIy05HmzfFxz7+RYwMK/N07CLN3DyWv1vlezxGxJMZSx13SnX+XUjAaf+rY0zH5kyozZt5L+B4HWvl45dnGasiMXhTKGL5Tommu3/WPEF2VWOwuIa8FpPW5+jakPXfByLR4Su0OWskt+CPK7ANgxpiLwQbnDgow4xjp1/Rp6qpOVTwn9hZiG0vdyn1Q2pKc+SwVw0gtiLqlyey3j5rJsm2IiHXDZn1Eg6iDkdw0WVwMqfuws7WsYvcq1A2tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ko9vd6j/0qKN54o7ihcloidDlMzCnnWiCiPRuP5Cc4o=;
 b=wX8q/F/nDQSZiWf9jtyD7nasOr6+CZrTP0rViRF9nJm1qRSkeEDSVYAoZZfmf+7rv6ZbR6ma0W1mYimro6Dy9BpQjQkkd2HoHqcTgY5T05Aps4goDrxlPAt/mF7bjoFMk1HGXs7oggvmj18GG8dmNaU4xoc5XlDJXyAbEQE+FnaQIsDdIO24F6H+E6xZCRNZ7AG9HSG8DafjfC+u2S6bkgCaZFjEBO9rdCwzcyuhW1BmhHCPnaOfmC8KOKqj85dfI2e4Y54SdxAB5AhQ/TuflQyhJc+sGhX7+a5mGEc3+22KxD4j4Dt+KIDAbUASHwMGRMTwDZmz5KjSU+xSDcsYuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ko9vd6j/0qKN54o7ihcloidDlMzCnnWiCiPRuP5Cc4o=;
 b=hAHS5QY/RXZtWVR+a/P96pofKF0VZeuG5Qi365KduMVAElyrlHYJkoSmUUwaxmCuPndlNHq/J1nZstzi1nzHoH1m/xkJ/LzeIAXC/JYnfdFELgGkvrZnot856nhOXIFDMfuzN4Wo9xGVxEtErgpD6/UtqhzhB7R+B8kJnH+CVgeeMQJXOptSQ5VAA8GGirtpRKROydSlom+yXe4k0nyWXImI5/8V2UBJAzB+Yw+jOF4DWwx76PjUI3FQBfR5eDUufF1ji3TfOH6Y3Ijx+n+uI1+0kyvMYsp67ZVSLQ/nbADu8EDscs6CxFLz03ggpTYdXTOXfpr1A76iuibmcJAPoQ==
Received: from SN6PR01CA0008.prod.exchangelabs.com (2603:10b6:805:b6::21) by
 SA1PR12MB8948.namprd12.prod.outlook.com (2603:10b6:806:38e::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.22; Sat, 5 Jul 2025 07:17:32 +0000
Received: from SA2PEPF00001506.namprd04.prod.outlook.com
 (2603:10b6:805:b6:cafe::99) by SN6PR01CA0008.outlook.office365.com
 (2603:10b6:805:b6::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.23 via Frontend Transport; Sat,
 5 Jul 2025 07:17:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00001506.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.15 via Frontend Transport; Sat, 5 Jul 2025 07:17:32 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 5 Jul 2025
 00:17:23 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 5 Jul
 2025 00:17:23 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 5 Jul 2025 00:17:22 -0700
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
Subject: [PATCH v10 3/6] KVM: arm64: Block cacheable PFNMAP mapping
Date: Sat, 5 Jul 2025 07:17:14 +0000
Message-ID: <20250705071717.5062-4-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001506:EE_|SA1PR12MB8948:EE_
X-MS-Office365-Filtering-Correlation-Id: 39c6db1e-3b23-455c-0d71-08ddbb940220
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5iEEpl0vLfVfREmxUkX1loE6n94TBbRHtElJ7ULFbxmejvoE/FiQXqISiFgG?=
 =?us-ascii?Q?FWKfSoriA7gbS6olnZ78phFko39zL2jxbVxkNRqolJCHN39vpqm/jfdVf/A1?=
 =?us-ascii?Q?SKjmg7A4UMwq8z7DpEcxc//lFuzJIVO5BFl6t+nEew+ThZI94Rd9Xh0LA7HQ?=
 =?us-ascii?Q?sKSL1TLTJW58CI40H3U/aMd0KIuN9lUwt/tpBi1c7d6zdt3xohtfMo4SPh8E?=
 =?us-ascii?Q?LVbc2KGCC0hqZU3TKA21o7Q1dOJ3HVOtAINaMUY5FxAOmZ3q0E8nmlJ4patx?=
 =?us-ascii?Q?KZWnyylhg5xf7YJLpuyqo81hfsz6H1JROnjhCQTIbsDAo4AP5A3hCuVYN04P?=
 =?us-ascii?Q?n27zW6yXFbSN+oQ/xDHBTaDksFTa/4fA49j3rlItWDS4Fp+wSqUAwqEnLfF0?=
 =?us-ascii?Q?TIPqJBWriPA8s1c8fJ/PQi+xLl39L7yUxOYH+vfHLqcE+YaqnO+f2D/VD/Rw?=
 =?us-ascii?Q?XnTZO7XZitD0JFqjEyKpBFtoZa+vlH9zlfx7qZ2xvUSV6wrlp/HOs7aiSxwt?=
 =?us-ascii?Q?m4n/TNL9ZkgXbEhgZYsTqkvTT10gFwEvpbSuEdLxpmfqovmtqVQgDj9OklWU?=
 =?us-ascii?Q?pKAd3nu+4bSZfCqB3Yd1BtFrKtRp88AQWOYhEKtzUqrM2bwmwOrPZBN+JUFS?=
 =?us-ascii?Q?JCWhGbgo9ygqAsk3o1zWdyXk3Tlm+J/1UA95fm69r7E+bTrt3uQmjVWyx6Wp?=
 =?us-ascii?Q?3A16SAp6tDVFPxesH7bG79/Ekfn0XU/G59psev9M6F9Mfkz4n2LdrDVdv3AN?=
 =?us-ascii?Q?NgNG0X7jbHJAsF80kQkCiyylbrCKTPT+JI+QcwVM7oLzOdhjJ7dz5NJxz9s8?=
 =?us-ascii?Q?Uj80CvPPwMmLN6HnDCZVFPBYyf+7VkKt7H5W5hA9fEPk564x/VUcfJ9OgQDj?=
 =?us-ascii?Q?aRPTCDnTJnrBrsQGwaCwtAeH5nUKHnSSTztQQCBPPXxapVqabYXvrUS0q7YS?=
 =?us-ascii?Q?h6Z96A6haF4TwyJIHbzJrqIX8H9LQNkcd7dqWYq5YFXfS9leBJQkSVY+pbAA?=
 =?us-ascii?Q?75BFPpomgN8xggusc/PlUtqKLkcnT7+7ZHXeMQO07tgALpihXvvPb9w31/xV?=
 =?us-ascii?Q?0rdbmGVCueNTxsTfRgaecHMZFNulDgc0DDH5pPXKj1iR29brqIACobH7PnYx?=
 =?us-ascii?Q?ys9zlAerdwPJJcjnCSWWuq1lCz8A4edxHfSyG1a6N1ddl+ULpsgw5Lp7uYhl?=
 =?us-ascii?Q?qW29qYpywPeUS2B7COaLgYdzn/LATogpZfpFG8X4Mqo9eMs6XcBaq06HQu6c?=
 =?us-ascii?Q?4ppGDwK1obiZya1YCHC06k+2zlobMSuPI8sQ9bhUgXHHmqcTY7gITL+bd109?=
 =?us-ascii?Q?MUGU/cKJQRbJOHx718R+A7Ap3AhKttw4OGvbrXcFuxxGxMpcepUkq3u8Tnvn?=
 =?us-ascii?Q?uflTbCFkHw8Go55vByJMlJCgbQp0OSoova2r+e7zLWEnh2kEN60Y5kwbmUjG?=
 =?us-ascii?Q?Ea+iLaNmJ1vIjm/anBU/hEjHv8t20yYkuLAXf5cR/x2r6d7JSwOTTxVu34vn?=
 =?us-ascii?Q?TYqhiSQpIvgvMa17Nh1P2S77Q3vF95fRuHD5dd3GsoGTRJLfDv79xXaAPw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2025 07:17:32.1053
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39c6db1e-3b23-455c-0d71-08ddbb940220
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001506.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8948

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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Donald Dutile <ddutile@redhat.com>
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

